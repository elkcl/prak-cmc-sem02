extern scanf, printf, realloc, free, memcpy

section .rodata
    ifmt: db "%d ", 0
    ofmt: db `%d\n`, 0
    
section .bss
    n: resd 1
    curr_k: resd 1
    curr_mat: resd 1
    curr_tr: resq 1
    ans_k: resd 1
    ans_mat: resd 1
    ans_tr: resq 1
    
section .text
global main
main:
    enter 8, 0
    mov dword [esp], ifmt
    mov dword [esp+4], n
    call scanf
    
    xor ebx, ebx
    .L1:
    cmp ebx, [n]
    jnl .L1_EXIT
        mov dword [esp], ifmt
        mov dword [esp+4], curr_k
        call scanf
        mov edi, [curr_k]
        imul edi, edi
        shl edi, 2
        mov dword [esp], curr_mat
        mov [esp+4], edi
        call realloc
        mov [curr_tr], 0
        
        xor esi, esi
        .L2:
        cmp esi, edi
        jnl .L2_EXIT
            mov dword [esp], ifmt
            lea eax, [esi + curr_mat]
            mov [esp+4], eax
            call scanf
            
            mov eax, esi
            shr eax, 2
            lea edx, [curr_k + 1]
            div edx
            test edx, edx
            jnz .CONT2
            mov eax, [esi + curr_mat]
            add [curr_tr], eax
            .CONT2:
        add esi, 4
        jmp .L2
        .L2_EXIT:
        
        cmp [ans_mat], 0
        je .COPY
        mov eax, [curr_tr]
        cmp eax, [ans_tr]
        
        jmp .CONT1
        .COPY:
        
        .CONT1:
    inc ebx
    jmp .L1
    .L1_EXIT:
    
    mov dword [esp], curr_mat
    call free
    mov dword [esp+4], ans_mat
    call free
    
    xor eax, eax
    leave
    ret