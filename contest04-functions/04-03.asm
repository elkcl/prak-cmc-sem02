extern io_get_dec, io_print_dec, io_print_char, io_newline

section .text
global main
main:
    enter 0, 0
    call reverse
    call io_newline
    leave
    xor eax, eax
    ret

reverse:
    enter 0, 0
    call io_get_dec
    test eax, eax
    jz .EXIT
    push eax
    call reverse
    pop eax
    call io_print_dec
    mov eax, ' '
    call io_print_char
.EXIT:    
    leave
    ret
