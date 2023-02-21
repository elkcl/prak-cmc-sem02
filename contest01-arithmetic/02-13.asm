extern io_get_char, io_print_dec

section .bss
    x1: resd 1
    y1: resd 1
    x2: resd 1
    y2: resd 1

section .text
global main
main:
    call io_get_char
    mov dword [x1], eax
    call io_get_char
    mov dword [y1], eax
    call io_get_char
    call io_get_char
    mov dword [x2], eax
    call io_get_char
    mov dword [y2], eax
    
    mov eax, dword [x1]
    sub eax, dword [x2]
    mov ebx, eax
    sar ebx, 31
    imul ebx, 2
    add ebx, 1
    imul eax, ebx
    mov ecx, eax
    mov eax, dword [y1]
    sub eax, dword [y2]
    mov ebx, eax
    sar ebx, 31
    imul ebx, 2
    add ebx, 1
    imul eax, ebx
    add eax, ecx
    call io_print_dec
    
    mov eax, 0
    ret
