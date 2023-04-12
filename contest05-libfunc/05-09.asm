extern scanf, printf, putchar, realloc, free, memcpy

section .rodata
    ifmt: db "%d", 0
    ofmt: db "%d ", 0
    
section .bss
    n: resd 1
    curr_k: resd 1
    curr_mat: resd 1
    curr_tr: resd 2
    ans_k: resd 1
    ans_mat: resd 1
    ans_tr: resd 2
    
section .text
global main
main:
    enter 24, 0
    mov [esp+12], ebx
    mov [esp+16], esi
    mov [esp+20], edi

    mov dword [esp], ifmt
    mov dword [esp+4], n
    call scanf
    
    ; ebx — номер матрицы
    xor ebx, ebx
    .L1:
    cmp ebx, [n]
    jnl .L1_EXIT
        mov dword [esp], ifmt
        mov dword [esp+4], curr_k
        call scanf
        ; edi — размер массива curr_mat в байтах
        mov edi, [curr_k]
        imul edi, edi
        shl edi, 2
        mov eax, [curr_mat]
        mov dword [esp], eax
        mov [esp+4], edi
        call realloc
        mov [curr_mat], eax
        mov dword [curr_tr], 0
        mov dword [curr_tr+4], 0
        
        ; esi — адрес текущей клетки матрицы без сдвига curr_mat
        xor esi, esi
        .L2:
        cmp esi, edi
        jnl .L2_EXIT
            mov dword [esp], ifmt
            mov eax, [curr_mat]
            add eax, esi
            mov [esp+4], eax
            call scanf
            
            mov eax, esi
            shr eax, 2
            mov ecx, [curr_k]
            inc ecx
            xor edx, edx
            div ecx
            test edx, edx
            jnz .CONT2
            mov eax, [curr_mat]
            mov eax, [eax + esi]
            cdq
            add dword [curr_tr], eax
            adc dword [curr_tr+4], edx
            .CONT2:
        add esi, 4
        jmp .L2
        .L2_EXIT:
        
        cmp dword [ans_mat], 0
        je .COPY
        mov eax, dword [curr_tr]
        mov edx, dword [curr_tr+4]
        cmp edx, dword [ans_tr+4]
        jg .COPY
        cmp edx, dword [ans_tr+4]
        jl .CONT1
        cmp eax, dword [ans_tr]
        ja .COPY
        jmp .CONT1
        .COPY:
        mov eax, dword [curr_tr]
        mov edx, dword [curr_tr+4]
        mov dword [ans_tr], eax
        mov dword [ans_tr+4], edx
        mov eax, [curr_k]
        mov [ans_k], eax
        mov eax, [ans_mat]
        mov dword [esp], eax
        mov [esp+4], edi
        call realloc
        mov [ans_mat], eax
        mov eax, [ans_mat]
        mov dword [esp], eax
        mov eax, [curr_mat]
        mov dword [esp+4], eax
        mov [esp+8], edi
        call memcpy
        .CONT1:
    inc ebx
    jmp .L1
    .L1_EXIT:
    
    xor ebx, ebx
    .L3:
    cmp ebx, [ans_k]
    jnl .L3_EXIT
        mov edi, ebx
        imul edi, [ans_k]
        
        xor esi, esi
        .L4:
        cmp esi, [ans_k]
        jnl .L4_EXIT
            mov eax, [ans_mat]
            mov eax, [eax + edi*4]
            mov dword [esp], ofmt
            mov [esp+4], eax
            call printf
        inc edi
        inc esi
        jmp .L4
        .L4_EXIT:
        mov dword [esp], `\n`
        call putchar
    inc ebx
    jmp .L3
    .L3_EXIT:
    
    mov eax, [curr_mat]
    mov dword [esp], eax
    call free
    mov eax, [ans_mat]
    mov dword [esp], eax
    call free
    
    xor eax, eax
    mov ebx, [esp+12]
    mov esi, [esp+16]
    mov edi, [esp+20]
    leave
    ret
