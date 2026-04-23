/*
 * ==========================================
 * วิธีต่อวงจร ESP32 (สำหรับจอ Common Cathode)
 * ==========================================
 * [จอ 7-Segment]
 * - ขา Segments (A,B,C,D,E,F,G,DP) -> ต่อเข้า GPIO: 17, 5, 18, 19, 21, 22, 23, 15
 * - ขา Positions (D1,D2,D3,D4) -> ต่อเข้า GPIO: 13, 12, 14, 27
 * * [ปุ่มกด Interrupt]
 * - ปุ่มบวก 2 (+2) -> ขาด้านนึงต่อ GPIO 25 / อีกด้านต่อ GND
 * - ปุ่มลบ 1 (-1)  -> ขาด้านนึงต่อ GPIO 26 / อีกด้านต่อ GND
 * ==========================================
 */

const int segmentPins[] = {17, 5, 18, 19, 21, 22, 23, 15};
const int positionPins[] = {13, 12, 14, 27};

const byte digitPatterns[] = {
  0b00111111, // 0
  0b00000110, // 1
  0b01011011, // 2
  0b01001111, // 3
  0b01100110, // 4
  0b01101101, // 5
  0b01111101, // 6
  0b00000111, // 7
  0b01111111, // 8
  0b01101111  // 9
};

volatile int Counter = 9875; // รหัส 4 ตัวท้าย
volatile unsigned long lastAdd = 0, lastSub = 0; // กันปุ่มเด้ง

const int btnAddPin = 25;
const int btnSubPin = 26;

// ฟังก์ชัน Interrupt (บวก 2)
void IRAM_ATTR ISR_Add() {
  if (millis() - lastAdd > 200) {
    Counter = (Counter + 2) % 10000;
    lastAdd = millis();
  }
}

// ฟังก์ชัน Interrupt (ลบ 1)
void IRAM_ATTR ISR_Sub() {
  if (millis() - lastSub > 200) {
    Counter--;
    if (Counter < 0) Counter = 9999;
    lastSub = millis();
  }
}

void setup() {
  for (int i = 0; i < 8; i++) pinMode(segmentPins[i], OUTPUT);
  for (int i = 0; i < 4; i++) {
    pinMode(positionPins[i], OUTPUT);
    digitalWrite(positionPins[i], HIGH); // Common Cathode ปิดหลักด้วย HIGH
  }
  
  pinMode(btnAddPin, INPUT_PULLUP);
  pinMode(btnSubPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(btnAddPin), ISR_Add, FALLING);
  attachInterrupt(digitalPinToInterrupt(btnSubPin), ISR_Sub, FALLING);
}

void displayDigit(int digit, int position) {
  byte pattern = digitPatterns[digit];
  
  // ปิดทุกหลักก่อน
  for (int p = 0; p < 4; p++) digitalWrite(positionPins[p], HIGH);
  
  // ส่งสัญญาณให้ Segment (Common Cathode จ่าย HIGH ให้ไฟติด)
  for (int i = 0; i < 8; i++) {
    bool bitValue = bitRead(pattern, i); // เอา ! ออก เพื่อส่ง 1 ให้ไฟติด
    digitalWrite(segmentPins[i], bitValue);
  }
  
  // เปิดหลักที่ต้องการ (Common Cathode เปิดหลักด้วย LOW)
  digitalWrite(positionPins[position], LOW);
  delay(5);
  digitalWrite(positionPins[position], HIGH); // ปิดเมื่อเสร็จ
}

void display4Digit(int tempp) {
  tempp %= 10000; displayDigit(tempp / 1000, 3);
  tempp %= 1000;  displayDigit(tempp / 100, 2);
  tempp %= 100;   displayDigit(tempp / 10, 1);
  tempp %= 10;    displayDigit(tempp / 1, 0);
}

void loop() {
  display4Digit(Counter);
}