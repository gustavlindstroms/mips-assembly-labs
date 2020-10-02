.data

	string: .asciiz "aMbUsH"
	
.text
j main

camelcase:
	add $t0, $zero, $zero # set i to 0
	addi $t3, $zero, 1 # set boolean to true
	
	camelcase_loop:
		lb $t2, string($t0) # load first char if string to $t2
		beqz $t2, camelcase_done #if char == null go to done
	
		beq $t3, 0, lowercase #if false go to caps
		beq $t3, 1, caps # if true go to lowercase
	
		back: # point to jump back from subroutine
		sb $t2, string($t0) # store the modified char
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
	
main:
	la $a1, string
	jal camelcase
	
	li	$v0, 4
	la	$a0, string
	syscall
	
	