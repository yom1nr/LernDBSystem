#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>
#include <ESPmDNS.h>
#include <Update.h>

// เปลี่ยนเป็นชื่อและรหัส Wi-Fi ของคุณ
const char* ssid = "Phatsakorn"; 
const char* password = "mayom0900";

WebServer server(80);

// หน้าเว็บ HTML หน้าตาบ้านๆ สำหรับกดปุ่มเลือกไฟล์
String serverIndex = 
"<form method='POST' action='/update' enctype='multipart/form-data'>"
  "<input type='file' name='update'>"
  "<input type='submit' value='Update'>"
"</form>";

void setup() {
  Serial.begin(115200);
  
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  
  // รอเชื่อมต่อ Wi-Fi
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    delay(5000);
    ESP.restart();
  }
  
  MDNS.begin("esp32-webupdate");
  
  // ⚠️ สำคัญ: พิมพ์ IP Address ออกมาทาง Serial Monitor
  Serial.println("");
  Serial.print("Connected! IP Address: ");
  Serial.println(WiFi.localIP());

  // ตั้งค่าหน้าเว็บหน้าแรก (โชว์ปุ่มอัปโหลด)
  server.on("/", HTTP_GET, []() {
    server.sendHeader("Connection", "close");
    server.send(200, "text/html", serverIndex);
  });

  // ตั้งค่าระบบรับไฟล์และเบิร์นลงชิป
  server.on("/update", HTTP_POST, []() {
    server.sendHeader("Connection", "close");
    server.send(200, "text/plain", (Update.hasError()) ? "Update Failed!" : "Update Success! Rebooting...");
    ESP.restart();
  }, []() {
    HTTPUpload& upload = server.upload();
    if (upload.status == UPLOAD_FILE_START) {
      if (!Update.begin(UPDATE_SIZE_UNKNOWN)) { 
        Update.printError(Serial);
      }
    } else if (upload.status == UPLOAD_FILE_WRITE) {
      if (Update.write(upload.buf, upload.currentSize) != upload.currentSize) {
        Update.printError(Serial);
      }
    } else if (upload.status == UPLOAD_FILE_END) {
      if (Update.end(true)) {
        Serial.printf("Update Success: %u bytes\n", upload.totalSize);
      }
    }
  });

  server.begin();
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  server.handleClient(); // คำสั่งให้บอร์ดคอยรับแขกที่เข้าเว็บ
  
  // --- โค้ด Blink01 (กระพริบช้า) ---
  digitalWrite(LED_BUILTIN, HIGH); delay(500);
  digitalWrite(LED_BUILTIN, LOW);  delay(500);
}