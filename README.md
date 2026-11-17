# Assembly-Calculator

A simple 8086 Assembly calculator implementing basic arithmetic operations using EMU8086

# 8086 Assembly Calculator

A simple arithmetic calculator developed using **8086 Assembly Language** and **EMU8086**.

## Project Overview

This project implements a basic calculator that allows users to perform arithmetic operations using three different number systems: Binary, Decimal, and Hexadecimal.

The program uses 8086 registers, procedures, and DOS interrupts to handle input and output operations.

## Features

- Support for three number systems:
  - Binary (Base 2)
  - Decimal (Base 10)
  - Hexadecimal (Base 16)
- Basic arithmetic operations:
  - Addition (+)
  - Subtraction (-)
  - Multiplication (\*)
  - Division (/)
- User input through the keyboard.
- Backspace support during number input.
- Division by zero detection.
- Automatic conversion between input strings and numeric values.
- Display of the result in the selected number system.

## Technologies Used

- Assembly Language (Intel 8086)
- EMU8086 Emulator
- DOS Interrupts (INT 21h)

## Project Structure

```text
Assembly-Calculator/
│
├── src/
│   └── calculator.asm
│
├── screenshots/
│
├── README.md
└── .gitignore
```

## How to Run

1. Install and open EMU8086.
2. Open the `calculator.asm` source file.
3. Compile the program.
4. Emulate and execute the program.
5. Follow the instructions displayed in the emulator.

## Supported Operations

| Operation      | Symbol |
| -------------- | ------ |
| Addition       | +      |
| Subtraction    | -      |
| Multiplication | \*     |
| Division       | /      |

## Number Systems

| Number System | Base |
| ------------- | ---- |
| Binary        | 2    |
| Decimal       | 10   |
| Hexadecimal   | 16   |

## Technical Notes

- Arithmetic values are handled using 16-bit registers.
- Division returns the integer quotient.
- The program detects division by zero.
- Arithmetic overflow and signed-number handling are not explicitly implemented.

## Authors

- Abderaouf Zerkouk

## Academic Project

This project was developed as a programming exercise to practice Assembly Language, register manipulation, arithmetic instructions, procedures, and number-system conversions.
