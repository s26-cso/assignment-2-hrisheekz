

.globl make_node

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sw a0, 4(sp)

    addi a0, x0, 24
    call malloc

    lw t0, 4(sp)        # t0 = val
    sw t0, 0(a0)        # loading val onto the node 
    sd zero, 8(a0)      # node->left = NULL
    sd zero, 16(a0)     # node->right = NULL


    ld ra, 8(sp)
    addi sp, sp, 16
    ret


.globl insert
insert:
    bne a0, x0, .function1      # if root != NULL
    addi a0, a1, 0              # returning node when root = NULL
    jal x0, make_node

.function1:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sw s2, 4(sp)

    addi s0, a0, 0      # s0 = root
    addi s1, a0, 0      # s1 = current = root
    addi s2, a1, 0      # s2 = val 

.finding_node:
    lw t0, 0(s1)
    beq s2, t0, .done_insert
    blt s2, t0, .goleft

.goright:
    ld t1, 16(s1)                # Load right child into t1
    beqz t1, .insertright    # If it's NULL we found our spot
    mv s1, t1                   # Move down curr = curr->right
    jal x0, .finding_node          # curr->right = new node

.insertright:
    mv a0, s2
    call make_node
    sd a0, 16(s1)               # Attach new node to the parent we kept in s1
    jal x0, .done_insert

.goleft:
    ld t1, 8(s1)                # Load left child into t1
    beqz t1, .insertleft    # If it's NULL we found our spot
    mv s1, t1                   # Move down curr = curr->left
    jal x0, .finding_node          # curr->left = new node

.insertleft:
    mv a0, s2
    call make_node
    sd a0, 8(s1)                # Attach to parent's left
    jal x0, .done_insert

.done_insert:
    mv a0, s0
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    lw s2, 4(sp)
    addi sp, sp, 32
    ret
   




.globl get
get:
.get_loop:
     beqz a0, .notfound     # root = NULL
     lw t0, 0(a0)
     beq a1, t0, .found     # current->val=val
     blt a1, t0, .get_searchleft    # val < current->val so we go left

     ld a0, 16(a0)              # searching in right subtree
     jal x0, .get_loop

.get_searchleft:
    ld a0, 8(a0)
    jal x0, .get_loop

.notfound:
    addi a0, x0, 0          # returning NULL when node not found

.found:
    ret




.globl getAtMost
getAtMost:
    addi t1, x0, -1     # Initializing answer to 0

.get_atmost_loop:
    beqz a1, .done      # root = NULL 
    lw t0, 0(a1)
    beq a0, t0, .foundexact     # current nodes value is the exact value
    blt a0, t0, .get_atmost_searchleft    # if val < current->val search in the left sub tree

    addi t1, t0, 0              # updating answer 
    ld a1, 16(a1)               # going to right sub tree when val > current->val
    jal x0, .get_atmost_loop

.get_atmost_searchleft:
    ld a1, 8(a1)
    jal x0, .get_atmost_loop

.foundexact:
    ret     # a0 is the required value

.done:
addi a0, t1, 0
ret


