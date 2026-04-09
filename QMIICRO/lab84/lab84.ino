const int DIN_PIN = 23;
const int CLK_PIN = 18;
const int CS_PIN = 5;

const int BTN_UP = 19;
const int BTN_DOWN = 21;

volatile int counter = 0;
volatile bool countChanged = true;

volatile unsigned long last_time_up = 0;
volatile unsigned long last_time_down = 0;
const unsigned long DEBOUNCE_DELAY = 250;

void sendMAX7219(byte address, byte data) {
  digitalWrite(CS_PIN, LOW);
  shiftOut(DIN_PIN, CLK_PIN, MSBFIRST, address);
  shiftOut(DIN_PIN, CLK_PIN, MSBFIRST, data);
  digitalWrite(CS_PIN, HIGH);
}

void setupMAX7219() {
  pinMode(DIN_PIN, OUTPUT);
  pinMode(CLK_PIN, OUTPUT);
  pinMode(CS_PIN, OUTPUT);
  digitalWrite(CS_PIN, HIGH);

  sendMAX7219(0x0C, 1);
  sendMAX7219(0x09, 0xFF);
  sendMAX7219(0x0A, 8);
  sendMAX7219(0x0B, 7);
  sendMAX7219(0x0F, 0);

  for(int i = 1; i <= 8; i++) {
    sendMAX7219(i, 0x0F); 
  }
}

void displayCounter(int num) {
  for(int i = 1; i <= 8; i++) {
    sendMAX7219(i, 0x0F); 
  }

  if (num == 0) {
    sendMAX7219(1, 0);
    return;
  }

  int pos = 1;
  long temp = abs(num); 
  
  while(temp > 0 && pos <= 8) {
    sendMAX7219(pos, temp % 10);
    temp /= 10;
    pos++;
  }

  if (num < 0 && pos <= 8) {
    sendMAX7219(pos, 0x0A);
  }
}

void IRAM_ATTR isr_up() {
  unsigned long current_time = millis();
  if (current_time - last_time_up > DEBOUNCE_DELAY) {
    counter++;
    countChanged = true;
    last_time_up = current_time;
  }
}

void IRAM_ATTR isr_down() {
  unsigned long current_time = millis();
  if (current_time - last_time_down > DEBOUNCE_DELAY) {
    counter--;
    countChanged = true;
    last_time_down = current_time;
  }
}

void setup() {
  Serial.begin(115200);
  
  setupMAX7219();

  pinMode(BTN_UP, INPUT_PULLUP);
  pinMode(BTN_DOWN, INPUT_PULLUP);

  attachInterrupt(BTN_UP, isr_up, FALLING);
  attachInterrupt(BTN_DOWN, isr_down, FALLING);
}

void loop() {
  if (countChanged) {
    displayCounter(counter);
    Serial.println(counter);
    countChanged = false;
  }
}
