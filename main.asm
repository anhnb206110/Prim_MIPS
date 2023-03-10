# Title: Prim algorithm         Filename: main.asm
# Author: anhnb206110           Date: 18/01/2023
# Description: Chuong trinh thuc hien thuat toan Prim tim cay khung nho nhat
# Input: Ma tran trong so cua do thi (Ma tran vuong kich thuoc VxV, voi V la so luong dinh) 
# Output: Cay khung co tong trong so nho nhat

.include "io.asm"
.include "math.asm"
.include "matrix.asm"
.include "Prim.asm"

############################ Main program ##################################
.data
	filename: .space 256

.text
	
.globl main
main:
    print_string("\n______________________________________________\n")
    print_string("1. Nhap tu file\n")
    print_string("2. Nhap tu ban phim\n")
    print_string("3. Chay thuat toan Prim tim cay khung nho nhat\n")
    print_string("4. Thoat\n")
    print_string("Lua chon: ")
    addi $v0, $0, 5
    syscall
    # Switch case
    beq $v0, 1, case1
    beq $v0, 2, case2
    beq $v0, 3, case3
    beq $v0, 4, case4
    print_string("Lua chon khong hop le\n")
    j main
    
case1:
	print_string("Nhap duong dan den file: ")
	read_string(filename)
    print_string("Ma tran doc duoc la:\n")
    la $s0, filename
    load_smatrix($s0, $s3, $s4)     # s3 = load_matrix("..."); s4 = row(s3)
    print_matrix($s3, $s4, $s4)     # print_matrix(s3, row, column)
    j main

case2:
    from_keyboard($s3, $s4)
    print_string("\nNhap thanh cong! Ma tran trong so la:\n")
    print_matrix($s3, $s4, $s4)
    j main

case3:
	beq $s4, $0, main				# Ma tran chua duoc nap (so hang = 0)
    Prim($s3, $s4)
    j main

case4:
    exit
