extern fopen, fclose, fscanf, fprintf, calloc, free

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
merge:
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
    call merge
    mov edx, [ebp+8]
    mov [edx + node.next], eax
    mov eax, edx
    jmp .EXIT
    
    .NLE:
    mov edx, [edx + node.next]
    mov [esp], eax
    mov [esp+4], edx
    call merge
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
sort:
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
    .L1:
    mov edx, [edx + node.next]
    loop .L1
    mov edi, [edx + node.next]
    mov [edx + node.next], 0

    mov ecx, [ebp+12]
    shr ecx, 1
    mov [esp], esi
    mov [esp+4], ecx
    call sort
    mov esi, eax

    mov ecx, [ebp+12]
    shr ecx, 1
    neg ecx
    add ecx, [ebp+12]
    mov [esp], edi
    mov [esp+4], ecx
    call sort
    mov edi, eax

    mov [esp], esi
    mov [esp+4], edi
    call merge
    
.EXIT
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
    cmp eax, EOF
    je .EXIT
    mov eax, ebx

.EXIT:
    mov ebx, [esp+16]
    leave
    ret
