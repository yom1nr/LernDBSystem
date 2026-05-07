ORG     0000H
        JMP     0100H
        ORG     0100H
MAIN:
        MOV     SP, #3FH
        CLR     EA
        MOV     TMOD, #20H
        MOV     SCON, #50H
        MOV     TH1, #0FDH
        MOV     TL1, #0FDH
        SETB    TR1
        MOV     R0, #0
        SETB    P3.2
        SETB    P3.7
        MOV     A, R0
        CALL    UPDATE_7SEG
WAIT_RX:
        JNB     RI, WAIT_RX
        MOV     A, SBUF
        CLR     RI
        CJNE    A, #0DH, _N_CR
        SJMP    WAIT_RX
_N_CR:
        CJNE    A, #0AH, _N_LF
        SJMP    WAIT_RX
_N_LF:
        CJNE    A, #20H, _N_SP
        SJMP    WAIT_RX
_N_SP:
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
        SETB    P3.2
        MOV     A, R1
        CLR     C
        SUBB    A, #'0'
        MOV     R0, A
        MOV     R2, A
        CALL    UPDATE_7SEG
BLINK_LOOP:
        SETB    P3.7
        CALL    DELAY_250MS
        CLR     P3.7
        CALL    DELAY_250MS
        DJNZ    R2, BLINK_LOOP
        SJMP    WAIT_RX
OTHER_KEY:
        CLR     P3.2
        MOV     A, #10
        CALL    UPDATE_7SEG
        SJMP    WAIT_RX
SHOW_CNT:
        CLR     P3.2
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
DLY2:   MOV     R7, #228
        DJNZ    R7, $
        DJNZ    R6, DLY2
        DJNZ    R5, DLY1
        RET
SEG_TAB:
        DB      3FH   ; 0
        DB      06H   ; 1
        DB      5BH   ; 2
        DB      4FH   ; 3
        DB      66H   ; 4
        DB      6DH   ; 5
        DB      7DH   ; 6
        DB      07H   ; 7
        DB      7FH   ; 8
        DB      6FH   ; 9
        DB      40H   ; – ขีดกลาง (segment g เท่านั้น)
        END