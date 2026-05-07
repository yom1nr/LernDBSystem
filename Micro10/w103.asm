ORG     0000H
        JMP     0100H

        ORG     0100H
MAIN:
        MOV     SP, #3FH
        CLR     EA
        
        MOV     TMOD, #20H
        MOV     SCON, #50H
        MOV     TH1, #0FDH
        SETB    TR1

        MOV     P2, #0FFH
        MOV     P1, #00H

MAIN_LOOP:
        JNB     RI, CHECK_SWITCH
        MOV     A, SBUF
        CLR     RI

        CLR     C
        MOV     R1, A
        SUBB    A, #'0'
        JC      CHECK_SWITCH
        MOV     A, R1
        SUBB    A, #'9'
        JZ      VALID_NUM
        JNC     CHECK_SWITCH

VALID_NUM:
        MOV     A, R1
        CLR     C
        SUBB    A, #'0'
        MOV     DPTR, #SEG_TAB
        MOVC    A, @A+DPTR
        MOV     P1, A

CHECK_SWITCH:
        JNB     P2.0, SW0_PRESSED
        JNB     P2.1, SW1_PRESSED
        JNB     P2.2, SW2_PRESSED
        JNB     P2.3, SW3_PRESSED
        SJMP    MAIN_LOOP

SW0_PRESSED:
        CALL    DELAY_20MS
        JB      P2.0, MAIN_LOOP
        MOV     A, #'0'
        CALL    SEND_TX
WAIT_REL0: 
        JNB     P2.0, WAIT_REL0
        SJMP    MAIN_LOOP

SW1_PRESSED:
        CALL    DELAY_20MS
        JB      P2.1, MAIN_LOOP
        MOV     A, #'1'
        CALL    SEND_TX
WAIT_REL1: 
        JNB     P2.1, WAIT_REL1
        SJMP    MAIN_LOOP

SW2_PRESSED:
        CALL    DELAY_20MS
        JB      P2.2, MAIN_LOOP
        MOV     A, #'2'
        CALL    SEND_TX
WAIT_REL2: 
        JNB     P2.2, WAIT_REL2
        SJMP    MAIN_LOOP

SW3_PRESSED:
        CALL    DELAY_20MS
        JB      P2.3, MAIN_LOOP
        MOV     A, #'3'
        CALL    SEND_TX
WAIT_REL3: 
        JNB     P2.3, WAIT_REL3
        SJMP    MAIN_LOOP

SEND_TX:
        CLR     TI
        MOV     SBUF, A
        JNB     TI, $
        CLR     TI
        RET

DELAY_20MS:
        MOV     R6, #40
DLY1:   MOV     R7, #250
        DJNZ    R7, $
        DJNZ    R6, DLY1
        RET

SEG_TAB:
        DB      3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH
        
        END