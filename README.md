# Automated Conveyor Belt Sorting System
### CODESYS 3.5 + Factory I/O | Structured Text | OPC UA

An industrial automation simulation project featuring an automated conveyor system capable of identifying, sorting and counting boxes according to their height.

The system was developed using **CODESYS 3.5** for PLC programming and **Factory I/O** for 3D industrial process simulation. Communication between the two environments is established through **OPC UA**, allowing the PLC program to monitor sensors and control the simulated machinery in real time.

The project demonstrates the development of an automated sorting process, from initial box detection and classification to conveyor routing, turntable operation and production monitoring.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Demonstration](#demonstration)
- [System Layout](#system-layout)
- [Technologies Used](#technologies-used)
- [System Architecture](#system-architecture)
- [How the Sorting Process Works](#how-the-sorting-process-works)
- [PLC Programming](#plc-programming)
- [Control Panel](#control-panel)
- [OPC UA Communication and Configuration](#opc-ua-communication-and-configuration)
- [Sensors and Actuators](#sensors-and-actuators)
- [Safety and Operating Modes](#safety-and-operating-modes)
- [Production Counter](#production-counter)
- [Development Challenges and Solutions](#development-challenges-and-solutions)
- [Future Improvements](#future-improvements)

---

## Project Overview

The objective of this project was to design and program an automated conveyor belt sorting system capable of distinguishing between high and low boxes and routing them to separate conveyor lines.

The system uses height-detection sensors to classify incoming boxes. Based on the detected height, the PLC controls a turntable sorting mechanism that directs each box towards its corresponding conveyor.

The automation process is managed by a Structured Text (ST) program running in CODESYS, while Factory I/O provides the simulated industrial environment, including conveyors, sensors, actuators, boxes and operator controls.

The project was developed entirely in simulation, without requiring a physical PLC or industrial hardware.

### Main Features

- Automatic box generation and conveyor transportation.
- Detection and classification of high and low boxes.
- Automatic sorting into two separate conveyor lines.
- Turntable-based sorting mechanism.
- Sensor-based process sequencing.
- Automatic turntable return.
- Manual and automatic operating modes.
- Start, Stop and Emergency Stop functionality.
- Reset functionality.
- Production counter displayed in Factory I/O.
- Real-time communication between CODESYS and Factory I/O using OPC UA.

---

## Demonstration

The video below demonstrates the system operating in Factory I/O alongside the CODESYS PLC program.

PLC Logic Demonstration: https://www.youtube.com/watch?v=FjgqUa7RV2A

Factory IO Demonstration: https://www.youtube.com/watch?v=iOEDZyAuSeM

The demonstration shows the interaction between the simulated machinery and the PLC logic, including box detection, classification, sorting, conveyor operation and production counting.

---

## System Layout

The simulation is based on the Factory I/O **Sorting by Height (Advanced)** scene.

The system consists of an input section, a height-detection area, a turntable sorting mechanism and two output conveyor routes.

### Factory I/O – Complete System Overview

<img src="./screenshots/FactoryIO%20Overview.png" width="600">

### Control Panel

<img src="./screenshots/Control%20Panel%20FactoryIO.png" width="600">

The control panel provides the operator interface for starting and stopping the system, selecting operating modes and resetting the emergency lock.

### Sorting Mechanism

**Turntable**

<img src="./screenshots/FactoryIO%20Turntable.png" width="600">

The turntable is responsible for positioning the box for the selected sorting operation. Its actuator automatically returns the turntable to its original position when deactivated.

**Left Conveyor and Box Output**

<img src="./screenshots/FactoryIO%20Box%20on%20the%20left.png" width="600">

The left conveyor handles boxes classified as high.

**Removal Mechanism**

<img src="./screenshots/FactoryIO%20Remover.png" width="600">

The removal mechanism assists with transferring boxes along the appropriate sorting route.

---

## Technologies Used

| Technology | Purpose |
|---|---|
| CODESYS 3.5 (SP22) | PLC programming and execution |
| Structured Text (ST) | Automation control logic |
| Factory I/O | Industrial process simulation |
| OPC UA | Communication between CODESYS and Factory I/O |
| CODESYS Control Win V3 x64 | SoftPLC runtime |
| GitHub | Source code and project documentation |

---

## System Architecture

The project uses a PLC-controlled architecture.

Factory I/O provides the physical simulation, while CODESYS processes the sensor signals and determines which actuators should be activated.

The communication flow is:

1. Factory I/O sensors detect boxes and machine conditions.
2. Sensor signals are transmitted to CODESYS through OPC UA.
3. The PLC program processes the input signals and executes the programmed sequence.
4. CODESYS sends output commands back to Factory I/O.
5. Factory I/O activates the corresponding conveyors, turntable and sorting mechanisms.

<img src="./screenshots/FactoryIO%20Driver%20Config.png" width="600">

### OPC UA Configuration

<img src="./screenshots/FIO%20Config.png" width="600">

The CODESYS application publishes the required global variables through Symbol Configuration, allowing Factory I/O to access the PLC inputs and outputs.

The variables are organised into operator inputs, position sensors, box detection sensors, conveyor outputs, sorting mechanisms and indicator lights.

---

## How the Sorting Process Works

The automatic sorting sequence is controlled using a step-based state machine implemented with a `CASE` statement in Structured Text.

Each step represents a specific stage of the production process.

### 1. Box Generation and Feeding

When the machine is running in automatic mode, the emitter generates boxes and the feeder and entry conveyors transport them towards the sorting area.

When a box reaches the turntable entry sensor, the PLC begins the loading sequence.

### 2. Box Detection and Classification

Two height sensors are used:

- **LowBox:** Detects boxes passing through the lower sensor.
- **HighBox:** Detects boxes that reach the upper sensor.

Every box activates the lower sensor, while high boxes also activate the upper sensor.

The PLC stores the classification in the internal Boolean variable `BoxIsHigh`.

This allows the sorting logic to retain the classification while the box moves towards the turntable.

### 3. Turntable Operation

When the box reaches the front position, the turntable sorting sequence begins.

The turntable actuator is activated for approximately eight seconds.

After a two-second delay, the PLC activates the appropriate sorting output:

- High box: `FIO.Load`
- Low box: `FIO.Unload`

When the turntable actuator is deactivated, Factory I/O automatically returns the turntable to its starting position.

### 4. Conveyor Routing

The sorting output remains active until the appropriate exit sensor detects the box.

| Box Classification | Sorting Output | Conveyor Route | Exit Sensor |
|---|---|---|---|
| High | Load | Left | AtLeftExit |
| Low | Unload | Right | AtRightExit |

Once the correct exit sensor is activated, the sequence advances.

### 5. Restarting the Process

After the box reaches its destination, the PLC waits for the programmed delay before restarting the feeding process.

The system then prepares for the next box and repeats the sequence.

---

## PLC Programming

The PLC program is written in IEC 61131-3 Structured Text using CODESYS 3.5.

The automatic process is implemented as a step-based sequence using an integer variable called `FeedStep`.

### Main Sequence

| Step | Operation |
|---|---|
| 0 | Normal feeding and box detection |
| 10 | Load box onto turntable |
| 30 | Turntable movement and sorting delay |
| 40 | Maintain sorting output until the correct exit sensor activates |
| 50 | Wait before restarting |
| 70 | Restart delay and prepare for next box |

The sequence uses several TON (On-Delay) timers:

| Timer | Duration | Function |
|---|---:|---|
| `tTurnPulse` | 8 seconds | Controls turntable activation |
| `tEntryFeed` | 2 seconds | Controls entry conveyor feeding time |
| `tSortDelay` | 2 seconds | Delays the sorting output |
| `tReturnDelay` | 2 seconds | Waits after the box reaches its exit |
| `tRestartFeed` | 2 seconds | Delays the next feeding cycle |

The timers provide predictable sequencing and prevent the process from relying solely on sensor timing.

### Example: Height Classification

```iecst
IF (FeedStep = 0 OR FeedStep = 10) AND FIO.HighBox THEN
    BoxIsHigh := TRUE;
END_IF
```

The classification is stored in `BoxIsHigh` and used later to determine the appropriate sorting route.

### Example: Sorting Logic

```iecst
IF BoxIsHigh THEN
    FIO.Load := TRUE;

    IF FIO.AtLeftExit THEN
        FeedStep := 50;
    END_IF
ELSE
    FIO.Unload := TRUE;

    IF FIO.AtRightExit THEN
        FeedStep := 50;
    END_IF
END_IF
```

This ensures that high and low boxes are routed according to their stored classification.

---

## Control Panel

The operator interface provides the main controls for interacting with the simulated production system.

| Control | Function |
|---|---|
| Start | Starts the machine |
| Stop | Stops machine operation |
| Emergency Stop | Immediately stops the machine and activates the emergency lock |
| Reset | Clears the emergency lock and resets the production counter |
| Auto Mode | Enables automatic sorting |
| Manual Mode | Enables manual operation |

Indicator lights provide visual feedback:

- Green indicator: Machine running.
- Red indicator: Machine stopped.
- Reset indicator: Emergency lock active.

---

## OPC UA Communication and Configuration

Communication between CODESYS and Factory I/O is established using OPC UA.

The PLC variables are exposed through CODESYS Symbol Configuration and mapped to the corresponding Factory I/O sensors and actuators.

The communication includes:

- Operator control signals.
- Position and box detection sensors.
- Conveyor motor commands.
- Turntable and sorting actuator commands.
- Indicator lights.
- Production counter.

This arrangement allows the PLC program to operate the simulated machinery using real-time input and output signals.

---

## Sensors and Actuators

### Sensors

The project uses several digital sensors to monitor the position and classification of boxes.

| Sensor | Purpose |
|---|---|
| `AtTurntableEntry` | Detects a box approaching the turntable |
| `AtFront` | Detects the box at the front position |
| `AtLeftExit` | Detects a box reaching the left conveyor exit |
| `AtRightExit` | Detects a box reaching the right conveyor exit |
| `LowBox` | Detects boxes at the lower height level |
| `HighBox` | Detects boxes at the upper height level |

### Actuators

| Actuator | Purpose |
|---|---|
| `Emitter1` | Generates boxes |
| `FeederConveyor` | Feeds boxes into the system |
| `EntryConveyor` | Transports boxes towards the turntable |
| `LeftConveyor` | Transports high boxes |
| `RightConveyor` | Transports low boxes |
| `Turn` | Activates the turntable |
| `Load` | Selects the left sorting route |
| `Unload` | Selects the right sorting route |

---

## Safety and Operating Modes

The PLC program includes basic simulated machine control and safety interlocking.

### Start and Stop

The machine uses a latched running state. Pressing Start enables operation, while pressing Stop disables it.

### Emergency Stop

The Emergency Stop input is monitored continuously.

When activated, the PLC:

1. Sets the emergency lock.
2. Stops machine operation.
3. Prevents normal automatic operation from continuing.

The emergency lock remains active until the emergency stop is released and the Reset input is activated.

### Automatic and Manual Modes

The system supports two operating modes.

**Automatic Mode:** The PLC executes the complete sorting sequence using sensor feedback and timers.

**Manual Mode:** The emitter, feeder conveyor and entry conveyor can be operated continuously while the machine is running.

*Note: These are simulated control functions and are not a substitute for certified industrial safety hardware or a safety-rated PLC.*

---

## Production Counter

A production counter tracks the total number of boxes detected by the lower height sensor.

The counter uses an `R_TRIG` rising-edge trigger to ensure that a box is counted only once, even if the sensor remains active across multiple PLC scans.

The internal counter is a `DINT` and its value is transferred to the Factory I/O production display through:

```iecst
FIO.ProductionCounter := BoxCounter;
```

Pressing Reset clears the counter to zero.

---

## Development Challenges and Solutions

Several practical challenges were encountered during development. Solving these problems was an important part of the project.

### 1. OPC UA Communication

The initial setup required configuring the CODESYS application to publish the required global variables and establishing the correct Factory I/O driver configuration.

**Solution:** Enabled OPC UA support, configured Symbol Configuration and mapped the Factory I/O signals to their corresponding CODESYS variables.

### 2. Active-Low Stop and Emergency Stop Inputs

The Stop and Emergency Stop signals were active-low rather than active-high.

This meant that the signals were TRUE when released and FALSE when pressed.

**Solution:** The PLC logic was adapted to use inverted conditions when detecting button presses.

### 3. Box Classification and Sensor Positioning

One of the most important issues occurred when a new box reached the height sensors while the previous box was still being processed.

A high box could activate the HighBox sensor before the previous box had completed its sorting sequence. This caused the stored classification to change and could result in a low box being incorrectly routed to the high-box conveyor.

**Solution:** Both height sensors were physically repositioned closer to the turntable. This ensured that each box was classified at the appropriate point in the process, reducing interference between consecutive boxes.

This highlighted an important industrial automation principle: correct PLC logic must also account for the physical positioning and timing of sensors.

### 4. Turntable Operation

The turntable actuator behaves differently from a conventional motor output. Activating it moves the turntable, and deactivating it allows the mechanism to return automatically to its original position.

**Solution:** The PLC sequence was adjusted to use a timed activation followed by deactivation, allowing Factory I/O to handle the automatic return.

### 5. Production Counting

A simple Boolean condition would repeatedly increment the counter while a sensor remained TRUE.

**Solution:** An `R_TRIG` function block was used to detect only the rising edge of the sensor signal, ensuring one count per activation.


## Future Improvements

Possible future developments include:

- Separate production counters for high and low boxes.
- A total production statistics display.
- Fault detection and diagnostic messages.
- Conveyor jam detection.
- Improved manual control of individual actuators.
- HMI development with live process visualisation.
- Production efficiency and cycle-time monitoring.
- More advanced sequencing for simultaneous box processing.
- Additional sorting categories.

---

## Conclusion

This project demonstrates the development of a complete simulated industrial sorting system using PLC programming and Factory I/O.

It combines Structured Text programming, OPC UA communication, sensor feedback, actuator control, timers, state-based sequencing and basic safety interlocks.

Beyond implementing the required sorting functionality, the project provided practical experience in debugging PLC logic, understanding sensor behaviour, managing timing dependencies and adapting control logic to the physical behaviour of an industrial process.

The result is a working automated conveyor sorting simulation capable of identifying high and low boxes, routing them to separate conveyor lines and monitoring production output.

**Developed as a practical industrial automation and PLC programming project using CODESYS 3.5 and Factory I/O.**
