T2CON	EQU	0C8H
RCAP2L	EQU	0CAH 
RCAP2H	EQU	0CBH 
RX_Data	EQU	30H

	ORG	0000H	
	JMP	0100H
	
	ORG	0023H
	JMP	Serial_ISR
	
	ORG	0100H
	MOV	SP,#3FH
	CLR	EA	 
	CALL	Delay_250M	
	CALL	Initial_Serial	  
	CALL	Send_ClrScr
	SETB	ES
	SETB	EA
		
Main_Loop:
	CALL	Display
	JMP	Main_Loop	
	
Display:	
	MOV	DPTR,#Seg_Tab
	MOV	A,RX_Data
	SETB	P1.4
	CLR	P1.5
	CALL	_Display
	MOV	A,RX_Data
	CLR	P1.4
	SETB	P1.5
	SWAP	A
_Display:	
	ANL	A,#0FH
	MOVC	A,@A+DPTR
	CPL	A
	MOV	P0,A
	CLR	A
	DJNZ	Acc,$
	RET	
		

Seg_Tab:	DB 	77H, 11H, 6DH, 5DH, 1BH, 5EH, 7EH, 15H
	DB	7FH, 5FH, 3FH, 7AH, 66H, 79H, 6EH, 2EH

Serial_ISR:
	CLR	ES		; Disable Serial Interrupts
	JB	TI,_X_Srl	; If Tx Exit
	MOV 	A,SBUF	; Save Data
	MOV	SBUF,A	; Echo Data
	MOV	Rx_Data,A	; Save to Variable
_X_Srl:	CLR	TI		; Clear Ti Flag
	CLR	RI		; Clear Ri Flag
	SETB	ES		; Enable Serial Interrupts
	RETI			; Return from Interrupts

$INCLUDE (myDelay.A51)
$INCLUDE (mySerial.A51)

	END		

