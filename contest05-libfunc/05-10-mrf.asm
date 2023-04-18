extern calloc, free, scanf, printf

struc node
    .key resd 1
    .value resd 1
    .height resd 1
    .left resd 1
    .right resd 1
endstruc


section .rodata
    input_char_format db " %c", 0
    input_int_format db " %d", 0
    output_format db "%d %d", 10, 0


section .text
global main

; int height(node* root)
height:
    enter 8, 0

    mov eax, dword[ebp + 8]
    test eax, eax
    jz .EXIT
    mov eax, dword[eax + node.height]

.EXIT:
    leave
    ret


; int balanceFactor(node* root)
balanceFactor:
    enter 8, 0
    mov dword[ebp - 4], ebx

    mov eax, dword[ebp + 8]
    mov eax, dword[eax + node.left]
    mov dword[esp], eax
    call height
    mov ebx, eax

    mov eax, dword[ebp + 8]
    mov eax, dword[eax + node.right]
    mov dword[esp], eax
    call height

    sub eax, ebx

    mov ebx, dword[ebp - 4]
    leave
    ret


; void updateHeight(node* root)
updateHeight:
    enter 8, 0
    mov dword[ebp - 4], ebx

    mov eax, dword[ebp + 8]
    mov eax, dword[eax + node.left]
    mov dword[esp], eax
    call height
    mov ebx, eax

    mov eax, dword[ebp + 8]
    mov eax, dword[eax + node.right]
    mov dword[esp], eax
    call height

    cmp eax, ebx
    cmovg ebx, eax
    inc ebx
    mov eax, dword[ebp + 8]
    mov dword[eax + node.height], ebx

    mov ebx, dword[ebp - 4]
    leave
    ret


; node* rotateRight(node* root)
; q = root.left <- root = p -> root.right
rotateRight:
    enter 24, 0
    mov dword[ebp - 4], ebx
    mov dword[ebp - 8], esi
    mov dword[ebp - 12], edi

    mov esi, dword[ebp + 8] ; p 
    mov edi, dword[esi + node.left] ; q

    mov eax, dword[edi + node.right] ; q.right
    mov dword[esi + node.left], eax ; p.left = q.right

    mov dword[edi + node.right], esi ; q.right = p

    mov dword[esp], esi
    call updateHeight

    mov dword[esp], edi
    call updateHeight

    mov eax, edi

    mov edi, dword[ebp - 12]
    mov esi, dword[ebp - 8]
    mov ebx, dword[ebp - 4]
    leave
    ret


; node* rotateLeft(node* root)
; root.left <- q = root -> root.right = p
rotateLeft:
    enter 24, 0
    mov dword[ebp - 4], ebx
    mov dword[ebp - 8], esi
    mov dword[ebp - 12], edi

    mov edi, dword[ebp + 8] ; q 
    mov esi, dword[edi + node.right] ; p

    mov eax, dword[esi + node.left] ; p.left
    mov dword[edi + node.right], eax ; q.right = p.left

    mov dword[esi + node.left], edi ; p.left = q

    mov dword[esp], edi
    call updateHeight

    mov dword[esp], esi
    call updateHeight

    mov eax, esi

    mov edi, dword[ebp - 12]
    mov esi, dword[ebp - 8]
    mov ebx, dword[ebp - 4]
    leave
    ret


; node* balance(node* root)
balance:
    enter 8, 0

    mov eax, dword[ebp + 8]
    mov dword[esp], eax
    call updateHeight

    call balanceFactor

    cmp eax, 2
    jnz .RIGHTNORMAL

    mov ecx, dword[ebp + 8]
    mov ecx, dword[ecx + node.right]
    mov dword[esp], ecx
    call balanceFactor

    cmp eax, 0
    jnl .ROTATELEFT

    call rotateRight

    mov ecx, dword[ebp + 8]
    mov dword[ecx + node.right], eax

.ROTATELEFT:
    mov ecx, dword[ebp + 8]
    mov dword[esp], ecx
    call rotateLeft
    jmp .EXIT

.RIGHTNORMAL:
    cmp eax, -2
    jnz .LEFTNORMAL

    mov ecx, dword[ebp + 8]
    mov ecx, dword[ecx + node.left]
    mov dword[esp], ecx
    call balanceFactor

    cmp eax, 0
    jng .ROTATERIGHT

    call rotateLeft

    mov ecx, dword[ebp + 8]
    mov dword[ecx + node.left], eax

.ROTATERIGHT:
    mov ecx, dword[ebp + 8]
    mov dword[esp], ecx
    call rotateRight
    jmp .EXIT

.LEFTNORMAL:
    mov eax, dword[ebp + 8]

.EXIT:
    leave
    ret


; node* insert(node* root, int k, int v)
insert:
    enter 24, 0

    cmp dword[ebp + 8], 0 
    jnz .COMPARE

    mov dword[esp + 4], node_size
    mov dword[esp], 1
    call calloc

    mov edx, dword[ebp + 12]
    mov dword[eax + node.key], edx

    mov edx, dword[ebp + 16]
    mov dword[eax + node.value], edx

    mov dword[eax + node.height], 1

    leave
    ret

.COMPARE:
    mov ecx, dword[ebp + 8]
    mov edx, dword[ecx + node.key]

    cmp dword[ebp + 12], edx

    jz .EQUAL

    mov edx, dword[ebp + 16]
    mov dword[esp + 8], edx
    mov edx, dword[ebp + 12]
    mov dword[esp + 4], edx

    jg .GREATER

.LESS:
    mov ecx, dword[ebp + 8]
    mov ecx, dword[ecx + node.left]
    mov dword[esp], ecx
    call insert

    mov ecx, dword[ebp + 8]
    mov dword[ecx + node.left], eax 
    jmp .EXIT

.GREATER:
    mov ecx, dword[ebp + 8]
    mov ecx, dword[ecx + node.right]
    mov dword[esp], ecx
    call insert

    mov ecx, dword[ebp + 8]
    mov dword[ecx + node.right], eax 
    jmp .EXIT

.EQUAL:
    mov ecx, dword[ebp + 8]
    mov edx, dword[ebp + 16]
    mov dword[ecx + node.value], edx
    jmp .EXIT

.EXIT:
    mov ecx, dword[ebp + 8]
    mov dword[esp], ecx 
    call balance

    leave
    ret


; node* findMin(node* root)
findMin:
    enter 8, 0

    mov eax, dword[ebp + 8]
    mov eax, dword[eax + node.left]

    test eax, eax
    jz .ZERO

    mov dword[esp], eax
    call findMin
    jmp .EXIT

.ZERO:
    mov eax, dword[ebp + 8]

.EXIT:
    leave
    ret


; node* removeMin(node* root)
removeMin:
    enter 8, 0

    mov eax, dword[ebp + 8]
    mov ecx, dword[eax + node.left]

    test ecx, ecx
    jnz .GOLEFT

    mov eax, dword[eax + node.right]
    jmp .EXIT

.GOLEFT:
    mov dword[esp], ecx
    call removeMin

    mov ecx, dword[ebp + 8]
    mov dword[ecx + node.left], eax

    mov edx, dword[ebp + 8]
    mov dword[esp], edx
    call balance

.EXIT:
    leave
    ret


; node* remove(node* root, int key)
remove:
    enter 24, 0
    mov dword[ebp - 4], edi
    mov dword[ebp - 8], esi
    mov dword[ebp - 12], ebx

    mov ecx, dword[ebp + 8]
    test ecx, ecx
    jnz .NOTZERO

    xor eax, eax
    jmp .EXIT

.NOTZERO:
    mov edx, dword[ecx + node.key]
    cmp edx, dword[ebp + 12]

    je .EQUAL

    mov eax, dword[ebp + 12]
    mov dword[esp + 4], eax

    jl .GREATER
.LESS:
    mov ecx, dword[ecx + node.left]
    mov dword[esp], ecx
    call remove

    mov ecx, dword[ebp + 8]
    mov dword[ecx + node.left], eax
    mov eax, ecx

    jmp .EXIT

.GREATER:
    mov ecx, dword[ecx + node.right]
    mov dword[esp], ecx
    call remove

    mov ecx, dword[ebp + 8]
    mov dword[ecx + node.right], eax
    mov eax, ecx

    jmp .EXIT

.EQUAL:
    mov edi, dword[ecx + node.left] ; q
    mov esi, dword[ecx + node.right] ; r

    mov dword[esp], ecx
    call free

    test esi, esi
    jnz .NOTZERORIGHT

    mov eax, edi
    jmp .EXIT

.NOTZERORIGHT:
    mov dword[esp], esi
    call findMin

    mov ebx, eax

    call removeMin

    mov dword[ebx + node.right], eax
    mov dword[ebx + node.left], edi

    mov dword[esp], ebx
    call balance

.EXIT:
    mov edi, dword[ebp - 4]
    mov esi, dword[ebp - 8]
    mov ebx, dword[ebp - 12]
    leave
    ret


; void cleanup(node* root)
cleanup:
    enter 8, 0

    mov eax, dword[ebp + 8]
    test eax, eax
    jz .EXIT

    mov eax, dword[eax + node.left]
    mov dword[esp], eax
    call cleanup

    mov eax, dword[ebp + 8]
    mov eax, dword[eax + node.right]
    mov dword[esp], eax
    call cleanup

    mov eax, dword[ebp + 8]
    mov dword[esp], eax
    call free

.EXIT:
    leave
    ret


; void search(node* root, int key)
search:
    enter 24, 0

    mov eax, dword[ebp + 8]

    test eax, eax
    jz .EXIT

    mov edx, dword[eax + node.key]
    cmp edx, dword[ebp + 12]

    jz .EQUAL

    mov ecx, dword[ebp + 12]
    mov dword[esp + 4], ecx

    jl .GREATER
.LESS:
    mov eax, dword[eax + node.left]
    mov dword[esp], eax
    call search
    jmp .EXIT

.GREATER:
    mov eax, dword[eax + node.right]
    mov dword[esp], eax
    call search
    jmp .EXIT

.EQUAL:
    mov ecx, dword[eax + node.value]
    mov dword[esp + 8], ecx
    mov dword[esp + 4], edx
    mov dword[esp], output_format
    call printf

.EXIT:
    leave
    ret


main:
    enter 40, 0
    mov dword[ebp - 4], ebx
    mov dword[ebp - 8], edi
    mov dword[ebp - 12], esi

    xor esi, esi ; root

.READLOOP:
    mov dword[esp + 4], ebp
    sub dword[esp + 4], 16
    mov dword[esp], input_char_format
    call scanf

    cmp dword[ebp - 16], 'A'
    jnz .SKIP1

    mov dword[esp], input_int_format
    call scanf
    mov ebx, dword[ebp - 16]

    call scanf
    mov eax, dword[ebp - 16]

    mov dword[esp + 8], eax
    mov dword[esp + 4], ebx
    mov dword[esp], esi

    call insert
    mov esi, eax

    jmp .READLOOP

.SKIP1:
    cmp dword[ebp - 16], 'D'
    jnz .SKIP2

    mov dword[esp], input_int_format
    call scanf

    mov eax, dword[ebp - 16]
    mov dword[esp + 4], eax
    mov dword[esp], esi
    call remove
    mov esi, eax

    jmp .READLOOP

.SKIP2:
    cmp dword[ebp - 16], 'S'
    jnz .SKIP3

    mov dword[esp], input_int_format
    call scanf

    mov eax, dword[ebp - 16]
    mov dword[esp + 4], eax
    mov dword[esp], esi
    call search

    jmp .READLOOP

.SKIP3:
    cmp dword[ebp - 16], 'F'
    jnz .READLOOP

    mov dword[esp], esi
    call cleanup

    xor eax, eax
    mov ebx, dword[ebp - 4]
    mov edi, dword[ebp - 8]
    mov esi, dword[ebp - 12]
    leave
    ret
