# Tiva Makefile
# #####################################
#
# Part of the uCtools project
# uctools.github.com
#
#######################################
# user configuration:
#######################################
# TARGET: name of the output file
TARGET = main
# MCU: part number to build for
MCU = TM4C123GH6PM
# SOURCES: list of input source sources
SRCDIR = src
INCDIR = inc
SOURCES := $(wildcard $(SRCDIR)/*.c)
# INCLUDES: list of includes, by default, use Includes directory
# INCLUDES := $(wildcard $(SRCDIR)/*.h)
# OUTDIR: directory to use for output
OUTDIR = build
# TIVAWARE_PATH: path to tivaware folder
TIVAWARE_PATH = $(HOME)/Embedded/tivaware
# FLASH_PATH: path to lm4flash
FLASH_PATH = $(HOME)/Embedded/lm4tools/lm4flash

# additional libraries
# libdriver.a path: tivaware/driverlib/gcc/
DRIVERLIB_PATH = $(HOME)/Embedded/tivaware/driverlib/gcc
LDLIBS = -L$(DRIVERLIB_PATH) -ldriver

# LD_SCRIPT: linker script
LD_SCRIPT = $(MCU).ld

# define flags
CFLAGS = -g -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard
# commented out: floating point flag
CFLAGS += -fsingle-precision-constant
# CFLAGS = -g -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp
CFLAGS +=-Os -ffunction-sections -fdata-sections -MD -std=c99 -Wall
CFLAGS += -pedantic -DPART_$(MCU) -c -I$(TIVAWARE_PATH) -I$(INCDIR)
CFLAGS += -DTARGET_IS_BLIZZARD_RA1
LDFLAGS = --entry ResetISR --gc-sections -T$(LD_SCRIPT)

#######################################
# end of user configuration
#######################################
#
#######################################
# binaries
#######################################
CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
# LD = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
RM      = rm -f
MKDIR	= mkdir -p
#######################################

# list of object files, placed in the build directory regardless of source path
OBJECTS = $(addprefix $(OUTDIR)/,$(notdir $(SOURCES:.c=.o)))

# default: build bin
all: $(OUTDIR)/$(TARGET).bin

$(OUTDIR)/%.o: src/%.c | $(OUTDIR)
	$(CC) -o $@ $^ $(CFLAGS)

$(OUTDIR)/a.out: $(OBJECTS)
	$(LD) -o $@ $^ $(LDFLAGS) $(LDLIBS)

$(OUTDIR)/main.bin: $(OUTDIR)/a.out
	$(OBJCOPY) -O binary $< $@

# create the output directory
$(OUTDIR):
	$(MKDIR) $(OUTDIR)

flash:
		$(FLASH_PATH)/lm4flash $(shell pwd)/$(OUTDIR)/main.bin

clean:
	-$(RM) $(OUTDIR)/*

.PHONY: all clean

.PHONY: print_vars
print_vars:
	@echo "SRCDIR:" $(SRCDIR)
	@echo "SOURCES:" $(SOURCES)
	@echo "INCLUDES:" $(INCDIR)
	@echo "TIVAWARE_PATH:" $(TIVAWARE_PATH)
	@echo "LDLIBS:" $(LDLIBS)
	@echo "OUTDIR:" $(OUTDIR)
