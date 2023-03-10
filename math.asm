# Title: Math library           Filename: math.asm
# Author: anhnb206110           Date: 18/01/2023
# Description: Thu vien tinh toan toan hoc
# Input: 
# Output: 

###################################################################
# Square root of an integer
.macro sqrti(%x, %sqrtx)
    .text
        slt $t0, %x, $0        # Check if the integer is negative
        bne $t0, $0, end
        mtc1 %x, $f1        # Move to coproc1
        cvt.s.w $f1, $f1    # Convert to float
        # Take the square root of $f1
        sqrt.s $f12, $f1
        cvt.w.s $f12, $f12
        mfc1 %sqrtx, $f12
    end:
.end_macro

.macro fabs(%f)
    .text
        mfc1 $t9, %f
        sll $t9, $t9, 1
        srl $t9, $t9, 1
        mtc1 $t9, %f
.end_macro
