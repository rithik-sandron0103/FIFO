## Parameterized Asynchronous FIFO Buffer Verilog Implementation

# Overview

This project implements a robust, fully parameterized, and synthesizable Asynchronous First-In, First-Out (FIFO) buffer in Verilog. Designed with a modular architecture, it features decoupled write and read clock domains, multi-stage Gray code pointer synchronization, and automated boundary verification using a structured testbench.

# Architecture & Design
The FIFO implementation is organized around core data handling and control logic:
- Circular Memory Array: A parameterizable register array (`memory`) that acts as the underlying storage buffer, indexed via lower pointer bits.
- Pointer & Wrap-Around Logic: Uses dual pointers (`w_ptr` and `r_ptr`) where the most significant bit handles wrap-around tracking and the lower bits handle physical memory indexing.
- Flag Generation: Implements safe combinational and registered flag logic to evaluate `wfull` and `rempty` states across independent clock domains without losing storage capacity.

# Components
The design is modular, consisting of primary building blocks integrated into a complete system:
- `memory.v` (Dual-Port RAM): True dual-port RAM storage core indexed by lower address bits (`waddr` and `raddr`).
- `write_ctrl.v` (Write Controller): Manages write-side pointer generation, binary-to-gray conversion, and full flag generation using synchronized read pointers.
- `read_ctrl.v` (Read Controller): Manages read-side pointer generation and empty flag verification.
- `ptr_synch.v` (Pointer Synchronizer): Implements multi-stage synchronizers to cross pointers safely across clock boundaries.
- `topmodule.v` (Top-level): Integrates memory, controllers, and synchronizers into a complete asynchronous FIFO system.

## Simulation
The software stack used is:
- Icarus Verilog: Used for compilation and simulation.
- GTKWave : Used for waveform visualization
### How to run:
To compile and run the provided testbench, use the following commands in your terminal:
```bash
# Compile the design
iverilog -o dsn memory.v write_ctrl.v ptr_synch.v read_ctrl.v testbench.v
# Run the simulation
vvp dsn
# Open the waveform in GTKWave
gtkwave async_fifo.vcd
```

## Waveform Analysis
The design's correctness is verified through GTKWave simulation traces. The system relies on independent write and read clock domains, proper dual-clock initialization, and robust pointer handshaking.

**Figure 1: Full System Dual-Clock Asynchronous FIFO Stream and Flag Validation Overview**
<img width="1793" height="249" alt="Screenshot from 2026-07-22 00-50-20" src="https://github.com/user-attachments/assets/5d26bed3-729f-4400-b49d-6accaaf7bbce" />
- System Initialization: As observed in the simulation, independent clocks (`wclk`, `rclk`) and active-high resets (`wrst`, `rrst`) cleanly initialize the internal state machines and default flag states (`rempty` high, `wfull` low).
- Burst Data Transfers: Data streams correctly sequence through the buffer from write inputs (`din`) to read outputs (`dout`) across asynchronous clock domains.
- Flag Protection: The full (`wfull`) and empty (`rempty`) flags assert precisely at capacity boundaries, preventing buffer overflow and underflow during wrap-over test sequences.

## Results
- Correct parameterized asynchronous FIFO dual-clock loopback and storage verified via simulation.
- Proper Gray code pointer synchronization, clock domain crossing, and address pointer roll-overs observed across the system.
- Clean waveform capture and automated verification achieved using Icarus Verilog and GTKWave.


