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
    
    xor edi, edi
    .L2_n:         ; n = 0..31
        mov ebx, edi
        imul ebx, 31
        inc ebx
        mov edx, edi
        dec edx
        imul edx, 31
        
        xor esi, esi
        inc esi
        .L2_k:     ; k = 1..31
            mov eax, [pas + edx*4]
            inc edx
            add eax, [pas + edx*4]
            mov [pas + ebx*4], eax
            inc ebx
        inc esi
        cmp esi, 31
        jl .L2_k
    inc edi
    cmp edi, 31
    jl .L2_n
    
    lzcnt edi, [n]
    mov edx, 1
    shl edx, 31
    mov ecx, edi
    shr edx, cl
.L3:
    lzcnt ecx, [n]
    sub ecx, edi
    add edi, ecx
    ; ecx - сдвиг
    ; edi - lzcnt
    shr edx, cl
    xor [n], edx
    sub [k], ecx
    inc dword [k]
    mov ebx, 31
    sub ebx, edi
    imul ebx, 31
    add ebx, [k]
    mov eax, [pas + ebx*4]
    add [ans], eax
    mov eax, [n]
    test eax, eax
    jnz .L3
    
    mov eax, [ans]
    call io_print_udec
    
.EXIT:
    mov eax, `\n`
    call io_print_char
    
    leave
    xor eax, eax
    ret
