.text
.align 2
.globl main


main:
    li      $v0, 5       
    syscall          
    move    $a0, $v0     

    jal func            


    move    $a0, $v0     
    li      $v0, 1   
    syscall               

    li      $v0, 10   
    syscall               


func:
    addi    $sp, $sp, -12  
    sw      $ra, 8($sp)     
    sw      $s0, 4($sp)

    sw      $s1, 0($sp)    
    move    $s0, $a0



    beqz     $a0, base  

    la $s2, check
    lw $s2, 0($s2)
    beq $s2, $a0, base

    addi $a0, $s0, -1
    jal func
    move $s1, $v0

    addi $a0, $s0,-2
    jal func



    add $s1, $v0, $s1
    add $s1, $v0, $s1

    add $v0, $s1, 3
    j clean

base:
    move $v0, $s0          


clean:
    lw      $s0, 4($sp)
    lw      $s1, 0($sp)
    lw      $ra, 8($sp) 
    addi    $sp, $sp, 12   
    jr $ra                 




.data
.align 2
check: .word 1 
