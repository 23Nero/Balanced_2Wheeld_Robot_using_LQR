﻿# Balanced_2Wheeld_Robot_using_LQR
LQR-BalanceBot is a two wheel self-balancing robot, based on Arduino Mega. It uses Linear-Quadratic-Regulator, an optimal controller which optimizes a cost function using energy-based method to give optimum gains according to our requirements. A six-state variable state space model has been designed to control position, velocity, yaw (using Quadrature encoders), and tilt angle (using GY-87 sensor) of the bot.

#LQR Controller
<img src="![image](https://github.com/23Nero/Balanced_2Wheeld_Robot_using_LQR/assets/134192393/dcc44559-e21b-452f-9ea7-12d9e5df64b0)">

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
