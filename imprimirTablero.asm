global imprimirTablero

extern printf

%macro mPrintf 1
    mov     rdi,%1
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

%macro mPrintf 2
    mov     rdi, %1
    mov     rsi, %2
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

%macro mPrintf 3
    mov     rdi, %1
    mov     rsi, %2
    mov     rdx, %3
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

section .data
    tablero     db -1, -1, 1, 1, 1, -1, -1
                db -1, -1, 1, 1, 1, -1, -1
                db  1,  1, 1, 1, 1,  1,  1
                db  1,  0, 0, 0, 0,  0,  1
                db  1,  0, 0, 2, 0,  0,  1
                db -1, -1, 0, 0, 0, -1, -1
                db -1, -1, 0, 0, 0, -1, -1

    CANT_FILAS      equ 7
    CANT_COLUMNAS   equ 7
    msjLinea        db "|---+---+---+---+---+---+---|", 10,13,0
    msjElemento     db "| %c ", 0
    newLine         db "|", 10, 13, 0
    
section .bss
    dirTablero      resq 1
    filaActual      resq 1
    columnaActual   resq 1

section .text

imprimirTablero:
    mov qword[dirTablero], rdi
    mov qword [filaActual], 0
    jmp loopFila

loopFila:
    jmp imprimirFila

imprimirFila:
    cmp qword [filaActual], CANT_FILAS
    je finProg
    mov qword [columnaActual], 0
    jmp loopImprimirColumna
    
loopImprimirColumna:
    cmp qword [columnaActual], CANT_COLUMNAS
    je imprimirSiguienteFila

    ; Calculate the offset for the current element
    mov rax, qword [filaActual]
    imul rax, CANT_COLUMNAS
    add rax, qword [columnaActual]
    movsx rbx, byte [tablero + rax]

    ; Determine the character to print based on the element value
    cmp rbx, -1
    je printPlus
    cmp rbx, 0
    je printSpace
    cmp rbx, 1
    je printO
    cmp rbx, 2
    je printX

    jmp continueLoop

printPlus:
    mov rdi, msjElemento
    mov rsi, '+'
    mPrintf rdi, rsi
    jmp continueLoop

printSpace:
    mov rdi, msjElemento
    mov rsi, ' '
    mPrintf rdi, rsi
    jmp continueLoop

printO:
    mov rdi, msjElemento
    mov rsi, 'O'
    mPrintf rdi, rsi
    jmp continueLoop

printX:
    mov rdi, msjElemento
    mov rsi, 'X'
    mPrintf rdi, rsi
    jmp continueLoop

continueLoop:
    inc qword [columnaActual]
    jmp loopImprimirColumna

imprimirSiguienteFila:
    mPrintf newLine
    mPrintf msjLinea
    inc qword [filaActual]
    jmp loopFila
    
finProg:
    ret
