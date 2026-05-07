ORG     0000H
        JMP     MAIN

        ORG     0100H
MAIN:
        MOV     SP, #3FH
        CLR     EA              ; ปิด Interrupt (ใช้แบบวนลูปเช็คเอา)
        
        ; --- 1. ตั้งค่า Timer และ Counter ---
        ; TMOD = 0010 0101B (25H)
        ; -> ครึ่งซ้าย (20H) : ตั้ง Timer 1 เป็น Mode 2 (ใช้สร้าง Baud Rate 9600)
        ; -> ครึ่งขวา (05H) : ตั้ง Timer 0 เป็น Counter Mode 1 (รับสัญญาณนับจากภายนอกที่ขา P3.4)
        MOV     TMOD, #25H      
        
        ; --- 2. ตั้งค่า Serial Port (9600 bps @ คริสตัล 11.0592 MHz) ---
        MOV     TH1, #0FDH      ; ค่า TH1 สำหรับ 9600 bps
        MOV     SCON, #50H      ; Serial Mode 1, อนุญาตให้รับ-ส่ง (REN=1)
        SETB    TR1             ; สตาร์ท Timer 1 ให้ Serial เริ่มทำงาน

        ; --- 3. ตั้งค่า Counter 0 (ตัวนับชิ้นงาน) ---
        MOV     TH0, #0         ; เคลียร์ค่านับหลักบนให้เป็น 0
        MOV     TL0, #0         ; เคลียร์ค่านับหลักล่างให้เป็น 0
        SETB    TR0             ; สตาร์ท Counter 0 ให้เริ่มรอรับ Pulse ชิ้นงาน

MAIN_LOOP:
        ; --- สเต็ป A: ส่งข้อความ "Data Count = " ---
        MOV     DPTR, #STR_DATA
        CALL    SEND_STRING

        ; --- สเต็ป B: ดึงค่านับ (TH0) มาแปลงเป็นตัวหนังสือ 2 ตัวแล้วส่งออก ---
        MOV     A, TH0
        CALL    SEND_HEX_BYTE

        ; --- สเต็ป C: ดึงค่านับ (TL0) มาแปลงเป็นตัวหนังสือ 2 ตัวแล้วส่งออก ---
        MOV     A, TL0
        CALL    SEND_HEX_BYTE

        ; --- สเต็ป D: ส่งคำสั่งขึ้นบรรทัดใหม่ (Enter) ---
        MOV     A, #0DH         ; รหัส CR (Carriage Return) ให้กลับไปต้นบรรทัด
        CALL    SEND_CHAR
        MOV     A, #0AH         ; รหัส LF (Line Feed) ให้ปัดตกบรรทัดใหม่
        CALL    SEND_CHAR

        ; --- สเต็ป E: หน่วงเวลา 0.5 วินาที ตามโจทย์สั่ง ---
        CALL    DELAY_500MS
        
        SJMP    MAIN_LOOP       ; วนลูปส่งข้อมูลแบบนี้ไปเรื่อยๆ

; ==========================================
; โปรแกรมย่อย: แปลงค่า 1 Byte เป็นอักษรฐาน 16 (2 ตัว) แล้วส่งออก Serial
; ==========================================
SEND_HEX_BYTE:
        PUSH    ACC             ; เก็บค่าดั้งเดิมไว้ก่อน
        SWAP    A               ; สลับ 4 บิตบนมาไว้ครึ่งล่าง (เพื่อทำตัวหน้าก่อน)
        CALL    NIBBLE_TO_ASCII
        CALL    SEND_CHAR       ; ส่งตัวอักษรตัวหน้าออกไป
        
        POP     ACC             ; ดึงค่าดั้งเดิมกลับมา
        CALL    NIBBLE_TO_ASCII ; ทำ 4 บิตล่าง
        CALL    SEND_CHAR       ; ส่งตัวอักษรตัวหลังออกไป
        RET

NIBBLE_TO_ASCII:
        ANL     A, #0FH         ; ตัดเอาแค่ 4 บิตล่างมาพิจารณา
        PUSH    DPH             ; เซฟค่า DPTR เดิมเก็บไว้ก่อน
        PUSH    DPL
        MOV     DPTR, #HEX_TABLE
        MOVC    A, @A+DPTR      ; ไปดึงตัวอักษร '0'-'F' จากตารางด้านล่าง
        POP     DPL             ; คืนค่า DPTR กลับมา
        POP     DPH
        RET

; ==========================================
; โปรแกรมย่อย: ส่งข้อความยาวๆ (String)
; ==========================================
SEND_STRING:
        CLR     A
        MOVC    A, @A+DPTR
        JZ      SEND_STRING_END ; ถ้าดึงข้อมูลมาเจอเลข 00H แปลว่าจบประโยค ให้หยุด
        CALL    SEND_CHAR
        INC     DPTR
        SJMP    SEND_STRING
SEND_STRING_END:
        RET

; ==========================================
; โปรแกรมย่อย: ส่งอักขระ 1 ตัว (Char)
; ==========================================
SEND_CHAR:
        CLR     TI              ; เคลียร์ธงรอส่ง
        MOV     SBUF, A         ; ยัดข้อมูลลงท่อส่ง
        JNB     TI, $           ; ยืนรอจนกว่าจะส่งเสร็จ (TI เด้งเป็น 1)
        CLR     TI              ; ส่งเสร็จแล้วเคลียร์ธงทิ้ง
        RET

; ==========================================
; โปรแกรมย่อย: หน่วงเวลา 500ms (0.5 วินาที)
; ==========================================
DELAY_500MS:
        MOV     R5, #5
DLY1:   MOV     R6, #200
DLY2:   MOV     R7, #250
        DJNZ    R7, $
        DJNZ    R6, DLY2
        DJNZ    R5, DLY1
        RET

; ==========================================
; ฐานข้อมูลตัวหนังสือ
; ==========================================
STR_DATA:   
        DB      'Data Count = ', 00H
HEX_TABLE:  
        DB      '0123456789ABCDEF'

        END