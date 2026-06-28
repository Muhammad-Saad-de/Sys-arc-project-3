_start:
    li sp, 0xe000        # initialize stack pointer

    # Set up exception handler address in mtvec (direct mode)
    la t0, exception_handler
    csrw mtvec, t0

    # Set mepc to point to user program entry point
    la t0, user_systemcalls
    csrw mepc, t0

    # Set MPP to 00 (user mode) in mstatus so mret drops to user mode
    li t0, 0x1800        # bits 12:11 = MPP
    csrc mstatus, t0     # clear MPP -> user mode

    mret                 # jump to user program

exception_handler:
    # Save registers we will clobber
    addi sp, sp, -32
    sw ra,  0(sp)
    sw t0,  4(sp)
    sw t1,  8(sp)
    sw t2, 12(sp)
    sw a0, 16(sp)
    sw a1, 20(sp)
    sw a6, 24(sp)
    sw a7, 28(sp)

    # Read mcause
    csrr t0, mcause

    # Check if interrupt (bit 31 set)
    li t1, 0x80000000
    and t1, t0, t1
    bnez t1, unsupported

    # Check exception code == 8 (ecall from user mode)
    andi t0, t0, 0xff
    li t1, 8
    bne t0, t1, unsupported

    # Dispatch on EID (a7) and FID (a6)
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
    j restore_and_ret

syscall_return:
    li a0, 0             # success

restore_and_ret:
    # Advance mepc past the ecall
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

handle_write_string:
    # a0 = address of null-terminated string
    la t1, terminal_ready
    la t2, terminal_data
write_string_loop:
    lb t0, 0(a0)
    beqz t0, write_string_done
write_string_wait:
    lw t3, 0(t1)
    andi t3, t3, 1
    beqz t3, write_string_wait
    sw t0, 0(t2)
    addi a0, a0, 1
    j write_string_loop
write_string_done:
    ret

handle_write_number:
    # a0 = signed 32-bit integer to print
    la t1, terminal_ready
    la t2, terminal_data

    # Handle negative: print '-' then negate
    mv t3, a0
    bgez t3, write_number_positive
write_neg_wait:
    lw t4, 0(t1)
    andi t4, t4, 1
    beqz t4, write_neg_wait
    li t4, 45            # '-'
    sw t4, 0(t2)
    neg t3, t3           # make positive

write_number_positive:
    # Special case: 0
    bnez t3, write_number_nonzero
write_zero_wait:
    lw t4, 0(t1)
    andi t4, t4, 1
    beqz t4, write_zero_wait
    li t4, 48            # '0'
    sw t4, 0(t2)
    ret

write_number_nonzero:
    li t4, 0x0000f000    # digit buffer base
    li t5, 0             # digit count

digit_loop:
    beqz t3, digit_loop_done
    li t0, 10
    rem t1, t3, t0
    div t3, t3, t0
    addi t1, t1, 48      # to ASCII
    sb t1, 0(t4)
    addi t4, t4, 1
    addi t5, t5, 1
    j digit_loop

digit_loop_done:
    la t1, terminal_ready
    la t2, terminal_data
print_digit_loop:
    beqz t5, print_digit_done
    addi t4, t4, -1
    lb t0, 0(t4)
print_digit_wait:
    lw t3, 0(t1)
    andi t3, t3, 1
    beqz t3, print_digit_wait
    sw t0, 0(t2)
    addi t5, t5, -1
    j print_digit_loop
print_digit_done:
    ret