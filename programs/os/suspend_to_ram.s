_start:
    li sp, 0xe000

    # Set up exception handler
    la t0, exception_handler
    csrw mtvec, t0

    # Set mepc to user program
    la t0, user_suspend_to_ram
    csrw mepc, t0

    # Drop to user mode (clear MPP bits 12:11)
    li t0, 0x1800
    csrc mstatus, t0

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
    and t1, t0, t1
    bnez t1, unsupported

    andi t0, t0, 0xff
    li t1, 8
    bne t0, t1, unsupported

    li t0, 0x4442434E
    beq a7, t0, dispatch_dbcn

    li t0, 0x54494D45
    beq a7, t0, dispatch_time

    li t0, 0x53555350
    beq a7, t0, dispatch_suspend

    j unsupported

dispatch_dbcn:
    li t0, 3
    beq a6, t0, do_read
    li t0, 2
    beq a6, t0, do_write
    j unsupported

do_read:
    jal ra, handle_console_read
    j syscall_return_read

do_write:
    jal ra, handle_console_write
    j syscall_return

dispatch_time:
    li t0, 1
    bne a6, t0, unsupported
    jal ra, handle_time
    j syscall_return

dispatch_suspend:
    li t0, 0
    bne a6, t0, unsupported
    lw ra,  0(sp)
    lw t0,  4(sp)
    lw t1,  8(sp)
    lw t2, 12(sp)
    lw a0, 16(sp)
    lw a1, 20(sp)
    lw a6, 24(sp)
    lw a7, 28(sp)
    addi sp, sp, 32
    j handle_suspend

unsupported:
    li a0, -2
    j restore_and_ret

syscall_return:
    li a0, 0

restore_and_ret:
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

syscall_return_read:
    li a0, 0
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0

    lw ra,  0(sp)
    lw t0,  4(sp)
    lw t1,  8(sp)
    lw t2, 12(sp)
    lw a6, 24(sp)
    lw a7, 28(sp)
    addi sp, sp, 32
    mret

handle_console_read:
    la t0, keyboard_ready
    la t1, keyboard_data
read_wait:
    lw t2, 0(t0)
    andi t2, t2, 1
    beqz t2, read_wait
    lw a1, 0(t1)
    andi a1, a1, 0xff
    ret

handle_console_write:
    la t0, terminal_ready
    la t1, terminal_data
write_wait:
    lw t2, 0(t0)
    andi t2, t2, 1
    beqz t2, write_wait
    sw a0, 0(t1)
    ret

handle_time:
    la t0, mtime
    lw t1, 0(t0)
    lw t2, 4(t0)
    sw t1, 0(a1)
    sw t2, 4(a1)

    csrr t1, mcycle
    csrr t2, mcycleh
    sw t1, 8(a1)
    sw t2, 12(a1)

    csrr t1, minstret
    csrr t2, minstreth
    sw t1, 16(a1)
    sw t2, 20(a1)

    ret

handle_suspend:
    li t0, 0x1000

    sw x1,   0(t0)
    sw x2,   4(t0)
    sw x3,   8(t0)
    sw x4,  12(t0)
    sw x5,  16(t0)
    sw x6,  20(t0)
    sw x7,  24(t0)
    sw x8,  28(t0)
    sw x9,  32(t0)
    sw x10, 36(t0)
    sw x11, 40(t0)
    sw x12, 44(t0)
    sw x13, 48(t0)
    sw x14, 52(t0)
    sw x15, 56(t0)
    sw x16, 60(t0)
    sw x17, 64(t0)
    sw x18, 68(t0)
    sw x19, 72(t0)
    sw x20, 76(t0)
    sw x21, 80(t0)
    sw x22, 84(t0)
    sw x23, 88(t0)
    sw x24, 92(t0)
    sw x25, 96(t0)
    sw x26, 100(t0)
    sw x27, 104(t0)
    sw x28, 108(t0)
    sw x29, 112(t0)
    sw x30, 116(t0)
    sw x31, 120(t0)

    # Save resume_addr (a1)
    sw a1, 172(t0)

    # Save mepc + 4 (past the ecall)
    csrr t1, mepc
    addi t1, t1, 4
    sw t1, 124(t0)

    csrr t1, mstatus
    sw t1, 128(t0)

    csrr t1, mie
    sw t1, 132(t0)

    csrr t1, mscratch
    sw t1, 136(t0)

    la t2, mtimecmp
    lw t1, 0(t2)
    sw t1, 140(t0)
    lw t1, 4(t2)
    sw t1, 144(t0)

    # Save mtime, mcycle, minstret for monotonicity offset
    la t2, mtime
    lw t1, 0(t2)
    sw t1, 164(t0)      # mtime low before suspend
    lw t1, 4(t2)
    sw t1, 168(t0)      # mtime high before suspend

    csrr t1, mcycle
    sw t1, 148(t0)
    csrr t1, mcycleh
    sw t1, 152(t0)

    csrr t1, minstret
    sw t1, 156(t0)
    csrr t1, minstreth
    sw t1, 160(t0)

    j _suspend

_resume_from_suspend:
    # Restore mtvec first
    la t0, exception_handler
    csrw mtvec, t0

    li sp, 0xe000

    li t0, 0x1000

    # Restore mtimecmp safely
    la t1, mtimecmp
    li t2, -1
    sw t2, 0(t1)
    lw t2, 144(t0)
    sw t2, 4(t1)
    lw t2, 140(t0)
    sw t2, 0(t1)

    # Restore mtime to saved value + 1 to ensure monotonic increase
    la t1, mtime
    lw t2, 164(t0)      # saved mtime low
    lw t3, 168(t0)      # saved mtime high
    addi t2, t2, 1      # add 1 to guarantee strictly greater
    sw t2, 0(t1)
    sw t3, 4(t1)

    # Restore mstatus with MPP=00 (user mode)
    lw t1, 128(t0)
    li t2, 0x1800
    not t2, t2
    and t1, t1, t2
    csrw mstatus, t1

    lw t1, 132(t0)
    csrw mie, t1

    lw t1, 136(t0)
    csrw mscratch, t1

    # Set mepc to resume_addr
    lw t1, 172(t0)
    csrw mepc, t1

    # Restore GPRs (t0/x5 last)
    lw x1,   0(t0)
    lw x2,   4(t0)
    lw x3,   8(t0)
    lw x4,  12(t0)
    lw x6,  20(t0)
    lw x7,  24(t0)
    lw x8,  28(t0)
    lw x9,  32(t0)
    lw x10, 36(t0)
    lw x11, 40(t0)
    lw x12, 44(t0)
    lw x13, 48(t0)
    lw x14, 52(t0)
    lw x15, 56(t0)
    lw x16, 60(t0)
    lw x17, 64(t0)
    lw x18, 68(t0)
    lw x19, 72(t0)
    lw x20, 76(t0)
    lw x21, 80(t0)
    lw x22, 84(t0)
    lw x23, 88(t0)
    lw x24, 92(t0)
    lw x25, 96(t0)
    lw x26, 100(t0)
    lw x27, 104(t0)
    lw x28, 108(t0)
    lw x29, 112(t0)
    lw x30, 116(t0)
    lw x31, 120(t0)
    lw x5,  16(t0)

    mret

# ----------------------------------------------------------------------
# Simulated suspension. Do not touch this part.
# ----------------------------------------------------------------------
_suspend:
    nop
    nop
    j _resume_from_suspend