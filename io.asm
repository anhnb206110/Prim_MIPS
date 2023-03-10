# Title: Input output helper    Filename: io.asm
# Author: anhnb206110           Date: 18/01/2023
# Description: Mot so macro de giup cho viec doc va ghi don gian hon khi lam viec voi file va ban phim
# Input: 
# Output: 

###################################################################
# In ky tu %c ma khong lam thay doi gia tri thanh ghi nao
.macro putc(%c)
    .text
        addi $sp, $sp, -8
        sw $v0, ($sp)
        sw $a0, 4($sp) 
        addi $v0, $0, 11
        addi $a0, $0, %c
        syscall
        lw $v0, ($sp)
        lw $a0, 4($sp)
        addi $sp, $sp, 8
.end_macro

# In khoang trang
.macro space
    putc(' ')
.end_macro

# In ky tu xuong dong
.macro endl
    putc('\n')
.end_macro

# Voi index = a, index < b thi jump and link %handle
.macro for(%index, %a, %b, %handle)
    .text
        add %index, $0, %a
    _loop:
        beq %index, %b, _end_loop
        jal %handle
        add %index, %index, 1
        j _loop
    _end_loop:
.end_macro

# Doc so nguyen vao thanh ghi %des
.macro read_int(%des)
    .text
        addi $sp, $sp, -4
        sw $v0, ($sp)
        addi $v0, $0, 5
        syscall
        add %des, $v0, $0
        lw $v0, ($sp)
        addi $sp, $sp, 4
.end_macro

# In so nguyen co trong thanh ghi %src
.macro print_int(%src)
    .text
        addi $sp, $sp, -8
        sw $v0, ($sp)
        sw $a0, 4($sp)
        addi $v0, $0, 1
        add $a0, %src, $0
        syscall
        lw $v0, ($sp)
        lw $a0, 4($sp)
        addi $sp, $sp, 8
.end_macro

# In so thuc chinh xac don luu trong thanh ghi %src (%src bat dau bang 'f')
.macro print_float(%src)
    .text
        addi $sp, $sp, -8
        sw $v0, ($sp)
        s.s $f12, 4($sp)
        addi $v0, $0, 2
        mov.s $f12, %src
        syscall
        lw $v0, ($sp)
        l.s $f12, 4($sp)
        addi $sp, $sp, 8
.end_macro

# Truc tiep in ra xau (khong co ky tu xuong dong)
.macro print_string(%string)
    .data
        str: .asciiz %string
    .text
        addi $sp, $sp, -8
        sw $v0, ($sp)
        sw $a0, 4($sp)
        addi $v0, $0, 4
        la $a0, str
        syscall
        lw $v0, ($sp)
        lw $a0, 4($sp)
        addi $sp, $sp, 8
.end_macro

# In ra xau co dia chi ban dau luu trong thanh ghi %string
.macro print_str(%string)
    .text
        addi $sp, $sp, -8
        sw $v0, ($sp)
        sw $a0, 4($sp)
        addi $v0, $0, 4
        move $a0, %string
        syscall
        lw $v0, ($sp)
        lw $a0, 4($sp)
        addi $sp, $sp, 8
.end_macro

# Doc mot xau ky tu vao buffer (max 256 bytes)
.macro read_string(%buffer)
	.text
		addi $sp, $sp, -12
		sw $v0, ($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		li $v0, 8
		la $a0, %buffer
		li $a1, 256
		syscall
	loop:
		lb $a1, ($a0)
		beq $a1, '\n', end_read
		addi $a0, $a0, 1
		j loop
	end_read:
		sb $0, ($a0)
		lw $v0, ($sp)
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		addi $sp, $sp, 12
.end_macro

# Gan gia tri cua mang %buffer bang gia tri %value, %size tinh bang byte
.macro memset(%buffer, %size, %value)
    .text
        addi $sp, $sp, -8
        sw $t8, ($sp)
        sw $t9, 4($sp)
        la $t8, %buffer
        addi $t9, $t8, %size
        li $at, %value
    clear_next:
        beq $t8, $t9, end_clear
        sw $at, ($t8)
        addi $t8, $t8, 4
        j clear_next
    end_clear:
        lw $t8, ($sp)
        lw $t9, 4($sp)
        addi $sp, $sp, 8
.end_macro

################## Lam viec voi file ###########################
# Mo file, tra ve thanh ghi %file_ptr, la so am neu loi
.macro fopen(%filename, %flags, %file_ptr)
    .text
        addi $v0, $0, 13
        move $a0, %filename
        li $a1, %flags            # 0 : read, 1 : write
        li $a2, 0                # ignore
        syscall
        move %file_ptr, $v0        # return value, negative if error
.end_macro

# Doc noi dung %file vao %buffer voi kich thuoc buffer la %buffer_size, kich thuoc chuoi doc duoc la %actual_size
.macro fread(%file, %buffer, %actual_size, %buffer_size)
    .text
        addi $v0, $0, 14
        add $a0, $0, %file
        add $a1, $0, %buffer    # data store in this buffer
        addi $a2, $0, %buffer_size
        syscall
        move %actual_size, $v0    # return value
.end_macro

# Dong file khi khong su dung nua
.macro fclose(%file)
    .text
        addi $sp, $sp, -8
        sw $v0, ($sp)
        sw $a0, 4($sp)
        addi $v0, $0, 16
        add $a0, $0, %file
        syscall
        lw $v0, ($sp)
        lw $a0, 4($sp)
        addi $sp, $sp, 8
.end_macro

# Exit the program
.macro exit
    addi $v0, $0, 10
    syscall    
.end_macro
