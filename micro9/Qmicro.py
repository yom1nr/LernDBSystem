from machine import Pin
import time

# --- การตั้งค่าขา Pin ตามเอกสาร ---
seg_pins_numbers = [17, 5, 18, 19, 21, 22, 23, 15]
pos_pins_numbers = [13, 12, 14, 27]

segments = [Pin(p, Pin.OUT) for p in seg_pins_numbers]
positions = [Pin(p, Pin.OUT) for p in pos_pins_numbers]

# รูปแบบบิต 0-9 
digit_patterns = [
    0b00111111, # 0
    0b00000110, # 1
    0b01011011, # 2
    0b01001111, # 3
    0b01100110, # 4
    0b01101101, # 5
    0b01111101, # 6
    0b00000111, # 7
    0b01111111, # 8
    0b01101111  # 9
]

# --- 1. ตั้งค่าเริ่มต้น 4 ตัวท้าย ---
counter = 9875 

# --- 2. กำหนดขาปุ่มกด Interrupt ---
# ใช้ GPIO 25 สำหรับ +2 และ GPIO 26 สำหรับ -1 (แบบ Pull-up ภายใน)
btn_add = Pin(25, Pin.IN, Pin.PULL_UP)
btn_sub = Pin(26, Pin.IN, Pin.PULL_UP)

# ตัวแปรสำหรับจับเวลาเพื่อกันปุ่มเด้ง (Debounce)
last_add_time = 0
last_sub_time = 0

# --- 3. ฟังก์ชัน Interrupt ---
def isr_add(pin):
    global counter, last_add_time
    current_time = time.ticks_ms()
    if time.ticks_diff(current_time, last_add_time) > 200: # กันปุ่มเด้ง 200ms
        counter = (counter + 2) % 10000  # บวก 2 แบบวนลูป
        last_add_time = current_time

def isr_sub(pin):
    global counter, last_sub_time
    current_time = time.ticks_ms()
    if time.ticks_diff(current_time, last_sub_time) > 200: # กันปุ่มเด้ง 200ms
        counter -= 1
        if counter < 0:
            counter = 9999  # ลด 1 แบบวนลูป
        last_sub_time = current_time

# ผูก Interrupt (ทำงานตอนกดปุ่ม = ขอบขาลง)
btn_add.irq(trigger=Pin.IRQ_FALLING, handler=isr_add)
btn_sub.irq(trigger=Pin.IRQ_FALLING, handler=isr_sub)

# --- 4. ฟังก์ชันแสดงผลสำหรับจอ Common Cathode ---
def display_digit(digit, pos_index):
    pattern = digit_patterns[digit]
    
    # ดับทุกหลักก่อนกันภาพซ้อน (Common Cathode ปิดด้วย 1)
    for p in positions:
        p.value(1)
        
    # ส่งสัญญาณไฟเข้าแต่ละข้อ (Segments)
    for i in range(8):
        bit_value = (pattern >> i) & 0x01
        segments[i].value(bit_value)  # Common Cathode ติดสว่างด้วย 1
        
    # เปิดหลักที่ต้องการให้แสดง (Common Cathode เปิดด้วย 0)
    positions[pos_index].value(0)
    time.sleep_ms(5)
    
    # ปิดหลักเมื่อเสร็จ
    positions[pos_index].value(1)

def display_4_digit(number):
    number %= 10000
    display_digit(number // 1000, 3)
    display_digit((number // 100) % 10, 2)
    display_digit((number // 10) % 10, 1)
    display_digit(number % 10, 0)

# --- 5. ลูปหลักทำงาน ---
while True:
    display_4_digit(counter)
