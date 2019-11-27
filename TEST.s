.data
str: .asciiz "Hello mum!.\n"
.text
.globl main #necessary for the assembler
main:
    jal message
    jal message
    li $v0,10
    syscall #exit the program gracefully
message:
    la $a0,str
    li $v0,4
    syscall #Magic to printhings on the screen.
    jr $ra
