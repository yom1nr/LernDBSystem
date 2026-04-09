	ORG	0000H
	MOV	P1, #0FFH
	MOV	P2, #00H
	
MAIN:	MOV	A,P1
	CPL	A
	ANL	A, #0FH
	JZ	SHOW
	
	MOV	DPTR, #TABLE
	MOVC	A, @A+DPTR
	MOV	P2,A
	JMP	MAIN
	
SHOW:	MOV	P2,#01000000B
	JMP	MAIN
	
TABLE:
	DB 00111111B
	DB 00000110B
	DB 01011011B
	DB 01001111B
    	DB 01100110B
    	DB 01101101B
    	DB 01111101B
    	DB 00000111B
    	DB 01111111B
 	DB 01101111B
    	DB 01110111B
    	DB 01111100B
    	DB 00111001B
    	DB 01011110B
    	DB 01111001B
    	DB 01110001B
	
	END
    ORG 0000H
    MOV P1, #0FFH    

MAIN:
    MOV A, P1  
    CPL A         
    ANL A, #0FH     
    JZ DASH           

    MOV DPTR, #TAB  
    MOVC A, @A+DPTR
    MOV P2, A     
    SJMP MAIN           

DASH:
    MOV P2, #40H       
    SJMP MAIN


TAB: 
    DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H 
    DB 7FH, 6FH, 77H, 7CH, 39H, 5EH, 79H, 71H
    END
//S
    ORG 0000H
    MOV P1, #0FFH
    MOV A, #01H         
    MOV R0, #1          

MAIN:
    JNB P1.0, M1
    JNB P1.1, M2
    JNB P1.2, M3
    JNB P1.3, M4
    SJMP RUN            

M1: MOV R0, #1
    SJMP RUN
M2: MOV R0, #2
    SJMP RUN
M3: MOV R0, #3
    SJMP RUN
M4: MOV R0, #4

RUN:
    CJNE R0, #1, C2    
    RL A
    MOV R7, #1          
    SJMP OUT
C2: CJNE R0, #2, C3   
    RL A
    MOV R7, #5          
    SJMP OUT
C3: CJNE R0, #3, C4   
    RR A
    MOV R7, #5
    SJMP OUT
C4: RR A               
    MOV R7, #1

OUT:
    MOV P2, A
    CALL DLY
    SJMP MAIN

DLY: MOV R6, #200       
D1:  MOV R5, #200
D2:  DJNZ R5, D2
     DJNZ R6, D1
     DJNZ R7, DLY
     RET
     END


    ORG 0000H
    MOV P1, #0FFH       
    MOV P2, #00H        

MAIN:

B0: JB P1.0, B1         
    CALL DLY            
    JB P1.0, B1         
    CPL P2.0            
W0: JNB P1.0, W0        


B1: JB P1.1, B2
    CALL DLY
    JB P1.1, B2
    CPL P2.1
W1: JNB P1.1, W1


B2: JB P1.2, B3
    CALL DLY
    JB P1.2, B3
    CPL P2.2
W2: JNB P1.2, W2

; --- ปุ่ม 3 ---
B3: JB P1.3, MAIN       
    CALL DLY
    JB P1.3, MAIN
    CPL P2.3
W3: JNB P1.3, W3
    SJMP MAIN           

DLY: MOV R6, #50
D1:  MOV R5, #255
D2:  DJNZ R5, D2
     DJNZ R6, D1
     RET
     END


