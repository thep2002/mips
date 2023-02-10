.data
	CharPtr: .word  0 # Bien con tro, tro toi kieu asciiz
	CharPtrcopy: .word  0
	BytePtr: .word  0 # Bien con tro, tro toi kieu Byte
	WordPtr: .word  0 # Bien con tro, tro toi mang kieu Word
	WordPtrij: .word  0 # Bien con tro, tro toi mang kieu Word
	Warningmess: .asciiz "Warning\n"
	Funtion: .asciiz "Ban muon chon chuc nang\n1.Lay gia tri\n2.Lay dia chi\n3.Copy\n4.Toan bo bo nho da cap phat\n5.Get\n6.Set\n7.Exit\nHay nhap chuc nang\n"
	nhap: .asciiz "So gia tri toi da duoc nhap: "
	hap: .asciiz "\n" 
.kdata  # Bien chua dia chi dau tien cua vung nho con trong
Sys_TheTopOfFree: .word  1 # Vung khong gian tu do, dung de cap bo nho cho cac bien con tro
Sys_MyFreeSpace: 
.text  #Khoi tao vung nho cap phat dong
	
	jal   SysInitMem 
	#-----------------------
	#  Cap phat cho bien con tro, gom 3 phan tu,moi phan tu 1 byte
	#-----------------------
	la   $a0, CharPtr
	addi $a1, $zero, 6
	addi $a2, $zero, 1     
	move $s5,$a0
	jal malloc 
	jal open
	
	la   $a0, CharPtrcopy
	addi $a1, $zero, 6
	addi $a2, $zero, 1     
	jal malloc
	#-----------------------
	#  Cap phatcho bien con tro, gom 6 phan tu, moi phan tu 1 byte
	#-----------------------
	la   $a0, BytePtr
	addi $a1, $zero, 6
	addi $a2, $zero, 1
	jal  malloc 
	jal open
	#-----------------------
	#  Cap phat cho bien con tro, gom 5 phan tu, moi phan tu 4byte
	#-----------------------
	li $s7 ,4
	la   $a0, WordPtr
	addi $a1, $zero, 5
	addi $a2, $zero, 4
	jal  malloc 
	jal CHECK_LOOP
	jal open
	la   $a0, WordPtrij 
	addi $a1, $zero, 10
	addi $a2, $zero, 10
	jal  malloc2
	jal CHECK_LOOP
	jal open
		
	LOOP_MAIN:
	la $a0,Funtion
	jal PrintString
	li $v0,5
	syscall
	beq $v0,1,LAYGIATRI
	beq $v0,2,LAYDIACHI
	beq $v0,3,Saochep
	beq $v0,4,BONHO
	beq $v0,5,Lay
	beq $v0,6,Thietlap
	beq $v0,7,Exit
	b LOOP_MAIN
#------------------------------------------
	# Ham cpy con tro
	# @param $a1 Truyen vao dia chi chuoi thu 1
	# @param $a2 Truyen vao dia chi chuoi thu 2
	# output con tro thu 2 copy con tro thu nhat
#------------------------------------------	
Saochep:
	add $s3,$0,$0
	la   $a0, CharPtr 
	jal hash
	lw $s1,0($k0)
	la   $a0, CharPtrcopy
	jal hash
	lw $s2,0($k0)
	lw   $a1, CharPtr
	lw   $a2, CharPtrcopy
	j Copy
#------------------------------------------
	# Ham Lay con tro
	# @param $a0 Truyen vao dia chi con tro
	# @param $a1 Truyen vao so hang
	# @param $a2 Truyen vao so cot
	# output lay gia trị [i][j] cua mang
#------------------------------------------	
Lay:
	la   $a0, WordPtrij #get
	addi $a1, $zero, 1
	addi $a2, $zero, 0
	jal hash
	lw   $a0, WordPtrij
	j get
#------------------------------------------
	# Ham Lay con tro
	# @param $a0 Truyen vao dia chi con tro
	# @param $a1 Truyen vao so hang
	# @param $a2 Truyen vao so cot
	# @param $a2 Truyen vao gia tri muon thiet lap lai
	# output lay gia trị [i][j] cua mang
#------------------------------------------	
Thietlap:	
	la   $a0, WordPtrij #set
	addi $a1, $zero, 0
	addi $a2, $zero, 0
	addi $a3,$0,6
	jal hash
	lw   $a0, 0($a0)
	j set
#------------------------------------------
	# Ham check
	# Kiem tra dia chi cua kieu word
#------------------------------------------
CHECK_LOOP:
	div $t6,$s7
	mfhi $t0
	beq $t0,$0,END_LOOP
	addi $t6,$t6,1
	addi $t8,$t8,1
	b CHECK_LOOP
	END_LOOP:
	sw   $t8, 0($a0)
	sw   $t6, 0($t9)
	jr $ra
SysInitMem:  
	la   $t9, Sys_TheTopOfFree  #Lay con tro chua  dau tien con trong, khoi tao
	la   $t7, Sys_MyFreeSpace #Lay dia chi dau tien con trong, khoi tao      
	sw   $t7, 0($t9) # Luu lai 
	jr   $ra
malloc:   
	la   $t9, Sys_TheTopOfFree   
	lw   $t8, 0($t9) #Lay dia chi dau tien con trong
	sw   $t8, 0($a0)    #Cat dia chi do vao bien con tro
	addi $v0, $t8, 0   # Dong thoi la ket qua tra ve cua ham
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal hash 
	lw $ra,0($sp)
	addi $sp,$sp,4
	mul  $t7, $a1,$a2   #Tinh kich thuoc cua mang can cap phat
	add $s0,$s0,$t7
	add  $t6, $t8, $t7  #Tinh dia chi dau tien con trong 
	sw   $t6, 0($t9)    #Luu tro lai dia chi dau tien do vao bien Sys_TheTopOfFree 
	sw  $a1,0($k0)
	sw  $a2,0($k1)
	jr   $ra
#------------------------------------------
	# Ham hash
	# @param $a0 chua dia chi cua con tro
	# output $k0 chua dia chi tro toi so phan tu cua mot mang
	# output $k1 chua dia chi tro toi so byte cua mot phan tu trong mang
#------------------------------------------
hash:
	#add $k0,$0,$0
	#add $k1,$0,$0
	addi $k0,$a0,0x00010000 #so luong ký tu
	addi $k1,$a0,0x00015000 #kieu du lieu
	jr   $ra
#------------------------------------------
	# Ham lay gia tri
	# @param $a0 Chua nhan chua dia chi cua bien con tro 
	# @param $a1 chua thu tu cua phan tu muon tro toi
	# output 
#------------------------------------------
LAYGIATRI:
	la   $a0, WordPtr
	li $a1,1
	jal hash
	lw   $a0, 0($a0)
	lb $k1,0($k1)
	lb $k0,0($k0)
	bgt  $a1,$k0,warning
	mul $a1,$a1,$k1
	add $a0,$a0,$a1
	beq $k1,1,Loadone
	beq $k1,4,Loadfour
	j LOOP_MAIN
Loadone: #Ham in 1 byte
	lb  $a0,0($a0)
	li $v0,11
	syscall
	li $v0,4
	la $a0,hap
	syscall
	j LOOP_MAIN
Loadfour: #Ham in 4 byte
 	lw  $a0,0($a0)
 	li $v0,34
 	syscall
 	li $v0,4
	la $a0,hap
	syscall
	j LOOP_MAIN
#------------------------------------------
	# Ham lay dia chi
	# @param $a0 Chua nhan chua dia chi cua bien con tro 
	# output $a0 Chua dia chi
#------------------------------------------	
LAYDIACHI:
	lw $a0,CharPtr
	li $v0,34
 	syscall
 	li $v0,4
	la $a0,hap
	syscall
	j LOOP_MAIN
#------------------------------------------
	# Ham em so luong bo nho da cap phat
	# output $s0 chua so luong bo nho da cap phat
#------------------------------------------	
BONHO:
	move $a0,$s0
	li $v0,1
 	syscall
 	li $v0,4
	la $a0,hap
	syscall
	j LOOP_MAIN
Copy:
	bgt  $s1,$s2,warning
	lb $a3,0($a1)
	sb $a3,0($a2)
	addi $s3,$s3,1
	addi $a1,$a1,1
	addi $a2,$a2,1
	beq $s3,$s1,LOOP_MAIN
	j Copy
warning:
	li $v0,4
	la $a0, Warningmess
	syscall
	j LOOP_MAIN
malloc2:   
	la   $t9, Sys_TheTopOfFree   
	lw   $t8, 0($t9) #Lay dia chi dau tien con trong
	sw   $t8, 0($a0)    #Cat dia chi do vao bien con tro
	addi $v0, $t8, 0   # Dong thoi la ket qua tra ve cua ham
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal hash 
	lw $ra,0($sp)
	addi $sp,$sp,4
	mul  $t7, $a1,$a2   #Tinh kich thuoc cua mang can cap phat
	mul $t7,$t7,$s7
	add $s0,$s0,$t7
	add  $t6, $t8, $t7  #Tinh dia chi dau tien con trong 
	sw   $t6, 0($t9)    #Luu tro lai dia chi dau tien do vao bien Sys_TheTopOfFree 
	sw  $a1,0($k0)
	sw  $a2,0($k1)
	jr   $ra
get:	
	lb $k0,0($k0)
	lb $k1,0($k1)
	bgt  $a1,$k0,warning
	bgt  $a2,$k1,warning
	mul $a1,$a1,$k0
	add $a1,$a1,$a2
	mul $a1,$a1,$s7
	add $a0,$a0,$a1
	b Loadfour	
set:
	lb $k0,0($k0)
	lb $k1,0($k1)
	bgt  $a1,$k0,warning
	bgt  $a2,$k1,warning
	mul $a1,$a1,$k0
	add $a1,$a1,$a2
	mul $a1,$a1,$s7
	add $a0,$a0,$a1
	sw $a3,0($a0)
	j LOOP_MAIN
#------------------------------------------
	# Ham lay gia tri cho con tro
	# @param $a0 Chua dia chi cua bien con tro 
#------------------------------------------	
open:
	li $v0,4
	move $a1,$a0
	la $a0,nhap
	syscall
	li $v0,1
	move $a0,$t7
	addi $a0,$a0,-1
	syscall
	li $v0,4
	la $a0,hap
	syscall
	li $v0,8
	move $a0,$a1
	lw $a0,0($a0)
	move $a1,$t7
	syscall
	li $v0,4
	la $a0,hap
	syscall
	jr $ra
.include "utils.asm"
