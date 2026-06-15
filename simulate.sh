#!/bin/bash

# ========================================================
# Simulation Script for 4-Bit Adder/Subtractor
# Purpose: Simple automation for compiling and running tests
# Usage: ./simulate.sh [options]
# ========================================================

# Color output for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
IVERILOG=$(which iverilog)
VVP=$(which vvp)
GTKWAVE=$(which gtkwave)

SOURCES="half_adder.v full_adder.v adder_adder_subtractor_4bit.v"
TESTBENCH="adder_and_subtractor_tb.v"
SIM_EXECUTABLE="adder_sim"
VCD_FILE="dump.vcd"

# ========================================================
# Functions
# ========================================================

print_header() {
    echo -e "${BLUE}========================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================================${NC}"
}

print_success() {
    echo -e "${GREEN}[✓] $1${NC}"
}

print_error() {
    echo -e "${RED}[✗] $1${NC}"
}

print_info() {
    echo -e "${YELLOW}[i] $1${NC}"
}

check_tools() {
    print_header "Checking for Required Tools"
    
    if [ -z "$IVERILOG" ]; then
        print_error "iverilog not found! Please install Icarus Verilog"
        exit 1
    else
        print_success "iverilog found: $IVERILOG"
    fi
    
    if [ -z "$VVP" ]; then
        print_error "vvp not found! Please install Icarus Verilog"
        exit 1
    else
        print_success "vvp found: $VVP"
    fi
    
    if [ -z "$GTKWAVE" ]; then
        print_info "gtkwave not found (optional) - waveform viewing disabled"
    else
        print_success "gtkwave found: $GTKWAVE"
    fi
}

check_files() {
    print_header "Checking for Source Files"
    
    for file in $SOURCES $TESTBENCH; do
        if [ ! -f "$file" ]; then
            print_error "File not found: $file"
            exit 1
        else
            print_success "Found: $file"
        fi
    done
}

compile() {
    print_header "Compiling Verilog Files"
    
    print_info "Command: $IVERILOG -o $SIM_EXECUTABLE $SOURCES $TESTBENCH"
    $IVERILOG -o $SIM_EXECUTABLE $SOURCES $TESTBENCH
    
    if [ $? -eq 0 ]; then
        print_success "Compilation successful!"
        print_success "Executable created: $SIM_EXECUTABLE"
    else
        print_error "Compilation failed!"
        exit 1
    fi
}

simulate() {
    print_header "Running Simulation"
    
    print_info "Executing: $VVP $SIM_EXECUTABLE"
    $VVP $SIM_EXECUTABLE
    
    if [ $? -eq 0 ]; then
        print_success "Simulation completed successfully!"
    else
        print_error "Simulation failed!"
        exit 1
    fi
}

simulate_with_wave() {
    print_header "Running Simulation with Waveform Generation"
    
    print_info "Executing: $VVP $SIM_EXECUTABLE -vcd"
    $VVP $SIM_EXECUTABLE -vcd
    
    if [ $? -eq 0 ]; then
        print_success "Simulation completed!"
        if [ -f "$VCD_FILE" ]; then
            print_success "Waveform file generated: $VCD_FILE"
        fi
    else
        print_error "Simulation failed!"
        exit 1
    fi
}

view_waveform() {
    if [ ! -f "$VCD_FILE" ]; then
        print_error "Waveform file not found: $VCD_FILE"
        print_info "Run simulation first: ./simulate.sh wave"
        exit 1
    fi
    
    if [ -z "$GTKWAVE" ]; then
        print_error "GTKWave not found! Cannot view waveform"
        exit 1
    fi
    
    print_header "Opening Waveform Viewer"
    print_info "Launching GTKWave..."
    $GTKWAVE $VCD_FILE &
    print_success "GTKWave launched!"
}

cleanup() {
    print_header "Cleaning Up"
    
    files_to_remove="$SIM_EXECUTABLE $VCD_FILE dump.gtkw"
    for file in $files_to_remove; do
        if [ -f "$file" ]; then
            rm -f "$file"
            print_success "Removed: $file"
        fi
    done
    print_success "Cleanup complete!"
}

show_help() {
    echo -e "${BLUE}========================================================${NC}"
    echo -e "${BLUE}4-Bit Adder/Subtractor Simulation Script${NC}"
    echo -e "${BLUE}========================================================${NC}"
    echo ""
    echo "Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  simulate    - Compile and run simulation (default)"
    echo "  wave        - Compile and run with waveform generation"
    echo "  view        - View generated waveform in GTKWave"
    echo "  clean       - Remove generated files"
    echo "  help        - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Run simulation"
    echo "  $0 wave         # Run and generate waveform"
    echo "  $0 view         # View waveform"
    echo "  $0 clean        # Clean up files"
    echo ""
    echo -e "${BLUE}========================================================${NC}"
}

# ========================================================
# Main Script
# ========================================================

# Default action
ACTION=${1:-simulate}

case $ACTION in
    simulate)
        check_tools
        check_files
        compile
        simulate
        ;;
    wave)
        check_tools
        check_files
        compile
        simulate_with_wave
        ;;
    view)
        check_tools
        view_waveform
        ;;
    clean)
        cleanup
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown option: $ACTION"
        echo ""
        show_help
        exit 1
        ;;
esac

exit 0
