# 4-Bit Adder and Subtractor (Gate-Level Implementation)

## Overview
This repository contains a **gate-level Verilog implementation** of a 4-bit adder/subtractor circuit. The design uses fundamental logic gates (XOR, AND, OR) to create a functional arithmetic unit capable of performing both addition and subtraction operations on 4-bit binary numbers.

## Project Structure

### Hierarchy
```
┌─────────────────────────────────────┐
│  4-Bit Adder/Subtractor (Top)      │
│  adder_subtractor_4bit.v            │
└──────────────┬──────────────────────┘
               │
       ┌───────┴────────┐
       │                │
   ┌───▼────────┐   ┌──▼──────────┐
   │ Full Adder │   │ XOR Gates   │
   │ (x4)       │   │ (2's Comp)  │
   └───┬────────┘   └─────────────┘
       │
   ┌───▼────────┐
   │ Half Adder │
   │ (x2)       │
   └────────────┘
```

### Core Modules

#### 1. **half_adder.v**
   - **Purpose**: Basic building block for addition
   - **Inputs**: A, B (1-bit each)
   - **Outputs**: S (Sum), C (Carry)
   - **Logic**: 
     - Sum = A XOR B
     - Carry = A AND B

#### 2. **full_adder.v**
   - **Purpose**: Handles 3-input addition (A, B, and carry-in)
   - **Inputs**: A, B, CIN (1-bit each)
   - **Outputs**: SUM, COUT (1-bit each)
   - **Implementation**: Two half adders + OR gate
   - **Logic**:
     - First half adder adds A and B
     - Second half adder adds result with carry-in
     - Output carry = (c1 OR c2)

#### 3. **adder_subtractor_4bit.v** (Top Module)
   - **Purpose**: 4-bit arithmetic unit for addition/subtraction
   - **Inputs**:
     - `a[3:0]` - First 4-bit operand
     - `b[3:0]` - Second 4-bit operand
     - `m` - Mode control
       - m = 0 → Addition (a + b)
       - m = 1 → Subtraction (a - b using 2's complement)
   - **Outputs**:
     - `s[3:0]` - 4-bit result
     - `cout` - Carry out / Overflow indicator
   - **Implementation**:
     - XOR gates convert b to 2's complement when m=1
     - Four full adders in cascade for bit-wise addition
     - Carry ripple through stages

## Operation

### Mode: Addition (m = 0)
- XOR gates pass b unchanged: b_xor = b
- Carry-in (m) = 0
- Result: S = A + B

**Example**: 5 + 3 = 8
```
  0101 (5)
+ 0011 (3)
-------
  1000 (8), cout = 0
```

### Mode: Subtraction (m = 1)
- XOR gates invert b: b_xor = NOT(b) (1's complement)
- Carry-in (m) = 1 (adds 1 to create 2's complement)
- Result: S = A - B = A + NOT(B) + 1

**Example**: 9 - 4 = 5
```
  9 = 1001
  4 = 0100
  NOT(4) = 1011
  1011 + 1 = 1100 (2's complement of 4)
  1001 + 1100 = 0101 (5), cout = 1
```

## Truth Table

### Addition Mode (m = 0)
| A | B | S | Cout |
|---|---|---|------|
| 0 | 0 | 0 | 0 |
| 5 | 3 | 8 | 0 |
| 12| 4 | 0 | 1 (overflow) |
| 15| 1 | 0 | 1 (15+1=16, wraps) |

### Subtraction Mode (m = 1)
| A | B | S | Cout |
|---|---|---|------|
| 9 | 4 | 5 | 1 |
| 3 | 7 | -4 (1100) | 0 |
| 10| 10| 0 | 1 |

## Simulation

### Testbench: adder_and_subtractor_tb.v
The testbench (`adder_and_subtractor_tb.v`) includes:
- **Addition test cases**: 5+3, 12+4, 0+0
- **Subtraction test cases**: 9-4, 3-7, 10-10
- **Output format**: Shows M (mode), A, B, COUT, S with binary representation

### Running Simulation

#### Using Icarus Verilog:
```bash
# Compile
iverilog -o adder_sim full_adder.v half_adder.v adder_adder_subtractor_4bit.v adder_and_subtractor_tb.v

# Run
vvp adder_sim

# Generate VCD waveform (optional)
iverilog -o adder_sim full_adder.v half_adder.v adder_adder_subtractor_4bit.v adder_and_subtractor_tb.v
vvp adder_sim -vcd
gtkwave dump.vcd
```

#### Using ModelSim:
```bash
vlib work
vlog half_adder.v full_adder.v adder_adder_subtractor_4bit.v adder_and_subtractor_tb.v
vsim work.tb_adder_subtractor_4bit
run -all
```

## Key Design Features

✅ **Gate-Level Implementation**: Uses XOR, AND, OR gates (no high-level operators)
✅ **Modular Design**: Hierarchical structure for easy testing and modification
✅ **Overflow Detection**: Carry-out flag indicates overflow in unsigned operations
✅ **2's Complement Support**: Automatic conversion for signed subtraction
✅ **Cascaded Full Adders**: Ripple carry for 4-bit operations

## Overflow and Edge Cases

- **Unsigned Addition Overflow**: When A + B > 15, cout = 1
- **Signed Subtraction**: Result is in 2's complement form (4-bit signed range: -8 to +7)
- **Example**: 3 - 7 = -4, represented as 1100 (2's complement)

## Files Included

- `half_adder.v` - Half adder module
- `full_adder.v` - Full adder module
- `adder_adder_subtractor_4bit.v` - 4-bit adder/subtractor (top module)
- `adder_and_subtractor_tb.v` - Testbench
- `Schematic*.png` - Gate-level schematics
- `LICENSE` - License information

## Hardware Specifications

| Parameter | Value |
|-----------|-------|
| Bit Width | 4 bits |
| Operation | Addition, Subtraction |
| Max Value (Unsigned) | 15 (4'b1111) |
| Min Value (Signed) | -8 (4'b1000) |
| Max Value (Signed) | +7 (4'b0111) |
| Gate Delay | Depends on technology |

## Future Enhancements

- [ ] 8-bit and 16-bit variants
- [ ] Lookahead carry (CLA) for faster operation
- [ ] Pipelined implementation
- [ ] FPGA deployment (Xilinx/Altera)
- [ ] Synthesis reports
- [ ] Power consumption analysis

## References

- **2's Complement Arithmetic**: [Wikipedia - Two's Complement](https://en.wikipedia.org/wiki/Two%27s_complement)
- **Full Adder**: Standard digital logic design
- **Binary Arithmetic**: IEEE 754 floating-point standard

## Author

Created as a gate-level digital logic design project.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Last Updated**: June 15, 2026
