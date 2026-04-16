.section .data
format_str:  .asciz "%d "
format_strend: .asciz "%d"
newline_str: .asciz "\n"

.section .text
.globl main

main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    sd s2, 16(sp)
    sd s3, 8(sp)
    sd s4, 0(sp)

    li t0, 1
    ble a0, t0, end_main
    addi s0, a0, -1     # s0 = number of elements
    addi s1, a1, 0      # s1 = pointer to first element in input

    slli s2, s0, 2
    sub sp, sp, s2
    addi s3, sp, 0      # pointer to input arr


    sub sp, sp, s2
    addi s4, sp, 0      # pointer to result arr

    addi t0, x0, 0      # i = 0
    loop:
        bge t0, s0, start
        addi t1, t0, 1
        slli t1, t1, 3
        add t1, s1, t1
        ld a0, 0(t1)        # loading val of input arr

        addi sp, sp, -16
        sd t0, 0(sp)

        call atoi           # convert string to int 

        ld t0, 0(sp)
        addi sp, sp, 16

        slli t1, t0, 2
        add t1, s3, t1
        sw a0, 0(t1)        # arr[i] = atoi(argv[i+1])

        addi t0, t0, 1
        jal x0, loop

    start:
        addi a0, s3, 0      # a0 = arr
        addi a1, s4, 0      # a1 = result
        addi a2, s0, 0      # a2 = n
        call next_greater

        li t0, 0            # i = 0
        addi t2, s0, -1
        print:
        bge t0, s0, end
        beq t0, t2, last
        slli t1, t0, 2
        add t1, s4, t1
        lw a1, 0(t1)
        la a0, format_str
        addi sp, sp, -16       # saving t0
        sd t0, 0(sp)

        call printf
        ld t0, 0(sp)        # restore t0
        addi sp, sp, 16

        addi t0, t0, 1
        jal x0, print

        last:
        slli t1, t0, 2
        add t1, s4, t1
        lw a1, 0(t1)
        la a0, format_strend
        addi sp, sp, -16       # saving t0
        sd t0, 0(sp)

        call printf
        ld t0, 0(sp)        # restore t0
        addi sp, sp, 16
            

        end:
        la a0, newline_str
        call printf

        slli t0, s0, 3      # deallocate arr and 'result' arrays from stack
        add sp, sp, t0

    end_main:
    li a0, 0
    ld s4, 0(sp)
    ld s3, 8(sp)
    ld s2, 16(sp)
    ld s1, 24(sp)
    ld s0, 32(sp)
    ld ra, 40(sp)
    addi sp, sp, 48
    ret
    
next_greater:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sd s2, 0(sp)

    addi s0, a0, 0      # s0 = arr
    addi s1, a1, 0      # s1 = result
    addi s2, a2, 0      # s2 = n
    
    
    slli t0, s2, 2       # Allocate memory for the Stack array (n * 4 bytes)
    sub sp, sp, t0
    addi t1, sp, 0      # t1 = address of stack

    addi t2, x0, 0
    addi t3, x0, -1

loop_result:        # initializing result[i] = -1 for all i
    bge t2, s2, algo_start      
    slli t4, t2, 2
    add t4, s1, t4
    sw  t3, 0(t4)
    addi t2, t2, 1
    jal x0, loop_result

 algo_start:
    addi t2, x0, -1     # top = -1
    addi t3, s2, -1     # i = n-1

for_loop:
    bltz t3, end_for

while_loop:
    bltz t2, end_while      # checking if stack is empty

    slli t4, t2, 2
    add t4, t1, t4
    lw t5, 0(t4)   # t5 = stack[top]
    slli t6, t5, 2
    add t6, s0, t6
    lw t6, 0(t6)    # t6 = arr[stack[top]]

    slli t0, t3, 2
    add t0, s0, t0
    lw t0, 0(t0)      # t0 = arr[i]

    bgt t6, t0, end_while       # If arr[stack.top()] > arr[i], break out of the while loop

    addi t2, t2, -1
    jal x0, while_loop

end_while:
    bltz t2, stack_empty        # if (!stack.empty()) result[i] = stack.top()

    slli t4, t2, 2
    add t4, t1, t4
    lw t5, 0(t4)    # t5 = stack[top]

    slli t4, t3, 2
    add t4, s1, t4
    sw t5, 0(t4)    # result[i] = stack[top]

stack_empty:
    addi t2, t2, 1
    slli t4, t2, 2
    add t4, t1, t4
    sw t3, 0(t4)      # stack[top] = arr[i]

    addi t3, t3, -1     # i--
    jal x0, for_loop

end_for:
    slli t0, s2, 2
    add sp, sp, t0      
    
    ld s2, 0(sp)
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret



    



    





