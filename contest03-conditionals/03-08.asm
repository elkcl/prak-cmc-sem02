extern io_get_dec, io_print_dec, io_print_char

section .bss
    n: resd 1
    m: resd 1
    k: resd 1
    mat1: resd 10000
    mat2: resd 10000
    mat3: resd 10000

section .text
global main
main:
    enter 0, 0
    
    call io_get_dec
    mov [n], eax
    call io_get_dec
    mov [m], eax
    call io_get_dec
    mov [k], eax
    
    ; edi, esi, ecx - i, j, l
    
    xor edi, edi
    .L1_i:             ; i = 0..n
        xor esi, esi
        .L1_j:         ; j = 0..m
            ; ebx = i*m + j
            mov ebx, edi
            imul ebx, [m]
            add ebx, esi
            call io_get_dec
            mov [mat1 + ebx*4], eax
        inc esi
        cmp esi, [m]
        jl .L1_j
    inc edi
    cmp edi, [n]
    jl .L1_i
    
    xor edi, edi
    .L2_i:             ; i = 0..m
        xor esi, esi
        .L2_j:         ; j = 0..k
            ; ebx = j*m + i
            mov ebx, esi
            imul ebx, [m]
            add ebx, edi
            call io_get_dec
            mov [mat2 + ebx*4], eax
        inc esi
        cmp esi, [k]
        jl .L2_j
    inc edi
    cmp edi, [m]
    jl .L2_i
    
    xor edi, edi
    .L3_i:             ; i = 0..n
        xor esi, esi
        .L3_j:         ; j = 0..k
            ; ebx = i*k + j
            mov ebx, edi
            imul ebx, [k]
            add ebx, esi
            mov dword [mat3 + ebx*4], 0
            
            xor ecx, ecx
            .L3_l:     ; l = 0..m
                ; edx = i*m + l
                mov edx, edi
                imul edx, [m]
                add edx, ecx
                mov eax, [mat1 + edx*4]
                ; edx = j*m + l
                mov edx, esi
                imul edx, [m]
                add edx, ecx
                imul eax, [mat2 + edx*4]
                add [mat3 + ebx*4], eax
            inc ecx
            cmp ecx, [m]
            jl .L3_l
        inc esi
        cmp esi, [k]
        jl .L3_j
    inc edi
    cmp edi, [n]
    jl .L3_i
    
    xor edi, edi
    .L4_i:             ; i = 0..n
        xor esi, esi
        .L4_j:         ; j = 0..k
            ; ebx = i*k + j
            mov ebx, edi
            imul ebx, [k]
            add ebx, esi
            mov eax, [mat3 + ebx*4]
            call io_print_dec
            mov eax, ' '
            call io_print_char
        inc esi
        cmp esi, [k]
        jl .L4_j
        
        mov eax, `\n`
        call io_print_char
    inc edi
    cmp edi, [n]
    jl .L4_i
    
    leave
    xor eax, eax
    ret
