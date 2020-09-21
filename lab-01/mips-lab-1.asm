##############################################################################
#
#  KURS: 1DT038 2020.  Computer Architecture
#	
# DATUM: 2020-09-19
#
#  NAMN:	 Gustav Lindstr�m		
#
#  NAMN: Johan Terenius
#
##############################################################################

	.data
	
ARRAY_SIZE:
	.word	10	# Change here to try other values (less than 10)
FIBONACCI_ARRAY:
	.word	1, 1, 2, 3, 5, 8, 13, 21, 34, 55
STR_str:
	.asciiz "hunden, katten, glassen"

	.globl DBG
	.text
j main
##############################################################################
#
# DESCRIPTION:  For an array of integers, returns the total sum of all
#		elements in the array.
#
# INPUT:        $a0 - address to first integer in array.
#		$a1 - size of array, i.e., numbers of integers in the array.
#
# OUTPUT:       $v0 - the total sum of all integers in the array.
#
##############################################################################
integer_array_sum:  

DBG:	##### DEBUGG BREAKPOINT ######

        addi    $v0, $zero, 0           # Initialize Sum to zero.
	add	$t0, $zero, $zero	# Initialize array index i to zero.
	
for_all_in_array:
	
	beq $t0, $a1, end_for_all 	# Done if i == N
	add $t1, $t0, $t0		# 2*i
	add $t1, $t1, $t1		# 2*i
	add $t3, $a0, $t1		# address = ARRAY + 4*i
	lw $t2, 0($t3)  			# n = A[i]
       	add $v0, $v0, $t2		# Sum = Sum + n
        addi $t0, $t0, 1			# i++ 
  	j for_all_in_array 		# next element
	
end_for_all:
	add $t0, $zero, $zero
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	jr	$ra			# Return to caller.
	
##############################################################################
#
# DESCRIPTION: Gives the length of a string.
#
#       INPUT: $a0 - address to a NUL terminated string.
#
#      OUTPUT: $v0 - length of the string (NUL excluded).
#
#    EXAMPLE:  string_length("abcdef") == 6.
#
##############################################################################	
string_length:
	add $v0, $zero, $zero
	for:
		lb   $a0, 0($t0) 		# load char at string location i
		beqz $a0, done 			# if char at i == null return
   		addi $t0,$t0,1			# i++
    		addi $v0,$v0,1			# counter ++
    		j for
	
	done:
		add $t0, $zero, $zero	# restore temp register
		add $t1, $zero, $zero 	#restore temp register
		jr	$ra		#return
	
##############################################################################
#
#  DESCRIPTION: For each of the characters in a string (from left to right),
#		call a callback subroutine.
#
#		The callback suboutine will be called with the address of
#	        the character as the input parameter ($a0).
#	
#        INPUT: $a0 - address to a NUL terminated string.
#
#		$a1 - address to a callback subroutine.
#
##############################################################################	
string_for_each:

    addiu $sp, $sp, -12             # move stackpointer down three steps for vaiables
    sw  $ra, 0($sp)                 # Store ra
    sw  $a1, 8($sp)                 # Store a1

for_each:
    sw  $a0, 4($sp)                 # Store a0
    lb  $t0, 0($a0)                 # get char at i
    beqz $t0, end_for_each    	   # If Char at i == null return 
    jalr $a1                        # go to subroutine at address a1
    lw  $a0, 4($sp)                 # Reload a0
    lw  $a1, 8($sp)                 # reload a1
    addi $a0, $a0, 1                # i++
    j   for_each

end_for_each:
    lw  $ra, 0($sp)                 # reload ra
    addiu $sp, $sp, 12              # move stackpointer back three steps
    jr  $ra

##############################################################################
#
#  DESCRIPTION: Transforms a lower case character [a-z] to upper case [A-Z].
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################		
to_upper:

	#### Write your solution here ##
	lb $t0, 0($a0)	        	# load byte at addres of the para
	blt $t0, 'a', skip_char 	# Skip char if ASCII value in $T0 is less than 97 
        	bgt $t0, 'z', skip_char	 	# Skip char if ASCII value in $T0 is more than 122 
	subi $t0, $t0, 32	# subtract 32 (to get uppcase value of a-z char)
	sb $t0, 0($a0)		# save the now uppercase character
	add $t0, $zero, $zero	# reset t0
	jr	$ra
	
	skip_char:
		add $t0, $zero, $zero	# reset t0
		jr $ra
		


##############################################################################
#
# Strings used by main:
#
##############################################################################

	.data

NLNL:	.asciiz "\n\n"
	
STR_sum_of_fibonacci_a:	
	.asciiz "The sum of the " 
STR_sum_of_fibonacci_b:
	.asciiz " first Fibonacci numbers is " 

STR_string_length:
	.asciiz	"\n\nstring_length(str) = "

STR_for_each_ascii:	
	.asciiz "\n\nstring_for_each(str, ascii)\n"

STR_for_each_to_upper:
	.asciiz "\n\nstring_for_each(str, to_upper)\n\n"	

	.text
	.globl main

##############################################################################
#
# MAIN: Main calls various subroutines and print out results.
#
##############################################################################	
main:
	addi	$sp, $sp, -4	# PUSH return address
	sw	$ra, 0($sp)

	##
	### integer_array_sum
	##
	
	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_a
	syscall

	lw 	$a0, ARRAY_SIZE
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_b
	syscall
	
	la	$a0, FIBONACCI_ARRAY
	lw	$a1, ARRAY_SIZE
	jal 	integer_array_sum

	# Print sum
	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	la	$a0, STR_str
	jal	print_test_string

	##
	### string_length 
	##
	
	li	$v0, 4
	la	$a0, STR_string_length
	syscall

	la	$a0, STR_str
	jal 	string_length

	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	##
	### string_for_each(string, ascii)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_ascii
	syscall
	
	la	$a0, STR_str
	la	$a1, ascii
	jal	string_for_each

	##
	### string_for_each(string, to_upper)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_to_upper
	syscall

	la	$a0, STR_str
	la	$a1, to_upper
	jal	string_for_each
	
	la	$a0, STR_str
	jal	print_test_string
	
	
	lw	$ra, 0($sp)	# POP return address
	addi	$sp, $sp, 4	
	
	jr	$ra

##############################################################################
#
#  DESCRIPTION : Prints out 'str = ' followed by the input string surronded
#		 by double quotes to the console. 
#
#        INPUT: $a0 - address to a NUL terminated string.
#
##############################################################################
print_test_string:	

	.data
STR_str_is:
	.asciiz "str = \""
STR_quote:
	.asciiz "\""	

	.text

	add	$t0, $a0, $zero
	
	li	$v0, 4
	la	$a0, STR_str_is
	syscall

	add	$a0, $t0, $zero
	syscall

	li	$v0, 4	
	la	$a0, STR_quote
	syscall
	
	jr	$ra
	

##############################################################################
#
#  DESCRIPTION: Prints out the Ascii value of a character.
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################
ascii:	
	.data
STR_the_ascii_value_is:
	.asciiz "\nAscii('X') = "

	.text

	la	$t0, STR_the_ascii_value_is

	# Replace X with the input character
	
	add	$t1, $t0, 8	# Position of X
	lb	$t2, 0($a0)	# Get the Ascii value
	sb	$t2, 0($t1)

	# Print "The Ascii value of..."
	
	add	$a0, $t0, $zero 
	li	$v0, 4
	syscall

	# Append the Ascii value
	
	add	$a0, $t2, $zero
	li	$v0, 1
	syscall


	jr	$ra
	
