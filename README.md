# Balanced_2Wheeld_Robot_using_LQR
LQR-BalanceBot is a two wheel self-balancing robot, based on Arduino Mega. It uses Linear-Quadratic-Regulator, an optimal controller which optimizes a cost function using energy-based method to give optimum gains according to our requirements. 

# LQR Controller
![image](https://github.com/23Nero/Balanced_2Wheeld_Robot_using_LQR/assets/134192393/dcc44559-e21b-452f-9ea7-12d9e5df64b0)
**LQR (Linear Quadratic Regulator)** is an automated control method used to optimize the performance or energy efficiency of dynamic systems. It's widely applied in industrial automation, robotics, and motor control. LQR computes optimal control parameters based on system models and cost functions.

## Features

- Self-balancing two-wheeled robot.
- Utilizes Linear Quadratic Regulator (LQR) for optimal control.
- Dynamically adjusts control gains.
- Incorporates a state space model with six variables.
- Monitors and controls position, velocity, yaw, and tilt angle.

## Hardware Components

- Arduino Mega 2560 microcontroller.
- Two-wheel robot chassis with motors.
- Quadrature encoders for measuring wheel rotation.
- MPU-6050 sensor for measuring tilt angle.
