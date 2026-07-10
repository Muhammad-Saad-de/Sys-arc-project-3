# bootup
_start:
    li sp, 0xe000

    la t0, exception_handler
    csrw mtvec, t0

    li t0, 0x4000000
    csrw mepc, t0

    li t0, 0x1800
    csrc mstatus, t0

    li t0, 0x8
    csrs mstatus, t0

    li t0, 0x80
    csrs mie, t0

    li t0, 0x10000
    li t1, 0x4000000
    sw t1, 0(t0)
    li t1, 0x0000f000
    sw t1, 4(t0)
    sw t1, 8(t0)
    sw t1, 12(t0)
    sw t1, 16(t0)
    sw t1, 20(t0)
    sw t1, 24(t0)
    sw t1, 28(t0)
    sw t1, 32(t0)
    sw t1, 36(t0)
    sw t1, 40(t0)
    sw t1, 44(t0)
    sw t1, 48(t0)
    sw t1, 52(t0)
    sw t1, 56(t0)
    sw t1, 60(t0)
    sw t1, 64(t0)
    sw t1, 68(t0)
    sw t1, 72(t0)
    sw t1, 76(t0)
    sw t1, 80(t0)
    sw t1, 84(t0)

    li t0, 0x10080
    li t1, 0x8000000
    sw t1, 0(t0)
    li t1, 0x0000f100
    sw t1, 4(t0)
    sw t1, 8(t0)
    sw t1, 12(t0)
    sw t1, 16(t0)
    sw t1, 20(t0)
    sw t1, 24(t0)
    sw t1, 28(t0)
    sw t1, 32(t0)
    sw t1, 36(t0)
    sw t1, 40(t0)
    sw t1, 44(t0)
    sw t1, 48(t0)
    sw t1, 52(t0)
    sw t1, 56(t0)
    sw t1, 60(t0)
    sw t1, 64(t0)
    sw t1, 68(t0)
    sw t1, 72(t0)
    sw t1, 76(t0)
    sw t1, 80(t0)
    sw t1, 84(t0)

    li t0, 0x100c0
    li t1, 0
    sw t1, 0(t0)

    li t0, 0xffff0000
    lw t1, 0(t0)
    addi t1, t1, 300
    li t0, 0xffff0008
    sw t1, 0(t0)

    mret

exception_handler:
    addi sp, sp, -88
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    sw t4, 20(sp)
    sw t5, 24(sp)
    sw t6, 28(sp)
    sw a0, 32(sp)
    sw a1, 36(sp)
    sw a2, 40(sp)
    sw a3, 44(sp)
    sw a4, 48(sp)
    sw a5, 52(sp)
    sw a6, 56(sp)
    sw a7, 60(sp)
    sw s0, 64(sp)
    sw s1, 68(sp)
    sw gp, 72(sp)
    sw tp, 76(sp)
    addi t6, sp, 88
    sw t6, 80(sp)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t0, 0x10000
    beqz t1, save_current_state
    li t0, 0x10080
save_current_state:
    csrr t2, mepc
    sw t2, 0(t0)
    lw t2, 80(sp)
    sw t2, 4(t0)
    lw t2, 0(sp)
    sw t2, 8(t0)
    lw t2, 4(sp)
    sw t2, 12(t0)
    lw t2, 8(sp)
    sw t2, 16(t0)
    lw t2, 12(sp)
    sw t2, 20(t0)
    lw t2, 16(sp)
    sw t2, 24(t0)
    lw t2, 20(sp)
    sw t2, 28(t0)
    lw t2, 24(sp)
    sw t2, 32(t0)
    lw t2, 28(sp)
    sw t2, 36(t0)
    lw t2, 32(sp)
    sw t2, 40(t0)
    lw t2, 36(sp)
    sw t2, 44(t0)
    lw t2, 40(sp)
    sw t2, 48(t0)
    lw t2, 44(sp)
    sw t2, 52(t0)
    lw t2, 48(sp)
    sw t2, 56(t0)
    lw t2, 52(sp)
    sw t2, 60(t0)
    lw t2, 56(sp)
    sw t2, 64(t0)
    lw t2, 60(sp)
    sw t2, 68(t0)
    lw t2, 64(sp)
    sw t2, 72(t0)
    lw t2, 68(sp)
    sw t2, 76(t0)
    lw t2, 72(sp)
    sw t2, 80(t0)
    lw t2, 76(sp)
    sw t2, 84(t0)

    li t0, 0x100c0
    lw t1, 0(t0)
    xori t1, t1, 1
    sw t1, 0(t0)

    li t0, 0x10000
    beqz t1, restore_from_pcb
    li t0, 0x10080
restore_from_pcb:
    lw t1, 0(t0)
    csrw mepc, t1
    lw t1, 4(t0)
    mv sp, t1
    lw ra, 8(t0)
    lw t1, 16(t0)
    lw t2, 20(t0)
    lw t3, 24(t0)
    lw t4, 28(t0)
    lw t5, 32(t0)
    lw t6, 36(t0)
    lw a0, 40(t0)
    lw a1, 44(t0)
    lw a2, 48(t0)
    lw a3, 52(t0)
    lw a4, 56(t0)
    lw a5, 60(t0)
    lw a6, 64(t0)
    lw a7, 68(t0)
    lw s0, 72(t0)
    lw s1, 76(t0)
    lw gp, 80(t0)
    lw tp, 84(t0)
    lw t0, 12(t0)

    li t0, 0xffff0000
    lw t1, 0(t0)
    addi t1, t1, 300
    li t0, 0xffff0008
    sw t1, 0(t0)

    mret