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

global main

;funciones externas de C
extern printf
extern gets

extern imprimirTablero


section .data

    ;Logica del juego
    MatrizTablero db "XXOOOXX"
     f1         db   "XXOOOXX"
     f2         db   "OOOOOOO"
     f3         db   "O     O"
     f4         db   "O  Z  O"
     f5         db   "XX   XX"
     f6         db   "XX   XX"

    ;Mensajes
    msjInicioDelJuego           db "--EL ZORRO Y LAS OCAS",10,10,"Elija una opcion para jugar",10,"1 - Nueva Partida",10,"2 - Salir del juego",10,0
    msjComienzoNuevaPartida     db "Usted ha comenzado una nueva partida.",10,0
    msjSalidaDelJuego           db "Saliendo del juego.",10,0


    msjErrorDeValidacion        db "No se pudo validar ninguna de las opciones",10,0

    msjTurnoZorro               db "<========== Turno zorro. ==========>",10,0
    msjMovimientosZorro         db "1. arriba", 10, "2. arriba derecha", 10, "3. derecha", 10, "4. abajo derecha", 10, "5. abajo", 10, "6. abajo izquierda", 10, "7. izquierda", 10, "8. arriba izquierda", 10, "S. Salir del juego", 10 ,0

    msjTurnoOca                 db "<========== Turno Oca ==========>", 10,0
    msjMovimientosOca           db "1. derecha", 10, "2. abajo", 10, "3. izquierda", 10,"S. Salir del juego",10,0

    msjPedirOpcion              db "Elija una opcion: ", 0

    msjValidacion       db "Validacion mov", 10, 0
    msjJugadaIngresada  db "Jugada ingresada: %c", 10, 0

    ;opciones de la partida
    opcionNuevaPartida  db "1",0
    opcionSalirJuego    db "2",0

    opcionSalirJuego2   db "S",0
    opcionSalirJuego3   db "s",0

    turnoActual         db "Z"

section .bss
    auxIngreso  resb 20 ;Guarda el ultimo ingreso por teclado
    auxValidacion   resb 1 ;auxiliar en las opciones de validacion
    filaZorro       resb 1
    columnaZorro    resb 1

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

    mov     al,[opcionSalirJuego]
    cmp     al,[auxValidacion]
    je      salirDelJuego

    mPrintf msjErrorDeValidacion

    ret

salirDelJuego:
    mPrintf     msjSalidaDelJuego

    ; Aca habria que guardar el estado del juego
    ; Ej:
    ; call guardarEstado
    ret

comienzoNuevaPartida:
    mPrintf     msjComienzoNuevaPartida

principioLoop:
    mov     rdi, MatrizTablero
    sub     rsp,8
    call        imprimirTablero
    add     rsp,8

;    sub     rsp, 8
;    call    calcularPosicionZorro
;    add     rsp, 8

    ;Si el turno actual es de la OCA, salta a preguntarPorMovimientoAOca
    mov al, [turnoActual]
    cmp al, 'O'
    je preguntarPorMovimientoAOca

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

    computarMovimiento:
        sub rsp, 8
        call        validarMovimientoDelZorro ;Valida el movimiento del zorro, si es un movimiento invalido setea rax en -1.
        add rsp, 8

;    cmp         rax,-1                     ; Si el movimiento fue invalido, vuelvo a preguntar por movimiento
;    jmp     preguntarPorMovimientoAlZorro
    
    mov byte[turnoActual], 'O' ;Si termina el turno del zorro, cambio el turno a la Oca
    ;call        realizarMovimientoDelZorro

    ;call        verificaCondicionDeFinDePartida

    jmp principioLoop


    preguntarPorMovimientoAOca:
        mPrintf msjTurnoOca
        mPrintf msjMovimientosOca
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

    computarMovimientoOca:
        sub rsp, 8
        call        validarMovimientoDeOca ;Valida el movimiento de la oca, si es un movimiento invalido setea rax en -1.
        add rsp, 8


    ;call        realizarMovimientoDeOca
    ; cmp rax, -1                       ; Verificar si el movimiento de la oca fue invalido
    ;jmp preguntarPorMovimientosOca     ; Vuelvo a preguntar movimiento

    ;call        verificaCondicionDeFinDePartida

    mov byte[turnoActual], 'Z'      ;Cuando termina el turno de la Oca, cambia el turno al zorro.
    
    jmp principioLoop

calcularPosicionZorro:
    mPrintf msjValidacion
    ret

validarMovimientoDelZorro:
    mPrintf msjValidacion
    ret

validarMovimientoDeOca:
    mPrintf msjValidacion
    ret
