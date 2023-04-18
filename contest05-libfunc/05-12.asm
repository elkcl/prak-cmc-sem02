extern fopen, fclose, fread, printf, putchar

%define MAXN 10000

struc node
    .k: resd 1
    .l: resd 1
    .r: resd 1
endstruc

section .bss
    tree: resb MAXN * node_size
    vis: resb MAXN
    handle: resd 1
    n: resd 1
    root: resd 1

section .rodata
    filename: db "input.bin", 0
    mode: db "rb", 0
    ofmt: db "%d ", 0
    sz: dd node_size

section .text
global main
main:
    enter 24,0
    mov [esp+16], ebx

    mov dword [esp], filename
    mov dword [esp+4], mode
    call fopen
    mov [handle], eax
    
    mov dword [esp], tree
    mov dword [esp+4], node_size
    mov dword [esp+8], MAXN
    mov [esp+12], eax
    call fread
    mov [n], eax

    xor ecx, ecx
    xor edx, edx
    mov ebx, [n]
    imul ebx, node_size
    .L1:
    cmp ecx, ebx
    jnl .L1_EXIT
        mov eax, [tree + ecx + node.l]
        cmp eax, -1
        je .R
        div dword [sz]
        mov byte [vis + eax], 1
        .R:
        mov eax, [tree + ecx + node.r]
        cmp eax, -1
        je .CONT1
        div dword [sz]
        mov byte [vis + eax], 1
        .CONT1:
    add ecx, node_size
    jmp .L1
    .L1_EXIT:
    
    xor ecx, ecx
    .L2:
    cmp ecx, [n]
    jnl .L2_EXIT
        cmp byte [vis + ecx], 0
        jne .CONT2
        imul ecx, 12
        mov [root], ecx
        jmp .L2_EXIT
        .CONT2:
    inc ecx
    jmp .L2
    .L2_EXIT:

    mov eax, [root]
    mov [esp], eax
    call dfs
    mov dword [esp], `\n`
    call putchar

    mov eax, [handle]
    mov [esp], eax
    call fclose

    mov ebx, [esp+16]
    xor eax, eax
    leave
    ret

; v: int (ebp+8)
; -> void
dfs:
    enter 8,0
    mov ecx, [ebp+8]
    cmp ecx, -1
    je .EXIT
    mov eax, [tree + ecx + node.k]
    mov dword [esp], ofmt
    mov [esp+4], eax
    call printf

    mov ecx, [ebp+8]
    mov eax, [tree + ecx + node.l]
    mov [esp], eax
    call dfs

    mov ecx, [ebp+8]
    mov eax, [tree + ecx + node.r]
    mov [esp], eax
    call dfs

.EXIT:
    leave
    ret
