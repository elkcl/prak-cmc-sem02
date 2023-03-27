extern io_get_udec, io_print_char, io_newline

section .bss
    n1: resd 1
    n2: resd 1
    n3: resd 1

section .text
global main
main:
    enter 0, 0
    call io_get_udec
    mov ebx, eax
    call io_get_udec
    mul ebx
    mov [n1], edx
    mov [n3], eax
    call io_get_udec
    mov ecx, eax
    mov eax, [n3]
    mul ecx
    mov [n2], edx
    mov [n3], eax
    mov eax, [n1]
    mul ecx
    add eax, [n2]
    adc edx, 0
    mov [n1], edx
    mov [n2], eax

    push dword [n3]
    push dword [n2]
    push dword [n1]
    call print3
    add esp, 12
    call io_newline

    xor eax, eax
    leave
    ret

; n1: u32 (ebp + 8)
; n2: u32 (ebp + 12)
; n3: u32 (ebp + 16)
; -> void
print3:
    enter 0, 0
    sub esp, 16
    ; new1: u32 (ebp - 16)
    ; new2: u32 (ebp - 12)
    ; new3: u32 (ebp - 8)
    ; rest: u32 (ebp - 4)
    
    cmp dword [ebp + 8], 0
    jne .CONT
    cmp dword [ebp + 12], 0
    jne .CONT
    cmp dword [ebp + 16], 0
    je .EXIT

.CONT:
    mov ecx, 10
    xor edx, edx
    mov eax, [ebp + 8]
    div ecx
    mov [ebp - 16], eax
    mov eax, [ebp + 12]
    div ecx
    mov [ebp - 12], eax
    mov eax, [ebp + 16]
    div ecx
    mov [ebp - 8], eax
    mov [ebp - 4], edx
    call print3
    mov eax, [ebp - 4]
    add eax, '0'
    call io_print_char

.EXIT:
    add esp, 16
    leave
    ret
