# Smart Temperature Monitoring and Automatic Cooling System Using PIC16F877A

## Project Overview

The **Smart Temperature Monitoring and Automatic Cooling System** is an embedded systems project developed using the PIC16F877A microcontroller and Assembly Language. It monitors surrounding temperature, displays temperature readings on an LCD, and responds automatically when the temperature exceeds a predefined threshold.

The system integrates a DHT11 temperature sensor, LCD display, LED indicators, buzzer, relay module, and DC cooling fan. When the measured temperature exceeds **35°C**, the system activates visual and audible alerts and operates the cooling fan according to the programmed control logic.

This project demonstrates the practical implementation of microcontroller programming, sensor interfacing, threshold-based decision-making, and automatic control using embedded systems.

## Key Features

- **Temperature Monitoring:** Measures ambient temperature using a DHT11 sensor.
- **LCD Display:** Displays temperature readings for real-time monitoring.
- **Threshold Detection:** Identifies temperature conditions exceeding the configured 35°C threshold.
- **Visual Alerts:** Uses LED indicators to indicate high-temperature conditions.
- **Audible Alerts:** Activates a buzzer when the temperature exceeds the configured limit.
- **Automatic Cooling:** Controls a DC fan through a relay based on the programmed logic.
- **Assembly Language Programming:** Implements the control logic using the PIC16F877A microcontroller.
- **Integrated System Design:** Combines sensing, display, alert generation, and cooling control.

## Project Images

### 1. Temperature Monitoring System

This image presents the temperature monitoring system and its overall circuit or project arrangement.

![Temperature Monitoring System](images/Temperature%20monitoring%20System.jpg)

### 2. Hardware Implementation

This image shows the hardware setup of the temperature monitoring system, including the interfaced components used in the project.

![Temperature Monitoring System Hardware](images/Temperature%20Monitoring%20System%20Hardware.jpg)

### 3. System Output

This image demonstrates the system output, showing the monitoring or alert response during operation.

![Temperature Monitoring System Output](images/Output%20of%20System.jpg)

## Hardware Components

| Component | Purpose |
|---|---|
| PIC16F877A | Processes sensor data and controls system outputs |
| DHT11 Temperature Sensor | Measures ambient temperature |
| LCD Display | Displays measured temperature |
| LED Indicators | Provides visual alerts |
| Buzzer | Generates audible warnings |
| Relay Module | Switches the cooling fan |
| DC Cooling Fan | Provides cooling when required |
| Supporting Components | Provides power, connections, and circuit support |

## Software and Development Tools

- **Microcontroller:** PIC16F877A
- **Programming Language:** Assembly Language
- **Source Code:** `temperaturepic.asm`
- **Development Environment:** Specify the IDE and assembler actually used.
- **Simulation Software:** Specify the simulation tool actually used, if applicable.

## Working Principle

1. **Temperature Sensing:** The DHT11 sensor measures the surrounding temperature.
2. **Data Processing:** The PIC16F877A executes the programmed control logic.
3. **Temperature Display:** The measured temperature is displayed on the LCD.
4. **Threshold Comparison:** The controller compares the temperature with the predefined threshold of 35°C.
5. **Alert Generation:** When the temperature exceeds the threshold, the LED and buzzer provide visual and audible alerts.
6. **Cooling Control:** The relay controls the DC fan according to the implemented control logic.
7. **Continuous Monitoring:** The system continues monitoring temperature and updates its outputs according to the programmed conditions.

## Learning Outcomes

- PIC16F877A programming using Assembly Language.
- DHT11 temperature sensor interfacing.
- LCD interfacing and temperature display.
- Digital input/output control.
- Threshold-based alert implementation.
- Relay-based DC fan control.
- Integration of sensors and output devices.
- Embedded system debugging and hardware interfacing.

## Potential Applications

The project concept can be adapted for:

- Temperature monitoring in electronic enclosures.
- Small-scale automatic cooling systems.
- Embedded systems laboratory demonstrations.
- Temperature warning systems.
- Basic environmental monitoring applications.

## Repository Structure

```text
PIC16F877A-Temperature-Monitoring-System/
│
├── README.md
├── temperaturepic.asm
│
└── images/
    ├── Temperature monitoring System.jpg
    ├── Temperature Monitoring System Hardware.jpg
    └── Output of System.jpg
```

This structure reflects the files shown in the images folder; include other files only if they are present in your repository.

## Future Enhancements

- Adjustable temperature thresholds.
- Temperature data logging.
- Sensor disconnection detection.
- Hysteresis-based fan control to reduce frequent relay switching.
- Additional sensors for expanded environmental monitoring.

## Conclusion

The Smart Temperature Monitoring and Automatic Cooling System demonstrates the use of a PIC16F877A microcontroller to integrate temperature sensing, LCD-based monitoring, alert generation, and relay-controlled cooling. The project strengthens practical understanding of Assembly Language programming, peripheral interfacing, and automated embedded control.

It also provides a foundation for developing more advanced temperature monitoring and automation applications.

---

**Project Category:** Embedded Systems  
**Microcontroller:** PIC16F877A  
**Programming Language:** Assembly Language  
**Temperature Sensor:** DHT11  
**Temperature Threshold:** 35°C
