extern scanf, printf, strcmp

section .rodata
    ifmt_n: db "%d ", 0
    ifmt_s: db "%10s", 0
    ofmt: db `%d\n`, 0

section .bss
    n: resd 1
    s: resb 5500
    ans: resd 1
    
section .text
global main
main:
    enter 8, 0
    mov dword [esp], ifmt_n
    mov dword [esp+4], n
    call scanf
    
    mov esi, s
    .L1:
    mov eax, [n]
    imul eax, 11
    add eax, s
    cmp esi, eax
    jnl .L1_EXIT
        mov dword [esp], ifmt_s
        mov dword [esp+4], esi
        call scanf
        
        mov ebx, 1
        mov edi, s
        .L2:
        cmp edi, esi
        jnl .L2_EXIT
            mov dword [esp], esi
            mov dword [esp+4], edi
            call strcmp
            test eax, eax
            jnz .CONT
            xor ebx, ebx
            jmp .L2_EXIT
            .CONT:
        add edi, 11
        jmp .L2
        .L2_EXIT:
        add [ans], ebx
    add esi, 11
    jmp .L1
    .L1_EXIT:
        
    mov eax, [ans]
    mov dword [esp], ofmt
    mov [esp+4], eax
    call printf
    
    xor eax, eax
    leave
    ret