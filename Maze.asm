.text     #代码段
.globl main


main:   #程序入口地址
	
#$a1 start $a2 end $a3 总个数
#	la $a0,str1
#	li $v0,4
#	syscall
#	li $v0,5
#	syscall
	addi $a1,$0,52
	addi $a2,$0,2548
	addi $a3,$0,2601
	
	#la $s6,Maze
	addi $s6,$0,0
	
	addi $t3,$0,0 #t3作为计数器
	init_for:
	slt $t0,$t3,$a3
	beq $t0,$0,init_Map
	
	add $t4,$s6,$t3
	add $t4,$t4,$t3
	add $t4,$t4,$t3
	add $t4,$t4,$t3
	
	lw $t1,0($t4) #maze[t3*4]
	addi $t0,$0,2
	addi $t3,$t3,1
	bne $t1,$t0,init_for
	addi $t0,$0,1
	sw $t0,0($t4)
	j init_for
	
	
	init_Map:
	addi $s4,$0,10404
	addi $t3,$0,0 #t3作为计数器
	init_Map_for:
	slt $t0,$t3,$a3
	beq $t0,$0,init_find
	
	add $t4,$s4,$t3
	add $t4,$t4,$t3
	add $t4,$t4,$t3
	add $t4,$t4,$t3
	
	addi $t3,$t3,1
	sw $0,0($t4)
	j init_Map_for
	
	init_find:
	addi $s2,$0,26010
	addi $s2,$s2,26010
	addi $t3,$0,0 #t3作为计数器
	init_find_for:
	slt $t0,$t3,$a3
	beq $t0,$0,init_step
	
	add $t4,$s2,$t3
	add $t4,$t4,$t3
	add $t4,$t4,$t3
	add $t4,$t4,$t3
	
	addi $t3,$t3,1
	sw $0,0($t4)
	j init_find_for
	
	init_step:
	addi $s1,$0,20808
	addi $t3,$0,0 #t3作为计数器
	init_step_for:
	slt $t0,$t3,$a3
	beq $t0,$0,init_path
	
	add $t4,$s1,$t3
	add $t4,$t4,$t3
	add $t4,$t4,$t3
	add $t4,$t4,$t3
	
	addi $t3,$t3,1
	sw $0,0($t4)
	j init_step_for
	
	init_path:
	addi $s7,$0,31212
	addi $t3,$0,0 #t3作为计数器
	init_path_for:
	slt $t0,$t3,$a3
	beq $t0,$0,BFS
	
	add $t4,$s7,$t3
	add $t4,$t4,$t3
	add $t4,$t4,$t3
	add $t4,$t4,$t3
	
	addi $t3,$t3,1
	sw $0,0($t4)
	j init_path_for
#	la $a0,str2
#	li $v0,4
#	syscall
#	li $v0,5
#	syscall
#	add $a2,$0,$v0
	
#	la $a0,str3
#	li $v0,4
#	syscall
#	li $v0,5
#	syscall
#	add $a3,$0,$v0	
#read:
#	la $s0,Maze
#	addi $s0,$0,0x2710
#	addi $t3,$0,0 #t3作为计数器
#	la $a0,str4
#	li $v0,4
#	syscall	
#	read_1:
#		slt $t0, $t3, $a3 # if $s0<$a1 $t0=1 else $t0=0 break
#		beq $t0, $zero, exit_1 # if $t0=0 -> exit_1
#		li $v0,5
#		syscall
#		add $t4,$v0,$0 #t4保存读入的数字
		
#		sll $t0, $t3, 2 # $ t0=$s0*4
#		add $t1, $s0, $t0 # $t1=$a0+$t0 即更新地址	
#		sw $t4,0($t1) # store $v0 -> $t1+0,保存刚读入的数字
#		addi $t3, $t3, 1 # $s0++
#		j read_1 # 继续读取
	
#	exit_1:
#		j BFS

BFS: #BFS算法
        #假定$a1表示start,$a2表示end
	add $s0,$0,$a1   #$s0表示当前位置
	#la $s1,step #$s1表示step数组的首地址
	addi $s1,$0,20808
	
	add $t0,$a1,$s1 # $t0表示step[start] $a0表示start
	add $t0,$a1,$t0 #地址要乘4，因为没有乘法指令所以这里加四次
	add $t0,$a1,$t0
	add $t0,$a1,$t0
	
	sw $0,0($t0)  #step[start]=0
	
	#la $s2,Queue #$s2 Queue的首地址
	addi $s2,$0,20808#41616
	addi $s2,$s2,20808
	addi $s3,$0,0  #$s3 表示当前队列的长度
	
	add $t0,$s2,$0 #队尾的地址
	
	sw $a1,0($t0) #EnQueue(Q, start);
	addi $s3,$s3,1 #自增1
	
	#la $s4,map #$s4表示map的地址
	addi $s4,$0,10404
	add $t0,$s0,$s4 #map[now]
	add $t0,$s0,$t0
	add $t0,$s0,$t0
	add $t0,$s0,$t0
	
	addi $t1,$0,1
	sw $t1,0($t0) #map[now]=1	

While:
	beq $s3,$0,exit_while #如果队列长度为0就退出
	
	addi $t0,$0,1
	sub $t3,$s3,$t0
	
	add $t0,$s2,$t3 #t0=s2+(s3-1)*4
	add $t0,$t0,$t3
	add $t0,$t0,$t3
	add $t0,$t0,$t3
	
	lw $s5,0($t0) #取出队尾元素
	
	#li $v0,1
	#add $a0,$0,$s5
	#syscall
	#li $a0, ' '
	#li $v0, 11 # print character
	#syscall	
	
	addi $t1,$0,1 
	sub $s3,$s3,$t1 #队列长度减1
	
	beq $s5,$a2,find #到达终点
	
	addi $t3,$0,0  #t3表示i
	
	For:
		addi $t4,$0,0
		addi $t5,$0,1
		addi $t6,$0,2
		addi $t7,$0,3
		addi $t8,$0,4
						
		beq $t3,$t8,While
		
		bne $t3,$t4,else1 #t3=0执行下列操作
			
		slti $t0,$s5,51 #0是向上，先检测会不会越界
		addi $t2,$0,1
		addi $t3,$t3,1 # i=i+1
		beq $t0,$t2,For #会越界就执行下一个
		addi $t1,$0,51
		sub $s0,$s5,$t1
		j For_continue #不会越界就continue
		
		else1: 
		bne $t3,$t5,else2
		
		slti $t0,$s5,2499
		addi $t2,$0,1
		addi $t3,$t3,1 # i=i+1
		bne $t0,$t2,For #会越界就执行下一个
		addi $t1,$0,51
		add $s0,$s5,$t1
		j For_continue #不会越界就continue
		
		else2:
		bne $t3,$t6,else3 #向左
		add $t2,$0,$s5 #t2保存s5的值
		
		else2_for:
		slti $t0,$t2,51
		addi $t1,$0,1
		beq $t0,$t1,else2_continue # mod 51
		addi $t1,$0,51
		sub $t2,$t2,$t1
		j else2_for
		
		else2_continue: 
		slti $t0,$t2,1
		addi $t1,$0,1
		addi $t3,$t3,1 # i=i+1
		beq $t0,$t1,For #会越界就执行下一个
		sub $s0,$s5,$t1
		j For_continue #不会越界就continue
		
		else3:
		add $t2,$0,$s5 #t2保存s5的值
		else3_for:
		slti $t0,$t2,51
		addi $t1,$0,1
		beq $t0,$t1,else3_continue # mod 51
		addi $t1,$0,51
		sub $t2,$t2,$t1
		j else3_for
		
		else3_continue:								
		slti $t0,$t2,50
		addi $t1,$0,1
		addi $t3,$t3,1 # i=i+1
		bne $t0,$t1,For #会越界就执行下一个
		add $s0,$s5,$t1
		j For_continue #不会越界就continue
		
		
		For_continue:
		#la $s6,Maze
		addi $s6,$0,0
		add $t4,$0,$s0 #(pos.x - 1)*n + (pos.y - 1)
		add $t4,$t4,$s0
		add $t4,$t4,$s0
		add $t4,$t4,$s0
		
		#Maze[(pos.x - 1)*n + (pos.y - 1)]
		add $t0,$s6,$t4
		lw $t1,0($t0)
		addi $t2,$0,1
		bne $t1,$t2,For
		
		add $t0,$s4,$t4 #!Map[(pos.x - 1)*n + (pos.y - 1)]
		lw $t1,0($t0)
		addi $t2,$0,0
		bne $t1,$t2,For
		
		add $t0,$s1,$s5  #pos.step = e.step + 1;//记录步数
		add $t0,$t0,$s5
		add $t0,$t0,$s5
		add $t0,$t0,$s5
		
		add $t1,$s1,$s0 
		add $t1,$t1,$s0
		add $t1,$t1,$s0
		add $t1,$t1,$s0
		
		lw $t2,0($t0)
		addi $t2,$t2,1
		sw $t2,0($t1)
		
		add $t0,$s4,$t4 #Map[(pos.x - 1)*n + (pos.y - 1)] = 1;//记录这个位置走过
		addi $t1,$0,1
		sw $t1,0($t0) 
		
		#EnQueue(Q, pos);//入队列
		add $t0,$s2,$s3 #队尾的地址
		add $t0,$t0,$s3
		add $t0,$t0,$s3
		add $t0,$t0,$s3
	
		sw $s0,0($t0) 
		addi $s3,$s3,1 #自增1
		
		#la $s7,path
		addi $s7,$0,31212		
		add $s7,$s7,$t4
		sw $s5,0($s7)
		
		j For
		
	exit_while:
		addi $s7,$0,0
		j get_path
	find:
		add $t0,$s1,$s5  #e.step
		add $t0,$t0,$s5
		add $t0,$t0,$s5
		add $t0,$t0,$s5
		lw $t1,0($t0)
		add $s7,$0,$t1
		j get_path


get_path:
	beq $0,$s7,no_path
	
	#la $s2,Find #find首地址
	addi $s2,$0,26010
	addi $s2,$s2,26010
	add $t7,$s7,$0 #result
	
	add $t0,$s2,$t7
	add $t0,$t0,$t7
	add $t0,$t0,$t7	
	add $t0,$t0,$t7
	
	sw $a2,0($t0) #Temp[result].x = end.x;
	
	addi $t0,$0,1
	sub $t3,$t7,$t0 # i = result - 1
	j for_path
	
	for_path:
		addi $t0,$0,1
		slt $t1,$t3,$0
		beq $t1,$t0,print
		
		add $t0,$s2,$t3 #Temp[i]
		add $t0,$t0,$t3
		add $t0,$t0,$t3	
		add $t0,$t0,$t3	
		
		lw $t4,4($t0) #Temp[i+1]
		#la $t5,path
		addi $t5,$0,31212
		
		add $t5,$t5,$t4
		add $t5,$t5,$t4
		add $t5,$t5,$t4
		add $t5,$t5,$t4
		
		lw $t1,0($t5) #path[temp[i+1]]
		sw $t1,0($t0) #temp[i]=path[temp[i+1]]
		
		addi $t0,$0,1
		sub $t3,$t3,$t0
		
		j for_path
		
	no_path:
		#la $a0, not_find 
		#li $v0, 4 # $v0=4 -> print string
		#syscall
		
		sw $0,0($0)
		j finish
	
	print:
		addi $t3,$0,0 #i
		addi $t7,$t7,1
		sw $t7,0($0)
		j for_print
		
		for_print:
			slt $t0,$t3,$t7
			addi $t1,$0,1
			bne $t0,$t1,finish
			
			addi $s2,$0,26010 #find首地址
			addi $s2,$s2,26010
			
			add $t4,$s2,$t3
			add $t4,$t4,$t3
			add $t4,$t4,$t3
			add $t4,$t4,$t3
			
			lw $t0,0($t4)
			add $t1,$s6,$t0
			add $t1,$t1,$t0
			add $t1,$t1,$t0
			add $t1,$t1,$t0
			addi $t0,$0,2
			sw $t0,0($t1)  #修改Maze相应位置
			

			#add $a0, $0,$t0  #read the number to $a0
			#li $v0, 1 # print integer
		#	syscall
		
		#	li $a0, ' '
		#	li $v0, 11 # print character
		#	syscall	
			
			addi $t3,$t3,1
			j for_print
	
finish:
	j finish

#.data
#	path:
#		.space 10000
#	map:
#		.space 10000
#		
#	Maze:
#		.space 10000
#		
#	step:
#		.space 10000
#	Queue:
#		.space 1000
#	Find:
#		.space 10000	
#	not_find:
#		.asciiz "\nNot Find!\n"
#	find_it:
#		.asciiz "\nFind it!\n"
#	str1:
#		.asciiz "\nPlease input the start"
#	str2:
#		.asciiz "\nPlease input the end"
#	str3:
#		.asciiz "\nPlease input the num"
#	str4:
#		.asciiz "\nPlease input the Maze "
