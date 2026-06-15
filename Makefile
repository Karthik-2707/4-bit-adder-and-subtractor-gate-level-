#!/bin/bash

# ========================================================
# Makefile for 4-Bit Adder/Subtractor Verilog Project
# Purpose: Build, simulate, and analyze the design
# ========================================================

# Compiler and tools
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# File definitions
SOURCES = half_adder.v full_adder.v adder_adder_subtractor_4bit.v
TESTBENCH = adder_and_subtractor_tb.v
SIM_EXECUTABLE = adder_sim
VCD_FILE = dump.vcd
LOG_FILE = simulation.log

# Default target
.DEFAULT_GOAL := help

# ========================================================
# TARGETS
# ========================================================

.PHONY: help
help:
	@echo "========================================================="
	@echo "4-Bit Adder/Subtractor Makefile - Available Targets"
	@echo "========================================================="
	@echo ""
	@echo "Build & Simulate:"
	@echo "  make compile    - Compile Verilog files"
	@echo "  make simulate   - Run simulation (text output)"
	@echo "  make wave       - Simulate and generate waveform file"
	@echo "  make view       - Open waveform in GTKWave"
	@echo ""
	@echo "Utilities:"
	@echo "  make clean      - Remove generated files"
	@echo "  make all        - Compile and simulate"
	@echo "  make help       - Display this help message"
	@echo ""
	@echo "========================================================="

# ========================================================
# Compilation Target
# ========================================================
.PHONY: compile
compile:
	@echo "[BUILD] Compiling Verilog files..."
	$(IVERILOG) -o $(SIM_EXECUTABLE) $(SOURCES) $(TESTBENCH)
	@echo "[BUILD] Compilation successful! ($(SIM_EXECUTABLE) created)"

# ========================================================
# Simulation Targets
# ========================================================

# Run simulation with text output (no waveform)
.PHONY: simulate
simulate: compile
	@echo "[SIM] Running simulation (text output only)..."
	@echo "[SIM] Simulation output:" > $(LOG_FILE)
	@$(VVP) $(SIM_EXECUTABLE) >> $(LOG_FILE) 2>&1
	@cat $(LOG_FILE)
	@echo "[SIM] Simulation complete! Logs saved to $(LOG_FILE)"

# Run simulation and generate VCD waveform file
.PHONY: wave
wave: compile
	@echo "[SIM] Running simulation with waveform generation..."
	@echo "[SIM] VCD file will be saved as: $(VCD_FILE)"
	@$(VVP) $(SIM_EXECUTABLE) -vcd >> $(LOG_FILE) 2>&1
	@echo "[SIM] Waveform file generated: $(VCD_FILE)"
	@echo "[SIM] To view, use: make view"

# View waveform in GTKWave
.PHONY: view
view:
	@if [ -f $(VCD_FILE) ]; then \
		echo "[VIEW] Opening $(VCD_FILE) in GTKWave..."; \
		$(GTKWAVE) $(VCD_FILE) &; \
	else \
		echo "[ERROR] Waveform file $(VCD_FILE) not found!"; \
		echo "[INFO] Generate it first using: make wave"; \
	fi

# ========================================================
# Convenience Targets
# ========================================================

# Do everything: compile and simulate
.PHONY: all
all: simulate

# Clean up generated files
.PHONY: clean
clean:
	@echo "[CLEAN] Removing generated files..."
	rm -f $(SIM_EXECUTABLE) $(VCD_FILE) $(LOG_FILE)
	rm -f dump.vcd dump.gtkw
	rm -f *.o *.vvp
	@echo "[CLEAN] Cleanup complete!"

# ========================================================
# Usage Examples
# ========================================================
# make                 - Show this help message
# make all             - Compile and simulate
# make simulate        - Run text-based simulation
# make wave            - Generate waveform file
# make view            - View waveform in GTKWave
# make clean           - Remove all generated files
# ========================================================
