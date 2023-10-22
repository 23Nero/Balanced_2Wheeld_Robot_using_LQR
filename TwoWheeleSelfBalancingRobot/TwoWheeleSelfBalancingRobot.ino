/*
 * Made by Le Nguyen Khanh Lam \
 */

#include <Wire.h>
#include "Kalman.h" //https://github.com/TKJElectronics/KalmanFilter
#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

RF24 radio(26, 28); // Khai báo đối tượng radio với các chân CE và CSN

const uint64_t pipe = 0xE8E8F0F0E1LL; // Địa chỉ ống dẫn để gửi dữ liệu

#define ToRad PI / 180
#define ToDeg 180 / PI

Kalman kalman; // Kalman filter define: kalman.getAngle(pitch, gyrorate, dt);

#define factortheta PI / 20 // The theta setpoint value change ever 7ms if control
#define factorphi PI / 180  // The Phi setpoint value change ever 7ms if control
#define rung_lac 255
#define song_day 80
#define pos -0.03
#define DO 20

int inChar;
uint32_t timerloop, timerold;
const int pin = A11;
const int pin1 = A12;

// int data = 0;
// char userInput;

// Motor control Pin//
int leftpwm = 9; // Control pwm left motor A
int leftdir1 = 5;
int leftdir2 = 4; // Control direction left motor

int righpwm = 10; // Control pwm right motor B
int righdir1 = 12;
int righdir2 = 11; // Control direction right motor;

volatile long leftencoder; // read left encoder value
volatile long righencoder; // read right encoder value
int leftencoder_a = 2;     // Read state encoder channel LOW or HIGH
int leftencoder_b = 6;
int righencoder_a = 3;
int righencoder_b = 7;

// MPU6050 Data//
float mpudata; // Save psi angle ( Y axis)
float AcX, AcZ;
float Gyro;

uint32_t timer; // Timer for kalman filter psi angle;
uint8_t i2cData[14];

// LQR data//
long PWML, PWMR;              // PWM output for H-Brigde
float k1, k2, k3, k4, k5, k6; // The factor of K maxtrix
bool falldown;                // Run = true; Stop  = false;

float theta, psi, phi;
float thetadot, psidot, phidot;
float thetaold, psiold, phiold;

float leftvolt; // output volt left motor in LQR
float righvolt; // output volt right motor in lQR

float addtheta; // Save setpoint value
float addphi;   // Save setpoint value

int ForwardBack; // 1 -> Forward;   -1 -> Back;      0 -> Stop And Balancing
int LeftRight;   // 1 -> Turnleft;  -1 -> TurnRight  0 -> Stop And Balancing

void setup()
{

  Serial.begin(9600);
  Serial1.begin(9600);

  radio.begin();
  radio.openWritingPipe(pipe);

  /*
  // Set factor of K maxtrix
   K = | k1   k2   k3   k4   k5   k6 |
       | k1   k2   k3   k4  -k5  -k6 |
        */

  k1 = 0.19;  // k1*theta 0.1
  k2 = 0.33;  // k2*thetadot 0.38
  k3 = -1100; // k3*psi 129 705 178 214
  k4 = -5;    // k4*psidot 10
  k5 = 0.01;  // k5*phi 0.038
  k6 = 0.22;  // k6*phidot 0.32

  // Set state control motor begin
  ForwardBack = 0;
  LeftRight = 0;
  // Set zero setpoint value
  addphi = 0;
  addtheta = 0;

  // SET PWM FREQUENCY 31 kHz
  TCCR2B = TCCR2B & B11111000 | B00000001; // Pin 9 & Pin 10 (https://arduino-info.wikispaces.com/Arduino-PWM-Frequency)

  // Output pin control motor left and right//
  pinMode(pin, OUTPUT);
  pinMode(pin1, INPUT);

  pinMode(leftpwm, OUTPUT);
  pinMode(righpwm, OUTPUT);

  pinMode(leftdir1, OUTPUT);
  pinMode(righdir1, OUTPUT);

  pinMode(leftdir2, OUTPUT);
  pinMode(righdir2, OUTPUT);

  // Input pin read encoder//
  pinMode(leftencoder_a, INPUT_PULLUP);
  pinMode(leftencoder_b, INPUT_PULLUP);
  pinMode(righencoder_a, INPUT_PULLUP);
  pinMode(righencoder_b, INPUT_PULLUP);

  // interrupt encoder//
  attachInterrupt(0, left_isr, RISING);
  attachInterrupt(1, righ_isr, RISING);

  // Data MPU6050//
  Wire.begin();

  TWBR = ((F_CPU / 400000L) - 16) / 2;
  i2cData[0] = 7;
  i2cData[1] = 0x00;
  i2cData[2] = 0x00;
  i2cData[3] = 0x00;

  while (i2cWrite(0x19, i2cData, 4, false))
    ;
  while (i2cWrite(0x6B, 0x01, true))
    ;
  while (i2cRead(0x75, i2cData, 1))
    ;
  if (i2cData[0] != 0x68)
  {
    Serial.print(F("Error reading sensor"));
    while (1)
      ;
  }

  delay(100);

  while (i2cRead(0x3B, i2cData, 6))
    ;
  AcX = (i2cData[0] << 8) | i2cData[1];
  AcZ = (i2cData[4] << 8) | i2cData[5];

  double pitch = atan2(-AcX, AcZ) * RAD_TO_DEG;
  kalman.setAngle(pitch);
  timer = micros();
}

void loop()
{
  readmpu();

  if ((micros() - timerloop) > 6000)
  {                                                     // Set time loop update and control motor
    theta = gettheta(leftencoder, righencoder) * ToRad; // Read theta value and convert to Rad
    psi = (mpudata + pos) * ToRad;                      // Read psi value and convert to Rad
    phi = getphi(leftencoder, righencoder) * ToRad;     // Read phi value and convert to Rad

    // Update time compare with timeloop
    float dt = (float)(micros() - timerloop) / 1000000.0;
    timerloop = micros();
    // Update input angle value
    thetadot = (theta - thetaold) / dt;
    psidot = (psi) / dt;
    phidot = (phi - phiold) / dt;
    // Upadte old angle value
    thetaold = theta;
    psiold = psi;
    phiold = phi;
    //
    addtheta = addtheta + ForwardBack * factortheta;
    addphi = addphi + LeftRight * factorphi;

    getlqr(theta + addtheta, thetadot, psi, psidot, phi + addphi, phidot);

    motorcontrol(PWML, PWMR, (mpudata + pos), falldown);

    radio.write(&mpudata, sizeof(mpudata));
    Serial.println(mpudata);

  }
}

// left motor encoder interrupt//
void left_isr()
{
  if (digitalRead(leftencoder_b))
  {
    leftencoder++;
  }
  else
  {
    leftencoder--;
  }
}

// right motor encoder interrupt//
void righ_isr()
{
  if (digitalRead(righencoder_b))
  {
    righencoder++;
  }
  else
  {
    righencoder--;
  }
}
// Read psi//
void readmpu()
{
  while (i2cRead(0x3B, i2cData, 14))
    ;
  AcX = ((i2cData[0] << 8) | i2cData[1]);
  AcZ = ((i2cData[4] << 8) | i2cData[5]);
  Gyro = (i2cData[10] << 8) | i2cData[11];

  double dt = (double)(micros() - timer) / 1000000; // Calculate delta time
  timer = micros();

  double pitch = atan2(-AcX, AcZ) * RAD_TO_DEG;
  double Gyrorate = Gyro / 131.0;

  mpudata = kalman.getAngle(pitch, Gyrorate, dt); // Using kalman filter angle
  //
  if (abs(mpudata) > song_day) // Limit angle falldown motor
  {
    falldown = true; // Stop Motor
  }
  else
  {
    falldown = false; // Run Motor
  }
  //
}
// Read theta angle function//
float gettheta(long lencoder, long rencoder)
{ // deg value
  float angle = (360 / (660 * 2)) * (lencoder + rencoder);
  return angle;
}
// Read phi angle function//
float getphi(long lencoder, long rencoder)
{ // deg value
  float angle = (3.25 * 360 / (17 * 660)) * (lencoder - rencoder);
  return angle;
}
// LQR function//
void getlqr(float theta_, float thetadot_, float psi_, float psidot_, float phi_, float phidot_)
{
  leftvolt = k1 * theta_ + k2 * thetadot_ + k3 * psi_ + k4 * psidot_ + k5 * phi_ + k6 * phidot_;
  righvolt = k1 * theta_ + k2 * thetadot_ + k3 * psi_ + k4 * psidot_ - k5 * phi_ - k6 * phidot_;

  PWML = map(leftvolt, -(k3 * PI) / DO, (k3 * PI) / DO, -250, 250); // Limit 15 deg.
  PWMR = map(righvolt, -(k3 * PI) / DO, (k3 * PI) / DO, -250, 250);

  PWML = constrain(PWML, -rung_lac, rung_lac); // limit pwm value in (-240, 240) because we using high frequency pwm (31 khz)
  PWMR = constrain(PWMR, -rung_lac, rung_lac);
}
// Motor control function//
void motorcontrol(long lpwm, long rpwm, float angle, bool stopstate)
{

  if (stopstate == true)
  {
    stopandreset();
  }
  else
  {
    if (abs(angle) > 30) // angle psi > 30 motor will stop
    {
      stopandreset();
    }
    else
    {
      //
      if (leftvolt > 0) 
      {
        leftmotor(abs(lpwm), 1); // Forward
      }
      else if (leftvolt < 0)
      {
        leftmotor(abs(lpwm), 0); // Back
      }
      else
      {
        stopandreset();
      }
      //
      if (righvolt > 0) 
      {
        righmotor(abs(rpwm), 1);
      }
      else if (righvolt < 0)
      {
        righmotor(abs(rpwm), 0);
      }
      else
      {
        stopandreset();
      }
    }
  }
}
// Stop motor and reset data
void stopandreset() // The data angle and encoder will be reset back to zero.
{
  digitalWrite(leftpwm, LOW);
  digitalWrite(righpwm, LOW);
  // Reset default place//
  leftencoder = 0;
  righencoder = 0;
  // Reset zero setpoint
  addtheta = 0;
  addphi = 0;
}
// Control left motor
void leftmotor(uint8_t lpwm, int direct)
{
  if (direct == 1)
  { // angle > 0
    digitalWrite(leftdir1, HIGH);
    digitalWrite(leftdir2, LOW);
    analogWrite(leftpwm, lpwm);
  }
  else
  {
    digitalWrite(leftdir1, LOW);
    digitalWrite(leftdir2, HIGH);
    analogWrite(leftpwm, lpwm);
  }
}
// Control right motor
void righmotor(uint8_t rpwm, int direct)
{
  if (direct == 1)
  { // angle > 0
    digitalWrite(righdir1, HIGH);
    digitalWrite(righdir2, LOW);
    analogWrite(righpwm, rpwm);
  }
  else
  {
    digitalWrite(righdir1, LOW);
    digitalWrite(righdir2, HIGH);
    analogWrite(righpwm, rpwm);
  }
}
// Serial interrupt receive data control
void serialEvent1()
{
  while (Serial1.available() > 0)
  {
    inChar = Serial1.read();
  }
  // Control motor forward
  if (inChar == 70) // F -->run
  {
    ForwardBack = 1;
  }
  if (inChar == 83) // T -->stop
  {
    ForwardBack = 0;
  }
  // Control motor Back
  if (inChar == 66) // B
  {
    ForwardBack = -1;
  }
  if (inChar == 86) // V
  {
    ForwardBack = 0;
  }
  // Control motor Left
  if (inChar == 76) // L
  {
    LeftRight = 1;
  }
  if (inChar == 85) // U
  {
    LeftRight = 0;
  }
  // Control motor right
  if (inChar == 82) // R
  {
    LeftRight = -1;
  }
  if (inChar == 79) // O
  {
    LeftRight = 0;
  }
}
