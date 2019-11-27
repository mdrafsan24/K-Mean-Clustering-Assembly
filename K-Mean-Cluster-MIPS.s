.data
    allInputsArray: .space 40 # Has at most 10 vals ; contains all inputs
    centroidOneArray: .space 40 # Has at most 10 vals , each 4 bits there 4X10 = 40
    centroidTwoArray: .space 40 # Has at most 10 vals , each 4 bits there 4X10 = 40

    centroidOneSize: .space 4
    centroidTwoSize: .space 4
    
MSG1: .asciiz "Enter all coordinate in 0000 format:" # Asking for user Input
MSG2: .asciiz "Enter the first centroid in 0000 format: " # Asking for first centroid
MSG3: .asciiz "Enter the second centroid in 0000 format: " # Asking for first centroid

CentroidOne: .asciiz "This is the first centroid: "
CentroidTwo: .asciiz "This is the second centroid: "

distanceCentroidOne : .asciiz "Distance from centroid one: "
distanceCentroidTwo : .asciiz "Distance from centroid two: "

newline: .asciiz "\n" #To print a new line

.text
.globl main

######################################################################
######### Reads and puts all inputs in allInputsArray ################
######### Read and puts the two centroids in s0,s1   ################
######################################################################
main:
    li $v0,4
    la $a0, MSG1
    syscall
    li $v0,5 #tell syscall to read integer
    syscall

    move $s0,$v0 # Save read integer in s0
    sw $s0, allInputsArray($t0) # Storing read int in array
    addi $t0, $t0, 4 # increase index of t0 by 4

    beq $t0, 40, getCentroid
    j main

##### Reads centroids and puts them in s0,s1 respectively #####
##### s0 and s1 has the first and second centroid always #####
getCentroid:
    li $v0,4
    la $a0, MSG2
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s0,$v0 # Save read integer in s0

    li $v0,4
    la $a0, MSG3
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s1,$v0 # Save read integer in s0

    #### clear up registers #####
    move $v0, $0
    li $v0, 0
    move $t0, $0
    li $t0, 0

##### s0 - Centroid One
##### s1 - Centroid Two
##########################################
# s0 and s1 are the two centroids  #######
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
    div $s0, $s7
    mflo $s5
    mfhi $s6

    li $v0, 1
    move $a0, $s5
    syscall
    li $a0, ','
    li $v0, 11    # print_character
    syscall
    li $v0, 1
    move $a0, $s6
    syscall
    li $a0, ')'
    li $v0, 11    # print_character
    syscall

    li $v0, 4
    la $a0, newline
    syscall
#################### PRINTS NEW LINE ###########################
    li $v0, 4
    la $a0, CentroidTwo
    syscall
    li $a0, '('
    li $v0, 11    # print_character
    syscall
    li $s7, 100
    div $s1, $s7
    mflo $s5
    mfhi $s6

    li $v0, 1
    move $a0, $s5
    syscall
    li $a0, ','
    li $v0, 11    # print_character
    syscall
    li $v0, 1
    move $a0, $s6
    syscall
    li $a0, ')'
    li $v0, 11    # print_character
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    #### clear up registers #####
    move $s5, $0
    li $s5, 0
    move $s6, $0
    li $s6, 0
    move $s7, $0
    li $s7, 0
    move $v0, $0
    li $v0, 0

### After printing Centroid One and Two #######
################################################
# Will go through each point print coordinate  #
# Then calculate distance from each centroid   #
################################################
goThroughEachPoint:
    lw $t0, allInputsArray($t1)
    li $s7, 100
    div $t0, $s7
    mflo $s4  # X value of each point
    mfhi $s5 # Y value of each point
    jal printCoordinate
    jal printDistance
    addi $t1, $t1, 4
    li $a2, 0
    li $a3, 0
    li $t8, 0
    li $t6, 0
    beq $t1, 40, calculateNewCentroidOne
    j goThroughEachPoint

#CALCULATES new centroid and puts it back into s0 and s1
calculateNewCentroidOne:
    li $t0, 0
    lw $t1, centroidOneArray($t0)
    lw $t8, centroidOneSize($zero)
    beq $a2, $t8, putNewCentroidOne
    move $t8, $0
    li $t8, 0
    li $s7, 100
    div $t1, $s7
    mflo $t2 # contains x of point in centroid one
    mfhi $t3 # contains y of point in centroid one
    add $t4, $t4, $t2 # Add all the x values
    add $t5, $t5, $t3 # Add all the y values
    add $t6, $t6, 1 #t6 is the number we gotta divide by
    addi $a2, $a2, 1
    j calculateNewCentroidOne

putNewCentroidOne:
    ### Find and store centroid one in s0
    lw $t6, centroidOneSize($zero)
    div $t4, $t6
    mflo $t7 ## **Might be an issue late if $t7 turns out to be 3 digits
    div $t5, $t6
    mflo $t8
    li $t9, 100
    mul $t7, $t7, $t9
    add $t7, $t7, $t8
    move $s0, $t7
    move $t0, $0
    li $t0, 0
    move $t1, $0
    li $t1, 0
    move $t2, $0
    li $t2, 0
    move $t3, $0
    li $t3, 0
    move $t4, $0
    li $t4, 0
    move $t5, $0
    li $t5, 0
    move $t6, $0
    li $t6, 0
    move $t7, $0
    li $t7, 0
    move $t8, $0
    li $t8, 0
    move $t9, $0
    li $t9, 0
    move $a2, $0
    li $a2, 0
    j calculateNewCentroidTwo

calculateNewCentroidTwo:
    li $t0, 0
    lw $t1, centroidTwoArray($t0)
    lw $t8, centroidTwoSize($zero)
    beq $a2, $t8, putNewCentroidTwo
    move $t8, $0
    li $t8, 0
    li $s7, 100
    div $t1, $s7
    mflo $t2 # contains x of point in centroid two
    mfhi $t3 # contains y of point in centroid two
    add $t4, $t4, $t2 # Add all the x values
    add $t5, $t5, $t3 # Add all the y values
    add $t6, $t6, 1 #t6 is the number we gotta divide by
    addi $a2, $a2, 1
    j calculateNewCentroidTwo
putNewCentroidTwo:
    ### Find and store centroid one in s0
    lw $t6, centroidOneSize($zero)
    div $t4, $t6
    mflo $t7 ## **Might be an issue late if $t7 turns out to be 3 digds
    div $t5, $t6
    mflo $t8
    li $t9, 100
    mul $t7, $t7, $t9
    add $t7, $t7, $t8
    move $s1, $t7 ## Put new centroid in s1

    move $t0, $0
    li $t0, 0
    move $t1, $0
    li $t1, 0
    move $t2, $0
    li $t2, 0
    move $t3, $0
    li $t3, 0
    move $t4, $0
    li $t4, 0
    move $t5, $0
    li $t5, 0
    move $t6, $0
    li $t6, 0
    move $t7, $0
    li $t7, 0
    move $t8, $0
    li $t8, 0
    move $t9, $0
    li $t9, 0
    move $a2, $0
    li $a2, 0
    j printCentroid

##############################################
# Prints distance and then compares and puts #
# the value in the right array ###############
##############################################
printDistance :
    ### Calculates and prints the distance from Centroid ONE
    li $s7, 100
    div $s0, $s7
    mflo $t4 # contains x value of centroid 1
    mfhi $t5 # contains y value of centroid 1
    sub $a0, $t4, $s4
    mul $a0, $a0, $a0
    sub $a1, $t5, $s5
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

    ### Calculates and prints the distance from Centroid TWO
    li $s7, 100
    div $s1, $s7
    mflo $t4 # contains x value of centroid 1
    mfhi $t5 # contains y value of centroid 1
    sub $a0, $t4, $s4
    mul $a0, $a0, $a0
    sub $a1, $t5, $s5
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
    li $t8, 0
    mul $a2, $a2, 100
    add $a2, $a2, $s4
    mul $a2, $a2, 100
    add $a2, $a2, $s5 # $a2 has the coordinate in 0000 format
    sw $a2, centroidOneArray($a3)
    addi $a3, $a3, 4 #Adding 4 so the index of centroid one array is at 4
    lw $t8, centroidOneSize($t8)
    addi $t8, $t8, 1
    li $t9, 0
    sw $t8, centroidOneSize($t9) #recording centroid one size
    move $t8, $0
    li $t8, 0
    move $t9, $0
    li $t9, 0


    ####### CLEAN UP a2, s6, s7 ########### NEVER CLEAN UP a3
    move $a2, $0
    li $a2, 0
    move $s6, $0
    li $s6, 0
    move $s7, $0
    li $s7, 0
    jr $ra

putInCTwo:
    move $t8, $0
    li $t8, 0
    mul $a2, $a2, 100
    add $a2, $a2, $s4
    mul $a2, $a2, 100
    add $a2, $a2, $s5 # $a2 has the coordinate in 0000 format
    sw $a2, centroidTwoArray($v1)
    addi $v1, $v1, 4 #Adding 4 so the index of centroid one array is at 4
    lw $t8, centroidTwoSize($t8)
    addi $t8, $t8, 1
    li $t9, 0
    sw $t8, centroidOneSize($t9) #recording centroid one size
    move $t8, $0
    li $t8, 0
    move $t9, $0
    li $t9, 0

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



exit:
    li $v0, 10
    syscall
