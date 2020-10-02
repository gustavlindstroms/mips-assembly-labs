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
	back:
	sb $t2, string($t0) # store the modified char
	addi $t0, $t0, 1 #i++
	j camelcase_loop
	
	caps: 
	blt $t2, '[', caps_done 	# Skip char if ASCII value in $T0 is less than 97 
	subi $t2, $t2, 32
	j caps_done
	
	caps_done:
	addi $t3, $zero, 0
	j back
	
	lowercase:
	bgt $t2, '`', lowercase_done
	addi $t2, $t2, 32
	j lowercase_done
	
	lowercase_done:
	addi $t3, $zero, 1
	j back
	
	camelcase_done:
	jr $ra
	
main:
	la $a1, string
	jal camelcase
	
	li	$v0, 4
	la	$a0, string
	syscall
	
	