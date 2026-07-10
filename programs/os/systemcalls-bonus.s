_start:
    li sp, 0xe000

    # Set up exception handler address in mtvec (direct mode)
    la t0, exception_handler
    csrw mtvec, t0

    # Set mepc to point to the first instruction of the startup process
    la t0, user_systemcalls
    csrw mepc, t0

    # Clear MPP -> user mode after mret
    li t0, 0x1800
    csrc mstatus, t0

    # Set MPIE = 1 (bit 7). On mret, mstatus.MIE = mstatus.MPIE,
    # so this is what actually enables interrupts once we're in user mode.
    li t0, 0x80
    csrs mstatus, t0

    # Enable external interrupts globally: mie.MEIE = bit 11
    li t0, 0x800
    csrs mie, t0

    # Enable the terminal's interrupt-enable bit (bit 1 of its control port)
    la t0, terminal_ready
    li t1, 2
    sw t1, 0(t0)

    # Initialize ring buffer state: head = 0, count = 0
    li t0, 0x0000f030      # buf_head
    sw zero, 0(t0)
    li t0, 0x0000f034      # buf_count
    sw zero, 0(t0)

    mret

exception_handler:
    addi sp, sp, -32
    sw ra,  0(sp)
    sw t0,  4(sp)
    sw t1,  8(sp)
    sw t2, 12(sp)
    sw a0, 16(sp)
    sw a1, 20(sp)
    sw a6, 24(sp)
    sw a7, 28(sp)

    csrr t0, mcause
    li t1, 0x80000000
    and t2, t0, t1
    bnez t2, handle_interrupt_entry

    # Exception path: check code == 8 (ecall from user mode)
    andi t0, t0, 0xff
    li t1, 8
    bne t0, t1, unsupported

    li t0, 0x4442434E
    bne a7, t0, unsupported

    li t0, 4
    beq a6, t0, do_write_string
    li t0, 5
    beq a6, t0, do_write_number
    j unsupported

do_write_string:
    jal ra, handle_write_string
    j syscall_return

do_write_number:
    jal ra, handle_write_number
    j syscall_return

unsupported:
    li a0, -2
    j syscall_exit

syscall_return:
    li a0, 0

syscall_exit:
    # Advance mepc past the ecall (syscalls only, not interrupts)
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0

    lw ra,  0(sp)
    lw t0,  4(sp)
    lw t1,  8(sp)
    lw t2, 12(sp)
    lw a1, 20(sp)
    lw a6, 24(sp)
    lw a7, 28(sp)
    addi sp, sp, 32
    mret

handle_interrupt_entry:
    jal ra, handle_interrupt

    lw ra,  0(sp)
    lw t0,  4(sp)
    lw t1,  8(sp)
    lw t2, 12(sp)
    lw a0, 16(sp)
    lw a1, 20(sp)
    lw a6, 24(sp)
    lw a7, 28(sp)
    addi sp, sp, 32
    mret

# --- Syscall handlers: enqueue characters instead of busy-waiting ---

handle_write_string:
    # a0 = address of null-terminated string. We copy each byte into
    # the ring buffer as we read it, so persistence of a0 doesn't matter.
    addi sp, sp, -4
    sw ra, 0(sp)

write_string_loop:
    lb t0, 0(a0)
    beqz t0, write_string_done
    mv t3, t0
    jal ra, push_char
    addi a0, a0, 1
    j write_string_loop

write_string_done:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

handle_write_number:
    # a0 = signed 32-bit integer to print
    addi sp, sp, -4
    sw ra, 0(sp)

    mv t2, a0
    li t5, 0                # digit count
    li t4, 0x0000f000        # digit_scratch base

    bgez t2, write_number_pos

    li t3, 45                # '-'
    jal ra, push_char
    neg t2, t2

write_number_pos:
    bnez t2, write_number_convert

    li t3, 48                 # '0'
    jal ra, push_char
    j write_number_done

write_number_convert:
digit_loop:
    beqz t2, digit_loop_done
    li t0, 10
    rem t1, t2, t0
    div t2, t2, t0
    addi t1, t1, 48
    sb t1, 0(t4)
    addi t4, t4, 1
    addi t5, t5, 1
    j digit_loop

digit_loop_done:
push_digits_loop:
    beqz t5, write_number_done
    addi t4, t4, -1
    lb t3, 0(t4)
    jal ra, push_char
    addi t5, t5, -1
    j push_digits_loop

write_number_done:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# push_char: append the byte in t3 to the ring buffer.
# Discards the oldest entry if the buffer (32 chars) is full.
# Clobbers t4, t5, t6. Leaf routine (no calls) so ra is safe.
push_char:
    li t4, 0x0000f034        # buf_count
    lw t5, 0(t4)
    li t6, 32
    blt t5, t6, push_char_store

    # full: drop oldest by advancing head, decrementing count
    li t6, 0x0000f030        # buf_head
    lw t5, 0(t6)
    addi t5, t5, 1
    andi t5, t5, 31
    sw t5, 0(t6)

    li t4, 0x0000f034
    lw t5, 0(t4)
    addi t5, t5, -1
    sw t5, 0(t4)

push_char_store:
    li t6, 0x0000f030        # head
    lw t5, 0(t6)
    li t4, 0x0000f034        # count
    lw t6, 0(t4)
    add t5, t5, t6
    andi t5, t5, 31           # tail = (head + count) mod 32

    li t6, 0x0000f010         # buf_data base
    add t6, t6, t5
    sb t3, 0(t6)

    li t4, 0x0000f034
    lw t5, 0(t4)
    addi t5, t5, 1
    sw t5, 0(t4)
    ret

# handle_interrupt: called on any external interrupt. If it's the
# terminal (ready bit set) and we have buffered chars, send the next one.
handle_interrupt:
    la t4, terminal_ready
    lw t5, 0(t4)
    andi t5, t5, 1
    beqz t5, handle_interrupt_done

    li t4, 0x0000f034         # buf_count
    lw t5, 0(t4)
    beqz t5, handle_interrupt_done

    li t4, 0x0000f030          # buf_head
    lw t5, 0(t4)
    li t6, 0x0000f010          # buf_data
    add t6, t6, t5
    lb t3, 0(t6)

    la t6, terminal_data
    sw t3, 0(t6)

    li t4, 0x0000f030
    lw t5, 0(t4)
    addi t5, t5, 1
    andi t5, t5, 31
    sw t5, 0(t4)

    li t4, 0x0000f034
    lw t5, 0(t4)
    addi t5, t5, -1
    sw t5, 0(t4)

handle_interrupt_done:
    ret