extern io_get_udec, io_print_udec, io_newline

section .bss
    n: resd 1
    arr: resd 1000
    k: resd 1
    ans: resd 1

section .text
global main
main:
    enter 0, 0
    
    call io_get_udec
    mov [n], eax
    
    ; for ebx = 0..n
    xor ebx, ebx
    .L1:
        cmp ebx, [n]
        jnl .END_L1
        
        call io_get_udec
        mov [arr + ebx*4], eax
        
        inc ebx
        jmp .L1
    .END_L1:
    
    call io_get_udec
    mov [k], eax
    
    ; for ebx = 0..n
    xor ebx, ebx
    .L2:
        cmp ebx, [n]
        jnl .END_L2
        
        push dword [arr + ebx*4]
        call zero_count
        add esp, 4
        cmp eax, [k]
        jne .NOTK
        inc dword [ans]
        .NOTK:
        
        inc ebx
        jmp .L2
    .END_L2:
    
    mov eax, [ans]
    call io_print_udec
    call io_newline
    
    xor eax, eax
    leave
    ret

zero_count:
    enter 0, 0
    
    xor eax, eax
    mov ecx, [ebp + 8]
    test ecx, ecx
    jz .EXIT
    
    mov eax, 32
    bsr edx, [ebp + 8]
    xor edx, 31
    ; edx - clz
    sub eax, edx

    ; while ecx != 0
    .L1:
        mov edx, 1
        and edx, ecx
        sub eax, edx
        shr ecx, 1
    jnz .L1
    
.EXIT:
    leave
    ret
