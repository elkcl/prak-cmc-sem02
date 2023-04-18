extern fopen, fclose, fscanf, fprintf, malloc, free, putc

%define EOF -1

struc node
    .val: resd 1
    .next: resd 1
endstruc

section .rodata
    ifmt: db "%d", 0
    ofmt: db "%d ", 0
    in_filename: db "input.txt", 0
    out_filename: db "output.txt", 0
    in_mode: db "r", 0
    out_mode: db "w", 0

section .bss
    in_handle: resd 1
    out_handle: resd 1

section .text
global main
main:
    enter 24,0
    
    mov dword [esp], in_filename
    mov dword [esp+4], in_mode
    call fopen
    mov [in_handle], eax
    
    mov dword [esp], out_filename
    mov dword [esp+4], out_mode
    call fopen
    mov [out_handle], eax

    call list_read
    mov edx, eax
    xor ecx, ecx
    .L1:
    test edx, edx
    jz .L1_EXIT
    inc ecx
    mov edx, [edx + node.next]
    jmp .L1
    .L1_EXIT:
    mov [esp], eax
    mov [esp+4], ecx
    call list_sort
    mov [esp], eax
    call list_print
    mov [esp], eax
    call list_free
    mov dword [esp], `\n`
    mov eax, [out_handle]
    mov [esp+4], eax
    call putc

    mov eax, [in_handle]
    mov [esp], eax
    call fclose

    mov eax, [out_handle]
    mov [esp], eax
    call fclose

    xor eax, eax
    leave
    ret

; xs: node* (ebp+8)
; ys: node* (ebp+12)
; -> node*
list_merge:
    enter 8,0
    
    mov eax, [ebp+12]
    cmp dword [ebp+8], 0
    je .EXIT
    mov eax, [ebp+8]
    cmp dword [ebp+12], 0
    je .EXIT

    mov eax, [ebp+8]
    mov ecx, [eax + node.val]
    mov edx, [ebp+12]
    cmp ecx, [edx + node.val]
    jnle .NLE
    
    mov eax, [eax + node.next]
    mov [esp], eax
    mov [esp+4], edx
    call list_merge
    mov edx, [ebp+8]
    mov [edx + node.next], eax
    mov eax, edx
    jmp .EXIT
    
    .NLE:
    mov edx, [edx + node.next]
    mov [esp], eax
    mov [esp+4], edx
    call list_merge
    mov edx, [ebp+12]
    mov [edx + node.next], eax
    mov eax, edx
    jmp .EXIT

.EXIT:
    leave
    ret

; xs: node* (ebp+8)
; n: int (ebp+12)
; -> node*
list_sort:
    enter 24,0
    mov [esp+8], esi
    mov [esp+12], edi
    
    mov eax, [ebp+8]
    test eax, eax
    jz .EXIT
    cmp dword [eax + node.next], 0
    je .EXIT

    mov ecx, [ebp+12]
    shr ecx, 1
    dec ecx
    mov esi, [ebp+8]
    mov edx, esi
    jecxz .L1_EXIT
    .L1:
    mov edx, [edx + node.next]
    loop .L1
    .L1_EXIT:
    mov edi, [edx + node.next]
    mov dword [edx + node.next], 0

    mov ecx, [ebp+12]
    shr ecx, 1
    mov [esp], esi
    mov [esp+4], ecx
    call list_sort
    mov esi, eax

    mov ecx, [ebp+12]
    shr ecx, 1
    neg ecx
    add ecx, [ebp+12]
    mov [esp], edi
    mov [esp+4], ecx
    call list_sort
    mov edi, eax

    mov [esp], esi
    mov [esp+4], edi
    call list_merge
    
.EXIT:
    mov esi, [esp+8]
    mov edi, [esp+12]
    leave
    ret

; -> node*
list_read:
    enter 24,0
    mov [esp+16], ebx

    mov eax, [in_handle]
    mov [esp], eax
    mov dword [esp+4], ifmt
    lea eax, [esp+12]
    mov [esp+8], eax
    call fscanf
    mov ecx, eax
    xor eax, eax
    cmp ecx, EOF
    je .EXIT
    mov ebx, [esp+12]
    
    mov dword [esp], node_size
    call malloc
    
    mov [eax + node.val], ebx
    mov ebx, eax
    call list_read
    mov [ebx + node.next], eax
    mov eax, ebx
    
.EXIT:
    mov ebx, [esp+16]
    leave
    ret
    
; xs: node* (ebp+8)
; -> void
list_print:
    enter 24,0
    
    mov eax, [out_handle]
    mov [esp], eax
    mov dword [esp+4], ofmt
    mov eax, [ebp+8]
    test eax, eax
    jz .EXIT
    mov eax, [eax + node.val]
    mov [esp+8], eax
    call fprintf
    
    mov eax, [ebp+8]
    mov eax, [eax + node.next]
    mov [esp], eax
    call list_print
    
.EXIT:    
    leave
    ret
    
; xs: node* (ebp+8)
; -> void
list_free:
    enter 8,0
    mov eax, [ebp+8]
    test eax, eax
    jz .EXIT
    mov eax, [eax + node.next]
    mov [esp], eax
    call list_free
    mov eax, [ebp+8]
    mov [esp], eax
    call free
.EXIT:
    leave
    ret
