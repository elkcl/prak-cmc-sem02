extern io_get_dec, io_print_dec

section .text
global main
main:
    call io_get_dec
    mov ebx, eax
    call io_get_dec
    mul ebx
    mov ebx, eax
    call io_get_dec
    mul ebx
    mov ebx, eax
    call io_get_dec
    xchg eax, ebx
    mov edx, 0
    div ebx
    sub edx, 1
    sar edx, 31
    add edx, 1
    add eax, edx
    mov ebx, eax
    call io_get_dec
    mov esi, 60
    mul esi
    mov esi, eax
    call io_get_dec
    add esi, eax
    sub esi, 360
    sar esi, 31
    add esi, 1
    mov eax, ebx
    mov ecx, 3
    mov edx, 0
    div ecx
    sub edx, 1
    sar edx, 31
    add edx, 1
    add eax, edx
    mul esi
    sub ebx, eax
    mov eax, ebx
    call io_print_dec
    
    mov eax, 0
    ret
