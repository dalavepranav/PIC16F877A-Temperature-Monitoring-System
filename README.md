# Temperature Monitoring System Using PIC16F877A

## Project Overview

Developed a Temperature Monitoring System using the PIC16F877A microcontroller and Assembly Language, in collaboration with teammate Akshata Chetgiri, as part of our Embedded Systems coursework.

The system uses a DHT11 temperature sensor to monitor temperature and displays the readings on an LCD. When the measured temperature exceeds a predefined threshold, LED and buzzer alerts notify the user. A relay-controlled DC fan provides automatic cooling based on the temperature condition.

This project demonstrates the practical implementation of embedded systems concepts, sensor interfacing, low-level programming, and automatic control.

## Key Features

- **Temperature Monitoring:** Reads temperature data using the DHT11 sensor.
- **LCD Display:** Displays the measured temperature.
- **Overtemperature Alert:** Activates LED and buzzer alerts when the temperature exceeds the configured threshold.
- **Automatic Cooling:** Controls a DC fan through a relay based on the temperature condition.
- **Assembly Language Programming:** Implements the control logic using the PIC16F877A microcontroller.

## Hardware Components

- PIC16F877A microcontroller
- DHT11 temperature sensor
- LCD display
- LED indicators
- Buzzer
- Relay module
- DC fan
- Supporting circuit components and power supply

## Software and Programming

- **Microcontroller:** PIC16F877A
- **Programming Language:** Assembly Language
- **Source File:** `temperaturepic.asm`
- **Development / Simulation Tools:** Add the actual IDE, assembler, and simulation software used.

## Working Principle

1. The DHT11 sensor measures the surrounding temperature.
2. The PIC16F877A processes the sensor data using the programmed control logic.
3. The measured temperature is displayed on the LCD.
4. When the temperature exceeds the predefined threshold, the LED and buzzer alerts are activated.
5. The relay controls the DC fan to provide automatic cooling according to the implemented control logic.

## Learning Outcomes

- PIC16F877A microcontroller programming using Assembly Language
- DHT11 temperature sensor interfacing
- LCD interfacing and data display
- Digital input/output control
- Relay-based fan control
- Implementation of threshold-based alerts
- Embedded system debugging and hardware integration

## Team

Developed as part of Embedded Systems coursework.

- Akshata Chetgiri

## Repository Contents

- `temperaturepic.asm` — Assembly Language source code
- `README.md` — Project documentation
- Circuit diagrams, simulation files, and project images can be added as available.

## Conclusion

This project provided practical experience in developing a temperature monitoring and automatic cooling system using a PIC16F877A microcontroller. It strengthened our understanding of Assembly Language programming, sensor interfacing, alert mechanisms, and relay-based control in embedded systems.

