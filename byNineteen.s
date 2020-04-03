.text
.align 2
.globl main


main: 


    li      $v0, 5         
    syscall                
    move    $t1, $v0       
    li      $t2, 1         
    li      $t3, 0    
    li      $t4, 19         

loop: 
    beq     $t1, $t3, exit  
    
    div     $t2, $t4        
    mfhi    $t6       
    beq     $t6, $0, print  


    
join: 
    addi    $t2, $t2, 1  
    j loop              

print: 
    addi    $t3, 1        

    li      $v0, 1          
    move    $a0, $t2   
    syscall             

    li      $v0, 4      
    la      $a0, nln     
    syscall  
    j join         

exit:
    li      $v0, 10       
    syscall              


.data                      
nln:    .asciiz "\n"
