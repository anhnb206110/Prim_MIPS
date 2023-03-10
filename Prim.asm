# Title: Prim algorithm         Filename: Prim.asm
# Author: anhnb206110           Date: 18/01/2023
# Description: Thuat toan Prim va cac ham bo tro
# Input: Ma tran trong so cua do thi (Ma tran vuong kich thuoc VxV, voi V la so luong dinh) 
# Output: Cay khung co tong trong so nho nhat

###########################################################################
.data
            .align 2
    parent: .space 512
    key:    .space 512
    mstSet: .space 512

###########################################################################
# Thuat toan chinh
.macro Prim(%graph, %vertex)
    .text
        memset(parent, 512, 0)        	# int parent[V]
        memset(key, 512, 10000)     	# int key[V] = INT_MAX (10000)
        memset(mstSet, 512, 0)        	# bool mstSet[V] = false
        la $t1, parent
        la $t2, key
        la $t3, mstSet
        li $t4, 0
        set($0, $t2, $t4)            	# key[0] = 0
        li $t5, -1
        set($t5, $t1, $t4)            	# parent[0] = -1
        addi $t4, %vertex, -1
        for($t0, $0, $t4, loop)        	# for (count = 0; count < V - 1; count++)
        j end_Prim
    loop:
        addi $sp, $sp, -4
        sw $ra, ($sp)
        minKey($v1, $t2, $t3, %vertex)  # u = minKey(key, mstSet)
        li $at, 1
        set($at, $t3, $v1)              # mstSet[u] = true
        for($t5, $0, %vertex, loop2)    # for(v = 0; v < V; v++)
        lw $ra, ($sp)
        addi $sp, $sp, 4
        jr $ra
    loop2:
        get2D($t6, %graph, $v1, $t5)    # t6 = graph[u][v]
        get($t7, $t3, $t5)              # t7 = mstSet[v]
        seq $t7, $t7, $0                # t7 = mstSet[v] == false
        sne $t8, $t6, $0
        and $t7, $t8, $t7               # mstSet[v] == false && graph[u][v]
        get($t8, $t2, $t5)              # key[v]
        slt $t8, $t6, $t8               # graph[u][v] < key[v]
        and $t8, $t7, $t8                
        beq $t8, $0, assign
        set($v1, $t1, $t5)              # parent[v] = u
        set($t6, $t2, $t5)              # key[v] = graph[u][v]
    assign:
        jr $ra
    end_Prim:
        printMST($t1, %graph, %vertex)
.end_macro

# In cay khung nho nhat
.macro printMST(%parent, %graph, %vertex)
    .text
        addi $sp, $sp, -12    # start printMST
        sw $t8, ($sp)
        sw $t9, 4($sp)
        sw $t7, 8($sp)
        print_string("Canh \tTrong so\n")
        li $t9, 1
        li $a0, 0
        for($t8, $t9, %vertex, loop)
        j end_printMST
    loop:
        get($t9, %parent, $t8)
        print_int($t9)
        print_string(" - ")
        print_int($t8)
        putc('\t')
        get2D($t7,%graph, $t8, $t9)
        print_int($t7)
        endl
        add $a0, $a0, $t7
        jr $ra
    end_printMST:
        print_string("Tong trong so: ")
        print_int($a0)
        lw $t8, ($sp)
        lw $t9, 4($sp)
        lw $t7, 8($sp)
        addi $sp, $sp, 12
.end_macro

# Canh co trong so be nhat
.macro minKey(%des, %key, %mstSet, %vertex)
    .text
        addi $sp, $sp, -16        # Start minKey
        sw $t7, ($sp)
        sw $t8, 4($sp)
        sw $t9, 8($sp)
        sw $t6, 12($sp)
        li $t7, 10000
        for($t8, $0, %vertex, loop)
        j end_minKey
    loop:
        get($t9, %mstSet, $t8)
        seq $t6, $t9, $0
        get($t9, %key, $t8)
        slt $t9, $t9, $t7
        and $t6, $t6, $t9
        beq $t6, $0, continue
        get($t9, %key, $t8)
        add $t7, $t9, $0
        add %des, $t8, $0    # min_index = v
        j continue
    continue:
        jr $ra
    end_minKey:
        lw $t7, ($sp)
        lw $t8, 4($sp)
        lw $t9, 8($sp)
        lw $t6, 12($sp)
        addi $sp, $sp, 16
.end_macro

# Nhap du lieu tu ban phim
.macro from_keyboard(%mat, %vertex)
    .text
        print_string("Nhap so luong dinh V = ")
        read_int(%vertex)
        malloc_arr2D(%mat, %vertex, %vertex)
        print_string("Nhap so luong canh M = ")
        read_int($t1)
        for($t0, $0, $t1, read_edge)
        j end_read
    read_edge:
        print_string("Nhap canh thu #")
        print_int($t0)
        endl
        print_string("Dinh dau: ")
        read_int($t2)
        print_string("Dinh cuoi: ")
        read_int($t3)
        print_string("Trong so canh: ")
        read_int($t4)
        set2D($t4, %mat, $t2, $t3)
        set2D($t4, %mat, $t3, $t2)
        jr $ra
    end_read:
.end_macro
