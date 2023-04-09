extern scanf, getchar, printf, calloc, free

struc node
    .k: resd 1
    .v: resd 1
    .h: resd 1
    .l: resd 1
    .r: resd 1
endstruc

section .rodata
    rm_ws: db " ", 0
    ifmt: db "%d", 0
    ofmt: db `%d %d\n`, 0

section .bss
    t: resd 1
    k: resd 1
    v: resd 1
    
section .text

; t: const node* (ebp+8)
; -> int
h:
    enter 8,0
    mov ecx, [ebp+8]
    xor eax, eax
    test ecx, ecx
    je .EXIT
    mov eax, [ecx + node.h]
.EXIT:
    leave
    ret
    
; t: const node* (ebp+8)
; -> int
bf:
    enter 8,0
    mov eax, [ebp+8]
    mov eax, [eax + node.l]
    mov [esp], eax
    call h
    mov [esp+4], eax
    mov eax, [ebp+8]
    mov eax, [eax + node.r]
    call h
    sub eax, [esp+4]
    leave
    ret

; t: node* (ebp+8)
; -> void
fixh:
    enter 8,0
    mov eax, [ebp+8]
    mov eax, [eax + node.l]
    mov [esp], eax
    call h
    mov [esp+4], eax
    mov eax, [ebp+8]
    mov eax, [eax + node.r]
    mov [esp], eax
    call h
    cmp eax, [esp+4]
    cmovl eax, [esp+4]
    inc eax
    mov ecx, [ebp+8]
    mov [ecx + node.h], eax
    leave
    ret

; a: node* (ebp+8)
; -> node*
rot_left:
    enter 8,0
    mov [esp+4], ebx
    
    mov eax, [ebp+8]        ; eax = a
    mov ebx, [eax + node.r] ; ebx = b = a->r
    mov edx, [ebx + node.l] ; edx = b->l
    mov [eax + node.r], edx
    mov [ebx + node.l], eax
    
    mov [esp], eax
    call fixh
    mov [esp], ebx
    call fixh
    mov eax, ebx
    
    mov ebx, [esp+4]
    leave
    ret

; a: node* (ebp+8)
; -> node*
rot_right:
    enter 8,0
    mov [esp+4], ebx
    
    mov eax, [ebp+8]        ; eax = a
    mov ebx, [eax + node.l] ; ebx = b = a->l
    mov edx, [ebx + node.r] ; edx = b->r
    mov [eax + node.l], edx
    mov [ebx + node.r], eax
    
    mov [esp], eax
    call fixh
    mov [esp], ebx
    call fixh
    mov eax, ebx
    
    mov ebx, [esp+4]
    leave
    ret
    
; a: node* (ebp+8)
; -> node*
balance:
    enter 8,0
    mov [esp+4], ebx
    mov ebx, [ebp+8]
    
    mov [esp], ebx
    call fixh
    mov [esp], ebx
    call bf
    
    cmp eax, 2
    jne .CMP2
    mov eax, [ebx + node.r]
    mov [esp], eax
    call bf
    cmp eax, -1
    jne .NO_ROT_RIGHT
    mov eax, [ebx + node.r]
    mov [esp], eax
    call rot_right
    mov [ebx + node.r], eax
.NO_ROT_RIGHT:
    mov [esp], ebx
    call rot_left
    jmp .EXIT
    
.CMP2:
    cmp eax, -2
    jne .RET_A
    mov eax, [ebx + node.l]
    mov [esp], eax
    call bf
    cmp eax, 1
    jne .NO_ROT_LEFT
    mov eax, [ebx + node.l]
    mov [esp], eax
    call rot_left
    mov [ebx + node.l], eax
.NO_ROT_LEFT:
    mov [esp], ebx
    call rot_right
    jmp .EXIT
    
.RET_A:
    mov eax, ebx
.EXIT:
    mov ebx, [esp+4]
    leave
    ret

; t: const node* (ebp+8)
; key: int (ebp+12)
; -> node*
find_key:
    enter 8,0
    mov eax, [ebp+8]
    test eax, eax
    je .EXIT
    mov eax, [eax + node.k]
    cmp eax, [ebp+12]
    jne .NE
    mov eax, [ebp+8]
    jmp .EXIT
.NE:
    jl .L
    mov eax, [ebp+8]
    mov eax, [eax + node.l]
    mov [esp], eax
    mov eax, [ebp+12]
    mov [esp+4], eax
    call find_key
    jmp .EXIT
.L:
    mov eax, [ebp+8]
    mov eax, [eax + node.r]
    mov [esp], eax
    mov eax, [ebp+12]
    mov [esp+4], eax
    call find_key
.EXIT:
    leave
    ret

; t: node* (ebp+8)
; k: int (ebp+12)
; v: int (ebp+16)
; -> node*
insert_key:
    enter 24,0
    mov [esp+12], ebx
    mov ebx, [ebp+8]
    
    test ebx, ebx
    jnz .NZ
    mov dword [esp], 1
    mov dword [esp+4], node_size
    call calloc
    mov ecx, [ebp+12]
    mov [eax + node.k], ecx
    mov ecx, [ebp+16]
    mov [eax + node.v], ecx
    mov dword [eax + node.h], 1
    jmp .EXIT
.NZ:
    mov eax, [ebx + node.k]
    cmp eax, [ebp+12]
    jne .NE
    mov eax, [ebp+16]
    mov [ebx + node.v], eax
    mov eax, ebx
    jmp .EXIT
.NE:
    jl .L
    mov eax, [ebx + node.l]
    mov [esp], eax
    mov eax, [ebp+12]
    mov [esp+4], eax
    mov eax, [ebp+16]
    mov [esp+8], eax
    call insert_key
    mov [ebx + node.l], eax
    jmp .BALANCE
.L:
    mov eax, [ebx + node.r]
    mov [esp], eax
    mov eax, [ebp+12]
    mov [esp+4], eax
    mov eax, [ebp+16]
    mov [esp+8], eax
    call insert_key
    mov [ebx + node.r], eax
.BALANCE:
    mov [esp], ebx
    call balance
.EXIT:
    mov ebx, [esp+12]
    leave
    ret
    
; t: const node* (ebp+8)
; -> node*
find_min:
    enter 8,0
    mov eax, [ebp+8]
    mov ecx, [eax + node.l]
    test ecx, ecx
    jz .EXIT
    mov [esp], ecx
    call find_min
.EXIT:
    leave
    ret
    
; t: node* (ebp+8)
; -> node*
remove_min:
    enter 8,0
    mov edx, [ebp+8]
    mov ecx, [edx + node.l]
    mov eax, [edx + node.r]
    test ecx, ecx
    jz .EXIT
    mov [esp], ecx
    call remove_min
    mov edx, [ebp+8]
    mov [edx + node.l], eax
    mov [esp], edx
    call balance
.EXIT:
    leave
    ret

; t: node* (ebp+8)
; key: int (ebp+12)
; -> node*
remove_key:
    enter 24,0
    mov [esp+8], ebx
    mov [esp+12], esi
    mov [esp+16], edi
    mov ebx, [ebp+8]
    
    mov eax, ebx
    test eax, eax
    jz .EXIT
    
    mov ecx, [ebx + node.k]
    cmp ecx, [ebp+12]
    jng .NG
    mov edx, [ebx + node.l]
    mov [esp], edx
    mov edx, [ebp+12]
    mov [esp+4], edx
    call remove_key
    mov [ebx + node.l], eax
    jmp .BALANCE
.NG:
    jnl .NL
    mov edx, [ebx + node.r]
    mov [esp], edx
    mov edx, [ebp+12]
    mov [esp+4], edx
    call remove_key
    mov [ebx + node.r], eax
    jmp .BALANCE
.NL:
    mov esi, [ebx + node.l]
    mov edi, [ebx + node.r]
    mov [esp], ebx
    call free
    test edi, edi
    jnz .R_NOT_EMPTY
    mov eax, esi
    jmp .EXIT
.R_NOT_EMPTY:
    mov [esp], edi
    call find_min
    mov ebx, eax
    mov [esp], edi
    call remove_min
    mov [ebx + node.r], eax
    mov [ebx + node.l], esi
.BALANCE:
    mov eax, [ebp+8]
    mov [esp], eax
    call balance
.EXIT:
    mov ebx, [esp+8]
    mov esi, [esp+12]
    mov edi, [esp+16]
    leave
    ret
    
; t: node* (ebp+8)
; -> void
node_free:
    enter 8,0
    mov eax, [ebp+8]
    test eax, eax
    jz .EXIT
    mov eax, [eax + node.l]
    mov [esp], eax
    call node_free
    mov eax, [ebp+8]
    mov eax, [eax + node.r]
    call node_free
    mov eax, [ebp+8]
    mov [esp], eax
    call free
.EXIT:
    leave
    ret

global main
main:
    enter 24,0
.L1:
    mov dword [esp], rm_ws
    call scanf
    call getchar
    cmp eax, 'A'
    je .A
    cmp eax, 'D'
    je .D
    cmp eax, 'S'
    je .S
    jmp .EXIT
    
.A:
    mov dword [esp], ifmt
    mov dword [esp+4], k
    call scanf
    mov dword [esp], ifmt
    mov dword [esp+4], v
    call scanf
    mov eax, [t]
    mov [esp], eax
    mov eax, [k]
    mov [esp+4], eax
    mov eax, [v]
    mov [esp+8], eax
    call insert_key
    mov [t], eax
    jmp .L1
.D:
    mov dword [esp], ifmt
    mov dword [esp+4], k
    call scanf
    mov eax, [t]
    mov [esp], eax
    mov eax, [k]
    mov [esp+4], eax
    call remove_key
    mov [t], eax
    jmp .L1
.S:
    mov dword [esp], ifmt
    mov dword [esp+4], k
    call scanf
    mov eax, [t]
    mov [esp], eax
    mov eax, [k]
    mov [esp+4], eax
    call find_key
    test eax, eax
    jz .L1
    mov dword [esp], ofmt
    mov ecx, [k]
    mov [esp+4], ecx
    mov ecx, [eax + node.v]
    mov [esp+8], ecx
    call printf
    jmp .L1
.EXIT:
    mov eax, [t]
    mov dword [esp], eax
    call node_free
    xor eax, eax
    leave
    ret
