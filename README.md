# Automated Plant Watering System
**Course:** EECS 1011 – Procedural Programming and Mechatronics  
**Institution:** York University  
**Date:** April 2026

## Overview
An automated plant watering system built with MATLAB and an Arduino Nano 
that monitors soil moisture in real time and controls a water pump 
automatically — no human supervision needed.

## How It Works
The system reads voltage from a soil moisture sensor and converts it to 
a moisture percentage using a custom linear calibration model. Based on 
the moisture level, it moves through a state machine with three states:

- **Monitoring** – reads soil moisture continuously
- **Watering** – activates the pump for 5 seconds when soil is dry
- **Waiting** – pauses for 55 seconds before re-checking

A 7-day automatic shutdown prevents overwatering during long-term use.

## Features
- Real-time moisture graph (MATLAB live plot)
- OLED display showing system status
- LED and buzzer feedback
- Emergency stop button
- Unit testing with MoistureTest.m

## Tech Stack
- MATLAB (state machine logic, data visualization, unit testing)
- Arduino Nano + Grove Beginner Kit
- Soil moisture sensor, MOSFET switch, water pump
- OLED display, LED, buzzer

## Key Concepts Demonstrated
- State machine design
- Sensor calibration and characterization
- Hardware-software integration
- Automated decision-making from real-time sensor data
- Unit testing (MATLAB testing framework)

## Files
| File | Description |
|------|-------------|
| main.m | Main state machine loop |
| computeMoisture.m | Converts sensor voltage to moisture % |
| MoistureTest.m | Unit tests for moisture function |
| plotCharacterization.m | Sensor calibration graph |
| Initialize_Oled.m | OLED display setup |
| display_write.m | Writes status to OLED |
| updateLED.m | Controls LED output |

## Results
The system successfully maintained optimal soil moisture levels, 
with the live graph accurately reflecting moisture trends and all 
safety mechanisms functioning as intended.
