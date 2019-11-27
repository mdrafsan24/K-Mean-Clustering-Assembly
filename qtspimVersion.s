.data
# screen size dimensions
displayHeight: .word 64
displayWidth: .word 64

# number of iterations for k-means
iterations: .word 5
iterationText: .asciiz "Iteration "

# color of classes
blue: 	.word	0x0000FF # color of 1 class
red: .word  0xFF0000 # color of 0 class
displayColor:.word 0xFFFFFF # white
black: .word 0x000000 # color of default class

# data file
dataFile: .asciiz "data.txt"

# 100X3 table
# align 2 makes aligns memory to word
xVector:
	.align 2
	.space 400
yVector:
	.align 2
	.space 400
colorVector:
	    .align 2
	    .space 400
fileBuffer:
	    .align 0
	    .space 600
# centroid data
centroids: .space 16 # array contains the coordinates of both centroids
blueCentroidText: .asciiz "Blue Centroid is located: "
redCentroidText: .asciiz "Red Centroid is located: "

# used for floating point division
division: .float 2.0

# used for printing out new lines
newLine: .asciiz "\n"

# used to print spaces
comma: .asciiz ","
.text
main:
### Read in text data ###
# open file
# THIS IS WHERE IT STARTS #
li $v0, 13
la $a0, dataFile
li $a1, 0
li $a2,0
syscall
move $t1, $v0 # save the file description

# read file
li $v0, 14
addi $a0, $t1, 0
la $a1, fileBuffer
li $a2, 400
syscall

# close file
li $v0,16
syscall

# initialize variables
la $t1, fileBuffer # store address of the file buffer
la $t2, xVector # store address of 1st column of table
la $t3, yVector # store address of 2nd column of table
la $t4, colorVector # stores address of 3rd column of table
li $s1, 600
li $s2, 0 # store character count to stop the loop
lw $s3, black # store the color of black

# file is assumed to be this structure: Two digits, space, two digits, new line
# ex:
# 04 34
# 11 03
loopThroughBuffer:
	addi $t5, $t1, 3 # store address of 2nd number in the row

	# load half the number from the buffer
	lb $t6, ($t1)
	lb $t7, ($t5)

	# converts ascii to number
	addi $t6,$t6,-48
	addi $t7,$t7,-48

	# load the 2nd half of the number from the buffer
	lb $t8, 1($t1)
	lb $t9, 1($t5)

	# converts ascii to number
	addi $t8,$t8,-48
	addi $t9,$t9,-48

	# multiply the digit by 10 to make the num the tens digit
	mul $t6, $t6, 10
	mul $t7, $t7, 10

	# combine the tens and one digit
	add $t6, $t6, $t8
	add $t7, $t7, $t9

	sw $t6, ($t2) # store number in x column
	sw $t7, ($t3) # store number in y column
	sw $s3 ($t4) # store color in color column

	# increment column index by a word
	addi $t2, $t2, 4
	addi $t3, $t3, 4
	addi $t4, $t4, 4

	addi $t1, $t1, 6 # increment buffer by six to move to new line
	addi $s2, $s2, 6 # increment number of characters read

	# i < 400
	blt $s2, $s1, loopThroughBuffer
