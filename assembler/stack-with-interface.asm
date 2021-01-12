.data
    enter: .asciiz "Enter the number: "
    menu: .asciiz "\nChoose action \n[1]Add number\n[2]Display number\n[3]End: "
    empty: .asciiz "The stack is empty"
    
    numberFromTop: .asciiz "Number: "
    
    # 2 – for word and 0 – for byte
    .align 2 
    #memory reservation
    stack: .space 100 
.text
#$t2 will be counter
	li $t2, 0
# init stack
    la $sp, stack
.main:
 
menuE:
    #display menu
    la $a0, menu
    li $v0, 4
    syscall
    
    #choose
    li $v0,5
    syscall
		
    #save choose in $t0 
    move $t0,$v0
    
    beq $t0, 1, readNumbers
    nop

    beq $t0, 2, checkStack
    nop
    
    end:
        li $v0,10
	syscall 
    

  
  checkStack:
  #check whether stack is empty
  beq $t2, 0, emptyStack
  
printOneNumber:

  # display 'number'
    li $v0, 4
    la $a0, numberFromTop
    syscall
    
    #download numebr and display
   subi $sp, $sp, 4
    l.s $f12, 0($sp)
    li $v0, 2
   syscall
   
    #decrement counter  
     sub $t2, $t2, 1



     j menuE
    nop
   
    

readNumbers:
    # display 'enter'
    li $v0, 4
    la $a0, enter
    syscall
    # $f0=number
    li  $v0, 6
    syscall
    # $f0 to stack
    s.s $f0, 0($sp)
    addi $sp, $sp, 4
    
    add $t2, $t2, 1
    
    j menuE
    nop


#when stack is empty
emptyStack:
    li $v0, 4
    la $a0, empty
    syscall
    
    j menuE
    nop