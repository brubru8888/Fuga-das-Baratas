call menu
call instrucoes
jmp main

; Charmap

;	nave 4 partes
;-- # --> N1
;	280	 : 	 00000001;
;	281  :   00000001;
;	282  :   00000001;
;	283  :   00000001;
;	284  :   00000001;
;	285  :	 00010011;
;	286  :   00010111;
;	287  :   01111111;
;
;-- $ --> N2
;	288  :   10000000;
;	289  :   10000000;
;	290  :   10000000;
;	291  :   10000000;
;	292  :   10000000;
;	293  :   11001000;
;	294  :   11101000;
;	295  :   11111110;
;
;-- % --> N3
;	296  :   01111111;
;	297  :   00000011;
;	297  :   00000001;
;	299  :   00000001;
;	300  :   00000001;
;	301  :   00000011;
;	302  :   00001100;
;	303  :   00010000;
;
;-- & --> N4
;	304  :   11111110;
;	305  :   11000000;
;	306  :   10000000;
;	307  :   10000000;
;	308  :   10000000;
;	309  :   11000000;
;	310  :   00110000;
;	311  :   00001000;

;-- * --> alien
;	336  :	 00000000;
;	337  :	 00111100;
;	338  :   01000010;
;	339  :	 01011010;
;	340  :	 01000010;
;	341  :	 00111100;
;	342  :	 00011000;
;	343  :   01000010;

; Variáveis

score: var #1 			; Pontos
vidas: var #1 			; Vidas

posNave1: var #1		; Coordenada N1
posNave2: var #1 		; Coordenada N2
flagTiroNave: var #1    ; Flag se nave atirou
posTiroNave: var #1     ; Posição tiro nave (armazena a coordenada da esqueda, na hora de imprimir é somado 1 para imprimir o da direita)

posAlien1: var #1 		; Coordenada A1
posAlien2: var #1 		; Coordenada A2
flagTiroAlien: var #1   ; Flag se alien atirou
posTiroAlien: var #1 	; Posição tiro nave (armazena a coordenada da esqueda, na hora de imprimir é somado 1 para imprimir o da direita)

IncRand: var #1			; Incremento para circular na Tabela de nr. Randomicos
Rand : var #30			; Tabela de nr. Randomicos entre 0 - 1. Para movimentação do alien.
	static Rand + #0, #1
	static Rand + #1, #1
	static Rand + #2, #0
	static Rand + #3, #1
	static Rand + #4, #1
	static Rand + #5, #1
	static Rand + #6, #0
	static Rand + #7, #1
	static Rand + #8, #0
	static Rand + #9, #0
	static Rand + #10, #1
	static Rand + #11, #0
	static Rand + #12, #0
	static Rand + #13, #1
	static Rand + #14, #0
	static Rand + #15, #0
	static Rand + #16, #1
	static Rand + #17, #0
	static Rand + #18, #0
	static Rand + #19, #1
	static Rand + #20, #1
	static Rand + #20, #1
	static Rand + #21, #0
	static Rand + #22, #1
	static Rand + #23, #1
	static Rand + #24, #0
	static Rand + #25, #0
	static Rand + #26, #1
	static Rand + #27, #0
	static Rand + #28, #0
	static Rand + #29, #1

gameOver:
	loadn r0, #0 					; Posição do começo da tela
	loadn r1, #gameOverLinha0 		; Endereço da tela na memória
	call ImprimeTela 				; imprime tela

	
	loadn r1, #582  		; Posição para imprimir os pontos
	load r0, score 			; r0 = score
	loadn r2, #100 			; r2 = 100
	div r3, r0, r2 			; r3 = r0 / r2    ->   pega o dígito da centena
	loadn r4, #48 			; r4 = 48
	add r3, r3, r4 			; r3 += r4  ->  converte o dígito para o seu valor na tabela ASCII, por exemplo o dígito 5 é representado pelo número 53 na tabela
	outchar r3, r1 			; imprime a centena
	sub r3, r3, r4 			; r3 -= r2  ->  volta do valor da tabela ASCII para o dígito
	mul r3, r3, r2 			; r3 *= r2  ->  multiplica o dígita da centena por 100
	sub r0, r0, r3 			; r0 -= r3  ->  remove as centenas

							; EXEMPLO:
							; 523 -> 523 / 100 = 5 -> dígito da centena = 5 -> imprime o 5 -> subtrai 5 * 100 do total de pontos ->
							; -> 523 - 5 * 100 = 23 -> segue processo análogo para dezena e unidade

	; Impressão da dezena
	inc r1
	loadn r2, #10 
	div r3, r0, r2 
	loadn r4, #48
	add r3, r3, r4
	outchar r3, r1
	sub r3, r3, r4
	mul r3, r3, r2
	sub r0, r0, r3

	; Impressão da unidade
	inc r1
	add r0, r0, r4
	outchar r0, r1

	gameOverLerCaractere:
	inchar r0 			; le tecla

	loadn r1, #13 		; r1 = 13 = ENTER
	cmp r0,r1
	jeq main 			; se ENTER foi pressionado, quer jogar denovo, então pula pra main
	
	loadn r1, #' ' 		; r1 = SPACE
	cmp r0, r1
	jeq fim  			; se SPACE foi pressionado, quer sair, então pula pro fim

	jmp gameOverLerCaractere  ; se nenhuma das teclas de interesse foi pressionada, volta pro gameOverLerCaractere

menu:
	push r1
	push r2

	loadn r1, #tela0Linha0 ; Endereco onde comeca a primeira linha da tela
	loadn r2, #0  		   ; Cor branca
	call ImprimeTela
	loadn r2, #13 

	lerTecla:
	inchar r1
	cmp r1, r2
	jne lerTecla

	call ApagaTela
	; Enquanto enter não for pressionado le a tecla
 			; if (r1 != ENTER) lerTecla



	pop r2
	pop r1

	rts

instrucoes:
	call ApagaTela

	push r1
	push r2

	loadn r1, #tela1Linha0 ; Endereco onde comeca a primeira linha da tela
	loadn r2, #0  		   ; Cor branca
	call ImprimeTela
	loadn r2, #106 

	lerTecla2:
	inchar r1
	cmp r1, r2
	jne lerTecla2

	call ApagaTela
	; Enquanto enter não for pressionado le a tecla
 			; if (r1 != ENTER) lerTecla



	pop r2
	pop r1

	rts

main:
 	call ApagaTela   		; Limpa a tela

	loadn r0, #5 			
	store vidas, r0 		; Quantidade de vidas

	loadn r0, #0
	store score, r0 		; Zera os pontos 

	loadn r0, #1059			; Posição nave1
	store posNave1, r0
	loadn r0, #1099			; Posição nave2
	store posNave2, r0
	loadn r0, #0
	store flagTiroNave, r0 	; Zera flag de tiro da nave

	loadn r0, #19 			; Posição alien1
	store posAlien1, r0
	loadn r0, #59
	store posAlien2, r0 	; Posição alien2
	loadn r0, #0
	store flagTiroAlien, r0 ; Zera flag de tiro do alien
	
	loadn r0, #0 			; Contador para os mods = 0
	loadn r2, #0 			; Para verificar se r0 % x == 0

	call imprimeHud 		; Imprime as palavras SCORE: e VIDAS: 

	jmp loop 				; pula pro loop



loop:
	; Os mods servem para executar as ações somente nos ciclos em que o contador é múltiplo de algum número.
	; Se r0 % 10 == 0
	; movimentação da nave
	loadn r1, #10
	mod r1, r0, r1
	cmp r1, r2
	ceq nave
	
	; Se r0 % 2 == 0
	; tiro da nave
	loadn r1, #2
	mod r1, r0, r1
	cmp r1, r2
	ceq tiroNave

	; Se r0 % 30 == 0
	; movimentação do alien
	loadn r1, #30
	mod r1, r0, r1
	cmp r1, r2
	ceq alien

	; Se r0 % 250 == 0
	; frequência de tiro do alien 
	loadn r1, #250
	mod r1, r0, r1
	cmp r1, r2
	ceq alienAtirou

	; Se r0 % 3 == 0
	; tiro do alien
	loadn r1, #3
	mod r1, r0, r1
	cmp r1, r2
	ceq tiroAlien

	call comparaPosicaoTiroNave		; compara a posição do tiro da nave com o alien

	call imprimeValoresHud 			; imprime os valores dos pontos e das vidas

	push r0 			; protege r0
	push r1 			; protege r1
	loadn r0, #0
	load r1, vidas
	cmp r0, r1
	jeq gameOver 		; if (vidas == 0) gameover 
	pop r1 				; protege r1
	pop r0 				; protege r0
	
	call Delay 				; Delay para as coisas não irem tão rápido
	inc r0					; Incrementa contador dos mods - r0++
	jmp loop


; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-HUD-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
imprimeHud:
	push r0
	push r1

	loadn r0, #1160  	 	; posição para começar imprimir
	loadn r1, #stringHud 	; endereço da string
	call ImprimeStr 		; imprime

	pop r1
	pop r0

	rts

imprimeValoresHud:
	push r0
	push r1
	push r2
	push r3
	push r4

	; imprime as vidas, valores somente de 0 a 9
	load r0, vidas 	 	; r0 = vidas
	loadn r1, #48 		
	add r0, r0, r1 		; converte pra valor do dígito na tabela ASCII
	loadn r1, #1198  	; lugar da tela para imprimir
	outchar r0, r1 		; imprime

	; imprime os pontos
	; mesma lógica explicada na função gameOver no começo do código
	loadn r1, #1168
	load r0, score
	loadn r2, #100
	div r3, r0, r2
	loadn r4, #48
	add r3, r3, r4
	outchar r3, r1
	sub r3, r3, r4
	mul r3, r3, r2
	sub r0, r0, r3

	inc r1
	loadn r2, #10
	div r3, r0, r2
	loadn r4, #48
	add r3, r3, r4
	outchar r3, r1
	sub r3, r3, r4
	mul r3, r3, r2
	sub r0, r0, r3

	inc r1
	add r0, r0, r4
	outchar r0, r1

	pop r4
	pop r3
	pop r2
	pop r1
	pop r0

	rts

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-COLISAO-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
comparaPosicaoTiroNave:
	push r0 
	push r1 
	
	load r0, posTiroNave	; pos tiro 1 (esquerda)
	load r1, posAlien1		; pos alien 1 (esquerda)
	cmp r0, r1 				; compara tiro 1 com alien 1
	ceq somaPonto
	
	inc r1 					; pos alien 2 (direita)
	
	cmp r0, r1 				; compara tiro 1 com alien 2
	ceq somaPonto
	
	inc r0					; pos tiro 2 (direita)
	
	cmp r0, r1 				; compara tiro2 com alien 2
	ceq somaPonto
	
	dec r1					; pos alien 1 (esquerda)
	
	cmp r0, r1 				; compara tiro2 com alien 1
	ceq somaPonto
	
	pop r1 
	pop r0
	
	rts
	
somaPonto:
	push r0 
	push r1 
	
	load r0, score			; pega o valor da score na memória
	
    ;loadn r1, #'A'			 ; teste visual 
    ;outchar r1, r0 		 ; escreve A na posicao do score (comeca em 0)
	
	inc r0 					; incrementa 1
	store score, r0 		; armazena de volta na memória
	
	loadn r0, #0			; reseta a posição do tiro da nave
	store posTiroNave, r0 	; evita que fique somando infinitamente
	
	pop r1 
	pop r0 
	
	rts

decVidas:
	push r0

	load r0, vidas 		; r0 = vidas
	dec r0 				; r0--
	store vidas, r0 	; vidas = r0

	pop r0

	rts

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-NAVE-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
nave:
	call naveDesenhar
	call naveMover
	
	rts

naveDesenhar:
	; A nave é composta por 4 caracteres
	;			     N1N3
	;				 N2N4

	push r0
	push r1

	loadn r0, #'#'  	; r0 = caractere nave1
	load r1, posNave1	; r1 = posição nave1
	outchar r0, r1		; desenha nave1

	inc r0				; r0++ (caractere nave3)
	inc r1				; r1++ (posição nave3)
	outchar r0, r1		; desenha nave3

	inc r0				; r0++ (caractere nave2)
	load r1, posNave2	; r1++ (posição nave2)
	outchar r0, r1		; desenha nave2

	inc r0				; r0++ (caractere nave4)
	inc r1				; r1++ (posição nave4)
	outchar r0, r1		; desenha nave4

	pop r1
	pop r0

	rts

naveApagar:
	push r0
	push r1
	push r2
	
	loadn r0, #' '			; r0 = ' '
	load r1, posNave1		; r1 = posição nave1
	load r2, posNave2		; r2 = posição nave2

	outchar r0, r1			; imprime ' ' em N1
	outchar r0, r2			; imprime ' ' em N2

	inc r1					; r1++ (posição nave3)
	inc r2					; r2++ (posição nave4)

	outchar r0, r1			; imprime ' ' em N3
	outchar r0, r2			; imprime ' ' em N4

	pop r2
	pop r1
	pop r0

	rts

naveMover:
	push r0
	push r1
	push r2
	push r3

	inchar r0			; Le a tecla digitada
	
	loadn r1, #'a'		; Se a tecla digitada for a, move pra esequerda
	cmp r0, r1
	ceq	naveMoveEsq

	loadn r1, #'d' 		; Se a tecla digitada for d, move pra direita
	cmp r0, r1
	ceq naveMoveDir

	loadn r1, #' '
	load r2, flagTiroNave
	loadn r3, #1
	cmp r2, r3
	jeq naveAtirou_Skip 	; Se a flag de tiro já está em 1 pula
	cmp r0, r1 				; Se SPACE foi pressionado e a flag de tiro está em 0, chama naveAtirou
	ceq naveAtirou
	naveAtirou_Skip:

	pop r3
	pop r2
	pop r1
	pop r0

	rts

naveMoveEsq:
	push r0
	push r1

	; Caso em que a nave está na borda
	load r0, posNave1
	loadn r1, #1041
	cmp r0, r1
	jle naveMoveEsq_skip	; if (posNave1 < 1041) não move

	call naveApagar			; Apaga a nave

	; Decrementa a posição da nave
	load r0, posNave1
	load r1, posNave2
	dec r0
	dec r1
	store posNave1, r0
	store posNave2, r1

	call naveDesenhar		; Desenha a nave na nova coordenada

	naveMoveEsq_skip:		; Label para não mover a nave

	pop r1
	pop r0

	rts

naveMoveDir:
	push r0
	push r1

	; Caso em que a nave está na borda
	load r0, posNave1
	loadn r1, #1077
	cmp r0, r1
	jgr naveMoveDir_skip 	; if (posNave1 > 1077) não move

	call naveApagar			; Apaga a nave

	; Incrementa a posição da nave
	load r0, posNave1
	load r1, posNave2
	inc r0
	inc r1
	store posNave1, r0
	store posNave2, r1

	call naveDesenhar		; Desenha a nave na nova coordenada

	naveMoveDir_skip:		; Label para não mover a nave

	pop r1
	pop r0

	rts

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-TIRO NAVE-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
naveAtirou:
	push r0

	loadn r0, #1
	store flagTiroNave, r0		; flagTiroNave = 1
	load r0, posNave1
	store posTiroNave, r0       ; posTiroNave = posNave1

	pop r0
	
	rts
	
tiroNave:
	push r0
	push r1

	loadn r0, #1
	load r1, flagTiroNave
	cmp r0, r1
	ceq tiroNaveMover 			; Se flagTiroNave == 1 chama tiroNaveMover

	pop r1
	pop r0

	rts

tiroNaveMover:
	push r0
	push r1
	push r2

	load r0, posTiroNave		; r0 = posTiroNave
	call tiroNaveApagar 		; apaga tiro
	loadn r2, #40 				; move a posição do tiro uma linha pra cima
	sub r0, r0, r2

	loadn r1, #40
	cmp r0, r1
	cle tiroNavePassouPrimeiraLinha ; if (posTiro < 40) passouPrimeiraLinha


	store posTiroNave, r0  			; armazena nova posição na variavel
	call tiroNaveDesenhar 			; desenha o tiro

	pop r2
	pop r1
	pop r0

	rts

tiroNavePassouPrimeiraLinha:
	push r0
	push r1
	push r2

	; flagTiroNave = 0
	loadn r0, #0
	store flagTiroNave, r0

	loadn r1, #' '
	load r2, posTiroNave

	outchar r1, r2  		; Desenha ' ' na posTiroNave
	inc r2
	outchar r1, r2 

	pop r2
	pop r1
	pop r0

	rts

tiroNaveDesenhar:
	push r1 
	push r2 
	push r3
	push r4
	push r5
	push r6
	
	load r1, flagTiroNave
	loadn r2, #0
	cmp r1, r2
	jeq tiroNaveDesenhar_Skip 	; if (flagTiro == 0) skip

	load r1, posTiroNave
	loadn r2, #'W'
	loadn r3, #'X'
	loadn r4, #'w'
	loadn r5, #'x'

	outchar r2, r1 				; Desenha '|' na posTiroNave
	
	inc r1 						
	outchar r3, r1 				; Desenha '|' na posTiroNave + 1

	dec r1
	loadn r6, #40
	add r1, r1, r6

	outchar r4, r1

	inc r1

	outchar r5, r1



	
	tiroNaveDesenhar_Skip:
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1 
	
	rts

tiroNaveApagar:
	push r0
	push r1
	push r2
	push r3

	loadn r0, #' '
	load r1, posTiroNave

	; if (posTiro == posNave) skip  
	load r2, posNave1
	loadn r3, #40
	cmp r1, r2
	jeq tiroNaveApagar_Skip

	add r1, r1, r3
	outchar r0, r1  		; Desenha ' ' na posTiroNave
	inc r1
	outchar r0, r1 			; Desenha ' ' na posTiroNave + 1

	tiroNaveApagar_Skip:

	pop r3
	pop r2
	pop r1
	pop r0

	rts

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-ALIEN-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
alien:
	call alienDesenhar
	call alienMover

	rts

alienDesenhar:
	; O alien é composto por 4 caracteres
	;			     A1A3
	;				 A2A4	
	push r0
	push r1

	; Mesma lógica de impressão da nave

	loadn r0, #0
	load r1, posAlien1
	outchar	r0, r1

	inc r0
	inc r1
	outchar r0, r1

	inc r0
	load r1, posAlien2
	outchar r0, r1

	inc r0
	inc r1
	outchar r0, r1

	pop r1
	pop r0

	rts

alienApagar:
	push r0
	push r1

	; Mesma lógica de apagar a nave

	loadn r0, #' '
	load r1, posAlien1
	outchar r0, r1

	inc r1
	outchar r0, r1

	load r1, posAlien2
	outchar r0, r1

	inc r1
	outchar r0, r1

	pop r1
	pop r0

	rts

alienMover:
	push r0
	push r1
	push r2

	loadn r0, #Rand 		; ponteiro para a tabela Rand
	load r1, IncRand 		; incremento da tabela Rand
	add r0, r0, r1 			; soma incremento no ponteiro

	loadi r2, r0 			; r2 = rand[r0]

	inc r1 					; incremento++

	loadn r0, #30
	cmp r1, r0
	jne alienMover_skipResetTabela ; if (r1 != 30) não reseta a tabela
	loadn r1, #0 				   ; else reseta -> r1 = 0
	alienMover_skipResetTabela:
	store IncRand, r1 			   ; armazena novo IncRand

	loadn r0, #0 				   ; if (r2 == 0) moveEsq	
	cmp r0, r2
	ceq alienMoverEsq

	loadn r0, #1 				   ; if (r2 == 1) moveDir
	cmp r0, r2
	ceq alienMoverDir

	pop r2
	pop r1
	pop r0

	rts

alienMoverEsq:
	push r0
	push r1

	load r0, posAlien1
	loadn r1, #1
	cmp r0, r1
	jle alienMoverEsq_Skip  ; Se está na borda esquerda, não move mais

	call alienApagar 		; Apaga o alien

	; Decrementa pos
	load r0, posAlien1
	load r1, posAlien2
	dec r0
	dec r1
	store posAlien1, r0
	store posAlien2, r1

	; Desenha o alien
	call alienDesenhar

	alienMoverEsq_Skip:

	pop r1
	pop r0

	rts

alienMoverDir:
	push r0
	push r1

	load r0, posAlien1 		; Se está na borda direita, não move mais
	loadn r1, #37
	cmp r0, r1
	jgr alienMoverDir_Skip

	call alienApagar 		; Apaga o alien

	; Incrementa pos
	load r0, posAlien1
	load r1, posAlien2
	inc r0
	inc r1
	store posAlien1, r0
	store posAlien2, r1

	; Desehna alien
	call alienDesenhar

	alienMoverDir_Skip:

	pop r1
	pop r0

	rts

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-TIRO ALIEN-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
alienAtirou:
	push r0
	push r1

	loadn r0, #1
	load r1, flagTiroAlien
	cmp r0, r1
	jeq alienAtirou_Skip  		; se flagTiroAlien já está em 1, pula, para não resetar indevidamente posTiroAlien

	loadn r0, #1
	store flagTiroAlien, r0		; flagTiroAlien = 1
	load r0, posAlien2
	store posTiroAlien, r0       ; posTiroAlien = posAlien2

	alienAtirou_Skip:

	pop r1
	pop r0
	
	rts
	
tiroAlien:
	push r0
	push r1

	loadn r0, #1
	load r1, flagTiroAlien
	cmp r0, r1
	ceq tiroAlienMover 			; Se flagTiroAlien == 1 chama tiroAlienMover

	pop r1
	pop r0

	rts

tiroAlienMover:
	push r0
	push r1
	push r2

	load r0, posTiroAlien		; r0 = posTiroAlien
	call tiroAlienApagar 		; apaga tiro
	loadn r2, #40 				; move a posição do tiro uma linha pra baixo
	add r0, r0, r2

	loadn r1, #1080
	cmp r0, r1
	cgr tiroAlienPassouUltimaLinha ; if (posTiro > 1080) passouUltimaLinha

	; if (posTiroAlien == posNave1 || posTiroAlien == posNave1 + 1 || posTiroAlien == posNave1 - 1) decrementa 

	; T1 T2 ||    T1 T2 || T1 T2
	; N1 N2 || N1 N2    ||    N1 N2

	; T = tiroAlien    N = nave

	; posTiroAlien = T1
	; posNave1 = n1

	load r1, posNave1
	cmp r0, r1
	ceq decVidas
	inc r1
	cmp r0, r1
	ceq decVidas
	dec r1
	dec r1
	cmp r0, r1
	ceq decVidas

	store posTiroAlien, r0  			; armazena nova posição na variavel
	call tiroAlienDesenhar 			 	; desenha o tiro

	pop r2
	pop r1
	pop r0

	rts

tiroAlienPassouUltimaLinha:
	push r0

	; flagTiroAlien = 0
	loadn r0, #0
	store flagTiroAlien, r0

	pop r0

	rts

tiroAlienDesenhar:
	push r1 
	push r2 
	
	load r1, flagTiroAlien
	loadn r2, #0
	cmp r1, r2
	jeq tiroAlienDesenhar_Skip 	; if (flagTiroAlien == 0) skip

	load r1, posTiroAlien
	loadn r2, #4
	outchar r2, r1 				; Desenha ' |' na posTiroAlien
	
	inc r2
	inc r1 						
	outchar r2, r1 				; Desenha '| ' na posTiroAlien + 1
	
	tiroAlienDesenhar_Skip:
	pop r2
	pop r1 
	
	rts

tiroAlienApagar:
	push r0
	push r1
	push r2

	loadn r0, #' '
	load r1, posTiroAlien

	; if (posTiroAlein == posAlien2) skip  
	load r2, posAlien2
	cmp r1, r2
	jeq tiroAlienApagar_Skip

	outchar r0, r1  		; Desenha ' ' na posTiroAlien
	inc r1
	outchar r0, r1 			; Desenha ' ' na posTiroAlien + 1

	tiroAlienApagar_Skip:

	pop r2
	pop r1
	pop r0

	rts



; Funções de utilidade -> FONTE: https://github.com/simoesusp/Processador-ICMC/blob/master/Software_Assembly/Nave11.asm
;********************************************************
;                       IMPRIME TELA
;********************************************************	

ImprimeTela: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r4 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

	pop r5	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------

;---------------------------	
;********************************************************
;                   IMPRIME STRING
;********************************************************
	
ImprimeStr:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;********************************************************
;                       APAGA TELA
;********************************************************
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	

;********************************************************
;                       DELAY
;********************************************************		


Delay:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	Push R0
	Push R1
	
	Loadn R1, #50  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	Loadn R0, #3000	; b
   Delay_volta: 
	Dec R0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	JNZ Delay_volta	
	Dec R1
	JNZ Delay_volta2
	
	Pop R1
	Pop R0
	
	RTS							;return


; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-TELAS-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;	Menu
tela0Linha0  : string "                                        "
tela0Linha1  : string "         _____                          "
tela0Linha2  : string "        |  ___|   _  __ _  __ _         "
tela0Linha3  : string "        | |_ | | | |/ _` |/ _` |        "
tela0Linha4  : string "        |  _|| |_| | (_| | (_| |        "
tela0Linha5  : string "        |_|   |__ _||__  ||__ _|        "
tela0Linha6  : string "                    |___/               "
tela0Linha7  : string "                                        "
tela0Linha8  : string "                 _                      "
tela0Linha9  : string "              __| | __ _ ___            "
tela0Linha10 : string "             / _` |/ _` / __|           "
tela0Linha11 : string "            | (_| | (_| |__ |           "
tela0Linha12 : string "             |__,_||__,_|__/            "
tela0Linha13 : string "                                        "
tela0Linha14 : string "   ____                  _              "
tela0Linha15 : string "  | __ )  __ _ _ __ __ _| |_ __ _ ___   "
tela0Linha16 : string "  |  _ | / _` | '__/ _` | __/ _` / __|  "
tela0Linha17 : string "  | |_) ) (_| | |  |(_| | || (_| |__ |  "
tela0Linha18 : string "  |____/ |__,_|_|  |__,_||__|__,_|___/  "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "     Pressione ENTER para continuar!    "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "

tela1Linha0  : string "                                        "
tela1Linha1  : string "                                        "
tela1Linha2  : string "    Toda vez que eu chego em casa       "
tela1Linha3  : string "    a barata da vizinha ta na minha     "
tela1Linha4  : string "                cama...                 "
tela1Linha5  : string "                                        "
tela1Linha6  : string "    Me diz jogador, o que voce vai      "
tela1Linha7  : string "               fazer?                   "
tela1Linha8  : string "                                        "
tela1Linha9  : string "    Vou pegar um chinelo para me        "
tela1Linha10 : string "              defender!                 "
tela1Linha11 : string "                                        "
tela1Linha12 : string "    Use o A e D para se mover e         "
tela1Linha13 : string "    ESPACO para jogar seu chinelo.      "
tela1Linha14 : string "                                        "
tela1Linha15 : string "                                        "
tela1Linha16 : string "                                        "
tela1Linha17 : string "                                        "
tela1Linha18 : string "                                        "
tela1Linha19 : string "                                        "
tela1Linha20 : string "                                        "
tela1Linha21 : string "        Pressione J para jogar          "
tela1Linha22 : string "                                        "
tela1Linha23 : string "                                        "
tela1Linha24 : string "                                        "
tela1Linha25 : string "                                        "
tela1Linha26 : string "                                        "
tela1Linha27 : string "                                        "
tela1Linha28 : string "                                        "
tela1Linha29 : string "                                        "


; Game Over
gameOverLinha0  : string "                                        "
gameOverLinha1  : string "                                        "
gameOverLinha2  : string "                                        "
gameOverLinha3  : string "                                        "
gameOverLinha4  : string "                                        "
gameOverLinha5  : string "                                        "
gameOverLinha6  : string "                                        "
gameOverLinha7  : string "            G A M E  O V E R            "
gameOverLinha8  : string "                                        "
gameOverLinha9  : string "         Voce deu uma chinelada         "
gameOverLinha10 : string "             na barata dela!            "
gameOverLinha11 : string "                                        "
gameOverLinha12 : string "                                        "
gameOverLinha13 : string "                                        "
gameOverLinha14 : string "               SCORE:                   "
gameOverLinha15 : string "                                        "
gameOverLinha16 : string "                                        "
gameOverLinha17 : string "                                        "
gameOverLinha18 : string "                                        "
gameOverLinha19 : string "        ENTER -> Jogar Novamente        "
gameOverLinha20 : string "                                        "
gameOverLinha21 : string "             SPACE -> Sair              "
gameOverLinha22 : string "                                        "
gameOverLinha23 : string "                                        "
gameOverLinha24 : string "                                        "
gameOverLinha25 : string "                                        "
gameOverLinha26 : string "                                        "
gameOverLinha27 : string "                                        "
gameOverLinha28 : string "                                        "
gameOverLinha29 : string "                                        "

; HUD
stringHud : string " SCORE:                         VIDAS:   "

fim: