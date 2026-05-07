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

        MOV     R0, #0

        SETB    P3.2
        SETB    P3.7

WAIT_RX:
        JNB     RI, WAIT_RX
        MOV     A, SBUF
        CLR     RI

        CJNE    A, #'+', CHK_MINUS
        INC     R0
        CJNE    R0, #10, SHOW_CNT
        MOV     R0, #0
        SJMP    SHOW_CNT

CHK_MINUS:
        CJNE    A, #'-', CHK_ZERO
        DEC     R0
        CJNE    R0, #0FFH, SHOW_CNT
        MOV     R0, #9
        SJMP    SHOW_CNT

CHK_ZERO:
        CJNE    A, #'0', CHK_1_TO_9
        SJMP    SHOW_CNT

CHK_1_TO_9:
        CLR     C
        MOV     R1, A
        SUBB    A, #'1'
        JC      OTHER_KEY
        MOV     A, R1
        SUBB    A, #'9'
        JZ      IS_1_TO_9
        JNC     OTHER_KEY

IS_1_TO_9:
        CLR     P3.2

        MOV     A, R1
        CLR     C
        SUBB    A, #'0'
        MOV     R2, A
        
        CALL    UPDATE_7SEG

BLINK_LOOP:
        CLR     P3.7
        CALL    DELAY_250MS
        SETB    P3.7
        CALL    DELAY_250MS
        DJNZ    R2, BLINK_LOOP

        SJMP    WAIT_RX

OTHER_KEY:
        SETB    P3.2
        MOV     A, #10
        CALL    UPDATE_7SEG
        SJMP    WAIT_RX

SHOW_CNT:
        SETB    P3.2
        MOV     A, R0
        CALL    UPDATE_7SEG
        SJMP    WAIT_RX

UPDATE_7SEG:
        MOV     DPTR, #SEG_TAB
        MOVC    A, @A+DPTR
        MOV     P1, A
        RET

DELAY_250MS:
        MOV     R5, #5
DLY1:   MOV     R6, #100
DLY2:   MOV     R7, #250
        DJNZ    R7, $
        DJNZ    R6, DLY2
        DJNZ    R5, DLY1
        RET

SEG_TAB:
        DB      3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH
        DB      40H
        
        END