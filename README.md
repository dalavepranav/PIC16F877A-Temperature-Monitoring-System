# Smart Temperature Monitoring and Automatic Cooling System Using PIC16F877A

## Project Overview

The **Smart Temperature Monitoring and Automatic Cooling System** is an embedded systems project developed using the PIC16F877A microcontroller and Assembly Language. The system is designed to monitor surrounding temperature, provide real-time temperature readings, and automatically respond to excessive temperature conditions.

The project integrates a DHT11 temperature sensor, LCD display, LED indicators, buzzer, relay module, and DC cooling fan to create a temperature-dependent monitoring and control system.

When the measured temperature exceeds a predefined threshold of **35°C**, the system activates visual and audible alerts while controlling the cooling fan through a relay. This approach combines temperature sensing, real-time feedback, alert generation, and automatic cooling in a single embedded application.

The project demonstrates the practical application of low-level microcontroller programming, peripheral interfacing, threshold-based decision-making, and automated control.

## Key Features

- **Real-Time Temperature Monitoring:** Measures the surrounding temperature using the DHT11 sensor.
- **LCD-Based Temperature Display:** Presents temperature readings on an LCD for easy monitoring.
- **Intelligent Threshold Detection:** Compares the measured temperature against a predefined threshold of 35°C.
- **Visual Alert System:** Uses LED indicators to signal high-temperature conditions.
- **Audible Warning:** Activates a buzzer when the temperature exceeds the configured limit.
- **Automatic Cooling Control:** Operates a DC fan through a relay according to the programmed temperature-control logic.
- **Low-Level Embedded Programming:** Implements system functionality using Assembly Language on the PIC16F877A.
- **Integrated Monitoring and Control:** Combines sensing, display, alerts, and cooling in one system.

## System Architecture

The system follows a sensor-to-controller-to-output architecture.

```text
       DHT11 Temperature Sensor
                  |
                  v
          PIC16F877A MCU
                  |
       +----------+----------+
       |          |          |
       v          v          v
   LCD Display   LED       Buzzer
                  |
                  v
             Relay Module
                  |
                  v
             DC Cooling Fan
```

The PIC16F877A processes the temperature information and coordinates the display, warning indicators, and cooling mechanism according to the programmed control conditions.

## Hardware Components

| Sr. No. | Component | Purpose |
|---|---|---|
| 1 | PIC16F877A Microcontroller | Processes sensor data and controls system outputs |
| 2 | DHT11 Temperature Sensor | Measures surrounding temperature |
| 3 | LCD Display | Displays measured temperature |
| 4 | LED Indicators | Provides visual alerts |
| 5 | Buzzer | Generates an audible warning |
| 6 | Relay Module | Switches the cooling fan |
| 7 | DC Cooling Fan | Provides active cooling |
| 8 | Supporting Components | Includes resistors, wiring, and power supply components |

## Software and Development Tools

- **Microcontroller:** PIC16F877A
- **Programming Language:** Assembly Language
- **Source Code:** `temperaturepic.asm`
- **Development Environment:** To be specified according to the actual tool used
- **Simulation Software:** To be specified according to the actual tool used

## Working Principle

1. **Temperature Acquisition:** The DHT11 sensor measures the surrounding temperature and provides the sensor data to the microcontroller.
2. **Data Processing:** The PIC16F877A executes the programmed logic to process the temperature information.
3. **Temperature Display:** The measured temperature is displayed on the LCD.
4. **Threshold Comparison:** The controller compares the measured temperature with the predefined threshold of 35°C.
5. **Alert Generation:** When the temperature exceeds the threshold, the LED indicator and buzzer provide visual and audible warnings.
6. **Automatic Cooling:** The relay controls the DC fan according to the programmed temperature-control logic.
7. **Continuous Monitoring:** The system continues monitoring temperature and updates the outputs based on the implemented control conditions.

## Project Images and Circuit Documentation

This section can include the actual circuit schematic, simulation screenshots, and hardware photographs.

### 1. Circuit Schematic

The circuit schematic illustrates the interfacing of the PIC16F877A microcontroller with the DHT11 sensor, LCD, LED indicators, buzzer, relay, and cooling fan.

Add your schematic PDF to the repository and link it here:

[View Circuit Schematic
(PDF)](docs/temperature_monitoring_schematic.pdf)

### 2. Proteus Simulation

Add a screenshot of the complete circuit simulation.

![Proteus Circuit Simulation](images/proteus_circuit.png)

### 3. Normal Temperature Condition

Add a screenshot showing the LCD reading and output status under normal temperature conditions.

![Normal Temperature Condition](images/normal_temperature.png)

### 4. High-Temperature Alert and Cooling

Add a screenshot demonstrating the high-temperature response, including the LED, buzzer, and relay-controlled fan.

![High Temperature Alert](images/high_temperature_alert.png)

> **Note:** Replace the example image paths with the actual filenames and folders in your repository. Remove any section for which you do not have a corresponding image or document.

## Learning Outcomes

This project provided practical experience in:

- Programming the PIC16F877A microcontroller using Assembly Language.
- Interfacing a digital temperature sensor with a microcontroller.
- Displaying sensor readings on an LCD.
- Implementing threshold-based decision-making.
- Controlling digital outputs such as LEDs and buzzers.
- Implementing relay-based switching for a DC cooling fan.
- Integrating sensor inputs, display units, and output devices.
- Understanding embedded control logic and system-level debugging.

## Potential Applications

The underlying concept can be adapted for:

- Electronic equipment temperature monitoring.
- Small enclosures requiring temperature-dependent cooling.
- Educational embedded systems demonstrations.
- Prototype temperature warning systems.
- Basic automated cooling applications.

These are potential applications of the design concept and are not claims of validated deployment.

## Repository Structure

```text
Smart-Temperature-Monitoring-System/
│
├── README.md
├── temperaturepic.asm
│
├── docs/
│   └── temperature_monitoring_schematic.pdf
│
└── images/
    ├── proteus_circuit.png
    ├── normal_temperature.png
    └── high_temperature_alert.png
```

The directory structure is illustrative. Include only the files and folders that actually exist in your repository.

## Future Enhancements

Potential improvements include:

- Adding adjustable temperature thresholds.
- Introducing a temperature history and data-logging feature.
- Incorporating additional sensors for environmental monitoring.
- Adding fault detection for sensor disconnection.
- Improving temperature-control hysteresis to reduce frequent relay switching.

## Conclusion

The Smart Temperature Monitoring and Automatic Cooling System demonstrates how a microcontroller can combine temperature sensing, visual and audible alerts, and automated cooling in a single embedded application. By using the PIC16F877A and Assembly Language, the project reinforces fundamental concepts of microcontroller architecture, peripheral interfacing, low-level programming, and condition-based control.

The project provides a foundation for exploring more advanced embedded monitoring and automation systems.

---

**Project Category:** Embedded Systems  
**Controller:** PIC16F877A  
**Programming Language:** Assembly Language  
**Sensor:** DHT11  
**Primary Function:** Temperature Monitoring and Automatic Cooling
