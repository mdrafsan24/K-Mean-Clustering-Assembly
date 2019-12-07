.data
    allInputsArray: .space 40 # Has at most 10 vals ; contains all inputs

    oldClusterOne: .space 40
    oldClusterTwo: .space 40

    oldClusterOneSize: .space 4 ### Contains the size of the old cluster
    oldClusterTwoSize: .space 4 ### Contains the size of old cluster

    clusterOneArray: .space 40 # Has at most 10 vals , each 4 bits there 4X10 = 40
    clusterTwoArray: .space 40 # Has at most 10 vals , each 4 bits there 4X10 = 40

    clusterOneSize: .space 4 ### Contains the size of the new cluster
    clusterTwoSize: .space 4 ### Contains the size of new cluster


MSGEnterCoordinates: .asciiz "Enter all coordinate in 0000 format:" # Asking for user Input
MSGEnterFirstCentroid: .asciiz "Enter the first centroid in 0000 format: " # Asking for first centroid
MSGEnterSecondCentroid: .asciiz "Enter the second centroid in 0000 format: " # Asking for first centroid
MSGClusterOne: .asciiz "This is the new cluster one: "
MSGClusterTwo: .asciiz "This is the new cluster two: "

CentroidOne: .asciiz "This is the first centroid: "
CentroidTwo: .asciiz "This is the second centroid: "

distanceCentroidOne : .asciiz "Distance from centroid one: "
distanceCentroidTwo : .asciiz "Distance from centroid two: "

finalCentroid : .asciiz "The final centroids are: "

endingMessage: .asciiz "Since it's the same as the last cluster, the program ends!"

newline: .asciiz "\n" #To print a new line

.text
.globl main


######################################################################
######### Reads and puts all inputs in allInputsArray ################
######### Read and puts the two centroids in s0,s1   ################
######################################################################
main:
    li $v0,4
    la $a0, MSGEnterCoordinates
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
    la $a0, MSGEnterFirstCentroid
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s0,$v0 # Save read integer in s0

    li $v0,4
    la $a0, MSGEnterSecondCentroid
    syscall
    li $v0,5 #tell syscall to read integer
    syscall
    move $s1,$v0 # Save read integer in s0

    #### clear up registers #####
    move $v0, $0
    li $v0, 0
    move $t0, $0
    li $t0, 0
    move $a0, $0
    li $a0, 0

    j printCentroid

################### Checks to see if the clusters are the same ###################
checkClusterOneSame:
    li $t0, 0
    lw $t1, clusterOneSize($t0)
    li $t2, 0
    lw $t2, oldClusterOneSize($t0)
    bne $t1, $t2, putCurrentArrayOneInPrev
    li $t0, 0
    lw $t1, clusterOneSize($t0)
checkClusterOne:
    lw $t2, clusterOneArray($t0)
    lw $t3, oldClusterOne($t0)
    bne $t2, $t3, putCurrentArrayOneInPrev
    mul $t2, $t1, 4
    beq $t0, $t2, checkClusterTwoSame
    add $t0, $t0, 4
    j checkClusterOne
checkClusterTwoSame:
    li $t0, 0
    lw $t1, clusterTwoSize($t0)
    li $t2, 0
    lw $t2, oldClusterTwoSize($t0)
    bne $t1, $t2, putCurrentArrayOneInPrev
    li $t0, 0
    lw $t1, clusterTwoSize($t0)
checkClusterTwo:
    lw $t2, clusterTwoArray($t0)
    lw $t3, oldClusterTwo($t0)
    bne $t2, $t3, putCurrentArrayOneInPrev
    li $t2, 0
    mul $t2, $t1, 4
    beq $t0, $t2, exit
    add $t0, $t0, 4
    j checkClusterTwo

putCurrentArrayOneInPrev:
    li $t0, 0
    lw $t1, clusterOneSize($t0)
    sw $t1, oldClusterOneSize($t0)

clusterOneToOld:
    lw $t2, clusterOneArray($t0)
    sw $t2, oldClusterOne($t0)
    mul $t3, $t1, 4
    beq $t3, $t0, putCurrentArrayTwoInPrev
    add $t0, $t0, 4
    j clusterOneToOld
putCurrentArrayTwoInPrev:
    li $t0, 0
    lw $t1, clusterTwoSize($t0)
    sw $t1, oldClusterTwoSize($t0)
clusterTwoToOld:
    lw $t2, clusterTwoArray($t0)
    sw $t2, oldClusterTwo($t0)
    mul $t3, $t1, 4
    beq $t3, $t0, calculateNewCentroidOne
    add $t0, $t0, 4
    j clusterTwoToOld

calculateNewCentroidOne:
    li $t0, 0
    lw $t1, clusterOneSize($t0)
    li $t2, 0 # Will have total of x vals
    li $t3, 0 # Will have total of y vals
    li $t4, 100
calculateCentroidOne:
    lw $t5, clusterOneArray($t0)
    div $t5, $t4
    mflo $t6
    mfhi $t7
    add $t2, $t2, $t6
    add $t3, $t3, $t7
    mul $t8, $t1, 4
    add $t0, $t0, 4
    beq $t8, $t0, calculateNewCentroidTwo

    j calculateCentroidOne

calculateNewCentroidTwo:
    li $t0, 0
    lw $t1, clusterOneSize($t0)
    move $s0, $t2
    div $s0, $t1
    mflo $s0
    mul $s0, $s0, 100
    div $t3, $t1
    mflo $t3
    add $s0, $s0, $t3
    li $t0, 0
    lw $t1, clusterTwoSize($t0)
    li $t2, 0 # Will have total of x vals
    li $t3, 0 # Will have total of y vals
    li $t4, 100
calculateCentroidTwo:
    lw $t5, clusterTwoArray($t0)
    div $t5, $t4
    mflo $t6
    mfhi $t7
    add $t2, $t2, $t6
    add $t3, $t3, $t7
    mul $t8, $t1, 4
    add $t0, $t0, 4
    beq $t8, $t0, finishCalc

    j calculateCentroidTwo
finishCalc:
    li $t0, 0
    lw $t1, clusterTwoSize($t0)
    move $s1, $t2
    div $s1, $t1
    mflo $s1
    mul $s1, $s1, 100
    div $t3, $t1
    mflo $t3
    add $s1, $s1, $t3

###################Enter The Program#################################
##### This is where after calculating new centroid the program ######
#####                       Loop back to                #############
#####################################################################
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
    move $a0, $0
    li $a0, 0

    move $v1, $0
    li $v1, 0

####################################################
################ ALL registers are clear ############
################ Except s0 and s1       #############
#####################################################

resetDistance:
    li $s3, 0
    sw $s3, clusterOneSize($s3)
    li $s3, 0
    sw $s3, clusterTwoSize($s3)
    move $s3, $0
    li $s3, 0
goThroughEachPoint:
    lw $t0, allInputsArray($v1)
    li $s7, 100 # s7 contains 100
    div $t0, $s7
    mflo $s4  # X value of each point
    mfhi $s5 # Y value of each point

    #### Print the coordinate
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

    ### After printing the coordinate calculate distance
    ### between coordinate and centroid
    li $a0, 0
    jal calculateDistance

    ## after finishing calculating distance and putting them in correct clusters

    addi $v1, $v1, 4
    li $a2, 0
    li $a3, 0
    li $t8, 0
    li $t6, 0

    beq $v1, 40, printNewCluster
    j goThroughEachPoint

printNewCluster:
    li $t0, 0
    li $t3, 0
    li $v0, 4
    la $a0, MSGClusterOne
    syscall
    li $a0, '{'
    li $v0, 11    # print_character
    syscall
    printClusterOne:
        li $a0, '('
        li $v0, 11    # print_character
        syscall

        lw $t1, clusterOneArray($t0)
        li $t8, 100
        div $t1, $t8
        mflo $a2
        mfhi $a3

        li $v0, 1
        move $a0, $a2
        syscall
        li $a0, ','
        li $v0, 11    # print_character
        syscall
        li $v0, 1
        move $a0, $a3
        syscall

        li $a0, ')'
        li $v0, 11    # print_character
        syscall

        add $t0, $t0, 4
        li $t1, 0
        lw $t2, clusterOneSize($t1)
        mul $t2, $t2, 4
        beq $t0, $t2, printNextCluster
        li $a0, ','
        li $v0, 11    # print_character
        syscall
        j printClusterOne

    printNextCluster:
        li $a0, '}'
        li $v0, 11    # print_character
        syscall
        li $v0, 4
        la $a0, newline
        syscall
        li $v0, 4
        la $a0, MSGClusterTwo
        syscall
        li $a0, '{'
        li $v0, 11    # print_character
        syscall

    printClusterTwo:
        li $a0, '('
        li $v0, 11    # print_character
        syscall
        lw $t1, clusterTwoArray($t3)
        li $t8, 100
        div $t1, $t8
        mflo $a2
        mfhi $a3
        li $v0, 1
        move $a0, $a2
        syscall
        li $v0, 1
        li $a0, ','
        li $v0, 11    # print_character
        syscall
        li $v0, 1
        move $a0, $a3
        syscall
        li $a0, ')'
        li $v0, 11    # print_character
        syscall
        add $t3, $t3, 4
        li $t1, 0
        lw $t2, clusterTwoSize($t1)
        mul $t2, $t2, 4
        beq $t3, $t2, finishPrintingCluster
        li $a0, ','
        li $v0, 11    # print_character
        syscall
        j printClusterTwo

finishPrintingCluster:
    li $a0, '}'
    li $v0, 11    # print_character
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    j checkClusterOneSame

calculateDistance:
    li $s7, 100 # Put 100 in s7
    div $s0, $s7 # divide centroid one by 100
    mflo $t4 # contains x value of centroid 1
    mfhi $t5 # contains y value of centroid 1

    ### calculate the distance and prints out
    sub $a0, $t4, $s4
    mul $a0, $a0, $a0
    sub $a1, $t5, $s5
    mul $a1, $a1, $a1
    add $s6, $a0, $a1
    li $v0, 4
    la $a0, distanceCentroidOne
    syscall
    ### Prints out
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
    move $v0, $0
    li $v0, 0
    move $t0, $0
    li $t0, 0
    move $t4, $0
    li $t4, 0
    move $t5, $0
    li $t5, 0

compareDistance:
    bge $s6, $s7, putInClusterTwo
    ### Now the we checked the distance we can free up s6 and s7
    move $s6, $0
    li $s6, 0
    move $s7, $0
    li $s7, 0
    ### Now the we checked the distance we can free up s6 and s7
    ### since $s6 < $s7, we will put coordinate in (s4, s5) in cluster one
    lw $s6, clusterOneSize($s7) ## s6 has the size of cluster one
    mul $s7, $s6, 4 ## where to put the coordinate
    li $t0, 0
    add $t0, $t0, $s4
    mul $t0, $t0, 100
    add $t0, $t0, $s5 # $t0 has the coordinate to put in cluster in 0000 format
    sw $t0, clusterOneArray($s7)
    add $s6, $s6, 1
    li $s7, 0
    sw $s6, clusterOneSize($s7) ## Update new size
    li $s6, 0

    jr $ra

putInClusterTwo:
    move $s6, $0
    li $s6, 0
    move $s7, $0
    li $s7, 0
    ### Now the we checked the distance we can free up s6 and s7
    ### since $s6 < $s7, we will put coordinate in (s4, s5) in cluster one
    lw $s6, clusterTwoSize($s7) ## s6 has the size of cluster one
    mul $s7, $s6, 4 ## where to put the coordinate
    li $t0, 0
    add $t0, $t0, $s4
    mul $t0, $t0, 100
    add $t0, $t0, $s5 # $t0 has the coordinate to put in cluster in 0000 format
    sw $t0, clusterTwoArray($s7)
    add $s6, $s6, 1
    li $s7, 0
    sw $s6, clusterTwoSize($s7) ## Update new address
    li $s6, 0

    jr $ra


exit:
    li $v0,4
    la $a0, finalCentroid
    syscall

    li $t4, 100
    div $s0, $t4
    mflo $t6
    mfhi $t7

    li $a0, '('
    li $v0, 11    # print_character
    syscall
    li $v0, 1
    move $a0, $t6
    syscall
    li $a0, ','
    li $v0, 11    # print_character
    syscall
    li $v0, 1
    move $a0, $t7
    syscall
    li $a0, ')'
    li $v0, 11    # print_character
    syscall


    li $t4, 100
    div $s1, $t4
    mflo $t6
    mfhi $t7

    li $a0, '('
    li $v0, 11    # print_character
    syscall
    li $v0, 1
    move $a0, $t6
    syscall
    li $a0, ','
    li $v0, 11    # print_character
    syscall
    li $v0, 1
    move $a0, $t7
    syscall
    li $a0, ')'
    li $v0, 11    # print_character
    syscall
    li $v0, 4
    la $a0, newline
    syscall


    li $v0,4
    la $a0, endingMessage
    syscall
    li $v0, 10
    syscall

calculateFinalCentroid:
