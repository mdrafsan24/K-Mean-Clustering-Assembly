.data
    myArray: .space 4
.text

main:
    addi $s0, $zero, 4123
    addi $s1, $zero, 9999
    ##addi $s2, $zero, $zero

    li $t0, 0
    lw $t6, myArray($t0)

    li $v0, 1
    addi $a0, $t6, 0
    syscall

    lw $t6, myArray($t0)
    addi $t6, $t6, 1
    sw $t6, myArray($t0)

    li $v0, 1
    addi $a0, $t6, 0
    syscall

    lw $t6, myArray($t0)
    addi $t6, $t6, 1
    sw $t6, myArray($t0)

    li $v0, 1
    addi $a0, $t6, 0
    syscall

    lw $t6, myArray($t0)
    addi $t6, $t6, 1
    sw $t6, myArray($t0)

    li $v0, 1
    addi $a0, $t6, 0
    syscall

    lw $t6, myArray($t0)
    addi $t6, $t6, 1
    sw $t6, myArray($t0)

    li $v0, 1
    addi $a0, $t6, 0
    syscall
