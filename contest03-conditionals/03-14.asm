extern io_get_udec, io_print_udec, io_print_char

section .bss
    n: resd 1
    k: resd 1
    ; n x k: 31 x 31
    pas: resd 961
    ans: resd 1

section .text
global main
main:
    enter 0, 0
    
    call io_get_udec
    mov [n], eax
    call io_get_udec
    mov [k], eax
    cmp eax, 29
    jna .NA
    xor eax, eax
    call io_print_udec
    jmp .EXIT
.NA:
    cmp dword [n], 0
    je .ANS
    
    xor ebx, ebx
    xor edx, edx
    mov ecx, 1
    .L0_i:
        test [n], ecx
        setnz dl
        add ebx, edx
    shl ecx, 1
    test ecx, ecx
    jnz .L0_i
    
    mov eax, 32
    sub eax, ebx
    bsr ebx, [n]
    xor ebx, 31
    sub eax, ebx
    xor ebx, ebx
    cmp eax, [k]
    sete bl
    add [ans], ebx
    
    
    
    xor edi, edi
    .L1_n:         ; n = 0..31
        mov ebx, edi
        imul ebx, 31
        mov dword [pas + ebx*4], 1
        add ebx, edi
        mov dword [pas + ebx*4], 1
    inc edi
    cmp edi, 31
    jl .L1_n
    
    mov edi, 2
    .L2_n:         ; n = 2..31
        mov ebx, edi
        imul ebx, 31
        inc ebx
        mov edx, edi
        dec edx
        imul edx, 31
        
        mov esi, 1
        .L2_k:     ; k = 1..n
            mov eax, [pas + edx*4]
            inc edx
            add eax, [pas + edx*4]
            mov [pas + ebx*4], eax
            inc ebx
        inc esi
        cmp esi, edi
        jl .L2_k
    inc edi
    cmp edi, 31
    jl .L2_n
    
    bsr edi, [n]
    xor edi, 31
    mov edx, 1
    shl edx, 31
    mov ecx, edi
    shr edx, cl
    xor [n], edx
    mov ebx, 31
    sub ebx, edi
    imul ebx, 31
    inc dword [k]
    add ebx, [k]
    mov eax, [pas + ebx*4]
    add [ans], eax
    dec dword [k]
    cmp dword [n], 0
    je .ANS
    .L3:
        bsr ecx, [n]
        xor ecx, 31
        sub ecx, edi
        add edi, ecx
        ; ecx - сдвиг
        ; edi - lzcnt
        shr edx, cl
        xor [n], edx
        sub [k], ecx
        cmp dword [k], 0
        jl .ANS
        mov ebx, 31
        sub ebx, edi
        imul ebx, 31
        add ebx, [k]
        mov eax, [pas + ebx*4]
        add [ans], eax
        inc dword [k]
    cmp dword [n], 0
    jne .L3
.ANS:    
    mov eax, [ans]
    call io_print_udec
    
.EXIT:
    mov eax, `\n`
    call io_print_char
    
    leave
    xor eax, eax
    ret
