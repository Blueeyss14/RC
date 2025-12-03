#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <Servo.h>

const int MOTOR_A = D1;
const int MOTOR_B = D2;
const int SERVO_PIN = D3;

const int SPEED_MAX = 1023;

ESP8266WebServer server(80);
Servo myServo;
int servoPos = 90;

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
  servoPos += 2;
  if (servoPos > 130) servoPos = 130;
  myServo.write(servoPos);
  server.send(200, "text/plain", "servo right");
}

void handleServoLeft() {
  servoPos -= 2;
  if (servoPos < 60) servoPos = 60;
  myServo.write(servoPos);
  server.send(200, "text/plain", "servo left");
}

void handleServoCenter() {
  servoPos = 90;
  myServo.write(servoPos);
  server.send(200, "text/plain", "center");
}

void setup() {
  pinMode(MOTOR_A, OUTPUT);
  pinMode(MOTOR_B, OUTPUT);

  myServo.attach(SERVO_PIN);
  myServo.write(servoPos);

  WiFi.persistent(false);
  WiFi.disconnect(true);
  WiFi.mode(WIFI_AP);
  WiFi.setSleepMode(WIFI_NONE_SLEEP);
  WiFi.setPhyMode(WIFI_PHY_MODE_11N);

  IPAddress apIP(192,168,4,1);
  IPAddress gw(192,168,4,1);
  IPAddress sn(255,255,255,0);
  WiFi.softAPConfig(apIP, gw, sn);

  WiFi.softAP("RC", "12345678", 6, false, 3);

  server.on("/forward", handleForward);
  server.on("/backward", handleBackward);
  server.on("/stop", handleStop);
  server.on("/servoRight", handleServoRight);
  server.on("/servoLeft", handleServoLeft);
  server.on("/servoCenter", handleServoCenter);

  server.begin();
}

void loop() {
  server.handleClient();
}
