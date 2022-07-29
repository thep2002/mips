.data
	inputString: .space 1000
	input: .asciiz "Enter a string: "
	true: .asciiz "True"
	false: .asciiz "False"
	
.text
.globl main
main:
	la $a0,input  # in ra chuoi "Enter a string: "
	jal PrintString
	li $v0,8
	la $a0,inputString # nguoi dung nhap chuôi, toi da 1000 ki tu
	li $a1,1000		# va luu dia chi cua chuoi do vao a0
	syscall
	add $a1,$zero,$zero #  khoi tao gia tri a1 = 0  lam input cho ham length
	move $a3,$a0
	j length
continue:
	j is_sur # nhay den ham is_cyclone_phrase

length: 

	lb $t0,0($a0) # load byte tai vi tri thu $a1 cua a0 vao t0
	beq $t0,0x0a,continue # vi chuoi nguoi dung nhap nen ket thuc chuoi la ki tu \n co ma ascii la 0x0a
				# nen neu gap ki tu 0x0a se thoat vong lap, gia tri tra ve la $a1 : do dai cua chuoi
	addi $a1,$a1,1		# neu khong phai ki tu \n thi tang do dai chuoi len 1 don vi
	addi $a0,$a0,1		# chuyen sang ki tu tiep theo
	j length
is_sur:
	beq $a1,0,print_true # neu chuoi co 0 ki tu thi dung
	beq $a1,1,print_true # neu chuoi co 1 ki tu thi dung
	beq $a1,2,print_true # neu chuoi co 2 ki tu thi dung
	addi $a1,$a1,-2 # cho thanh ghi a1 so lan so sanh du kien
	add $t4,$zero,$zero 
	j loop
loop:
	lb $t0,0($a3) # cho ki tu dau tien vao t0
	addi $a3,$a3,1 # tro to ky tu tiep theo cua chuoi
	lb $t1,0($a3) # cho ki tu dau tien vao t0
	addi $a3,$a3,1 # tro toi ky tu tiep theo cua chuoi
	sub $t2,$t0,$t1 # thuc hien phep tru cua phan tu thu hai va phan tu thu 1
	move $t5,$t2      # luu gia tri cua t2 vao t5 de thuc hien cau lenh gia tri tuyet doi
	bltzal $t5,absa # so sanh neu nho hon 0 thi thuc hien gia tri tuyet doi
	move $t2,$t5 
	lb $t0,0($a3) # luu gia tri cua phan tu tiep theo 
	sub $t3,$t0,$t1 # thuc hien phep tru cua phan tu thu hai va phan tu thu 3
	move $t5,$t3 # tuong tu thuc hien phep gia tri tuyet doi 
	bltzal $t5,absa 
	move $t3,$t5
	ble $t3,$t2,print_false # neu phep tru 1 lon hon phep tru hai thi sai
	addi $t4,$t4,1 # tang so lan so sanh len 1 don vi
	beq $t4,$a1,print_true # neu so lan so sanh du kien hien tai bang voi so lan so sanh hien tai thi dung
	addi $a3,$a3,-1
	j loop
print_true: # in dung
	la $a0,true
	addi $v0, $zero, 4
	syscall
	j Exit
print_false: # in sai
	la $a0,false
	addi $v0, $zero, 4
	syscall
	j Exit
absa:
	abs $t5,$t5 # dau gia tri tuyet doi 
	jr $ra
.include "utils.asm"
