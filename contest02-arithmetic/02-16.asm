extern io_get_dec, io_print_dec, io_print_char

section .bss
    a11: resd 1
    a12: resd 1
    a21: resd 1
    a22: resd 1
    b1: resd 1
    b2: resd 1
    c: resd 1
    d: resd 1
    det: resd 1
    x: resd 1
    y: resd 1

section .text
global main
main:
    call io_get_dec
    mov [a11], eax
    call io_get_dec
    mov [a12], eax
    call io_get_dec
    mov [a21], eax
    call io_get_dec
    mov [a22], eax
    call io_get_dec
    mov [b1], eax
    call io_get_dec
    mov [b2], eax
    
    mov eax, [a22] 
    and eax, [b1]
    mov ebx, [a12]
    and ebx, [b2]
    xor eax, ebx
    mov [c], eax
    
    mov eax, [a11] 
    and eax, [b2]
    mov ebx, [a21]
    and ebx, [b1]
    xor eax, ebx
    mov [d], eax
    
    mov eax, [a11] 
    and eax, [a22]
    mov ebx, [a12]
    and ebx, [a21]
    xor eax, ebx
    mov [det], eax
    
    mov ebx, [det]
    not ebx
    
    mov eax, [a11]
    and eax, [b1]
    and eax, ebx
    or [x], eax
    
    mov eax, [a11]
    not eax
    and eax, [a12]
    and eax, [b1]
    and eax, ebx
    or [y], eax
    
    mov eax, [a21]
    and eax, [b2]
    and eax, ebx
    or [x], eax
    
    mov eax, [a21]
    not eax
    and eax, [a22]
    and eax, [b2]
    and eax, ebx
    or [y], eax
    
    mov eax, [c]
    and eax, [det]
    or [x], eax
    
    mov eax, [d]
    and eax, [det]
    or [y], eax
    
    mov eax, [x]
    call io_print_dec
    mov eax, ' '
    call io_print_char
    mov eax, [y]
    call io_print_dec
    
    mov eax, 0
    ret
