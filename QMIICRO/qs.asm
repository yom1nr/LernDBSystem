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