call menu
call instrucoes
jmp main

; Charmap

;	pessoa 4 partes
;-- # --> P1
;	280	 : 	 00000001;
;	281  :   00000001;
;	282  :   00000001;
;	283  :   00000001;
;	284  :   00000001;
;	285  :	 00010011;
;	286  :   00010111;
;	287  :   01111111;
;
;-- $ --> P2
;	288  :   10000000;
;	289  :   10000000;
;	290  :   10000000;
;	291  :   10000000;
;	292  :   10000000;
;	293  :   11001000;
;	294  :   11101000;
;	295  :   11111110;
;
;-- % --> P3
;	296  :   01111111;
;	297  :   00000011;
;	297  :   00000001;
;	299  :   00000001;
;	300  :   00000001;
;	301  :   00000011;
;	302  :   00001100;
;	303  :   00010000;
;
;-- & --> P4
;	304  :   11111110;
;	305  :   11000000;
;	306  :   10000000;
;	307  :   10000000;
;	308  :   10000000;
;	309  :   11000000;
;	310  :   00110000;
;	311  :   00001000;

;-- * --> barata
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

posPessoa1: var #1		; Coordenada P1
posPessoa2: var #1 		; Coordenada P2
flagTiroPessoa: var #1    ; Flag se pessoa atirou
posTiroPessoa: var #1     ; Posição tiro pessoa (armazena a coordenada da esqueda, na hora de imprimir é somado 1 para imprimir o da direita)

posbarata1: var #1 		; Coordenada A1
posbarata2: var #1 		; Coordenada A2
flagTirobarata: var #1   ; Flag se barata atirou
posTirobarata: var #1 	; Posição tiro pessoa (armazena a coordenada da esqueda, na hora de imprimir é somado 1 para imprimir o da direita)

IncRand: var #1			; Incremento para circular na Tabela de nr. Randomicos
Rand : var #30			; Tabela de nr. Randomicos entre 0 - 1. Para movimentação do barata.
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
	 
	; Impressão da dezena do score
	loadn r2, #10 
	div r3, r0, r2          ; Calcula a dezena (r0 / 10) e salva em r3.
	loadn r4, #48           ; Carrega ASCII de '0' em r4.
	add r3, r3, r4          ; Converte a casa decimal para ASCII.
	outchar r3, r1
	sub r3, r3, r4          ; Restaura o valor numérico da dezena.
	mul r3, r3, r2          ; Calcula o valor decimal da dezena.
	sub r0, r0, r3          ; Atualiza r0 com as unidades restantes.

	; Impressão da unidade do score
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

gameWin:
	loadn r0, #0 					; Posição do começo da tela
	loadn r1, #gameWinLinha0 		; Endereço da tela na memória
	call ImprimeTela 				; imprime tela

	gameWinLerCaractere:
	inchar r0 			; le tecla

	loadn r1, #13 		; r1 = 13 = ENTER
	cmp r0,r1
	jeq main 			; se ENTER foi pressionado, quer jogar denovo, então pula pra main
	
	loadn r1, #' ' 		; r1 = SPACE
	cmp r0, r1
	jeq fim  			; se SPACE foi pressionado, quer sair, então pula pro fim

	jmp gameWinLerCaractere  ; se nenhuma das teclas de interesse foi pressionada, volta pro gameOverLerCaractere

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

	loadn r0, #3 			
	store vidas, r0 		; Quantidade de vidas

	loadn r0, #0
	store score, r0 		; Zera os pontos 

	loadn r0, #1059			; Posição Pessoa1
	store posPessoa1, r0
	loadn r0, #1099			; Posição Pessoa2
	store posPessoa2, r0
	loadn r0, #0
	store flagTiroPessoa, r0 	; Zera flag de tiro da pessoa

	loadn r0, #19 			; Posição barata1
	store posbarata1, r0
	loadn r0, #59
	store posbarata2, r0 	; Posição barata2
	loadn r0, #0
	store flagTirobarata, r0 ; Zera flag de tiro do barata
	
	loadn r0, #0 			; Contador para os mods = 0
	loadn r2, #0 			; Para verificar se r0 % x == 0

	call imprimeHud 		; Imprime as palavras SCORE: e VIDAS: 

	jmp loop 				; pula pro loop



loop:
	; Os mods servem para executar as ações somente nos ciclos em que o contador é múltiplo de algum número.
	; Se r0 % 10 == 0
	; movimentação da pessoa
	loadn r1, #10
	mod r1, r0, r1
	cmp r1, r2
	ceq pessoa
	
	; Se r0 % 2 == 0
	; tiro da pessoa
	loadn r1, #2
	mod r1, r0, r1
	cmp r1, r2
	ceq tiroPessoa

	; Se r0 % 30 == 0
	; movimentação do barata
	loadn r1, #30
	mod r1, r0, r1
	cmp r1, r2
	ceq barata

	; Se r0 % 250 == 0
	; frequência de tiro do barata 
	loadn r1, #250
	mod r1, r0, r1
	cmp r1, r2
	ceq barataAtirou

	; Se r0 % 3 == 0
	; tiro do barata
	loadn r1, #3
	mod r1, r0, r1
	cmp r1, r2
	ceq tirobarata

	call comparaPosicaoTiroPessoa		; compara a posição do tiro da pessoa com o barata

	call imprimeValoresHud 			; imprime os valores dos pontos e das vidas

	push r0 			; protege r0
	push r1 			; protege r1
	loadn r0, #0
	load r1, vidas
	cmp r0, r1
	jeq gameOver 		; if (vidas == 0) gameover 
	pop r1 				; protege r1
	pop r0 				; protege r0
	
	push r0            ; Protege r0
	push r1            ; Protege r1

	loadn r0, #10      ; Carrega 10 em r0
	load r1, score     ; Carrega o valor de score em r1
	cmp r1, r0         ; Compara score com 10
	jeg gameWin        ; Salta para gameWin se score >= 10

	pop r1             ; Restaura r1
	pop r0             ; Restaura r0

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

	; imprime as vidas, valores somente de 0 a 3
	load r0, vidas 	 	; r0 = vidas
	loadn r1, #48 		
	add r0, r0, r1 		; converte pra valor do dígito na tabela ASCII
	loadn r1, #1168  	; lugar da tela para imprimir
	outchar r0, r1 		; imprime

	; imprime os pontos
	; mesma lógica explicada na função gameOver no começo do código
	loadn r1, #1197
	load r0, score

	;impressão do score
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
comparaPosicaoTiroPessoa:
	push r0 
	push r1 
	
	load r0, posTiroPessoa	; pos tiro 1 (esquerda)
	load r1, posbarata1		; pos barata 1 (esquerda)
	cmp r0, r1 				; compara tiro 1 com barata 1
	ceq somaPonto
	
	inc r1 					; pos barata 2 (direita)
	
	cmp r0, r1 				; compara tiro 1 com barata 2
	ceq somaPonto
	
	inc r0					; pos tiro 2 (direita)
	
	cmp r0, r1 				; compara tiro2 com barata 2
	ceq somaPonto
	
	dec r1					; pos barata 1 (esquerda)
	
	cmp r0, r1 				; compara tiro2 com barata 1
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
	
	loadn r0, #0			; reseta a posição do tiro da pessoa
	store posTiroPessoa, r0 	; evita que fique somando infinitamente
	
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

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-pessoa-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
pessoa:
	call PessoaDesenhar
	call PessoaMover
	
	rts

PessoaDesenhar:
	; A pessoa é composta por 4 caracteres
	;			     P1P3
	;				 P2P4

	push r0
	push r1

	loadn r0, #'#'  	; r0 = caractere Pessoa1
	load r1, posPessoa1	; r1 = posição Pessoa1
	outchar r0, r1		; desenha Pessoa1

	inc r0				; r0++ (caractere Pessoa3)
	inc r1				; r1++ (posição Pessoa3)
	outchar r0, r1		; desenha Pessoa3

	inc r0				; r0++ (caractere Pessoa2)
	load r1, posPessoa2	; r1++ (posição Pessoa2)
	outchar r0, r1		; desenha Pessoa2

	inc r0				; r0++ (caractere Pessoa4)
	inc r1				; r1++ (posição Pessoa4)
	outchar r0, r1		; desenha Pessoa4

	pop r1
	pop r0

	rts

PessoaApagar:
	push r0
	push r1
	push r2
	
	loadn r0, #' '			; r0 = ' '
	load r1, posPessoa1		; r1 = posição Pessoa1
	load r2, posPessoa2		; r2 = posição Pessoa2

	outchar r0, r1			; imprime ' ' em P1
	outchar r0, r2			; imprime ' ' em P2

	inc r1					; r1++ (posição Pessoa3)
	inc r2					; r2++ (posição Pessoa4)

	outchar r0, r1			; imprime ' ' em P3
	outchar r0, r2			; imprime ' ' em P4

	pop r2
	pop r1
	pop r0

	rts

PessoaMover:
	push r0
	push r1
	push r2
	push r3

	inchar r0			; Le a tecla digitada
	
	loadn r1, #'a'		; Se a tecla digitada for a, move pra esequerda
	cmp r0, r1
	ceq	PessoaMoveEsq

	loadn r1, #'d' 		; Se a tecla digitada for d, move pra direita
	cmp r0, r1
	ceq PessoaMoveDir

	loadn r1, #' '
	load r2, flagTiroPessoa
	loadn r3, #1
	cmp r2, r3
	jeq PessoaAtirou_Skip 	; Se a flag de tiro já está em 1 pula
	cmp r0, r1 				; Se SPACE foi pressionado e a flag de tiro está em 0, chama PessoaAtirou
	ceq PessoaAtirou
	PessoaAtirou_Skip:

	pop r3
	pop r2
	pop r1
	pop r0

	rts

PessoaMoveEsq:
	push r0
	push r1

	; Caso em que a pessoa está na borda
	load r0, posPessoa1
	loadn r1, #1041
	cmp r0, r1
	jle PessoaMoveEsq_skip	; if (posPessoa1 < 1041) não move

	call PessoaApagar			; Apaga a pessoa

	; Decrementa a posição da pessoa
	load r0, posPessoa1
	load r1, posPessoa2
	dec r0
	dec r1
	store posPessoa1, r0
	store posPessoa2, r1

	call PessoaDesenhar		; Desenha a pessoa na nova coordenada

	PessoaMoveEsq_skip:		; Label para não mover a pessoa

	pop r1
	pop r0

	rts

PessoaMoveDir:
	push r0
	push r1

	; Caso em que a pessoa está na borda
	load r0, posPessoa1
	loadn r1, #1077
	cmp r0, r1
	jgr PessoaMoveDir_skip 	; if (posPessoa1 > 1077) não move

	call PessoaApagar			; Apaga a pessoa

	; Incrementa a posição da pessoa
	load r0, posPessoa1
	load r1, posPessoa2
	inc r0
	inc r1
	store posPessoa1, r0
	store posPessoa2, r1

	call PessoaDesenhar		; Desenha a pessoa na nova coordenada

	PessoaMoveDir_skip:		; Label para não mover a pessoa

	pop r1
	pop r0

	rts

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-TIRO pessoa-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
PessoaAtirou:
	push r0

	loadn r0, #1
	store flagTiroPessoa, r0		; flagTiroPessoa = 1
	load r0, posPessoa1
	store posTiroPessoa, r0       ; posTiroPessoa = posPessoa1

	pop r0
	
	rts
	
tiroPessoa:
	push r0
	push r1

	loadn r0, #1
	load r1, flagTiroPessoa
	cmp r0, r1
	ceq tiroPessoaMover 			; Se flagTiroPessoa == 1 chama tiroPessoaMover

	pop r1
	pop r0

	rts

tiroPessoaMover:
	push r0
	push r1
	push r2

	load r0, posTiroPessoa		; r0 = posTiroPessoa
	call tiroPessoaApagar 		; apaga tiro
	loadn r2, #40 				; move a posição do tiro uma linha pra cima
	sub r0, r0, r2

	loadn r1, #40
	cmp r0, r1
	cle tiroPessoaPassouPrimeiraLinha ; if (posTiro < 40) passouPrimeiraLinha


	store posTiroPessoa, r0  			; armazena nova posição na variavel
	call tiroPessoaDesenhar 			; desenha o tiro

	pop r2
	pop r1
	pop r0

	rts

tiroPessoaPassouPrimeiraLinha:
	push r0
	push r1
	push r2

	; flagTiroPessoa = 0
	loadn r0, #0
	store flagTiroPessoa, r0

	loadn r1, #' '
	load r2, posTiroPessoa

	outchar r1, r2  		; Desenha ' ' na posTiroPessoa
	inc r2
	outchar r1, r2 

	pop r2
	pop r1
	pop r0

	rts

tiroPessoaDesenhar:
	push r1 
	push r2 
	push r3
	push r4
	push r5
	push r6
	
	load r1, flagTiroPessoa
	loadn r2, #0
	cmp r1, r2
	jeq tiroPessoaDesenhar_Skip 	; if (flagTiro == 0) skip

	load r1, posTiroPessoa
	loadn r2, #'W'
	loadn r3, #'X'
	loadn r4, #'w'
	loadn r5, #'x'

	outchar r2, r1 				; Desenha '|' na posTiroPessoa
	
	inc r1 						
	outchar r3, r1 				; Desenha '|' na posTiroPessoa + 1

	dec r1
	loadn r6, #40
	add r1, r1, r6

	outchar r4, r1

	inc r1

	outchar r5, r1



	
	tiroPessoaDesenhar_Skip:
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1 
	
	rts

tiroPessoaApagar:
	push r0
	push r1
	push r2
	push r3

	loadn r0, #' '
	load r1, posTiroPessoa

	; if (posTiro == posPessoa) skip  
	load r2, posPessoa1
	loadn r3, #40
	cmp r1, r2
	jeq tiroPessoaApagar_Skip

	add r1, r1, r3
	outchar r0, r1  		; Desenha ' ' na posTiroPessoa
	inc r1
	outchar r0, r1 			; Desenha ' ' na posTiroPessoa + 1

	tiroPessoaApagar_Skip:

	pop r3
	pop r2
	pop r1
	pop r0

	rts

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-barata-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
barata:
	call barataDesenhar
	call barataMover

	rts

barataDesenhar:
	; O barata é composto por 4 caracteres
	;			     A1A3
	;				 A2A4	
	push r0
	push r1

	; Mesma lógica de impressão da pessoa

	loadn r0, #0
	load r1, posbarata1
	outchar	r0, r1

	inc r0
	inc r1
	outchar r0, r1

	inc r0
	load r1, posbarata2
	outchar r0, r1

	inc r0
	inc r1
	outchar r0, r1

	pop r1
	pop r0

	rts

barataApagar:
	push r0
	push r1

	; Mesma lógica de apagar a pessoa

	loadn r0, #' '
	load r1, posbarata1
	outchar r0, r1

	inc r1
	outchar r0, r1

	load r1, posbarata2
	outchar r0, r1

	inc r1
	outchar r0, r1

	pop r1
	pop r0

	rts

barataMover:
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
	jne barataMover_skipResetTabela ; if (r1 != 30) não reseta a tabela
	loadn r1, #0 				   ; else reseta -> r1 = 0
	barataMover_skipResetTabela:
	store IncRand, r1 			   ; armazena novo IncRand

	loadn r0, #0 				   ; if (r2 == 0) moveEsq	
	cmp r0, r2
	ceq barataMoverEsq

	loadn r0, #1 				   ; if (r2 == 1) moveDir
	cmp r0, r2
	ceq barataMoverDir

	pop r2
	pop r1
	pop r0

	rts

barataMoverEsq:
	push r0
	push r1

	load r0, posbarata1
	loadn r1, #1
	cmp r0, r1
	jle barataMoverEsq_Skip  ; Se está na borda esquerda, não move mais

	call barataApagar 		; Apaga o barata

	; Decrementa pos
	load r0, posbarata1
	load r1, posbarata2
	dec r0
	dec r1
	store posbarata1, r0
	store posbarata2, r1

	; Desenha o barata
	call barataDesenhar

	barataMoverEsq_Skip:

	pop r1
	pop r0

	rts

barataMoverDir:
	push r0
	push r1

	load r0, posbarata1 		; Se está na borda direita, não move mais
	loadn r1, #37
	cmp r0, r1
	jgr barataMoverDir_Skip

	call barataApagar 		; Apaga o barata

	; Incrementa pos
	load r0, posbarata1
	load r1, posbarata2
	inc r0
	inc r1
	store posbarata1, r0
	store posbarata2, r1

	; Desehna barata
	call barataDesenhar

	barataMoverDir_Skip:

	pop r1
	pop r0

	rts

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-TIRO barata-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
barataAtirou:
	push r0
	push r1

	loadn r0, #1
	load r1, flagTirobarata
	cmp r0, r1
	jeq barataAtirou_Skip  		; se flagTirobarata já está em 1, pula, para não resetar indevidamente posTirobarata

	loadn r0, #1
	store flagTirobarata, r0		; flagTirobarata = 1
	load r0, posbarata2
	store posTirobarata, r0       ; posTirobarata = posbarata2

	barataAtirou_Skip:

	pop r1
	pop r0
	
	rts
	
tirobarata:
	push r0
	push r1

	loadn r0, #1
	load r1, flagTirobarata
	cmp r0, r1
	ceq tirobarataMover 			; Se flagTirobarata == 1 chama tirobarataMover

	pop r1
	pop r0

	rts

tirobarataMover:
	push r0
	push r1
	push r2

	load r0, posTirobarata		; r0 = posTirobarata
	call tirobarataApagar 		; apaga tiro
	loadn r2, #40 				; move a posição do tiro uma linha pra baixo
	add r0, r0, r2

	loadn r1, #1080
	cmp r0, r1
	cgr tirobarataPassouUltimaLinha ; if (posTiro > 1080) passouUltimaLinha

	; if (posTirobarata == posPessoa1 || posTirobarata == posPessoa1 + 1 || posTirobarata == posPessoa1 - 1) decrementa 

	; T1 T2 ||    T1 T2 || T1 T2
	; P1 P2 || P1 P2    ||    P1 P2

	; T = tirobarata    N = pessoa

	; posTirobarata = T1
	; posPessoa1 = P1

	load r1, posPessoa1
	cmp r0, r1
	ceq decVidas
	inc r1
	cmp r0, r1
	ceq decVidas
	dec r1
	dec r1
	cmp r0, r1
	ceq decVidas

	store posTirobarata, r0  			; armazena nova posição na variavel
	call tirobarataDesenhar 			 	; desenha o tiro

	pop r2
	pop r1
	pop r0

	rts

tirobarataPassouUltimaLinha:
	push r0

	; flagTirobarata = 0
	loadn r0, #0
	store flagTirobarata, r0

	pop r0

	rts

tirobarataDesenhar:
	push r1 
	push r2 
	
	load r1, flagTirobarata
	loadn r2, #0
	cmp r1, r2
	jeq tirobarataDesenhar_Skip 	; if (flagTirobarata == 0) skip

	load r1, posTirobarata
	loadn r2, #4
	outchar r2, r1 				; Desenha ' |' na posTirobarata
	
	inc r2
	inc r1 						
	outchar r2, r1 				; Desenha '| ' na posTirobarata + 1
	
	tirobarataDesenhar_Skip:
	pop r2
	pop r1 
	
	rts

tirobarataApagar:
	push r0
	push r1
	push r2

	loadn r0, #' '
	load r1, posTirobarata

	; if (posTiroAlein == posbarata2) skip  
	load r2, posbarata2
	cmp r1, r2
	jeq tirobarataApagar_Skip

	outchar r0, r1  		; Desenha ' ' na posTirobarata
	inc r1
	outchar r0, r1 			; Desenha ' ' na posTirobarata + 1

	tirobarataApagar_Skip:

	pop r2
	pop r1
	pop r0

	rts



; Funções de utilidade -> FONTE: https://github.com/simoesusp/Processador-ICMC/blob/master/Software_Assembly/Pessoa11.asm
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
tela1Linha6  : string "                                        "
tela1Linha7  : string "                                        "
tela1Linha8  : string "    Me diz jogador, o que voce vai      "                             
tela1Linha9  : string "                fazer?                  "
tela1Linha10 : string "    Vou dar uma chinelada para me       "
tela1Linha11 : string "               defender!                "
tela1Linha12 : string "                                        "
tela1Linha13 : string "                                        "
tela1Linha14 : string "                                        "
tela1Linha15 : string "                                        "    
tela1Linha16 : string "                                        "
tela1Linha17 : string "                                        "
tela1Linha18 : string "                                        "
tela1Linha19 : string "             INSTRUCOES                 "
tela1Linha20 : string "    Use o A e D para se mover e         "
tela1Linha21 : string "    ESPACO para jogar seu chinelo       "
tela1Linha22 : string "                                        "
tela1Linha23 : string "                                        "
tela1Linha24 : string "                                        "
tela1Linha25 : string "                                        "
tela1Linha26 : string "        Pressione J para jogar          "
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
gameOverLinha9  : string "         Voce  precisa treinar mais     "
gameOverLinha10 : string "           as suas chineladas!          "
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



; Game Win
gameWinLinha0  : string "                                        "
gameWinLinha1  : string "                                        "
gameWinLinha2  : string "                                        "
gameWinLinha3  : string "                                        "
gameWinLinha4  : string "                                        "
gameWinLinha5  : string "                                        "
gameWinLinha6  : string "                                        "
gameWinLinha7  : string "         V O C E   G A N H O U !        "
gameWinLinha8  : string "                                        "
gameWinLinha9  : string "         Voce deu uma chinelada         "
gameWinLinha10 : string "             na barata dela!            "
gameWinLinha11 : string "                                        "
gameWinLinha12 : string "                                        "
gameWinLinha13 : string "                                        "
gameWinLinha14 : string "                                        "
gameWinLinha15 : string "                                        "
gameWinLinha16 : string "                                        "
gameWinLinha17 : string "                                        "
gameWinLinha18 : string "                                        "
gameWinLinha19 : string "        ENTER -> Jogar Novamente        "
gameWinLinha20 : string "                                        "
gameWinLinha21 : string "             SPACE -> Sair              "
gameWinLinha22 : string "                                        "
gameWinLinha23 : string "                                        "
gameWinLinha24 : string "                                        "
gameWinLinha25 : string "                                        "
gameWinLinha26 : string "                                        "
gameWinLinha27 : string "                                        "
gameWinLinha28 : string "                                        "
gameWinLinha29 : string "                                        "


; HUD
stringHud : string " VIDAS:                        SCORE:   "

fim: