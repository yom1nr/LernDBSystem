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

MAIN_LOOP:
        MOV     R2, #10           

PRINT_INFO:
        MOV     DPTR, #STR_INFO
        CALL    SEND_STRING
        CALL    DELAY_500MS
        DJNZ    R2, PRINT_INFO    

PRINT_WANT_A:
        MOV     DPTR, #STR_WANT_A
        CALL    SEND_STRING
        CALL    DELAY_500MS

        SJMP    $                  

SEND_STRING:
        CLR     A
        MOVC    A, @A+DPTR
        JZ      SEND_STRING_END
        CALL    SEND_CHAR
        INC     DPTR
        SJMP    SEND_STRING
SEND_STRING_END:
        RET

SEND_CHAR:
        CLR     TI
        MOV     SBUF, A
        JNB     TI, $
        CLR     TI
        RET

DELAY_500MS:
        MOV     R5, #5
DLY1:   MOV     R6, #200
DLY2:   MOV     R7, #250
        DJNZ    R7, $
        DJNZ    R6, DLY2
        DJNZ    R5, DLY1
        RET

STR_INFO:
        DB      'B6729875 Roek Watthanawongsa', 0DH, 0AH, 00H
STR_WANT_A:
        DB      'I Want A', 0DH, 0AH, 00H

        END