String strData;
String Cmd;
int Pulse = 50;
int Freq = 1;

unsigned long prevMillis = 0;
unsigned long currentMillis;

float period = 1000;
float onTime = 500;

int ledPin = 2;
bool ledState = false;

void setup() {
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT);

  Serial.println("=== READY ===");
  Serial.println("Use: P=xx, F=xx, G, ?");
}

void loop() {
  if (Serial.available()) {
    strData = Serial.readString();
    strData.trim();

    Cmd = strData.substring(0, 1);

    if (Cmd == "P") {
      Pulse = strData.substring(2).toInt();
      Serial.printf("Set Pulse = %d %%\n", Pulse);
    }

    if (Cmd == "F") {
      Freq = strData.substring(2).toInt();
      Serial.printf("Set Freq = %d Hz\n", Freq);
    }

    if (Cmd == "G") {
      calculateTime();
    }

    if (Cmd == "?") {
      Serial.println("P=xx → Pulse (%)");
      Serial.println("F=xx → Frequency (Hz)");
      Serial.println("G → Show result");
    }
  }

  currentMillis = millis();

  if (ledState && currentMillis - prevMillis >= onTime) {
    ledState = false;
    prevMillis = currentMillis;
    digitalWrite(ledPin, LOW);
  } 
  else if (!ledState && currentMillis - prevMillis >= (period - onTime)) {
    ledState = true;
    prevMillis = currentMillis; 
    digitalWrite(ledPin, HIGH);
  }
}

void calculateTime() {
  period = 1000.0 / Freq;           
  onTime = (period * Pulse) / 100.0;

  Serial.println("=== CALCULATION ===");
  Serial.printf("Period = %.2f ms\n", period);
  Serial.printf("ON time = %.2f ms\n", onTime);
  Serial.printf("OFF time = %.2f ms\n", period - onTime);
}