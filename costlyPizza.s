.text 
.align 2 
main:

    add $t0, $0, $0
    add $t1, $0, $0 

    jal getInfo


getInfo:
    li $v0, 4
    la $a0, name
    syscall 

    li $v0, 9
    li $a0, 64
    syscall 

    move $a0, $v0 

    li $v0, 8 
    li $a1, 64  
    syscall      

    move $t3, $a0

  

    loop:
        li $t4, 10
        lb $t2, 0($a0)
        beq $t4,$t2, exit_loop
        addi $a0, $a0, 1
        j loop

    exit_loop:
        sb $0, 0($a0)


    checkfordone:
        move $a1, $t3
        la $a2, done        
        jal compare 

        move    $a0, $t0        
        beq     $v0, $0, print


        li $v0, 4
        la $a0, pizzaDm
        syscall

        li $v0, 6
        syscall
        mov.s $f1, $f0 


        li $v0, 4
        la $a0, pizzaCost
        syscall

        li $v0, 6
        syscall

        

        
        jal calc   
       
        
      
        addi $sp, $sp, -4
        sw $ra, 0($sp) 
        jal insert  
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        j getInfo

        calc:
            lwc1 $f2, PI
            lwc1 $f3, zero
            c.eq.s $f1, $f3 
            bc1t Checkero   
            c.eq.s $f0, $f3   
            bc1t Checkero   
            lwc1 $f4, four 
            mul.s $f1, $f1, $f1
            mul.s $f1, $f1, $f2 
            div.s $f1, $f1, $f4
            div.s $f0, $f0, $f1
            jr $ra


        Checkero:
            mov.s $f0, $f3 
            jr $ra

insert:
li $v0, 9
        la $a0, 12
        syscall

      la $t2, 0($t3)  
      sw $t2, 0($v0)  
      swc1 $f0, 4($v0)  
      sw $0, 8($v0) 

    beqz $t0, firstno
    sw $v0, 8($t1)
    move $t1, $v0
    j return

    firstno:
        move $t0, $v0
        move $t1, $v0
      
    return:
        jr $ra

    

print:                    
    move    $t4, $a0       
    beq     $a0, $0, exit  
    
    
    lw $t5, 8($a0)
    beq  $t5, $0, onenode 

    addi $sp, $sp, -4
    li $t3, 1
    li $t5, 0
   
    sw $ra, 0($sp)
    jal sort 
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    pr:
        move    $t4, $a0        
        beq     $t4, $0, exit 
        li      $v0, 4         
        la      $t7, 0($t4)    
        lw      $a0, 0($t7)   
        syscall             

        li      $v0, 4         
        la      $a0, space      
        syscall                

         li      $v0, 2          
        l.s     $f12, 4($t4)  
        syscall   

        li      $v0, 4         
        la      $a0, bre
        syscall                 

        lw      $a0, 8($t4)    
        j pr                

    exit:
        li      $v0, 10      
        syscall            



    sort:
        move $s7, $a0
        bgt $t3, $t5, so
        
        jr $ra 
    

   
        so:
           
            move $t1, $s7 
            la $s6, 8($t1) 
            lw $t2, 0($s6)
            beqz $t2, endofloop
            l.s $f1, 4($t1)
            l.s $f2, 4($t2)
            c.lt.s $f1, $f2
            bc1t swap
            c.eq.s $f1, $f2
            bc1t checkalpha 
            move $s7, $t2
            j so

            endofloop:
                move $t3, $t5
                li $t5, 0
                j sort 




checkalpha:
    lw $s3, 0($t1)
    lw $s2, 0($t2) 
    move $a1, $s2
    move $a2, $s3
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal compare
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    bgtz $v0, swap
    j endofloop


swap:
    lw $s1, 0($t1)
    lw $s2, 0($t2)
    sw $s1, 0($t2)
    sw $s2, 0($t1)
    l.s $f1, 4($t1)   
    l.s $f2, 4($t2)  
    s.s $f1, 4($t2)
    s.s $f2, 4($t1) 
    move $s7, $t2
    addi $t5, $t5, 1
    j so



onenode:
    li      $v0, 4     
    la      $t5, 0($t4)
    lw      $a0, 0($t5)
    syscall                 

    li      $v0, 4     
    la      $a0, space      
    syscall                 

    li      $v0, 2        
    l.s     $f12, 4($t4)  
    syscall               

    li      $v0, 10        
    syscall           

compare:
    addi    $sp, $sp, -12   
    sw      $ra, 0($sp)     
    sw      $s0, 4($sp)     
    sw      $s1, 8($sp)   
    move    $s0, $a1        
    move    $s1, $a2       

strcmp:
    lb      $s2, 0($s0)     
    lb      $s3, 0($s1)     
    bne     $s2, $s3, cmpne 
    beq     $s2, $0, cmpeos 

    addi    $s0,$s0,1    
    addi    $s1,$s1,1       
    j       strcmp

cmpne:                     
    sub     $s4, $s2, $s3   
    bgtz	$s4, greater    
    li      $v0, 1        
    lw      $ra, 0($sp)     
    lw      $s0, 4($sp)    
    lw      $s1, 8($sp)   
    addi    $sp, $sp, 12   
    jr $ra                  

greater:                   
    li      $v0, -1       
    lw      $ra, 0($sp)     
    lw      $s0, 4($sp)    
    lw      $s1, 8($sp)   
    addi    $sp, $sp, 12   
    jr $ra                  

cmpeos:
    li      $v0, 0        
    lw      $ra, 0($sp)     
    lw      $s0, 4($sp)    
    lw      $s1, 8($sp)   
    addi    $sp, $sp, 12   
    jr $ra              



######################################################################################
.data
.align 2
name: .asciiz "Name of the Pizza: "
pizzaDm: .asciiz "Pizza Diameter: "
pizzaCost: .asciiz "Pizza Cost:  "

PI: .float 3.14159265358979323846
done: .asciiz "DONE"
one: .word 1
zero: .float 0.0
four: .float 4.0 
bre : .asciiz "\n"
space: .word 32  
