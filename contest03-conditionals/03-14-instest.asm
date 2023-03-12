extern io_get_udec, io_print_udec

section .text
global main
main:
    enter 0, 0
    
    call io_get_udec
    call io_get_udec
    
    mov ebx, 1
    bsr eax, ebx
    call io_print_udec
    
    leave
    xor eax, eax
    ret
