extern scanf, strstr, puts

%define MAXN 1003

section .rodata
    ifmt: db "%1003s", 0
    ans12: db "1 2", 0
    ans21: db "2 1", 0
    ans0: db "0", 0

section .bss
    s1: resb MAXN
    s2: resb MAXN

section .text
global main
main:
    enter 24, 0
    mov [esp+8], ebx

    ; esp+0 - fmt
    ; esp+4 - str
    mov dword [esp], ifmt
    mov dword [esp+4], s1
    call scanf
    mov dword [esp], ifmt
    mov dword [esp+4], s2
    call scanf

    mov ebx, ans12
    mov dword [esp], s2
    mov dword [esp+4], s1
    call strstr
    test eax, eax
    jnz .PRINT

    mov ebx, ans21
    mov dword [esp], s1
    mov dword [esp+4], s2
    call strstr
    test eax, eax
    jnz .PRINT

    mov ebx, ans0
.PRINT:
    mov [esp], ebx
    call puts

    xor eax, eax
    mov ebx, [esp+8]
    leave
    ret
