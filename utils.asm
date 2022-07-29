#File : utils.asm
#Puspose: To define a utilities which will be use in MIPS pro
#auther: Nguyen Van Nam-20205106

#subprograms index:
	#exit: call syscall with a sever 10 to exit the pro
	#newline: print a new line char(\n) to the console
	#printInt: print a integer number
	#printString: Print a string to console
	#PromptInt: prompt the user to enter a int and return it
	
#modification history:
#	9/5/2022 - Initical release


#purpose: to use syscall service 10 to exit program 
#side effect: the program is excited
.text
Exit: 
	li $v0, 10
	syscall
.text
PrintString: 
#string adress is in $a0
	addi $v0, $zero, 4
	syscall
	jr $ra
.text
PrintNewLine:
	li $v0,4
	la $a0, __PNL_newline
	syscall
	jr $ra 
.data 
	__PNL_newline: .asciiz "\n"
.text
PromptInt:
	#print the promt in $a0
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	jr $ra
.text
PrintInt:
#print string in $a0
	li $v0,4
	syscall
	#the int is in $a1 and ist must be first move to $a0
	move $a0,$a1
	li $v0,1
	syscall
	#print a newline char
	jal PrintNewLine
	jr $ra
