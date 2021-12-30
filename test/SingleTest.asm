.data 
.text 
	#addiu			without overflow
	addiu $2,$0,-99			#  r2 = -99
	#addi
	addi $1,$0,4294967295		#  r5 = 2^32-1

	addu $3,$1,$2			#  r4 = r1 + r3 = 50 + ffffffff
	#add
	add $4,$3,$1			# r7 = 1+ffffffff=0	(overflow)	
	#sub
	sub $4,$4,$3			# r7 = -49-ffffffff (overflow) 
	#subu
	subu $9,$4,$2			#r9 = 31-32=-1
	slt $3,$9,$2			#r7 = 1(r7<r5)
	sltu $1,$9,$2			# r1 =0
	xor $9,$9,$9			#r9 = 0
	nor $9,$9,$9			#r9 = ffffffff
	and $4,$4,$0			#r4 = 00000000
	or $10,$8,$9			#r10 = ffffffff
	srl $10,$10,16			#r10 = 0000ffff
	sll $9,$9,16			#r9 = ffff0000
	ori $8,$8,16			#r8 = 00000010
	sllv $10,$10,$8			#r10 = ffff0000
	srlv $9,$9,$8			#r9 = 0000ffff
	sh $9,-4($0)			#-4 = 0000ffff
	srav $10,$10,$8			#$10 = ffffffff
	sra $9,$9,16			#r9 = 00000000
	andi $10,$10,240		#r10 = 000000f0
	sb $10,-8($0)			#-8 = 000000f0
	lui $9,4369				#r9 = 11110000
	sw $9,-12($0)			#-12 = 11110000
	slti $9,$9,1			#$9 = 0
	lw $6,-12($0)			#r6 = 11110000
	lh $7,-10($0)			#r7 = 00001111
	lh $8,-4($0)			#r8 = ffffffff
	lhu $7,-4($0)			#r7 = 0000ffff
	lb $7,-8($0)			#r7 = fffffff0
	lbu $8,-8($0)			#r8 = 000000f0
	addiu $9,$0,1
	addi $10,$0,5	
L1:
	bgezal $10 L3			#r10 = 5 >=0	pc+4->r31
	subu $10,$10,$9			#r10 = 3
	jal L3				# 
	subu $10,$10,$9			#r10 = 1
L2:
	j L4
L3:
	subu $10,$10,$9			#r10 = 4	2.r10 = 2
	jr $31				#1.跳到begzal下一条指令,2.跳到jal L3 下条指令
L4:
	bgtz $10,L6				#r11 = 1 >0	2.r10=0 no jump
	bgez $10,L6				#r10 = 0,>=0 jump
	subu $10,$10,$9
	blez $10,L7
L5:
	addi $10,$10,1		#
	jalr $5,$31
L6:
	subu $10,$10,$9		#r10 = 0	2.r10=-1,<0
	beq $10,$0,L4		#r10 = 0 jump L4
	bltz $10,L4		#r10 = -1,
L7:	
	bltzal $10,L5
L8:
	bne $10,$0,L7
	addiu $10,$0,4294967295
