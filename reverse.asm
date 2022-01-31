#########################################################################################
#	COMP 3315 – Fall 2018								#
#	Ismail Mekan -- 02/12/2018							#
#	number_AS2.asm -- Assignment 2-MIPS assembly program for the C code given 	#
#	Registers used:									#
#	$t0 - used to hold the result.							#
#	$v0 - syscall parameter.							#
#	arr[0] --> $s0   address of start of array					#
#########################################################################################
	.eqv N 10		# define constant N for array / define N 10
#	code for the program
	.text
	.globl main
################################ main #################################################	
main:
#	Register map
#	arr[0] --> $s0   address of start of array
#	i --> $s1
#	f --> $s2
#	s --> $s3
#	N --> $s4
#	t --> $s5
# 	syscall parameter and return value --> $v0
# 	syscall parameter-the string to print --> $a0
	
	la $s0,arr		# start address of arr / int arr[N] = {95, 86, 79, 63, 52, 41, 34, 28, 17, 6}
	li $s3, 0		# load value 0 into s / s=0
	li $s4, N		# load value of N
	sub $s2, $s4, 1		# calculate f from N-1 / f=N-1
	jal f_iter		# call f_iter procedure / f_iter(arr, s, f);
	
	la $a0, f_iter_msg	# load the addr of f_iter_msg into $a0
	li $v0, 4		# print_strin syscall / printf("f_iter : ")
	syscall
	
	li $s1, 0		#load value 0 into i / i=0
LOOP_ITER:
	bge $s1, $s4, END_LOOP_ITER	# check if if is less than or equal to N / wile(i<N)
	
	lw $a0, ($s0)		# arr[i] to be printed
	li $v0, 1		# print_int / printf("%d", arr[i]);
	syscall
	la $a0, space		# load the addr of space
	li $v0, 4		# print_strin syscall
	syscall 
	
	add $s1, $s1, 1		# increment i / i++
	add $s0, $s0, 4		# next array element
	j LOOP_ITER		
END_LOOP_ITER:
	la $a0, next_line	# load the addr of next_line
	li $v0, 4		# print_strin syscall / printf("\n")
	syscall
		
	la $a0,arr		# load start address of arr into parameter a0
	la $s0,arr		# load start address of arr-reset
	li $a1, 0		# load value 0 into parameter a1 / s=0
	li $a2, N		# load value of N
	add $a2,$a2,-1		# calculate f from N-1 load into parameter a2 / f=N-1	
	jal f_rec
	
	la $a0, f_rec_msg	# load the addr of f_rec_msg into $a0
	li $v0, 4		# print_strin syscall / printf("f_rec : ")
	syscall
	
	li $s1, 0		#load value 0 into i / i=0
	
LOOP_REC:
	bge $s1, $s4, END_LOOP_REC	# check if f is less than or equal to N / wile(i<N)
	
	lw $a0, ($s0)		# arr[i] to be printed
	li $v0, 1		# print_int / printf("%d", arr[i]);
	syscall
	la $a0, space		# load the addr of space
	li $v0, 4		# print_strin syscall
	syscall 
	
	add $s1, $s1, 1		# increment i / i++
	add $s0, $s0, 4		# next array element
	j LOOP_REC		
END_LOOP_REC:
	la $a0, next_line	# load the addr of next_line
	li $v0, 4		# print_strin syscall / printf("\n")
	syscall
																																	
	li $v0, 10		# syscall code 10 is for exit / return 0
	syscall			# make the syscall.

############################### f_iter ################################################	
f_iter:				# using registers / void f_iter(int *a, int s, int f)
	move $t4, $s0		# $t4 used to store address of array
WHILE_LOOP:
	ble $s2, $s3, END_WHILE	# check if f is greater than s / while(s < f)
	
	lw $s5,($t4)		# load t with array value / t = a[s];
	add $t2, $s2, $s2	# $t2 = 2f
	add $t2, $t2, $t2	# $t2 = 4f
	add $t2, $s0, $t2	# $t2 = arr + 4f
	lw $t3, ($t2)		# $t3 = a[f]
	sw $t3,($t4)		# a[s] = a[f]
	sw $s5, ($t2)		# a[f] = t	
	
	add $s3, $s3, 1		# increment s / s++
	add $s2, $s2, -1	# decrement f / f--
	add $t4, $t4, 4		# next array element
	j WHILE_LOOP	
END_WHILE:
	jr $ra			# return back to main method
############################## f_rec ##################################################
f_rec:				# using stack / void f_rec(int *a, int s, int f)	
	addi  $sp, $sp, -16	# adjust stack for 4 items	
	sw $ra, 0($sp)		# save return address
	sw $a0, 4($sp)		# save argument arr
	sw $a1, 8($sp)		# save argument s
	sw $a2, 12($sp)		# save argument f
	
	ble $a2, $a1, END_IF	# check if f is greater than s / if(s < f)
	lw $s5,($a0)		# load t with array value / t = a[s];
	add $t2, $a2, $a2	# $t2 = 2f
	add $t2, $t2, $t2	# $t2 = 4f
	add $t2, $s0, $t2	# $t2 = arr + 4f
	lw $t3, ($t2)		# $t3 = a[f]
	sw $t3,($a0)		# a[s] = a[f]
	sw $s5, ($t2)		# a[f] = t	
	
	add $a1, $a1, 1		# increment s / s++
	add $a2, $a2, -1	# decrement f / f--
	add $a0, $a0, 4	
	
	jal f_rec
END_IF:	
	lw $ra, 0($sp)		# load return address
	lw $a0, 4($sp)		# load argument arr
	lw $a1, 8($sp)		# load argument s
	lw $a2, 12($sp)		# load argument f 
	addi $sp, $sp, 16       # bring back stack pointer
		
	jr $ra
############################### DATA ###################################################
#	Data for the program	
	.data
	arr:  .word   95, 86, 79, 63, 52, 41, 34, 28, 17, 6	# integers stored in 10-element array=arr
	f_iter_msg:	.asciiz "f_iter : "
	f_rec_msg:	.asciiz "f_rec : "
	space:		.asciiz " "
	next_line:	.asciiz "\n"
#	end of number_AS2.asm
