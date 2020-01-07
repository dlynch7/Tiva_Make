# Tiva_Make
Makefile for Texas Instruments' Tiva-C microcontroller

## Description
Uses a Makefile to build an app for the Tiva-C that blinks an onboard LED and sets up a console interface using a UART.
Pretty simple, but the Makefile also supports fancier stuff, especially floating-point math on the Tiva, which can be a pain to figure out from scratch.

## Getting started
### What you need to install
* Tivaware
* The GNU Embedded Toolchain for Arm. Includes `arm-none-eabi-gcc` (a GCC cross compiler) and `arm-none-eabi-ld` (a GCC linker).

### What you need to modify
