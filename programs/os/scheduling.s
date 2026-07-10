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

    li t0, 0x100c0
    li t1, 0
    sw t1, 0(t0)

    li t0, 0x100c4
    li t1, 0
    sw t1, 0(t0)

    li t0, 0x10000
    li t1, 0x4000000
    sw t1, 0(t0)
    li t1, 0x0f000
    sw t1, 4(t0)
    li t1, 1
    sw t1, 0x58(t0)
    li t1, 0
    sw t1, 0x5c(t0)
    sw t1, 0x60(t0)

    li t0, 0xffff0000
    lw t1, 0(t0)
    addi t1, t1, 300
    li t0, 0xffff0008
    sw t1, 0(t0)

    mret

exception_handler:
    mv t5, sp
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
    sw t5, 80(sp)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3

    csrr t4, mcause
    li t5, 0x80000000
    and t5, t4, t5
    bnez t5, handle_timer_interrupt

    csrr t4, mepc
    addi t4, t4, 4
    sw t4, 0(t2)

    lw t0, 80(sp)
    sw t0, 4(t2)
    lw t0, 0(sp)
    sw t0, 8(t2)
    lw t0, 4(sp)
    sw t0, 12(t2)
    lw t0, 8(sp)
    sw t0, 16(t2)
    lw t0, 12(sp)
    sw t0, 20(t2)
    lw t0, 16(sp)
    sw t0, 24(t2)
    lw t0, 20(sp)
    sw t0, 28(t2)
    lw t0, 24(sp)
    sw t0, 32(t2)
    lw t0, 28(sp)
    sw t0, 36(t2)
    lw t0, 32(sp)
    sw t0, 40(t2)
    lw t0, 36(sp)
    sw t0, 44(t2)
    lw t0, 40(sp)
    sw t0, 48(t2)
    lw t0, 44(sp)
    sw t0, 52(t2)
    lw t0, 48(sp)
    sw t0, 56(t2)
    lw t0, 52(sp)
    sw t0, 60(t2)
    lw t0, 56(sp)
    sw t0, 64(t2)
    lw t0, 60(sp)
    sw t0, 68(t2)
    lw t0, 64(sp)
    sw t0, 72(t2)
    lw t0, 68(sp)
    sw t0, 76(t2)
    lw t0, 72(sp)
    sw t0, 80(t2)
    lw t0, 76(sp)
    sw t0, 84(t2)

    andi t4, t4, 0xff
    li t5, 8
    bne t4, t5, schedule_next

    li t5, 0x0A000000
    bne a7, t5, schedule_next

    li t5, 0
    beq a6, t5, do_exec
    li t5, 1
    beq a6, t5, do_exit
    j schedule_next

do_exec:
    jal ra, create_process
    j schedule_next

do_exit:
    jal ra, kill_process
    j schedule_next

handle_timer_interrupt:
    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3

    csrr t4, mepc
    sw t4, 0(t2)

    lw t4, 0x58(t2)
    beqz t4, skip_remaining_update
    lw t4, 0x5c(t2)
    addi t4, t4, -300
    sw t4, 0x5c(t2)
skip_remaining_update:

    lw t0, 80(sp)
    sw t0, 4(t2)
    lw t0, 0(sp)
    sw t0, 8(t2)
    lw t0, 4(sp)
    sw t0, 12(t2)
    lw t0, 8(sp)
    sw t0, 16(t2)
    lw t0, 12(sp)
    sw t0, 20(t2)
    lw t0, 16(sp)
    sw t0, 24(t2)
    lw t0, 20(sp)
    sw t0, 28(t2)
    lw t0, 24(sp)
    sw t0, 32(t2)
    lw t0, 28(sp)
    sw t0, 36(t2)
    lw t0, 32(sp)
    sw t0, 40(t2)
    lw t0, 36(sp)
    sw t0, 44(t2)
    lw t0, 40(sp)
    sw t0, 48(t2)
    lw t0, 44(sp)
    sw t0, 52(t2)
    lw t0, 48(sp)
    sw t0, 56(t2)
    lw t0, 52(sp)
    sw t0, 60(t2)
    lw t0, 56(sp)
    sw t0, 64(t2)
    lw t0, 60(sp)
    sw t0, 68(t2)
    lw t0, 64(sp)
    sw t0, 72(t2)
    lw t0, 68(sp)
    sw t0, 76(t2)
    lw t0, 72(sp)
    sw t0, 80(t2)
    lw t0, 76(sp)
    sw t0, 84(t2)

    j schedule_next

schedule_next:
    li t0, 0x10000
    lw t1, 0x58(t0)
    bnez t1, choose_startup

    li t0, 0x100c4
    lw t1, 0(t0)
    beqz t1, shutdown

    li t2, 1
    li t3, 0
    li t4, 0x7fffffff

child_scan_loop:
    li t0, 0x10000
    slli t5, t2, 7
    add t0, t0, t5
    lw t5, 0x58(t0)
    beqz t5, child_scan_next
    lw t5, 0x5c(t0)
    bge t5, t4, child_scan_next
    mv t4, t5
    mv t3, t2

child_scan_next:
    addi t2, t2, 1
    li t5, 8
    bne t2, t5, child_scan_loop

    li t0, 0x100c0
    sw t3, 0(t0)
    j restore_selected

choose_startup:
    li t0, 0x100c0
    li t1, 0
    sw t1, 0(t0)

restore_selected:
    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3

    lw t0, 0(t2)
    csrw mepc, t0
    lw t0, 4(t2)
    mv sp, t0
    lw ra, 8(t2)
    lw t0, 12(t2)
    lw t1, 16(t2)
    lw t2, 20(t2)
    lw t3, 24(t2)
    lw t4, 28(t2)
    lw t5, 32(t2)
    lw t6, 36(t2)
    lw a0, 40(t2)
    lw a1, 44(t2)
    lw a2, 48(t2)
    lw a3, 52(t2)
    lw a4, 56(t2)
    lw a5, 60(t2)
    lw a6, 64(t2)
    lw a7, 68(t2)
    lw s0, 72(t2)
    lw s1, 76(t2)
    lw gp, 80(t2)
    lw tp, 84(t2)

    li t0, 0xffff0000
    lw t1, 0(t0)
    addi t1, t1, 300
    li t0, 0xffff0008
    sw t1, 0(t0)

    mret

create_process:
    li t0, 0x100c4
    lw t1, 0(t0)
    li t2, 8
    bge t1, t2, create_fail

    li t0, 0x100c0
    lw t2, 0(t0)
    li t0, 0x10000
    slli t3, t2, 7
    add t0, t0, t3

    li t3, 1
    li t4, 0x10000

find_free_slot:
    slli t5, t3, 7
    add t5, t4, t5
    lw t6, 0x58(t5)
    bnez t6, next_slot
    j slot_found
next_slot:
    addi t3, t3, 1
    li t6, 8
    bne t3, t6, find_free_slot
    j create_fail
slot_found:
    li t6, 1
    sw t6, 0x58(t5)
    lw t6, 0x5c(t0)
    sw t6, 0x5c(t5)
    lw t6, 0x60(t0)
    sw t6, 0x60(t5)

    lw t6, 0(t0)
    sw t6, 0(t5)
    lw t6, 4(t0)
    sw t6, 4(t5)
    lw t6, 8(t0)
    sw t6, 8(t5)
    lw t6, 12(t0)
    sw t6, 12(t5)
    lw t6, 16(t0)
    sw t6, 16(t5)
    lw t6, 20(t0)
    sw t6, 20(t5)
    lw t6, 24(t0)
    sw t6, 24(t5)
    lw t6, 28(t0)
    sw t6, 28(t5)
    lw t6, 32(t0)
    sw t6, 32(t5)
    lw t6, 36(t0)
    sw t6, 36(t5)
    lw t6, 40(t0)
    sw t6, 40(t5)
    lw t6, 44(t0)
    sw t6, 44(t5)
    lw t6, 48(t0)
    sw t6, 48(t5)
    lw t6, 52(t0)
    sw t6, 52(t5)
    lw t6, 56(t0)
    sw t6, 56(t5)
    lw t6, 60(t0)
    sw t6, 60(t5)
    lw t6, 64(t0)
    sw t6, 64(t5)
    lw t6, 68(t0)
    sw t6, 68(t5)
    lw t6, 72(t0)
    sw t6, 72(t5)
    lw t6, 76(t0)
    sw t6, 76(t5)
    lw t6, 80(t0)
    sw t6, 80(t5)
    lw t6, 84(t0)
    sw t6, 84(t5)

    li t0, 0x100c4
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 28(t2)
    sw t1, 28(t5)
    lw t1, 32(t2)
    sw t1, 32(t5)
    lw t1, 36(t2)
    sw t1, 36(t5)
    lw t1, 40(t2)
    sw t1, 40(t5)
    lw t1, 44(t2)
    sw t1, 44(t5)
    lw t1, 48(t2)
    sw t1, 48(t5)
    lw t1, 52(t2)
    sw t1, 52(t5)
    lw t1, 56(t2)
    sw t1, 56(t5)
    lw t1, 60(t2)
    sw t1, 60(t5)
    lw t1, 64(t2)
    sw t1, 64(t5)
    lw t1, 68(t2)
    sw t1, 68(t5)
    lw t1, 72(t2)
    sw t1, 72(t5)
    lw t1, 76(t2)
    sw t1, 76(t5)
    lw t1, 80(t2)
    sw t1, 80(t5)
    lw t1, 84(t2)
    sw t1, 84(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0(t2)
    sw t1, 0(t5)
    lw t1, 4(t2)
    sw t1, 4(t5)
    lw t1, 8(t2)
    sw t1, 8(t5)
    lw t1, 12(t2)
    sw t1, 12(t5)
    lw t1, 16(t2)
    sw t1, 16(t5)
    lw t1, 20(t2)
    sw t1, 20(t5)
    lw t1, 24(t2)
    sw t1, 24(t5)
    lw t1, 28(t2)
    sw t1, 28(t5)
    lw t1, 32(t2)
    sw t1, 32(t5)
    lw t1, 36(t2)
    sw t1, 36(t5)
    lw t1, 40(t2)
    sw t1, 40(t5)
    lw t1, 44(t2)
    sw t1, 44(t5)
    lw t1, 48(t2)
    sw t1, 48(t5)
    lw t1, 52(t2)
    sw t1, 52(t5)
    lw t1, 56(t2)
    sw t1, 56(t5)
    lw t1, 60(t2)
    sw t1, 60(t5)
    lw t1, 64(t2)
    sw t1, 64(t5)
    lw t1, 68(t2)
    sw t1, 68(t5)
    lw t1, 72(t2)
    sw t1, 72(t5)
    lw t1, 76(t2)
    sw t1, 76(t5)
    lw t1, 80(t2)
    sw t1, 80(t5)
    lw t1, 84(t2)
    sw t1, 84(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 28(t2)
    sw t1, 28(t5)
    lw t1, 32(t2)
    sw t1, 32(t5)
    lw t1, 36(t2)
    sw t1, 36(t5)
    lw t1, 40(t2)
    sw t1, 40(t5)
    lw t1, 44(t2)
    sw t1, 44(t5)
    lw t1, 48(t2)
    sw t1, 48(t5)
    lw t1, 52(t2)
    sw t1, 52(t5)
    lw t1, 56(t2)
    sw t1, 56(t5)
    lw t1, 60(t2)
    sw t1, 60(t5)
    lw t1, 64(t2)
    sw t1, 64(t5)
    lw t1, 68(t2)
    sw t1, 68(t5)
    lw t1, 72(t2)
    sw t1, 72(t5)
    lw t1, 76(t2)
    sw t1, 76(t5)
    lw t1, 80(t2)
    sw t1, 80(t5)
    lw t1, 84(t2)
    sw t1, 84(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x58(t2)
    sw t1, 0x58(t5)
    lw t1, 0x5c(t2)
    sw t1, 0x5c(t5)
    lw t1, 0x60(t2)
    sw t1, 0x60(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x58(t2)
    sw t1, 0x58(t5)
    lw t1, 0x5c(t2)
    sw t1, 0x5c(t5)
    lw t1, 0x60(t2)
    sw t1, 0x60(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x00(t2)
    sw t1, 0x00(t5)
    lw t1, 0x04(t2)
    sw t1, 0x04(t5)
    lw t1, 0x08(t2)
    sw t1, 0x08(t5)
    lw t1, 0x0c(t2)
    sw t1, 0x0c(t5)
    lw t1, 0x10(t2)
    sw t1, 0x10(t5)
    lw t1, 0x14(t2)
    sw t1, 0x14(t5)
    lw t1, 0x18(t2)
    sw t1, 0x18(t5)
    lw t1, 0x1c(t2)
    sw t1, 0x1c(t5)
    lw t1, 0x20(t2)
    sw t1, 0x20(t5)
    lw t1, 0x24(t2)
    sw t1, 0x24(t5)
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x58(t2)
    sw t1, 0x58(t5)
    lw t1, 0x5c(t2)
    sw t1, 0x5c(t5)
    lw t1, 0x60(t2)
    sw t1, 0x60(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x00(t2)
    sw t1, 0x00(t5)
    lw t1, 0x04(t2)
    sw t1, 0x04(t5)
    lw t1, 0x08(t2)
    sw t1, 0x08(t5)
    lw t1, 0x0c(t2)
    sw t1, 0x0c(t5)
    lw t1, 0x10(t2)
    sw t1, 0x10(t5)
    lw t1, 0x14(t2)
    sw t1, 0x14(t5)
    lw t1, 0x18(t2)
    sw t1, 0x18(t5)
    lw t1, 0x1c(t2)
    sw t1, 0x1c(t5)
    lw t1, 0x20(t2)
    sw t1, 0x20(t5)
    lw t1, 0x24(t2)
    sw t1, 0x24(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x58(t2)
    sw t1, 0x58(t5)
    lw t1, 0x5c(t2)
    sw t1, 0x5c(t5)
    lw t1, 0x60(t2)
    sw t1, 0x60(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x00(t2)
    sw t1, 0x00(t5)
    lw t1, 0x04(t2)
    sw t1, 0x04(t5)
    lw t1, 0x08(t2)
    sw t1, 0x08(t5)
    lw t1, 0x0c(t2)
    sw t1, 0x0c(t5)
    lw t1, 0x10(t2)
    sw t1, 0x10(t5)
    lw t1, 0x14(t2)
    sw t1, 0x14(t5)
    lw t1, 0x18(t2)
    sw t1, 0x18(t5)
    lw t1, 0x1c(t2)
    sw t1, 0x1c(t5)
    lw t1, 0x20(t2)
    sw t1, 0x20(t5)
    lw t1, 0x24(t2)
    sw t1, 0x24(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x58(t2)
    sw t1, 0x58(t5)
    lw t1, 0x5c(t2)
    sw t1, 0x5c(t5)
    lw t1, 0x60(t2)
    sw t1, 0x60(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x00(t2)
    sw t1, 0x00(t5)
    lw t1, 0x04(t2)
    sw t1, 0x04(t5)
    lw t1, 0x08(t2)
    sw t1, 0x08(t5)
    lw t1, 0x0c(t2)
    sw t1, 0x0c(t5)
    lw t1, 0x10(t2)
    sw t1, 0x10(t5)
    lw t1, 0x14(t2)
    sw t1, 0x14(t5)
    lw t1, 0x18(t2)
    sw t1, 0x18(t5)
    lw t1, 0x1c(t2)
    sw t1, 0x1c(t5)
    lw t1, 0x20(t2)
    sw t1, 0x20(t5)
    lw t1, 0x24(t2)
    sw t1, 0x24(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    li t1, 0
    sw t1, 0x28(t5)
    li t1, 0
    sw t1, 0x2c(t5)
    li t1, 0
    sw t1, 0x30(t5)
    li t1, 0
    sw t1, 0x34(t5)
    li t1, 0
    sw t1, 0x38(t5)
    li t1, 0
    sw t1, 0x3c(t5)
    li t1, 0
    sw t1, 0x40(t5)
    li t1, 0
    sw t1, 0x44(t5)
    li t1, 0
    sw t1, 0x48(t5)
    li t1, 0
    sw t1, 0x4c(t5)
    li t1, 0
    sw t1, 0x50(t5)
    li t1, 0
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x58(t2)
    sw t1, 0x58(t5)
    lw t1, 0x5c(t2)
    sw t1, 0x5c(t5)
    lw t1, 0x60(t2)
    sw t1, 0x60(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x00(t2)
    sw t1, 0x00(t5)
    lw t1, 0x04(t2)
    sw t1, 0x04(t5)
    lw t1, 0x08(t2)
    sw t1, 0x08(t5)
    lw t1, 0x0c(t2)
    sw t1, 0x0c(t5)
    lw t1, 0x10(t2)
    sw t1, 0x10(t5)
    lw t1, 0x14(t2)
    sw t1, 0x14(t5)
    lw t1, 0x18(t2)
    sw t1, 0x18(t5)
    lw t1, 0x1c(t2)
    sw t1, 0x1c(t5)
    lw t1, 0x20(t2)
    sw t1, 0x20(t5)
    lw t1, 0x24(t2)
    sw t1, 0x24(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    li t1, 0
    sw t1, 0x28(t5)
    sw t1, 0x2c(t5)
    sw t1, 0x30(t5)
    sw t1, 0x34(t5)
    sw t1, 0x38(t5)
    sw t1, 0x3c(t5)
    sw t1, 0x40(t5)
    sw t1, 0x44(t5)
    sw t1, 0x48(t5)
    sw t1, 0x4c(t5)
    sw t1, 0x50(t5)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x58(t2)
    sw t1, 0x58(t5)
    lw t1, 0x5c(t2)
    sw t1, 0x5c(t5)
    lw t1, 0x60(t2)
    sw t1, 0x60(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x00(t2)
    sw t1, 0x00(t5)
    lw t1, 0x04(t2)
    sw t1, 0x04(t5)
    lw t1, 0x08(t2)
    sw t1, 0x08(t5)
    lw t1, 0x0c(t2)
    sw t1, 0x0c(t5)
    lw t1, 0x10(t2)
    sw t1, 0x10(t5)
    lw t1, 0x14(t2)
    sw t1, 0x14(t5)
    lw t1, 0x18(t2)
    sw t1, 0x18(t5)
    lw t1, 0x1c(t2)
    sw t1, 0x1c(t5)
    lw t1, 0x20(t2)
    sw t1, 0x20(t5)
    lw t1, 0x24(t2)
    sw t1, 0x24(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    li t1, 0
    sw t1, 0x28(t5)
    sw t1, 0x2c(t5)
    sw t1, 0x30(t5)
    sw t1, 0x34(t5)
    sw t1, 0x38(t5)
    sw t1, 0x3c(t5)
    sw t1, 0x40(t5)
    sw t1, 0x44(t5)
    sw t1, 0x48(t5)
    sw t1, 0x4c(t5)
    sw t1, 0x50(t5)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x58(t2)
    sw t1, 0x58(t5)
    lw t1, 0x5c(t2)
    sw t1, 0x5c(t5)
    lw t1, 0x60(t2)
    sw t1, 0x60(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x00(t2)
    sw t1, 0x00(t5)
    lw t1, 0x04(t2)
    sw t1, 0x04(t5)
    lw t1, 0x08(t2)
    sw t1, 0x08(t5)
    lw t1, 0x0c(t2)
    sw t1, 0x0c(t5)
    lw t1, 0x10(t2)
    sw t1, 0x10(t5)
    lw t1, 0x14(t2)
    sw t1, 0x14(t5)
    lw t1, 0x18(t2)
    sw t1, 0x18(t5)
    lw t1, 0x1c(t2)
    sw t1, 0x1c(t5)
    lw t1, 0x20(t2)
    sw t1, 0x20(t5)
    lw t1, 0x24(t2)
    sw t1, 0x24(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x28(t2)
    sw t1, 0x28(t5)
    lw t1, 0x2c(t2)
    sw t1, 0x2c(t5)
    lw t1, 0x30(t2)
    sw t1, 0x30(t5)
    lw t1, 0x34(t2)
    sw t1, 0x34(t5)
    lw t1, 0x38(t2)
    sw t1, 0x38(t5)
    lw t1, 0x3c(t2)
    sw t1, 0x3c(t5)
    lw t1, 0x40(t2)
    sw t1, 0x40(t5)
    lw t1, 0x44(t2)
    sw t1, 0x44(t5)
    lw t1, 0x48(t2)
    sw t1, 0x48(t5)
    lw t1, 0x4c(t2)
    sw t1, 0x4c(t5)
    lw t1, 0x50(t2)
    sw t1, 0x50(t5)
    lw t1, 0x54(t2)
    sw t1, 0x54(t5)

    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    lw t1, 0x58(t2)
    sw t1, 0x58(t5)
    lw t1, 0x5c(t2)
    sw t1, 0x5c(t5)
    lw t1, 0x60(t2)
    sw t1, 0x60(t5)

    j schedule_next

create_fail:
    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    li t1, -1
    sw t1, 0x28(t2)
    ret

kill_process:
    li t0, 0x100c0
    lw t1, 0(t0)
    li t2, 0x10000
    slli t3, t1, 7
    add t2, t2, t3
    li t0, 0
    sw t0, 0x58(t2)
    li t0, 0x100c4
    lw t1, 0(t0)
    addi t1, t1, -1
    sw t1, 0(t0)
    ret

shutdown:
    j shutdown