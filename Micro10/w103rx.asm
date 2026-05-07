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

        MOV     P1, #00H

WAIT_RX:
        JNB     RI, WAIT_RX
        MOV     A, SBUF
        CLR     RI

        CLR     C
        MOV     R1, A
        SUBB    A, #'0'
        JC      WAIT_RX
        
        MOV     A, R1
        SUBB    A, #'9'
        JZ      VALID_NUM
        JNC     WAIT_RX

VALID_NUM:
        MOV     A, R1
        CLR     C
        SUBB    A, #'0'
        MOV     DPTR, #SEG_TAB
        MOVC    A, @A+DPTR
        MOV     P1, A
        SJMP    WAIT_RX

SEG_TAB:
        DB      3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH
        
        END