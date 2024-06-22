global validarMovimientoEstaDentroDelTablero
global validarOpcionMovimientoEsValido

%macro mPrintf 1
    mov     rdi,%1
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

extern printf


section .data

    msjMovimientoValido     db "El movimiento ingresado fue valido",10,0
    msjMovimientoInvalido   db "El movimiento ingresado fue invalido",10,0
    msjPosicionInvalida     db "La posicion del zorro es invalida",10,0

section .bss
    posicionDelZorro            resq 1
    desplazamientoVertical      resq 1
    desplazamientoHorizontal    resq 1
    filaZorro                   resq 1
    colZorro                    resq 1


section .text
validarMovimientoEstaDentroDelTablero:
;Funcion que verifica si se puede o no se puede hacer ese movieminto
    mov         qword[posicionDelZorro],rdi; es la posicion relativa
    mov         qword[desplazamientoHorizontal],rsi
    mov         qword[desplazamientoVertical],rcx


    ;calcular columna del zorro - Asumo posicion mayor o igual a 0
    mov         rax, qword[posicionDelZorro]
    cmp         rax,7
    jl          fila1
    
    cmp         rax,14
    jl          fila2

    cmp         rax,21
    jl          fila3

    cmp         rax,28
    jl          fila4

    cmp         rax,35
    jl          fila5

    cmp         rax,42
    jl          fila6

    cmp         rax,49
    jl          fila7

    jmp         posicionInvalida

    fila1:
        mov     qword[filaZorro],0
        jmp     verificarMovimiento
    
    fila2:
        mov     qword[filaZorro],1
        jmp     verificarMovimiento

    fila3:
        mov     qword[filaZorro],2
        jmp     verificarMovimiento

    fila4:
        mov     qword[filaZorro],3
        jmp     verificarMovimiento

    fila5:
        mov     qword[filaZorro],4
        jmp     verificarMovimiento

    fila6:
        mov     qword[filaZorro],5
        jmp     verificarMovimiento

    fila7:
        mov     qword[filaZorro],6
        jmp     verificarMovimiento

    verificarMovimiento:
        mov     rbx,qword[filaZorro]
        imul    rbx,7
        sub     rax,rbx
        mov     qword[colZorro],rax

        ;verificacion del desplazamiento de la columna
        mov     rax,qword[colZorro]
        mov     rbx,qword[desplazamientoHorizontal]
        add     rax,rbx

        cmp     rax,6
        jg      movimientoInvalido

        cmp     rax,0
        jl      movimientoInvalido

        ;verificacion del desplazamiento de la fila
        mov     rax,qword[filaZorro]
        mov     rbx,qword[desplazamientoVertical]
        add     rax,rbx

        cmp     rax,6
        jg      movimientoInvalido

        cmp     rax,0
        jl      movimientoInvalido

        jmp     movimientoValido

    movimientoInvalido:
        
        mPrintf msjMovimientoInvalido

        mov     rax,-1
        ret

    movimientoValido:

        mPrintf msjMovimientoValido

        mov     rax,1
        ret

    posicionInvalida:
        mPrintf msjPosicionInvalida

        mov     rax,0
        ret

validarOpcionMovimientoEsValido: ; Parametros: dil -> opcion elegida
                         ;             sil -> 0 si es oca, 1 si es zorro    
                         ; Devuelve en al 0 si es valido y -1 si no

    sub dil, '0'

    mov al, 0
    mov dl, 4 ; Valor para la oca

    cmp sil, 0
    je validarOpcionMovimientoEsEnRango

    mov dl, 8 ; Valor para el zorro

    validarOpcionMovimientoEsEnRango:

        cmp dil, dl
        jg validarOpcionMovimientoEsValidoResultadoInvalido

        cmp dil, 1
        jl validarOpcionMovimientoEsValidoResultadoInvalido

        ret ; Opcion valida

    validarOpcionMovimientoEsValidoResultadoInvalido:
        mov al, -1
    
    ret ; Opcion invalida

