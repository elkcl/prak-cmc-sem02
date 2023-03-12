extern io_get_udec, io_print_udec

section .text
global main
main:
    enter 0, 0
    
    call io_get_udec
    call io_get_udec
    
    mov eax, 1
    cpuid
    mov edx, 1
    shl edx, 23
    and ecx, edx
    test ecx, ecx
    jz .LOOP
    jmp .EXIT
.LOOP:
    jmp .LOOP
.EXIT:
    mov eax, 1
    call io_print_udec
    
    leave
    xor eax, eax
    ret
