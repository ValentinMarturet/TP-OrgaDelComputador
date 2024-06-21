CC= gcc
AS = nasm
ASFLAGS= -f elf64 -g
CFLAGS= -no-pie -g

all: juego 

juego: juego.o imprimirTablero.o
	$(CC) juego.o imprimirTablero.o -o juego $(CFLAGS)

juego.o: juego.asm imprimirTablero.o
	$(AS) juego.asm $(ASFLAGS)

imprimirTablero.o: imprimirTablero.asm
	$(AS) imprimirTablero.asm $(ASFLAGS)
	
clean: rm -f juego