.section .data
filename: .asciz "input.txt"
mode:  .asciz "r"
yes_str: .asciz "Yes\n"
no_str:  .asciz "No\n"

.section .text
.globl main

main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    sd s2, 16(sp)
    sd s3, 8(sp)

    la a0, filename
    la a1, mode
    call fopen
    
    beqz a0, end_main   # file_ptr = NULL
    mv s0, a0       # s0 = file_ptr

    mv a0, s0   
    li a1, 0
    li a2, 2    # going to the end of the file 
    call fseek

    mv a0, s0
    call ftell
    mv s2, a0       # s2 = total size of file 


    blez s2, palindrome     # length = 0 then palindrome

    addi s2, s2, -1     # s2 = right pointer
    li s1, 0        # s1 = left pointer

loop_compare:
    bge s1, s2, palindrome


    mv a0, s0
    mv a1, s1
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc
    mv s3, a0       # s3 = left_char

    mv a0, s0
    mv a1, s2
    li a2, 0
    call fseek      

    mv a0, s0
    call fgetc      # a0 = right_char

    bne s3, a0, not_palindrome
    addi s1, s1, 1
    addi s2, s2, -1
    jal x0, loop_compare

palindrome:
    la a0, yes_str
    call printf
    jal x0, done

not_palindrome:
    la a0, no_str
    call printf
    jal x0, done

done:
    mv a0, s0
    call fclose

end_main:
    li a0, 0
    ld s3, 8(sp)
    ld s2, 16(sp)
    ld s1, 24(sp)
    ld s0, 32(sp)
    ld ra, 40(sp)
    addi sp, sp, 48
    ret








