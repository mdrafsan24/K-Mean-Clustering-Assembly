.data
allInputsArray: .space 40 # Has at most 10 vals ; contains all inputs
centroidOneArray: .space 40 # Has at most 10 vals , each 4 bits there 4X10 = 40
centroidTwoArray: .space 40 # Has at most 10 vals , each 4 bits there 4X10 = 40

MSG1: .asciiz "Enter all coordinate in 0000 format:" # Asking for user Input

CentroidOne: .asciiz "This is the first centroid: "
CentroidTwo: .asciiz "This is the second centroid: "

distanceCentroidOne : .asciiz "Distance from centroid one: "
distanceCentroidTwo : .asciiz "Distance from centroid two: "

newline: .asciiz "\n" #To print a new line

.text
.globl main

#########################################################
######### Reads and puts values in t0-t9 ################
#########################################################
main:
    li $v0,4
    la $a0, MSG1
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s0,$v0 #save the read integer
    move $t0, $s0 #Move number to $a0

    move $s0, $0
    li $s0, 0
    move $v0, $0
    li $v0, 0


    li $v0,4
    la $a0, MSG1
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s0,$v0 #save the read integer
    move $t1, $s0 #Move number to $a0

    move $s0, $0
    li $s0, 0
    move $v0, $0
    li $v0, 0


    li $v0,4
    la $a0, MSG1
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s0,$v0 #save the read integer
    move $t2, $s0 #Move number to $a0

    move $s0, $0
    li $s0, 0
    move $v0, $0
    li $v0, 0


    li $v0,4
    la $a0, MSG1
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s0,$v0 #save the read integer
    move $t3, $s0 #Move number to $a0

    move $s0, $0
    li $s0, 0
    move $v0, $0
    li $v0, 0


    li $v0,4
    la $a0, MSG1
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s0,$v0 #save the read integer
    move $t4, $s0 #Move number to $a0

    move $s0, $0
    li $s0, 0
    move $v0, $0
    li $v0, 0


    li $v0,4
    la $a0, MSG1
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s0,$v0 #save the read integer
    move $t5, $s0 #Move number to $a0

    move $s0, $0
    li $s0, 0
    move $v0, $0
    li $v0, 0


    li $v0,4
    la $a0, MSG1
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s0,$v0 #save the read integer
    move $t6, $s0 #Move number to $a0

    move $s0, $0
    li $s0, 0
    move $v0, $0
    li $v0, 0


    li $v0,4
    la $a0, MSG1
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s0,$v0 #save the read integer
    move $t7, $s0 #Move number to $a0

    move $s0, $0
    li $s0, 0
    move $v0, $0
    li $v0, 0


    li $v0,4
    la $a0, MSG1
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s0,$v0 #save the read integer
    move $t8, $s0 #Move number to $a0

    move $s0, $0
    li $s0, 0
    move $v0, $0
    li $v0, 0


    li $v0,4
    la $a0, MSG1
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s0,$v0 #save the read integer
    move $t9, $s0 #Move number to $a0

    move $s0, $0
    li $s0, 0
    move $v0, $0
    li $v0, 0

    # Clear a0 and a1
    move $a0, $0
    li $a0, 0
    move $a1, $0
    li $a1, 0

    move $a2, $0
    li $a2, 0


##########################################
# t4 and t8 are the first two centroids  #
# Reads and print coordinate in (00,00)  #
##########################################
printCentroid:
    li $v0, 4
    la $a0, CentroidOne
    syscall
    li $a0, '('
    li $v0, 11    # print_character
    syscall
    li $s7, 100
    div $t4, $s7
    mflo $s0
    mfhi $s1

    li $v0, 1
    move $a0, $s0
    syscall
    li $a0, ','
    li $v0, 11    # print_character
    syscall
    li $v0, 1
    move $a0, $s1
    syscall
    li $a0, ')'
    li $v0, 11    # print_character
    syscall

    li $v0, 4
    la $a0, newline
    syscall
###################################### PRINTS NEW LINE ###########################
    li $v0, 4
    la $a0, CentroidTwo
    syscall
    li $a0, '('
    li $v0, 11    # print_character
    syscall
    li $s7, 100
    div $t8, $s7
    mflo $s2
    mfhi $s3

    li $v0, 1
    move $a0, $s2
    syscall
    li $a0, ','
    li $v0, 11    # print_character
    syscall
    li $v0, 1
    move $a0, $s3
    syscall
    li $a0, ')'
    li $v0, 11    # print_character
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    j goThroughEachPoint

##### Calculates new centroid and puts it into s0,s1,s2,s3 ########
calculateNewCentroid:
    addi $s0, $s0, 2
    addi $s1, $s1, 3
    addi $s2, $s2, 5
    addi $s3, $s3, 2
################################################
# Will go through each point print coordinate  #
# Then calculate distance from each centroid   #
################################################
goThroughEachPoint:

    li $s7, 100
    div $t0, $s7
    mflo $s4
    mfhi $s5
    jal printCoordinate
    jal printDistance

    li $s7, 100
    div $t1, $s7
    mflo $s4
    mfhi $s5
    jal printCoordinate
    jal printDistance

    li $s7, 100
    div $t2, $s7
    mflo $s4
    mfhi $s5
    jal printCoordinate
    jal printDistance

    li $s7, 100
    div $t3, $s7
    mflo $s4
    mfhi $s5
    jal printCoordinate
    jal printDistance

    li $s7, 100
    div $t4, $s7
    mflo $s4
    mfhi $s5
    jal printCoordinate
    jal printDistance

    li $s7, 100
    div $t5, $s7
    mflo $s4
    mfhi $s5
    jal printCoordinate
    jal printDistance

    li $s7, 100
    div $t6, $s7
    mflo $s4
    mfhi $s5
    jal printCoordinate
    jal printDistance

    li $s7, 100
    div $t7, $s7
    mflo $s4
    mfhi $s5
    jal printCoordinate
    jal printDistance

    li $s7, 100
    div $t8, $s7
    mflo $s4
    mfhi $s5
    jal printCoordinate
    jal printDistance

    li $s7, 100
    div $t9, $s7
    mflo $s4
    mfhi $s5
    jal printCoordinate
    jal printDistance

#############################  Check If Cluster Same  #################################
    jal checkClusterSameOrNot

#############################  Refill t0-t9 with new vals  #################################

    lw $t0, centroidOneArray($a0)
    lw $t5, centroidTwoArray($a0)
    addi $a0, $a0, 4
    lw $t1, centroidOneArray($a0)
    lw $t6, centroidTwoArray($a0)
    addi $a0, $a0, 4
    lw $t2, centroidOneArray($a0)
    lw $t7, centroidTwoArray($a0)
    addi $a0, $a0, 4
    lw $t3, centroidOneArray($a0)
    lw $t8, centroidTwoArray($a0)
    addi $a0, $a0, 4
    lw $t4, centroidOneArray($a0)
    lw $t9, centroidTwoArray($a0)
    addi $a0, $a0, 4


    jal cleanArrays # Clean up both arrays

    ### Clean up all variables ##
    move $v0, $0
    li $v0, 0
    move $v1, $0
    li $v1, 0
    move $a0, $0
    li $a0, 0
    move $a1, $0
    li $a1, 0
    move $a2, $0
    li $a2, 0
    move $a3, $0
    li $a3, 0

    move $s0, $0
    li $s0, 0
    move $s1, $0
    li $s1, 0
    move $s2, $0
    li $s2, 0
    move $s3, $0
    li $s4, 0
    move $s4, $0
    li $s4, 0
    move $s5, $0
    li $s5, 0
    move $s6, $0
    li $s6, 0
    move $s7, $0
    li $s7, 0

    j calculateNewCentroid

    jal exit


##############################################
# Prints distance and then compares and puts #
# the value in the right array ###############
##############################################
printDistance :
    sub $a0, $s0, $s4
    mul $a0, $a0, $a0
    sub $a1, $s1, $s5
    mul $a1, $a1, $a1
    add $s6, $a0, $a1
    li $v0, 4
    la $a0, distanceCentroidOne
    syscall
    li $v0, 1
    move $a0, $s6
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    move $a0, $0
    li $a0, 0
    move $a1, $0
    li $a1, 0

    sub $a0, $s2, $s4
    mul $a0, $a0, $a0
    sub $a1, $s3, $s5
    mul $a1, $a1, $a1
    add $s7, $a0, $a1
    li $v0, 4
    la $a0, distanceCentroidTwo
    syscall
    li $v0, 1
    move $a0, $s7
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    move $a0, $0
    li $a0, 0
    move $a1, $0
    li $a1, 0

    bge $s6, $s7, putInCTwo # Check to see if s6 > s7 if it is then put in Centroid Two
    ### Now the we checked the distance we can free up s6 and s7
    move $s6, $0
    li $s6, 0
    move $s7, $0
    li $s7, 0
    #################################################
    mul $a2, $a2, 100
    add $a2, $a2, $s4
    mul $a2, $a2, 100
    add $a2, $a2, $s5 # $a2 has the coordinate in 0000 format
    #### Store 10 in s7
    sw $a2, centroidOneArray($a3)
    addi $a3, $a3, 4 #Adding 4 so the index of centroid one array is at 4

    ####### CLEAN UP a2, s6, s7 ########### NEVER CLEAN UP a3
    move $a2, $0
    li $a2, 0
    move $s6, $0
    li $s6, 0
    move $s7, $0
    li $s7, 0

    jr $ra

#0101
putInCTwo:
    mul $a2, $a2, 100
    add $a2, $a2, $s4
    mul $a2, $a2, 100
    add $a2, $a2, $s5 # $a2 has the coordinate in 0000 format
    #### Store 10 in s7

    sw $a2, centroidTwoArray($v1)
    addi $v1, $v1, 4 #Adding 4 so the index of centroid one array is at 4

    ####### CLEAN UP a2, s6, s7 ########### NEVER CLEAN UP v1
    move $a2, $0
    li $a2, 0
    move $s6, $0
    li $s6, 0
    move $s7, $0
    li $s7, 0

    jr $ra

printCoordinate:
    li $a0, '('
    li $v0, 11    # print_character
    syscall
    li $v0, 1
    move $a0, $s4
    syscall
    li $a0, ','
    li $v0, 11    # print_character
    syscall
    li $v0, 1
    move $a0, $s5
    syscall
    li $a0, ')'
    li $v0, 11    # print_character
    syscall
    jr $ra

cleanArrays:
    move $a0, $0
    li $a0, 0

    sw $zero, centroidOneArray($a0)
    sw $zero, centroidTwoArray($a0)
    addi $a0, $a0, 4
    sw $zero, centroidOneArray($a0)
    sw $zero, centroidTwoArray($a0)
    addi $a0, $a0, 4
    sw $zero, centroidOneArray($a0)
    sw $zero, centroidTwoArray($a0)
    addi $a0, $a0, 4
    sw $zero, centroidOneArray($a0)
    sw $zero, centroidTwoArray($a0)
    addi $a0, $a0, 4
    sw $zero, centroidOneArray($a0)
    sw $zero, centroidTwoArray($a0)

    move $a0, $0
    li $a0, 0

    jr $ra

checkClusterSameOrNot:
    lw $a2, centroidOneArray($a0)
    bne $a2, $t0, goBackToMethodCall
    lw $a2, centroidTwoArray($a0)
    bne $a2, $t5, goBackToMethodCall
    addi $a0, $a0, 4
    lw $a2, centroidOneArray($a0)
    bne $a2, $t1, goBackToMethodCall
    lw $a2, centroidTwoArray($a0)
    bne $a2, $t6, goBackToMethodCall
    addi $a0, $a0, 4
    lw $a2, centroidOneArray($a0)
    bne $a2, $t2, goBackToMethodCall
    lw $a2, centroidTwoArray($a0)
    bne $a2, $t7, goBackToMethodCall
    addi $a0, $a0, 4
    lw $a2, centroidOneArray($a0)
    bne $a2, $t3, goBackToMethodCall
    lw $a2, centroidTwoArray($a0)
    bne $a2, $t8, goBackToMethodCall
    addi $a0, $a0, 4
    lw $a2, centroidOneArray($a0)
    bne $a2, $t4, goBackToMethodCall
    lw $a2, centroidTwoArray($a0)
    bne $a2, $t9, goBackToMethodCall

    jal exit

    goBackToMethodCall:
        jr $ra

exit:
    li $v0, 10
    syscall


## ISSUE CANT USE temporaries gotta use array and gotta store ONLY in array
