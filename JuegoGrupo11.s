/*Imprimir mapa*/
.data
 /* Definicion de datos */
mapa: .asciz "___________________________________________________|\n                                                   |\n     *** EL JUEGO DEL AHORCADO - ORGA 1 ***        |\n___________________________________________________|\n                                                   |\n                                                   |\n          +------------+                           |\n          |                                        |   \n          |                                        |\n          |                                        |\n          |                                        |\n          |                                        |\n          |                                        |\n          |                                        |\n          |                                        |\n +-------------------------------------------+     |\n |                                           |     |\n |                                           |     |\n |Letras erradas:                            |     |\n +-------------------------------------------+     |\n vida:8\n"
longitud = . - mapa

inicio_pal: .word 916

inicio_letras_e: .word 975

inicio_cuer: .word 450

inicio_vida: .word 1069

inicio_ganaste: .word 1061

/* ancho=53
  ___________________________________________________|\n
1                                                    |\n
2      *** EL JUEGO DEL AHORCADO - ORGA 1 ***        |\n
3 ___________________________________________________|\n
4                                                    |\n
5                                                    |\n
6           +------------+                           |\n
7           |            |                           |\n
8           |            o                           |\n
9           |           /|\\                         |\n
10          |            |                           |\n
11          |           / \\                         |\n
12          |                                        |\n
13          |                                        |\n
14          |                                        |\n
15 +-------------------------------------------+     |\n
16 |                                           |     |\n
17 |    _ _ _ _ _ _ _ _ _ _ _ _ _ _            |     |\n
18 |                                           |     |\n
19 +-------------------------------------------+     |\n
*/
enter: .ascii "\n"

guion: .ascii "-"

cls: .asciz "\x1b[H\x1b[2J" //una manera de borrar la pantalla usando ansi escape codes
lencls = .-cls

palabra1: .asciz "esquirla"

palabra2: .asciz "abrazo"

palabra3: .asciz "paloma"

palabra4: .asciz "lampara"

palabra5: .asciz "supercalifragilistico"

resp: .asciz ""
lenresp = .-resp
lengthresp: .byte 0


p_cuerpo: .asciz "o/||/|"

tiro_msj: .asciz "Te estan ahorcando Tenes otra chance de ganar disparando a la cuerda, introduce las coordenadas (columna, fila) de la cuerda \n"

pregunta_msj_0: .asciz "Estas a punto de ser ahorcado, para no perder, responde: ¿Aproximadamente cuantos metros de altura tiene la gran piramide de Giza? \n"

pregunta_msj_co: .asciz "Correcto tenes vida extra!\n"

ganaste_msj: .asciz "Correcto Has Ganado!"

perdiste_msj: .asciz "Incorrecto, perdiste!"

x_msj: .asciz "Introduce la columna: "

y_msj: .asciz "Introduce la fila: "

letra_msj: .asciz "Letra: "

vida: .word 0x38

pedir_palabra_msj: .asciz "Ingrese un numero del 1 al 5 para empezar a jugar\n"

cant_preguntas: .word 0x0
.align

pal_elegir: .byte 0
.align

letra: .byte 0
.align

coordenada_x: .byte 0
.align

coordenada_y: .byte 0
.align

//resp: .asciz "fragmentacion"
//lenresp = .-resp

pregunta_msj_1: .asciz ""

/*----------------------------------------------------------*/
.text             @ Defincion de codigo del programa
/*----------------------------------------------------------*/


/*----------------------------------------------------------*/
imprimirString:
  .fnstart
      /*Parametros inputs:
      /* r1=puntero al string que queremos imprimir
      /*r2=longitud de lo que queremos imprimir*/
      push {lr}
push {r1}
push {r2}
      bl clearScreen
      pop {r2}
      pop {r1}
      mov r7,#4   /* Salida por pantalla */
      mov r0,#1  /* Indicamos a SWI que sera una cadena*/
      swi 0       /* SWI, Software interrup*/
      pop {lr}
      bx lr        /*salimos de la funcion mifuncion*/
  .fnend
/*---------------------------------------------------------*/
clearScreen:
  .fnstart
      mov r0, #1
      ldr r1, =cls
      ldr r2, =lencls
      mov r7, #4
      swi 0

      bx lr /*salimos de la funcion mifuncion*/
  .fnend
//---------------------------------------------------------
/*----------------------------------------------------------*/



pedir_palabra:
  .fnstart
	push {lr}
	push {r0}
	push {r1}
	push {r2}
//	push {r3}
	push {r4}
	ciclo_3:

		mov r7, #4
		mov r0, #1
		mov r2, #100
		ldr r1, =pedir_palabra_msj //aparece un mensaje en pantalla que pide un numero del 1 al 5
		swi 0


		mov r7, #3
		mov r0, #0
		mov r2, #4
		ldr r1, =pal_elegir  //toma el ingreso del numero
		swi 0

		eor r0, r0
		eor r1, r1

		ldr r0, =pal_elegir
		ldrb r0, [r0]

		ldr r1, =resp

		cmp r0, #0x31 //si se ingreso un 1 toma la palabra 1
		beq pal1

		cmp r0, #0x32 //si se ingreso un 2 toma la palabra 2
		beq pal2

		cmp r0, #0x33 //si se ingreso un 3 toma la palabra 3
		beq pal3

		cmp r0, #0x34 //si se ingreso un 4 toma la palabra 4
		beq pal4

		cmp r0, #0x35 //si se ingreso un 5 toma la palabra 5
		beq pal5

		bal ciclo_3
	pal1:
		ldr r3, =palabra1

		ldr r1, =lengthresp
		mov r4, #8		//se establece la palabra elegida como la respuesta y se determina el largo de la palabra
		str r4, [r1]

		b salir_3
	pal2:
		ldr r3, =palabra2

		ldr r1, =lengthresp
		mov r4, #6		//se establece la palabra elegida como la respuesta y se determina el largo de la palabra
		str r4, [r1]

		b salir_3
	pal3:
		ldr r3, =palabra3

		ldr r1, =lengthresp
		mov r4, #6		//se establece la palabra elegida como la respuesta y se determina el largo de la palabra
		str r4, [r1]

		b salir_3
	pal4:
		ldr r3, =palabra4

		ldr r1, =lengthresp
		mov r4, #7		//se establece la palabra elegida como la respuesta y se determina el largo de la palabra
		str r4, [r1]

		b salir_3
	pal5:
		ldr r3, =palabra5

		ldr r1, =lengthresp
		mov r4, #21		//se establece la palabra elegida como la respuesta y se determina el largo de la palabra
		str r4, [r1]

		b salir_3
	salir_3:
		pop {r4}
//		pop {r3}
		pop {r2}
		pop {r1}
		pop {r0}
		pop {lr}
		bx lr
  .fnend






//------------------------------------------------------------
chequeo: //
  .fnstart
	push {lr}
	push {r0}
	push {r1}
	push {r2}
	push {r5}
	push {r6}
	push {r7}
	ldr r5, =lengthresp
	ldr r7, [r5]
	ldr r6, =inicio_pal //llamo la posicion donde empieza la palabra
	ldr r6, [r6]
	eor r9, r9
	ciclo:
		ldrb r0, [r3]
		cmp r0, #0 //si r0=0 quiere decir que termino la cadena por lo que salgo
		beq salir_

		cmp r0, r4 //comparo la letra que ingrese en el input con la primera de la respuesta
		bleq remplazar //si son iguales voy a la funcion remplazar
		addne r9, #1 // si no son iguales sumo al contador de error
		addeq r11, #1 // si lo son lo sumo al de aciertos
		subeq r7, #1
//		str r7, [r5]
		moveq r0, #'#' //si son iguales remplazo la letra en la memoria con un # para que no sirva repetir
		strb r0, [r3]
		add r3, #1

		add r6, #1
		bal ciclo
	salir_:
		pop {r7}
		pop {r6}
		pop {r5}
		pop {r2}
		pop {r1}
		pop {r0}
		pop {lr}
		bx lr
  .fnend
/*----------------------------------------------------------*/
error:
  .fnstart
	push {lr}
	push {r0}
	push {r1}
	push {r2}
	push {r3}
	push {r4}
	push {r5}

	eor r5, r5
	eor r2, r2
	eor r1, r1

	ldr r0, =lengthresp //longitud de la respuesta
	ldr r0, [r0]

	cmp r9, r0 //si la longitud de la respuesta y el contador de errores son iguales quiere decir que la letra ingresada no es correcta
	bne salir

	ldr r2, =inicio_letras_e
	ldr r6, [r2]
	ldr r5, =letra
	ldrb r4, [r5]
	bl remplazar  //muestra en el mapa la letra como una letra errada
	eor r5, r5
	add r5, r6, #1
	str r5, [r2]
//
	ldr r2, =inicio_letras_e
	ldr r6, [r2]
	ldr r5, =guion
	ldrb r4, [r5]
	bl remplazar  // agrega un guion(-) despues de la letra errada
	eor r5, r5
	add r5, r6, #1
	str r5, [r2]
//
	eor r5, r5
	eor r2, r2
	eor r4, r4
	eor r6, r6



	//Bajar vida --> accedo a la vida en memoria y la guardo en registro, le resto 1, remplazo en pantalla y la guardo denuevo en memoria
	ldr r1, =vida
	ldrb r2, [r1]

	sub r2, #1
	str r2, [r1]
	mov r4, r2

	ldr r6, =inicio_vida
	ldr r6, [r6]

	bl remplazar


	//poner cuerpo --> comparo la vida y segun la cantidad que tenga pongo una parte del cuerpo
	eor r0, r0
	eor r1, r1
	eor r2, r2
	eor r3, r3

	ldr r3, =p_cuerpo

	ldr r0, =inicio_cuer
	ldr r0, [r0] //pos. cabeza


	ldr r1, =vida
	ldrb r1, [r1] //vida que tengo

	cmp r1, #'7' //comparo la vida
	beq cabeza

	cmp r1, #'6'
	beq br_izq

	cmp r1, #'5'
	beq torso_0

	cmp r1, #'4'
	beq br_der

	cmp r1, #'3'
	beq torso_1

	cmp r1, #'2'
	beq pr_izq

	cmp r1, #'1'
	beq pr_der

	bal salir

	cabeza:
		mov r6, r0
//		ldrb r4, [r3]
		mov r4, #'o'
		bl remplazar
		b salir

	br_izq:
		add r6, r0, #52
//		ldrb r4, [r3, #1]! //--> recorro el cuerpo que esta dentro de una cadena
		mov r4, #'/'
		bl remplazar //--> remplazo en pantalla hago lo mmismo con las otras partes del cuerpo
		b salir

	torso_0:
		add r6, r0, #53
//		ldrb r4, [r3, #2]!
		mov r4, #'|'
		bl remplazar
		b salir

	br_der:
		add r6, r0, #54
		mov r4, #0x5c
		bl remplazar
		b salir

	torso_1:
		add r6, r0, #106
		ldrb r4, [r3, #3]!
		bl remplazar
		b salir

	pr_izq:
		add r6, r0, #158
		ldrb r4, [r3, #4]!
		bl remplazar
		b salir

	pr_der:
		add r6, r0, #160
		mov r4, #0x5c
		bl remplazar
		b salir

	salir:
	ldr r1, =mapa
	ldr r2, =longitud
	bl imprimirString
	pop {r5}
	pop {r4}
	pop {r3}
	pop {r2}
	pop {r1}
	pop {r0}
	pop {lr}
	bx lr
  .fnend
//-----------------------------------------------------------*/
remplazar: // esta funcion recibe una posicion (r6) y un caracter (r4) y remplaza en pantalla
  .fnstart
	push {lr}
	push {r1}
	push {r2}
	ldr r1, =mapa
	add r1, r6
	ldrb r2, [r1]
	mov r2, r4
	strb r2, [r1]
	pop {r2}
	pop {r1}
	pop {lr}
	bx lr
  .fnend
//----------------------------------------------------------
arrobas:// segun la longitud de la palabra remplazo por arrobas mediante un ciclo
  .fnstart
	push {r0}
	push {r1}
	push {r2}
	ldr r6, =inicio_pal
	ldr r6, [r6]
	eor r5, r5
	ldr r5, =lengthresp //longitud de la respuesta
	ldr r5, [r5]
	ldr r1, =mapa
	add r1, r6
	ciclo_0: //cada vez que remplazo le resto a la longitud una vez llega a cero salgo
		ldrb r0, [r1]
		mov r0, #'@'
		strb r0, [r1], #1
		sub r5, #1
		cmp r5, #0
		bgt ciclo_0
		pop {r2}
		pop {r1}
		pop {r0}
		bx lr

  .fnend
//-------------------------------------------------------------------------
input://pido una letra y la chequeo
  .fnstart
	push {lr}
	push {r3}
	push {r4}
	push {r5}
	push {r0}
	push {r1}
	push {r2}
	push {r7}

	mov r7, #4
	mov r0, #1
	mov r2, #7
	ldr r1, =letra_msj
	swi 0

pedir:
	mov r7,#3
	mov r0,#0
	mov r2,#4
	ldr r1,=letra
	swi 0

	ldr r5, =letra //guardo la letra en r4 y la respuesta en r3
	ldrb r4, [r5]
	cmp r4, #'\n'
	beq pedir

	pop {r7}
	pop {r2}
	pop {r1}
	pop {r0}

	bl chequeo

	pop {r5}
	pop {r4}
	pop {r3}
	pop {lr}
	bx lr
  .fnend
//-------------------------------------------------------------------------
ganaste://muestra el mensaje de que ganaste
  .fnstart
	mov r7, #4
	mov r0, #1
	mov r2, #20
	ldr r1, =ganaste_msj
	swi 0
	b finalizo
  .fnend
//-------------------------------------------------------------------------
perdiste: //muestra el mensaje de derrota
  .fnstart
	mov r7, #4
	mov r0, #1
	mov r2, #21
	ldr r1, =perdiste_msj
	swi 0
	b finalizo
  .fnend
//-------------------------------------------------------------------------
disparo: //pido coordenadas x e y y las comparo con las de la cuerda, si acierta ganas, sino, perdes
  .fnstart

	eor r6, r6
	eor r4, r4

	ldr r1, =mapa
	ldr r2, =longitud

	ldr r6, =inicio_cuer
	ldr r6, [r6]
	mov r4, #'|'
	sub r6, #56
	bl remplazar
	bl imprimirString //usando la funcion remplazar pongo la cuerda en pantalla

	//mensaje del objetivo
	mov r7, #4
	mov r0, #1
	mov r2, #127
	ldr r1, =tiro_msj
	swi 0

	//mensaje pedir coordenada x
	mov r7, #4
	mov r0, #1
	mov r2, #22
	ldr r1, =x_msj
	swi 0
	//input coordenada x
	mov r7, #3
	mov r0, #0
	mov r2, #4
	ldr r1, =coordenada_x
	swi 0
	//msj coordenada y
	mov r7, #4
	mov r0, #1
	mov r2, #19
	ldr r1, =y_msj
	swi 0
	//input coordenada y
	mov r7, #3
	mov r0, #0
	mov r2, #4
	ldr r1, =coordenada_y
	swi 0

	//la coodenada de la cuerda es x=25 e y=7
	ldr r1, =coordenada_x

	//agarro la primera letra y la comparo con 2 si es igual sigo sino significa que no acerte asi que pierdo
	ldrb r3, [r1], #1
	cmp r3, #0x32
	bne salir_1

	//comparo el 5
	ldrb r3, [r1]
	cmp r3, #0x35
	bne salir_1
	sig:
		//comparo el 7
		eor r1, r1
		ldr r2, =coordenada_y
		ldrb r1, [r2]
		cmp r1, #0x37
		bne salir_1
		b ganaste

	salir_1:
		b perdiste


  .fnend
//--------------------------------------------------------
pregunta://antes de ser ahorcado hago una pregunta para salvarte
  .fnstart
	push {r1}
	push {r2}
	push {r5}
	push {r6}
	push {r8}
	push {r9}

	//Iprimio un msj y recibo un input
	mov r7, #4
	mov r0, #1
	mov r2, #134
	ldr r1, =pregunta_msj_0
	swi 0

	mov r7, #3
	mov r0, #0
	mov r2, #4
	ldr r1, =pregunta_msj_1
	swi 0

	//guardar en r8 el valor numerico del input, convirtiendo los numeros asci a hexa
	eor r8, r8
	mov r5, #100
	mov r6, #10

	ldr r1, =pregunta_msj_1//obtengo la primera letra osea la centecima
	ldrb r2, [r1], #1
	sub r2, #0x30

	mul r8, r2, r5 //saco el valor y lo multiplico por 100

	ldrb r2, [r1], #1
	sub r2, #0x30
	mul r2, r6
	add r8, r2 //lo mismo que antes pero con la decena

	ldrb r2, [r1] //y la unidad la obtengo sin necesidad de multiplicar
	sub r2, #0x30
	add r8, r2 //la suma de los valores queda en r8

	//rango de aceptacion de la respuesta [130, 145]

	cmp r8, #130
	blt salir_p //si es menor a 130 esta mal asi que salgo
	cmp r8, #145 //si es mayor a 145 esta mal asi que salgo
	bgt salir_p
	salir_g:// si acerte la pregunta le sumo a vida, lo muestro y vuelvo a juego
		eor r1, r1
		eor r2, r2
		eor r6, r6
		eor r4, r4
		eor r5, r5
		eor r8, r8

		ldr r1, =mapa
		ldr r2, =longitud

		ldr r6, =inicio_vida
		ldr r6, [r6]
		ldr r5, =vida  //sumo la vida extra y lo muestro por pantalla
		ldr r4, [r5]
		add r4, #3 //3 vidas extra
		str r4, [r5]

		bl remplazar
		bl imprimirString

		ldr r8, =cant_preguntas //cambio el contador de preguntas a otro numero
		str r4, [r8]

		mov r7, #4
		mov r0, #1 //mensaje de acierto
		mov r2, #28
		ldr r1, =pregunta_msj_co
		swi 0

		pop {r9}
		pop {r8}
		pop {r6}
		pop {r5}
		pop {r2}
		pop {r1}
		b juego

	salir_p: //si fallo voy a la opcion de disparar
		pop {r9}
		pop {r8}
		pop {r6}
		pop {r5}
		pop {r2}
		pop {r1}
		b disparo
  .fnend

//---------------------------------------------------------

.global main        /* global, visible en todo el programa*/
main:
 /*imprimo el mapa para empezar*/

	ldr r2,=longitud /*Tamaño de la cadena*/
	ldr r1,=mapa   /*Cargamos en r1 la direccion del mensaje*/

	bl imprimirString
	bl pedir_palabra

	bl arrobas
	bl imprimirString
juego:
	ldr r1, =mapa
	ldr r2, =longitud

	bl input
	bl imprimirString

	ldr r10, =lengthresp
	ldr r10, [r10]
	cmp r11, r10 //comparo la cantidad de aciertos con la longitud de la palabra, si son iguales gane
	beq ganaste

	bl error

	ldr r12, =vida
	ldr r12, [r12] //mientras la vida sea distinta a 0x30 (0) se va a seguir ejecutando el ciclo
	cmp r12, #0x30
	bgt juego

	ldr r4, =cant_preguntas
	ldr r4, [r4]

	cmp r4, #0x0
	bleq pregunta //comparo con la cantidad de preguntas que hice, si ya he hecho una no vuelvo a ir a pregunta
	blne disparo

finalizo:
	mov r7,#1
	swi 0
