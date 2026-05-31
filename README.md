# 5-stage-pipelined-RISC-V-processor

A hardware implementation of a **32-bit RISC-V pipelined processor** written in **Verilog HDL**. This project implements the classic 5-stage pipeline architecture (IF → ID → EX → MEM → WB) based on the RV32I instruction set, complete with hazard detection and forwarding units.

---

## Table of Contents

- [Overview](#overview)
- [What is a Pipelined Processor?](#what-is-a-pipelined-processor)
- [Pipeline Stages](#pipeline-stages)
- [Hazard Handling](#hazard-handling)
- [Viewing Waveforms](#viewing-waveforms)
- [Key Concepts](#key-concepts)

---

## Overview

This project implements a fully functional **5-stage pipelined RISC-V processor** at the Register Transfer Level (RTL). The processor is based on the **RV32I** base integer instruction set — a 32-bit RISC-V standard.

Pipelining allows multiple instructions to be in different stages of execution at the same time, much like an assembly line in a factory. This significantly improves throughput compared to a single-cycle design.

**Language:** Verilog HDL  
**Architecture:** RISC-V RV32I  
**Pipeline Depth:** 5 stages  

---

## What is a Pipelined Processor?

In a **single-cycle processor**, each instruction takes one full clock cycle to complete — the entire datapath runs sequentially. While simple, this is slow because the clock must be slow enough for the longest instruction to finish.

In a **pipelined processor**, the execution of an instruction is broken into stages. While one instruction is being executed (EX stage), the next instruction is being decoded (ID stage), and another is being fetched (IF stage). This overlap means the processor can start a new instruction every clock cycle, greatly improving performance.

---

## Pipeline Stages

The processor is divided into 5 stages, separated by **pipeline registers** that hold intermediate values between stages:

| Stage | Name | Description |
|-------|------|-------------|
| **IF** | Instruction Fetch | Reads the next instruction from instruction memory using the Program Counter (PC). |
| **ID** | Instruction Decode | Decodes the instruction, reads source registers from the register file, and generates control signals. |
| **EX** | Execute | The ALU (Arithmetic Logic Unit) performs the computation (e.g., ADD, SUB, AND) or calculates memory addresses. |
| **MEM** | Memory Access | Reads from or writes to data memory. Only load (`lw`) and store (`sw`) instructions use this stage. |
| **WB** | Write Back | Writes the result back to the destination register in the register file. |

Each stage is separated by a **pipeline register** (e.g., IF/ID, ID/EX, EX/MEM, MEM/WB) that stores the values passing between stages on each clock cycle.

---

## Hazard Handling

Pipelining introduces **hazards** — situations where the pipeline cannot proceed correctly. This design handles the following:

### Data Hazards
A data hazard occurs when an instruction needs a result that hasn't been written back yet by a previous instruction.

- **Forwarding (Bypassing):** Instead of waiting, the result is "forwarded" directly from an earlier pipeline stage to where it's needed. For example, the output of the EX stage can be forwarded back to the EX stage's input for the next instruction. This avoids most stalls.

- **Stalling (Pipeline Bubble):** For **load-use hazards** — when a `lw` instruction is immediately followed by an instruction that uses its result — forwarding alone isn't enough. The pipeline must insert a one-cycle stall (a "bubble") to wait for the data.

### Control Hazards
A control hazard occurs when the processor fetches the wrong instruction after a branch (`beq`, `bne`, etc.) because it doesn't know which path to take yet.

- **Flushing:** When a branch is taken, instructions that were incorrectly fetched into the pipeline are flushed (discarded) to prevent incorrect execution.

---

## Viewing Waveforms

Generated simulation waveforms are included in the `Simulation Waveform/` folder. These waveforms show signal transitions across the 5 pipeline stages and are useful for verifying correct operation.

Key signals to observe in the waveform:
- `PC` — Program Counter (shows which instruction is being fetched)
- `instruction` — The 32-bit instruction word in the IF stage
- `ALUResult` — Output of the ALU in the EX stage
- `RegWrite`, `MemRead`, `MemWrite` — Control signals
- `ForwardA`, `ForwardB` — Forwarding control signals from the hazard unit
- `Stall`, `Flush` — Hazard control signals

---

## Key Concepts

| Concept | Explanation |
|---------|-------------|
| **RV32I** | The base integer instruction set of RISC-V; 32-bit instructions, 32 general-purpose registers |
| **Pipeline Register** | A flip-flop buffer between stages that holds values for one clock cycle |
| **ALU** | Arithmetic Logic Unit — performs ADD, SUB, AND, OR, SLT, etc. |
| **Register File** | 32 registers (x0–x31); x0 is always 0 |
| **Forwarding Unit** | Detects when a result can be reused before it's written to the register file |
| **Hazard Detection Unit** | Detects load-use hazards and inserts stalls; also handles branch flushes |
| **Control Unit** | Decodes the opcode and generates all control signals for the datapath |

---

*Designed and implemented in Verilog HDL as part of a Computer Architecture project.*

