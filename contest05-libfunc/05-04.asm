extern fopen, fclose, fscanf, printf

%define EOF -1

section .rodata
    ifmt: db "%*d", 0
    ofmt: db `%d\n`, 0
    filename: db "data.in", 0
    mode: db "r", 0

section .bss
    handle: resd 1

section .text
global main
main:
    enter 24, 0
    mov [esp+8], ebx

    mov dword [esp], filename
    mov dword [esp+4], mode
    call fopen
    mov [handle], eax
    xor ebx, ebx
.L1:
    mov eax, [handle]
    mov [esp], eax
    mov dword [esp+4], ifmt
    call fscanf
    inc ebx
    cmp eax, EOF
    jne .L1

    dec ebx
    mov dword [esp], ofmt
    mov [esp+4], ebx
    call printf

    mov eax, [handle]
    mov [esp], eax
    call fclose

    xor eax, eax
    mov ebx, [esp+8]
    leave
    ret
