# Tiva_Make
Makefile for Texas Instruments' Tiva-C microcontroller

## Description
Uses a Makefile to build an app for the Tiva-C that blinks an onboard LED and prints "Hello World!" to a UART.
Pretty simple, but the Makefile also supports fancier stuff, especially floating-point math on the Tiva, which can be a pain to figure out from scratch.

## Setup
The setup instructions closely follow [this extremely helpful reference](http://chrisrm.com/howto-develop-on-the-ti-tiva-launchpad-using-linux/).

In particular, the instructions on that page have you create a single `Embedded` folder, within which you install `Tivaware` and `lm4tools`. This simplifies the Makefile, as we'll see below.
If you follow those instructions, you can also install OpenOCD, the Open On-Chip Debugger, but we don't need it for now, so I won't get into it in this project template.

All users: complete Step 1 of the reference linked above.
Linux users: also complete Step 2 of the reference linked above.

Install the software listed below, then clone this repo into your newly-created `Embedded` folder.
### What you need to install
* Windows users only: [MinGW](http://www.mingw.org/)
* Windows users only: [LM4flash](http://www.ti.com/tool/LMFLASHPROGRAMMER) is a firmware-flashing tool (GUI and command line). Take note of where the installer puts LM4flash; you'll need to enter this location in the Makefile later.
* Linux users: [lm4tools](https://github.com/utzig/lm4tools) - contains `lm4flash`, a command-line firmware flashing tool which our Makefile will use.
* All users: download and install the [GNU Arm Embedded Toolchain](https://launchpad.net/gcc-arm-embedded/+download).
This toolchain includes `arm-none-eabi-gcc` (a GCC cross compiler) and `arm-none-eabi-ld` (a GCC linker).
    * Windows users: just download and run the Windows installer.
    * Linux users: download and extract the tarball (`.tar.bz2`)
    * Once installed, you will need to add the `bin` subfolder to your path, permanently (Linux users: edit your `.bashrc` file and then source it).
* All users: download the topmost executable (`.exe`) file from the [Tivaware](http://software-dl.ti.com/tiva-c/SW-TM4C/latest/index_FDS.html) download list.
    * Windows users: just download and run the installer. Take note of where the files are installed, because you'll need to enter this location in the Makefile.
    * Linux users: rename the file extension to `.zip` and extract the file. Compile with `make`.

### Linux users: using LM4flash without sudo privileges
You can set up a _udev rule_ for your device.
These rules won't take effect until you logout and login again.
```console
cd /etc/udev/rules.d
echo "SUBSYSTEM=="usb", ATTRS{idVendor}=="1cbe", ATTRS{idProduct}=="00fd", MODE="0660"" | sudo tee 99-tiva-launchpad.rules
# Remember to unplug and logout
```

### Project structure
Your project should reside in a folder.
For example, this project resides in a folder called `Tiva_Make`.
You can begin a new project by making a duplicate of `Tiva_Make` and renaming it.

In the project's root folder, there must be (at minimum) a `Makefile`, a bootloader (`TM4C123GH6PM.ld`) and three subfolders: `src`, `inc`, and `build`.
* C files (`.c`) that you write go in `src`.
* Header files (`.h`) that you write go in `inc`.
* Files produced during building (compiling and linking) are automatically stored in the `build` folder. You don't need to do anything yourself in the `build` folder.

With one exception, you shouldn't copy any Tivaware code to your project folder.
That one exception is `tivaware/utils/uartstdio.c`: copy that file to your `src` folder.

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

Although the folder structure described earlier simplifies and standardizes the build process, the Makefile needs to know where a few other things are.
### (Linux users) Editing paths in the Makefile
```make
# TIVAWARE_PATH: path to tivaware folder
TIVAWARE_PATH = $(HOME)/Embedded/tivaware

# FLASH_PATH: path to lm4flash
FLASH_PATH = $(HOME)/Embedded/lm4tools/lm4flash

# additional libraries:
# libdriver.a path: tivaware/driverlib/gcc/
DRIVERLIB_PATH = $(HOME)/Embedded/tivaware/driverlib/gcc
```

### (Windows users) Editing paths in the Makefile
```make
# TIVAWARE_PATH: path to tivaware folder
TIVAWARE_PATH = $(HOME???)/Embedded/tivaware

# FLASH_PATH: path to lm4flash
FLASH_PATH = $(HOME???)/Embedded/lm4tools/lm4flash

# additional libraries:
# libdriver.a path: tivaware/driverlib/gcc/
DRIVERLIB_PATH = $(HOME???)/Embedded/tivaware/driverlib/gcc
LDLIBS = -L$(DRIVERLIB_PATH) -ldriver
```

## Operation
Once you're in the top folder of your project (where the Makefile is), build the project simply by entering `make` at a command prompt.

Entering `make clean` will delete all the files in the `build\` folder but nothing else.

Entering `make flash` will flash the built binary file to the Tiva microcontroller.

To verify that everything works, open a terminal emulator (`screen` or `PuTTY`, for example).
On my system, I do the following:
```console
screen /dev/ttyACM0 115200
```

`/dev/ttyACM0` is the port over which the Tiva and my laptop communicate.
Windows users will need to specify a COM port instead.

I found the port name by entering `ls /dev/tty*` at a command prompt, before and after plugging in and powering on the Tiva, and looking at the difference in the command's output.

The `115200` is the baud rate at which Tiva-PC communication happens.

If everything worked, you should now see `Hello World!` repeatedly printing to your terminal emulator.
