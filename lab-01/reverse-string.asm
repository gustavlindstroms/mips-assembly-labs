
.data

str_memory_space:	.asciiz	"gustav&johan" # should be "nahoj&vatsug" reverseds

.text
.globl main
main:
	la	$a0, str_memory_space
	jal	str_length			# JAL to strlen function, saves return address to $ra
	
	add $a0, $v0, $zero #load the string length into $a0
	la $a1, str_memory_space #load the address of the string into $a1
	
	jal str_reverse
	
	li	$v0, 4
	la	$a0, str_memory_space
	syscall
	
	li	$v0, 10			# exit the program
	syscall
	
str_reverse:
	add $t0, $zero, $zero # t0 will hold our counter (++)
	add $t1, $a0, $zero # t1 will hold our counter (--)
	add $t2, $zero, $zero # t2 will hold our temp ascii value to be moved front
	add $t3, $zero, $zero # t3 will hold our temo ascii vaue to be moved back
	str_reverse_loop:

		bge $t0, $t1, str_reverse_done #if the ++ counter is greater or equal to --  counter
		lb $t2, str_memory_space($t1) #load the last char
		lb $t3, str_memory_space($t0) #load the first char
		sb $t2, str_memory_space($t0) # save the last char in the first char pos
		sb $t3, str_memory_space($t1) #save the first char in the last char pos
		addi $t0, $t0, 1 #add the first idex (i + 1)
		subi $t1, $t1, 1 #subtract one from the second index (string length -1)
		j str_reverse_loop # jump to top
	
str_reverse_done:
	jr $ra



str_length:
	add	$t0, $zero, $zero # T0 will hold the count
	add	$t1, $zero, $zero #T1 will hold the current char
	
	str_length_loop:
		lb	$t1, str_memory_space($t0)
		beqz	$t1, str_length_done
		addi	$t0, $t0, 1
		j	str_length_loop
		
	str_length_done:
		subi $t0, $t0, 1 # Change to zero based length 
		add $v0, $t0, $zero
		jr	$ra
