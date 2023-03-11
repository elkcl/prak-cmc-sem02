extern io_get_udec, io_print_udec, io_print_char

section .bss
    n: resd 1
    arr: resd 1000000

section .text
global main
main:
    enter 0, 0
    
    call io_get_udec
    test eax, eax
    jnz .NZ
    call io_get_udec
    jmp .EXIT
.NZ:    
    mov [n], eax
    
    xor ebx, ebx       ; ebx = i
    .L1_i:             ; i = 0..n
        call io_get_udec
        mov [arr + ebx*4], eax
    inc ebx
    cmp ebx, [n]
    jl .L1_i
    
    call io_get_udec
    test eax, eax
    jz .PRINT
    mov ecx, 32
    sub ecx, eax       ; ecx = 32 - k
    
    ; edi - old
    ; esi - new
    xor edi, edi
    xor esi, esi
    
    xor ebx, ebx
    .L2_i:
        mov esi, [arr + ebx*4]
        shl esi, cl
        neg ecx
        add ecx, 32
        shr dword [arr + ebx*4], cl
        neg ecx
        add ecx, 32
        or [arr + ebx*4], edi
        mov edi, esi
    inc ebx
    cmp ebx, [n]
    jl .L2_i
    
    or [arr], edi
    
.PRINT:
    xor ebx, ebx
    .L3_i:
        mov eax, [arr + ebx*4]
        call io_print_udec
        mov eax, ' '
        call io_print_char
    inc ebx
    cmp ebx, [n]
    jl .L3_i
    
    mov eax, `\n`
    call io_print_char

.EXIT:
    leave
    xor eax, eax
    ret
