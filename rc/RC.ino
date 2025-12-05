#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <Servo.h>

#define TRIG D5
#define ECHO D6

const int MOTOR_A = D1;
const int MOTOR_B = D2;
const int SERVO_PIN = D3;
const int pinBuzzer = D7;

const int SPEED_MAX = 1023;

ESP8266WebServer server(80);
Servo myServo;
int servoPos = 0;

void handleForward() {
  analogWrite(MOTOR_A, SPEED_MAX);
  analogWrite(MOTOR_B, 0);
  server.send(200, "text/plain", "forward");
}

void handleBackward() {
  analogWrite(MOTOR_A, 0);
  analogWrite(MOTOR_B, SPEED_MAX);
  server.send(200, "text/plain", "backward");
}

void handleStop() {
  analogWrite(MOTOR_A, 0);
  analogWrite(MOTOR_B, 0);
  server.send(200, "text/plain", "stop");
}

void handleServoRight() {
  servoPos = 20;
  myServo.write(servoPos);
  server.send(200, "text/plain", "servo right");
}

void handleServoLeft() {
  servoPos = -20;
  myServo.write(servoPos);
  server.send(200, "text/plain", "servo left");
}

void handleServoCenter() {
  servoPos = 0;
  myServo.write(servoPos);
  server.send(200, "text/plain", "center");
}

void handleUltrasonic() {
  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);

  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG, LOW);

  long dur = pulseIn(ECHO, HIGH);
  long cm = dur * 0.0343 / 2;

  Serial.println(cm);

  if (cm > 0 && cm <= 10) {
    Serial.println("10 CM TERDETEKSI");
    tone(pinBuzzer, 659 * 2);
    delay(200);
    tone(pinBuzzer, 784 * 2);
    delay(300);
  } else {
    noTone(pinBuzzer);
  }

  delay(100);
}

void setup() {
  Serial.begin(115200);
  pinMode(MOTOR_A, OUTPUT);
  pinMode(MOTOR_B, OUTPUT);

  myServo.attach(SERVO_PIN);
  myServo.write(servoPos);

  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);

  WiFi.persistent(false);
  WiFi.disconnect(true);
  WiFi.mode(WIFI_AP);
  WiFi.setSleepMode(WIFI_NONE_SLEEP);
  WiFi.setPhyMode(WIFI_PHY_MODE_11N);

  IPAddress apIP(192, 168, 4, 1);
  IPAddress gw(192, 168, 4, 1);
  IPAddress sn(255, 255, 255, 0);
  WiFi.softAPConfig(apIP, gw, sn);

  WiFi.softAP("RC", "12345678", 6, false, 3);

  server.on("/forward", handleForward);
  server.on("/backward", handleBackward);
  server.on("/stop", handleStop);
  server.on("/servoRight", handleServoRight);
  server.on("/servoLeft", handleServoLeft);
  server.on("/center", handleServoCenter);

  server.begin();
}

void loop() {
  server.handleClient();
  handleUltrasonic();
}
