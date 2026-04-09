Data_Count      EQU     40H
Left_Select     EQU     P1.4
Right_Select    EQU     P1.5
Segment_Port    EQU     P2

        ORG     0000H
        JMP     START

        ORG     0013H
        JMP     EX1_ROUTINE

        ORG     0100H
START:  
        SETB    IT1
        MOV     IE, #10000100B
        MOV     Data_Count, #75H

Main_Loop:
        CALL    Show_Tens
        CALL    Show_Units
        JMP     Main_Loop

EX1_ROUTINE:
        PUSH    B
        PUSH    Acc
        
        MOV     A, Data_Count
        ADD     A, #01H
        DA      A
        MOV     Data_Count, A

        CALL    Delay_750ms
        CLR     IE1
        
        POP     Acc
        POP     B
        RETI

Show_Tens:
        SETB    Right_Select
        MOV     A, Data_Count
        SWAP    A
        ANL     A, #0FH
        CALL    Get_Code
        MOV     Segment_Port, A
        CLR     Left_Select
        CALL    Delay_Mux
        SETB    Left_Select
        RET

Show_Units:
        SETB    Left_Select
        MOV     A, Data_Count
        ANL     A, #0FH
        CALL    Get_Code
        MOV     Segment_Port, A
        CLR     Right_Select
        CALL    Delay_Mux
        SETB    Right_Select
        RET

Get_Code:
        MOV     DPTR, #CODE_TABLE
        MOVC    A, @A+DPTR
        RET

Delay_Mux:
        MOV     R6, #10
M1:     MOV     R7, #100
M2:     DJNZ    R7, M2
        DJNZ    R6, M1
        RET

Delay_750ms:
        MOV     R5, #15
D1:     MOV     R6, #200
D2:     MOV     R7, #125
D3:     NOP
        DJNZ    R7, D3
        DJNZ    R6, D2
        DJNZ    R5, D1
        RET

CODE_TABLE: 
        DB      3FH
        DB      06H
        DB      5BH
        DB      4FH
        DB      66H
        DB      6DH
        DB      7DH
        DB      07H
        DB      7FH
        DB      6FH
        END