%macro mPrintf 1
    mov     rdi,%1
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

%macro mPrintf 2
    mov     rdi,%1
    mov     rsi, %2
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

%macro mGets 1
    mov     rdi,%1
    sub     rsp,8
    call    gets
    add     rsp,8
%endmacro

; Recibe un string por parametro y devuelve en rax el largo del string.
%macro mStrlen 1
    mov     rdi, %1
    sub     rsp, 8
    call    strlen
    add     rsp,8
%endmacro

%macro mImprimirTablero 1
    mov     rdi, %1
    sub     rsp, 8
    call    imprimirTablero
    add     rsp,8
%endmacro

%macro mValidarFinDePartida 1
    mov     rdi, %1
    sub     rsp, 8
    call    validarFinDePartida
    add     rsp,8
%endmacro

global main

;funciones externas de C
extern printf
extern gets
extern strlen

extern imprimirTablero
extern buscarZorroEnTablero
extern realizarMovimientoDelZorro
extern realizarMovimientoDeOca
extern validarMovimientoEstaDentroDelTablero

extern validarOpcionMovimientoEsValido

extern obtenerDireccionDeMovimiento

extern guardarPartida
extern cargarPartida
extern validarFinDePartida

section .data

    ;Logica del juego
;    MatrizTablero db "XXOOOXX"
;     f1         db   "XXOOOXX"
;     f2         db   "OOOOOOO"
;     f3         db   "O     O"
;     f4         db   "O  Z  O"
;     f5         db   "XX   XX"
;     f6         db   "XX   XX"

    MatrizTablero db "XX   XX"
     f1         db   "XX   XX"
     f2         db   "       "
     f3         db   "O     O"
     f4         db   "O  Z  O"
     f5         db   "XX   XX"
     f6         db   "XX   XX"

    ;Mensajes
    msjInicioDelJuego           db "--EL ZORRO Y LAS OCAS",10,10,"Elija una opcion para jugar",10,"1 - Nueva Partida",10, "2 - Cargar Partida",10, "3 - Salir del juego",10,10,0
    msjComienzoNuevaPartida     db "Usted ha comenzado una nueva partida.",10,0
    msjSalidaDelJuego           db "Saliendo del juego.",10,0
    msgNoExistePartida          db "No se encontro una partida guardada. Comenzando nueva partida...",10,0

    msjErrorDeValidacion        db "No se pudo validar ninguna de las opciones",10,0

    msjTurnoZorro               db "<========== Turno zorro. ==========>",10,0
    msjMovimientosZorro         db "1. arriba", 10, "2. arriba derecha", 10, "3. derecha", 10, "4. abajo derecha", 10, "5. abajo", 10 
                                db "6. abajo izquierda", 10, "7. izquierda", 10, "8. arriba izquierda", 10, "G. Guardar partida", 10, "S. Salir del juego", 10,10 ,0

    msjTurnoOca                 db "<========== Turno Oca ==========>", 10,0
    msjMovimientosOca           db "1. derecha", 10, "2. abajo", 10, "3. izquierda",10, "4. Elegir otra oca",10, "S. Salir del juego",10,0
    msjPedirCoordenadaOca       db "Ingresa coordenada de la OCA a mover. 'G' para guardar la partida, 'S' para salir: ",0
    msjPedirOpcion              db "Elija una opcion: ", 0

    msjCoordenadaInvalida   db "Coordenada invalida.",10,0
    msjOpcionInvalida   db "Opcion invalida.",10,0
    msjMovimientoInvalido   db 10, "Movimiento invalido!!!", 10, 0
    msjOcaComida            db "Oca comida! Tienes otro turno!", 10 ,0
    ;opciones de la partida
    opcionNuevaPartida  db "1",0
    opcionCargarPartida  db "2",0
    opcionSalirJuego    db "3",0

    opcionSalirJuego2   db "S",0
    opcionSalirJuego3   db "s",0
    opcionGuardarPartida   db "G",0

    msgPartidaGuardadaCorrectamente db "Partida guardada correctamente. Puede restaurarla desde el menu principal",10,0

    msjGanadorZorro     db "GANADOR: ZORRO! ^•ﻌ•^ ",10,0
    msjGanadorOcas     db "GANADOR  OCAS ( •ө• ) ( •ө• ) ( •ө• )!",10,0


    turnoActual         db "Z"

section .bss
    auxIngreso  resb 20 ;Guarda el ultimo ingreso por teclado
    auxValidacion   resb 1 ;auxiliar en las opciones de validacion
    filaZorro       resb 1
    columnaZorro    resb 1
    coordenadaOca resb 3 ; Antes de copiar aca me aseguro que el formato este bien
    posicionZorro resq 1;

    auxDesplazamientoVertical resb 1
    auxDesplazamientoHorizontal resb 1

section .text
main:
    mPrintf     msjInicioDelJuego

    mGets       auxIngreso

    jmp         validarIngreso


    



ret

validarIngreso:

    mov     al,[auxIngreso]
    mov     [auxValidacion],al

    mov     al,[opcionNuevaPartida]
    cmp     al,[auxValidacion]
    je      comienzoNuevaPartida

    mov     al,[opcionCargarPartida]
    cmp     al,[auxValidacion]
    je      cargar

    mov     al,[opcionSalirJuego]
    cmp     al,[auxValidacion]
    je      salirDelJuego

    mPrintf msjErrorDeValidacion

    ret

cargar:
    mov rdi, MatrizTablero
    sub rsp, 8
    call cargarPartida
    add rsp, 8

    cmp rax, -1
    jne principioLoop

    mPrintf msgNoExistePartida
    jmp principioLoop

salirDelJuego:
    mPrintf     msjSalidaDelJuego
    ret

comienzoNuevaPartida:
    mPrintf     msjComienzoNuevaPartida

principioLoop:
    mImprimirTablero MatrizTablero

    mValidarFinDePartida    MatrizTablero
    cmp rax, 0
    jne  finDelJuego

    ;Si el turno actual es de la OCA, salta a preguntarPorMovimientoAOca
    mov al, [turnoActual]
    cmp al, 'O'
    je preguntarPorCoordenadaOca

    preguntarPorMovimientoAlZorro:
        mPrintf msjTurnoZorro
        mPrintf msjMovimientosZorro
        mPrintf msjPedirOpcion

        mGets auxIngreso
        mov     al, [auxIngreso]
        mov     [auxValidacion],al

        ; Si el input es 'S', salgo del juego
        mov     al,[opcionSalirJuego2]
        cmp     al,[auxValidacion]
        je      salirDelJuego

        ; Si el input es 's', salgo del juego
        mov     al,[opcionSalirJuego3]
        cmp     al,[auxValidacion]
        je      salirDelJuego
        
        mov     dil,[auxValidacion] 
        sub     rsp,8
        call    verificarSiGuardarPartida
        add     rsp,8

    validarOpcion:
        mov     dil,[auxValidacion]
        mov     sil, 1 ; 1 = zorro

        sub     rsp,8
        call        validarOpcionMovimientoEsValido
        add     rsp,8

        cmp al, -1
        je preguntarPorMovimientoAlZorro 

    obtenerDireccion:
        mov     dil,[auxValidacion]
        mov     sil, 1 ; 1 = zorro

        sub     rsp,8
        call        obtenerDireccionDeMovimiento
        add     rsp,8

        mov [auxDesplazamientoHorizontal], al
        mov [auxDesplazamientoVertical], ah

    validarMovimientoEsValido:
        mov     rdi, MatrizTablero

        sub     rsp,8
        call        buscarZorroEnTablero
        add     rsp,8        

        mov [posicionZorro], rax

        sub     rax, MatrizTablero 
        mov     rdi, rax
        movsx   rsi, byte[auxDesplazamientoHorizontal]
        movsx   rdx, byte[auxDesplazamientoVertical]

        sub     rsp,8
        call        validarMovimientoEstaDentroDelTablero
        add     rsp,8        

        cmp rax, 1
        jne movimientoInvalido

    computarMovimiento:
        mov     rdi, MatrizTablero
        mov     rsi, [posicionZorro]
        mov     dl, [auxDesplazamientoHorizontal]
        mov     dh, [auxDesplazamientoVertical]

        sub     rsp,8
        call        realizarMovimientoDelZorro
        add     rsp,8

        cmp     rax, -1
        je      movimientoInvalido

        cmp     rax,1
        je      ocaComida
        

    mov byte[turnoActual], 'O' ;Si termina el turno del zorro, cambio el turno a la Oca
    jmp finTurno
    
    ocaComida:
        mPrintf msjOcaComida

    finTurno:
    jmp principioLoop


    preguntarPorCoordenadaOca:
        mPrintf msjTurnoOca
        mPrintf msjPedirCoordenadaOca

        mGets auxIngreso
        mov     al, [auxIngreso]
        mov     [auxValidacion],al

        ; Si el input es 'S', salgo del juego
        mov     al,[opcionSalirJuego2]
        cmp     al,[auxValidacion]
        je      salirDelJuego

        ; Si el input es 's', salgo del juego
        mov     al,[opcionSalirJuego3]
        cmp     al,[auxValidacion]
        je      salirDelJuego

        mov     dil,[auxValidacion] 
        sub     rsp,8
        call    verificarSiGuardarPartida
        add     rsp,8

        validarCoordenadaOca:
            mStrlen auxIngreso              ;Valido que el input sea 2 caracteres
            cmp     rax, 2
            jne     coordenadaInvalida

            mov rcx, 3
            lea rsi, [auxIngreso]
            lea rdi, [coordenadaOca]
        rep movsb

            jmp preguntarPorMovimientoAOca

        ;Validar que haya una oca, en la coordenada ingresada.

        coordenadaInvalida:
            mPrintf msjCoordenadaInvalida
            jmp     preguntarPorCoordenadaOca

    preguntarPorMovimientoAOca:
        mPrintf msjTurnoOca
        mPrintf msjMovimientosOca
        mPrintf msjPedirOpcion

        mGets auxIngreso
        mov     al, [auxIngreso]
        mov     [auxValidacion],al

        cmp     al, '4'
        je      preguntarPorCoordenadaOca

        ; Si el input es 'S', salgo del juego
        mov     al,[opcionSalirJuego2]
        cmp     al,[auxValidacion]
        je      salirDelJuego

        ; Si el input es 's', salgo del juego
        mov     al,[opcionSalirJuego3]
        cmp     al,[auxValidacion]
        je      salirDelJuego

    validarOpcionOca:

        mov     dil,[auxValidacion]
        mov     sil, 0

        sub     rsp,8
        call        validarOpcionMovimientoEsValido
        add     rsp,8

        cmp al, -1
        je preguntarPorMovimientoAOca 

        mov     dil,[auxValidacion]
        mov     sil, 0 ; 0 = oca

        sub     rsp,8
        call        obtenerDireccionDeMovimiento
        add     rsp,8


    computarMovimientoOca: 


    mov     rdi, MatrizTablero
    mov     rsi, coordenadaOca
    mov     dl, al
     
    sub     rsp,8
    call        realizarMovimientoDeOca
    add     rsp,8

    cmp     rax, -1
    je      movimientoInvalido

    mov byte[turnoActual], 'Z'      ;Cuando termina el turno de la Oca, cambia el turno al zorro.

    jmp principioLoop

calcularPosicionZorro:
    ret

movimientoInvalido:
    mPrintf msjMovimientoInvalido
    jmp principioLoop

ret

validarMovimientoDeOca:
    
    ret

verificarSiGuardarPartida:
    
    ; Si el input es 'G'o 'g', guardo la partida
    mov     al,[opcionGuardarPartida]
    cmp     al, dil
    je      guardar
    
    add     al, 32
    cmp     al, dil
    je      guardar

    ret
guardar:
    mov rdi, MatrizTablero

    sub     rsp,8
    call    guardarPartida
    add     rsp,8

    cmp rax, 0
    je guardadoCorrectamente
    ret
guardadoCorrectamente:
    mPrintf msgPartidaGuardadaCorrectamente
    ret
finDelJuego:
    cmp rax, 1
    je ganadorZorro
    cmp rax, -1
    je ganadorOcas
    
    ret

ganadorZorro:
    mPrintf msjGanadorZorro
    ret
ganadorOcas:
    mPrintf msjGanadorOcas
    ret
