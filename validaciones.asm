global validarMovimientoEstaDentroDelTablero
global validarOpcionMovimientoEsValido
global validarFinDePartida

%macro mPrintf 1
    mov     rdi,%1
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro
%macro mPrintf 2
    mov     rdi,%1
    mov     rsi,%2
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro
%macro mPrintf 3
    mov     rdi,%1
    mov     rsi,%2
    mov     rdx,%3
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro
extern printf

extern buscarZorroEnTablero
section .data

    msjMovimientoValido     db "El movimiento ingresado fue valido",10,0
    msjMovimientoInvalido   db "El movimiento ingresado fue invalido",10,0
    msjPosicionInvalida     db "La posicion del zorro es invalida",10,0
    msjDesplazamientoSimulacionN     db "%hhi, %hhi: movimiento valido",10,0
    msjDesplazamientoSimulacionNV     db "%hhi, %hhi: movimiento invalido",10,0
    msjDesplazamientoSimulacionNV2     db "%hhi, %hhi: moviasdmiento invalido",10,0
    formatoNumero db "N: %li",10,0
section .bss
    dirVec resq 1
    auxilarPosicion            resq 1
    desplazamientoVertical      resq 1
    desplazamientoHorizontal    resq 1
    auxDesplazamientoVertical      resb 1
    auxDesplazamientoHorizontal    resb 1
    auxiliarFila                   resq 1
    auxiliarColumna                    resq 1
    auxiliarProximaCelda resq 1
    posicionZorro   resq 1
    contadorMovimientosValidos resq 1

section .text
validarMovimientoEstaDentroDelTablero:
;Funcion que verifica si se puede o no se puede hacer ese movieminto
    mov         qword[auxilarPosicion],rdi; es la posicion relativa
    mov         qword[desplazamientoHorizontal],rsi
    mov         qword[desplazamientoVertical],rdx


    ;calcular columna de la pieza - Asumo posicion mayor o igual a 0
    mov         rax, qword[auxilarPosicion]
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
        mov     qword[auxiliarFila],0
        jmp     verificarMovimiento
    
    fila2:
        mov     qword[auxiliarFila],1
        jmp     verificarMovimiento

    fila3:
        mov     qword[auxiliarFila],2
        jmp     verificarMovimiento

    fila4:
        mov     qword[auxiliarFila],3
        jmp     verificarMovimiento

    fila5:
        mov     qword[auxiliarFila],4
        jmp     verificarMovimiento

    fila6:
        mov     qword[auxiliarFila],5
        jmp     verificarMovimiento

    fila7:
        mov     qword[auxiliarFila],6
        jmp     verificarMovimiento

    verificarMovimiento:
        mov     rbx,qword[auxiliarFila]
        imul    rbx,7
        sub     rax,rbx
        mov     qword[auxiliarColumna],rax

        ;verificacion del desplazamiento de la columna
        mov     rax,qword[auxiliarColumna]
        mov     rbx,qword[desplazamientoHorizontal]
        add     rax,rbx

        cmp     rax,6
        jg      movimientoInvalido

        cmp     rax,0
        jl      movimientoInvalido

        ;verificacion del desplazamiento de la fila
        mov     rax,qword[auxiliarFila]
        mov     rbx,qword[desplazamientoVertical]
        add     rax,rbx

        cmp     rax,6
        jg      movimientoInvalido

        cmp     rax,0
        jl      movimientoInvalido

        jmp     movimientoValido

    movimientoInvalido:
        mov     rax,-1
        ret

    movimientoValido:
        mov     rax,1
        ret

    posicionInvalida:
        mov     rax,0
        ret

;Valida si el input ingresado por el usuario es una de las opciones disponibles. 1-4 para la oca, 1-8 para el zorro
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

validarFinDePartida:    ;Parametros: rdi-direccionTablero
    mov [dirVec], rdi
    mov rax, rdi    
    mov rsi, 0      ;Indice
    mov rcx, 0      ;Contador de ocas

    loopTablero:
        cmp rsi, 49
        je finLoop

        mov rbx, rax
        add rbx, rsi

        cmp byte[rbx], 'O'
        jne siguienteCelda
        inc rcx

    siguienteCelda:    
        inc rsi
        jmp loopTablero

    finLoop:
        cmp rcx, 5
        jg verificarGanadorOca
        mov rax, 1
        ret

    verificarGanadorOca:
        mov rdi, qword[dirVec]

        sub     rsp,8
        call        buscarZorroEnTablero
        add     rsp,8   

        mov [posicionZorro], rax


        mov byte[auxDesplazamientoHorizontal],-1
        mov qword[contadorMovimientosValidos], 0
        
        verificarGanadorOcaLoopE:
            cmp byte[auxDesplazamientoHorizontal], 2; Verifico condicion de corte del loop externo
            je verificarGanadorOcaFinLoop

            mov byte[auxDesplazamientoVertical],-1 ;reseteo indice de columna e incremento el de fila

        verificarGanadorOcaLoopI: 
            cmp byte[auxDesplazamientoVertical], 2; Verifico condicion de corte del loop interno
            je verificarGanadorOcaLoopIAvanzar;  ;avanzo en el loop externo       
            
            mov rdi, [dirVec]
            mov rsi, [posicionZorro]

            sub     rsp,8
            call        contarMovimientoDelZorro
            add     rsp,8   

            add [contadorMovimientosValidos], rax

            inc byte[auxDesplazamientoVertical]
            jmp verificarGanadorOcaLoopI ;avanzo en el loop interno

        verificarGanadorOcaLoopIAvanzar:
            inc byte[auxDesplazamientoHorizontal]
            jmp verificarGanadorOcaLoopE

        verificarGanadorOcaFinLoop:
            mPrintf formatoNumero, [contadorMovimientosValidos]
            cmp qword[contadorMovimientosValidos], 2 ; Cantidad de movimientos posibles debe ser igual o mayor a 2 (incluye quedarse en el lugar)
            jl ganadorOcas
            
            mov rax, 0
            ret

        ganadorOcas:
            mov rax, -1
            
            ret


contarMovimientoDelZorro: ; Parametros: rdi -> direccion tablero
                            ;             rsi -> direccion zorro
                            ;             dl -> mov horizontal
                            ;             dh _> mov vertical
                            ; Devuelve:
                            ; 0 si no es valido
                            ; 1 si si

        mov qword[dirVec], rdi
        mov qword[posicionZorro], rsi

        mov     rax, [posicionZorro]          
        sub     rax, [dirVec] 
        mov     rdi, rax
        movsx   rsi,  byte[auxDesplazamientoHorizontal]
        movsx   rdx, byte[auxDesplazamientoVertical]

        sub     rsp,8
        call        validarMovimientoEstaDentroDelTablero
        add     rsp,8

        cmp rax, 1
        jne impimirMovInvalido

        mov       rax, [posicionZorro]
        movsx     rcx, byte[auxDesplazamientoHorizontal]
        movsx     rdx, byte[auxDesplazamientoVertical]
        imul    rdx, 7           ;Desplazamiento filas

        verificarSiHayOca:
            mov     r8, rax                         ;Copio la posicion del zorro
            add     r8, rdx                         ;Sumo desplazamiento filas
            add     r8, rcx                         ;Sumo desplazamiento columnas

            cmp     byte[r8], 'X'
            je      impimirMovInvalido

            cmp     byte[r8], 'O'
            je      validarSiguienteCelda
            
            jmp impimirMovValido


        validarSiguienteCelda:
            mov     [auxiliarProximaCelda], r8
            mov     rax, r8         
            sub     rax, [dirVec] 
            mov     rdi, rax
            movsx   rsi, byte[auxDesplazamientoHorizontal]
            movsx   rdx, byte[auxDesplazamientoVertical]

            sub     rsp,8
            call        validarMovimientoEstaDentroDelTablero
            add     rsp,8

            cmp rax, 1
            jne impimirMovInvalido

            mov       r9, [auxiliarProximaCelda]
            movsx     rcx, byte[auxDesplazamientoHorizontal]
            movsx     rdx, byte[auxDesplazamientoVertical]

            imul    rdx, 7  
            add     r9, rdx
            add     r9, rcx

            cmp     byte[r9], ' '
            jne    impimirMovInvalido
            jmp impimirMovValido

        impimirMovInvalido:
            mov rax, 0
            ret
        impimirMovValido:
            mov rax, 1
        ret