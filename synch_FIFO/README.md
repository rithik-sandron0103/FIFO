# Parameterized Synchronous FIFO Buffer Verilog Implementation

## Overview
This project implements a robust, fully parameterized, and synthesizable Synchronous First-In, First-Out (FIFO) buffer in Verilog. Designed with a modular architecture, it features adjustable data widths and depths, safe wrap-around pointer management for flag generation, and automated boundary verification using a structured testbench.

## Architecture & Design
The FIFO implementation is organized around core data handling and control logic:
- Circular Memory Array: A parameterizable register array (`memory`) that acts as the underlying storage buffer, indexed via lower pointer bits.
- Pointer & Wrap-Around Logic: Uses dual 5-bit pointers (`w_ptr` and `r_ptr`) where the most significant bit handles wrap-around tracking and the lower bits handle physical memory indexing.
- Flag Generation: Implements purely combinational flag logic to evaluate `full` and `empty` states safely without losing storage capacity.

## Simulation
The software stack used is:
- Icarus Verilog: Used for compilation and simulation.
- GTKWave : Used for waveform visualization
### How to run:
To compile and run the provided testbench, use the following commands in your terminal:
```bash
# Compile the design
iverilog -o dsn FIFO.v testbench.v
# Run the simulation
vvp dsn
# Open the waveform in GTKWave
gtkwave fifo.vcd
```
## Waveform Analysis
The design's correctness is verified through the provided GTKWave simulation trace. The system relies on precise pointer arithmetic and wrap-around logic to ensure safe state transitions without overflow or underflow.

**Figure 1: Full System Stream Overview**
<img width="1799" height="228" alt="Screenshot from 2026-07-21 18-57-52" src="https://github.com/user-attachments/assets/cd227dd0-230e-42e2-b521-0108749e753c" />
- System Initialization: As observed in the waveform, the system clock (clk) and reset (rst) cleanly initialize the internal pointers, asserting the empty flag immediately.
- Write Burst & Full Guard: Data (0 to 16) is written sequentially into the buffer. Once capacity is reached, the full flag correctly goes high to prevent overflow on extra writes.
- Read Burst & Empty Guard: Data is read out sequentially back-to-back, causing the empty flag to assert high once the buffer is fully drained.
- Pointer Wrap-Around: A secondary write burst demonstrates correct pointer roll-over behavior after completing a full operational cycle.

## Results
- Correct parameterized synchronous FIFO push and pop operations verified via simulation
- Proper wrap-around pointer logic, full/empty flag generation, and overflow protection observed across boundaries
- Clean waveform capture achieved using standard VCD dumping and simulation tracking
