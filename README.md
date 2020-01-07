# Tiva_Make
Makefile for Texas Instruments' Tiva-C microcontroller

## Description
Uses a Makefile to build an app for the Tiva-C that blinks an onboard LED and prints "Hello World!" to a UART
Pretty simple, but the Makefile also supports fancier stuff, especially floating-point math on the Tiva, which can be a pain to figure out from scratch.

## Setup
Install the software listed below, then clone this repo.
### What you need to install
* Tivaware
* The [GNU Embedded Toolchain for Arm](https://launchpad.net/gcc-arm-embedded/+download). Includes `arm-none-eabi-gcc` (a GCC cross compiler) and `arm-none-eabi-ld` (a GCC linker).
* [lm4tools](https://github.com/utzig/lm4tools) - contains lm4flash, a command-line firmware flashing tool which our Makefile will use.

[Here's](http://chrisrm.com/howto-develop-on-the-ti-tiva-launchpad-using-linux/) a helpful reference.
In particular, the instructions on that page have you create a single `Embedded` folder, within which you install Tivaware and lm4tools. This simplifies the Makefile, as we'll see below.
If you follow those instructions, you'll also install OpenOCD, the Open On-Chip Debugger, but I won't get into that in this project template.

### Project structure
Your project should reside in a folder.
In that folder, there must be (at minimum) a Makefile and three subfolders: `src\`, `inc\`, and `build\`.
* C files (`.c`) that you write go in `src\`.
* Header files (`.h`) that you write go in `inc\`.
* Files produced during building (compiling and linking) are automatically stored in the `build\` folder. You don't need to do anything yourself in the `build\` folder.

With one exception, you shouldn't copy any Tivaware code to your project folder.
That one exception is `utils/uartstdio.c`: copy that file to your `src\` folder.

### What you need to modify in the Makefile
Only modify the part of the Makefile sandwiched between
```make
#######################################
# user configuration:
#######################################
```
and
```make
#######################################
# end of user configuration
#######################################
```
Everything else is off-limits unless you know what you're doing!

Although the folder structure described earlier simplifies and standardizes the build process, the Makefile needs to know where a few other things are:
```make
# TIVAWARE_PATH: path to tivaware folder
TIVAWARE_PATH = $(HOME)/Embedded/tivaware

# FLASH_PATH: path to lm4flash
FLASH_PATH = $(HOME)/Embedded/lm4tools/lm4flash

# additional libraries:
# libdriver.a path: tivaware/driverlib/gcc/
DRIVERLIB_PATH = $(HOME)/Embedded/tivaware/driverlib/gcc
LDLIBS = -L$(DRIVERLIB_PATH) -ldriver
```

## Operation
Once you're in the top folder of your project (where the Makefile is), build the project simply by entering `make` at a command prompt.

Entering `make clean` will delete all the files in the `build\` folder but nothing else.

Entering `make flash` will flash the built binary file to the Tiva microcontroller.

To verify that everything works, open a terminal emulator (`screen` or `PuTTY`, for example).
On my system, I do the following:
```
screen /dev/ttyACM0 115200
```

`/dev/ttyACM0` is the port over which the Tiva and my laptop communicate.
Windows users will need to specify a COM port instead.

I found the port name by entering `ls /dev/tty*` at a command prompt, before and after plugging in and powering on the Tiva, and looking at the difference in the command's output.

The `115200` is the baud rate at which Tiva-PC communication happens.

If everything worked, you should now see `Hello World!` repeatedly printing to your terminal emulator.
