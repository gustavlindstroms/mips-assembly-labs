##############################################################################
#
#  KURS: 1DT038 2020.  Computer Architecture
#	
# DATUM: 2020-09-19
#
#  NAMN:	 Gustav Lindström		
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
	
str_memory_space:	.asciiz	"gustav&johan" # should be "nahoj&vatsug" reverseds

string_to_camelcase: .asciiz "aMbUsH"

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
    addi    $v0, $zero, 0           # Initialize Sum to zero.

	string_length_loop:
    		lb     $t0,($a0)
    		beqz    $t0, string_length_done
    		addi    $v0, $v0, 1
    		addi     $a0, $a0, 1
    		j string_length_loop

	string_length_done:
    		jr    $ra
	
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
    sw  $a1, 8($sp)                 # Store a1
    sw  $ra, 0($sp)                 # Store ra

for_each:
    sw  $a0, 4($sp)                 # Store a0
    lb  $t0, 0($a0)                 # get char at i
    beqz $t0, end_for_each    	    # if char at i == null return 
    jalr $a1                        # go to subroutine at address a1
    lw  $a0, 4($sp)                 # Reload a0
    addi $a0, $a0, 1                # i++
    lw  $a1, 8($sp)                 # reload a1
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
#  DESCRIPTION: Capitalizes every other letter in a string
#	
#        INPUT: $a0 - address of a the string
#
##############################################################################		
camelcase:
	add $t0, $zero, $zero # set i to 0
	addi $t3, $zero, 1 # set boolean to true
	add $t0, $a0, $zero

	camelcase_loop:
		lb $t2, 0($t0) # load first char if string to $t2
		beqz $t2, camelcase_done #if char == null go to done

		beq $t3, 0, lowercase #if false go to caps
		beq $t3, 1, caps # if true go to lowercase
	
		back: # point to jump back from subroutine
		sb $t2, 0($t0) # store the modified char
		addi $t0, $t0, 1 #i++
		j camelcase_loop # jump to top of loop
	
			caps: 
			blt $t2, '[', caps_done 	# skip char if already uppercase 
			subi $t2, $t2, 32 # subtract 32 to capitalize
			j caps_done
	
				caps_done:
				addi $t3, $zero, 0 # boolean = false (next letter should not be capitalized)
				j back
	
			lowercase:
			bgt $t2, '`', lowercase_done # skip if aready lowercase
			addi $t2, $t2, 32 #add 32 to make it lowercase
			j lowercase_done
	
				lowercase_done:
				addi $t3, $zero, 1 #boolean = true
				j back # jump back to method

	camelcase_done:
	jr $ra # jump return to main

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
	
	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	la	$a0, str_memory_space
	li	$v0, 4
	syscall	

	jal	string_length	# JAL to strlen function, saves return address to $ra
	
	add $a0, $v0, $zero #load the string length into $a0
	la $a1, str_memory_space #load the address of the string into $a1
	jal string_reverse
	
	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	li	$v0, 4
	la	$a0, str_memory_space
	syscall
	
	la $a0, string_to_camelcase
	jal camelcase
	
	li	$v0, 4
	la	$a0, string_to_camelcase
	syscall
	

	li	$v0, 10			# exit the program
	syscall
	
##############################################################################
#
#  DESCRIPTION : Revserses a string
#		 by double quotes to the console. 
#
#        INPUT: $a0 - address to a NUL terminated string.
#
##############################################################################
string_reverse:
	add $t0, $zero, $zero # t0 will hold our counter (++)
	add $t1, $a0, $zero # t1 will hold our counter (--)
	subi $t1, $t1, 1 # make the length zero based
	add $t2, $zero, $zero # t2 will hold our temp ascii value to be moved front
	add $t3, $zero, $zero # t3 will hold our temo ascii vaue to be moved back
	str_reverse_loop:

		bge $t0, $t1, str_reverse_done #if the ++ counter is greater or equal to -- counter
		lb $t2, str_memory_space($t1) #load the last char
		lb $t3, str_memory_space($t0) #load the first char
		sb $t2, str_memory_space($t0) # save the last char in the first char pos
		sb $t3, str_memory_space($t1) #save the first char in the last char pos
		addi $t0, $t0, 1 #add 1 to the first index (i + 1)
		subi $t1, $t1, 1 #subtract one from the second index (string length -1)
		j str_reverse_loop # jump to top
	
str_reverse_done:
	jr $ra
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
	
