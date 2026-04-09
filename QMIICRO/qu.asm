ORG 0000H
    JMP START

    ORG 0100H
START:
    MOV P1, #0FFH      
    MOV P2, #0FFH     

MAIN:
CHK0:
    JB P1.0, CHK1     
    CALL DELAY_DB       
    JB P1.0, CHK1     
    CPL P2.0            
W0: JNB P1.0, W0     


CHK1:
    JB P1.1, CHK2
    CALL DELAY_DB
    JB P1.1, CHK2
    CPL P2.1
W1: JNB P1.1, W1


CHK2:
    JB P1.2, CHK3
    CALL DELAY_DB
    JB P1.2, CHK3
    CPL P2.2
W2: JNB P1.2, W2


CHK3:
    JB P1.3, MAIN_END
    CALL DELAY_DB
    JB P1.3, MAIN_END
    CPL P2.3
W3: JNB P1.3, W3

MAIN_END:
    JMP MAIN           


DELAY_DB:
    MOV R6, #50         
DL1:MOV R5, #255
DL2:DJNZ R5, DL2
    DJNZ R6, DL1
    RET
    END