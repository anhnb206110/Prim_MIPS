# Title: Matrix helper            Filename: matrix.asm
# Author: anhnb206110           Date: 18/01/2023
# Description: Mot so chuc nang tro giup cho viec cap phat bo nho, truy cap ma tran, doc ma tran tu file
# Input: 
# Output: 

##############################################################################
# The buffer
.data
    _buffer: .space 2048    # global buffer for use

# Cap phat mang 1 chieu voi %size phan tu, cac phan tu la 32-bit
.macro malloc_arr(%des, %size)
    .text
        addi $sp, $sp, -8
        sw $v0, ($sp)
        sw $a0, 4($sp)
        addi $v0, $0, 9
        sll $a0, %size, 2
        syscall
        add %des, $v0, $0
        lw $v0, ($sp)
        lw $a0, 4($sp)
        addi $sp, $sp, 8
.end_macro

# Truy cap den phan tu thu %index trong mang %arr, ket qua tra ve %des
.macro get(%des, %arr, %index)    # des = arr[index]
    .text
        addi $sp, $sp, -4
        sw %index, ($sp)
        sll %index, %index, 2
        add %index, %index, %arr
        lw %des, (%index)
        lw %index, ($sp)
        addi $sp, $sp, 4
.end_macro

# Gan gia tri %src cho phan tu thu %index cua mang %arr
.macro set(%src, %arr, %index)    # arr[index] = src
    .text
        addi $sp, $sp, -4
        sw %index, ($sp)
        sll %index, %index, 2
        add %index, %index, %arr
        sw %src, (%index)
        lw %index, ($sp)
        addi $sp, $sp, 4
.end_macro

##############################################################################
# Mang 2 chieu (Ma tran)
.macro malloc_arr2D(%des, %row, %column)
    .text
        addi $sp, $sp, -8
        sw $t0, ($sp)
        sw $t1, 4($sp)
        malloc_arr(%des, %row)
        for($t0, $0, %row, alloc_row)
        j end_alloc
    alloc_row:
        malloc_arr($t1, %column)
        set($t1, %des, $t0)
        jr $ra
    end_alloc:
        lw $t0, ($sp)
        lw $t1, 4($sp)
        addi $sp, $sp, 8
.end_macro

.macro get2D(%des, %arr, %row, %column)    # des = arr[row][column]
    .text
        get($at, %arr, %row)
        get(%des, $at, %column)
.end_macro

.macro set2D(%src, %arr, %row, %column)    # arr[row][column] = src
    .text
        get($at, %arr, %row)
        set(%src, $at, %column)
.end_macro

# Chuyen mang 1 chieu %data thanh mang 2 chieu %des voi %row hang va %column cot
.macro reshape(%des, %data, %row, %column)
    .text
        malloc_arr2D(%des, %row, %column)
        for($t9, $0, %row, set_row)
        j end_reshape
    set_row:
        addi $sp, $sp, -4
        sw $ra, ($sp)
        for($t8, $0, %column, set_column)
        lw $ra, ($sp)
        addi $sp, $sp, 4
        jr $ra
    set_column:
        mul $at, $t9, %column
        add $at, $at, $t8
        get($t7, %data, $at)
        set2D($t7, %des, $t9, $t8)
        jr $ra
    end_reshape:
.end_macro
###############################################################################
# Doc ma tran so nguyen duong tu xau ky tu %buffer,
# kich thuoc %buffer la %size va tra ve ma tran vuong %out_mat voi kich thuoc %out_size
.macro read_matrix(%buffer, %size, %out_mat, %out_size)
    .text
        addi $sp, $sp, -8
        sw %out_mat, ($sp)
        sw %size, 4($sp)
    initial:
        add $t5, $0, $0
        add $t2, $0, $0
        add %size, %buffer, %size
        for($t0, %buffer, %size, convert)
        j end_read
    convert:
        lb $t1, ($t0)
        sge $t3, $t1, '0'
        sle $t4, $t1, '9'
        and $t3, $t3, $t4
        bne $t3, $0, increase_temp
        beq $t2, $0, continue
        add $t2, $0, $0
        sw $t5, (%out_mat)
        addi %out_mat, %out_mat, 4
        add $t5, $0, $0
        j continue
    increase_temp:
        subi $t1, $t1, '0'
        mul $t5, $t5, 10
        add $t5, $t5, $t1
        addi $t2, $0, 1
        j continue
    continue:
        jr $ra
    end_read:
        sw $t5, (%out_mat)
        addi %out_mat, %out_mat, 4
        lw %out_size, ($sp)
        sub %out_size, %out_mat, %out_size
        sra %out_size, %out_size, 2
        addi %out_size, %out_size, -1
        malloc_arr(%out_mat, %out_size)
        addi %out_size, %out_size, 1
        lw %out_mat, ($sp)
        lw %size, 4($sp)
        addi $sp, $sp, 8
.end_macro

# In ma tran %mat voi %row hang va %column cot
.macro print_matrix(%mat, %row, %column)
    .text
        for($t7, $0, %row, print_row)
        j end_print
    print_row:
        addi $sp, $sp, -4
        sw $ra, ($sp)
        for($t8, $0, %column, print_column)
        endl
        lw $ra, ($sp)
        addi $sp, $sp, 4
        jr $ra
    print_column:
        get2D($t9, %mat, $t7, $t8)
        print_int($t9)
        space
        jr $ra
    end_print:
.end_macro

# Doc ma tran vuong gom cac so nguyen duong tu %filename va tra ve %out_mat, %out_size
.macro load_smatrix(%filename, %out_mat, %out_size)
    .text
        addi $sp, $sp, -16
        sw $t6, 12($sp)
        sw $t7, ($sp)
        sw $t8, 4($sp)
        sw $t9, 8($sp)
        la $t8, _buffer                             # Ready to read the matrix
        memset(_buffer, 2048, 0)
        fopen(%filename, 0, $t7)                    # s0 = fopen("...", 'r')
        blt $t7, $0, end_load
        fread($t7, $t8, $t9, 2048)                  # read string into s1 with s2 = length(s1)
        fclose($t7)
        li %out_size, 1
        malloc_arr($t6, %out_size)                	# Allocate an array 1 elements (32-bit array)
        read_matrix($t8, $t9, $t6, %out_size)
    end_load:
        sqrti(%out_size, %out_size)
        reshape(%out_mat, $t6, %out_size, %out_size)
        lw $t6, 12($sp)
        lw $t7, ($sp)
        lw $t8, 4($sp)
        lw $t9, 8($sp)
        addi $sp, $sp, 16
.end_macro
