extern io_get_dec, io_print_dec, io_print_char

section .bss
    n: resd 1
    m: resd 1
    M: resd 1
    min: resd 250001
    max: resd 250001

section .text
global main
main:
    push ebp
    mov ebp, esp
    call io_get_dec
    mov [n], eax
    mov ecx, eax  ; ecx = N
    jecxz .PRINT_MIN
    sub ecx, 1
    jecxz .PRINT_MIN
    sub ecx, 1   
    jecxz .PRINT_MIN   ; выход при N <= 2
    ; edi, esi, ebx - три подряд
    push ecx
    call io_get_dec
    mov edi, eax
    call io_get_dec
    mov esi, eax
    mov ecx, 2    ; ecx = i, i = 0..n-1
.L1:
    push ecx
    call io_get_dec
    pop ecx
    mov ebx, eax
    cmp esi, edi
    setl al
    setg ah
    cmp esi, ebx
    setl dl
    setg dh
    and dl, al
    and dh, ah
    mov eax, [m]
    mov [min + eax*4], ecx
    mov eax, [M]
    mov [max + eax*4], ecx
    movzx eax, dl
    add [m], eax
    movzx eax, dh
    add [M], eax
    mov edi, esi
    mov esi, ebx
    inc ecx
    cmp ecx, [n]
    jl .L1
.PRINT_MIN:
    mov eax, [m]
    call io_print_dec
    mov eax, `\n`
    call io_print_char
    mov ecx, [m]
    jecxz .PRINT_MAX
    xor ecx, ecx
.L2:
    mov eax, [min + ecx*4]
    dec eax
    push ecx
    call io_print_dec
    mov eax, ' '
    call io_print_char
    pop ecx
    inc ecx
    cmp ecx, [m]
    jl .L2
    mov eax, `\n`
    call io_print_char
.PRINT_MAX:
    mov eax, [M]
    call io_print_dec
    mov eax, `\n`
    call io_print_char
    mov ecx, [M]
    jecxz .EXIT
    xor ecx, ecx
.L3:
    mov eax, [max + ecx*4]
    dec eax
    push ecx
    call io_print_dec
    mov eax, ' '
    call io_print_char
    pop ecx
    inc ecx
    cmp ecx, [M]
    jl .L3
    mov eax, `\n`
    call io_print_char
.EXIT:
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret
