# Overflow Handling Documentation

## Overview
The 4-bit adder/subtractor outputs a carry-out signal (`cout`) that has different meanings depending on the operation mode (addition or subtraction).

## Carry-Out in Addition Mode (m = 0)

### Unsigned Addition Overflow
When performing **unsigned addition**, the `cout` flag indicates overflow:

| A | B | A+B | Result (4-bit) | Cout | Interpretation |
|---|---|-----|---|------|-----------------|
| 5 | 3 | 8 | 1000 | 0 | No overflow, result valid |
| 12 | 4 | 16 | 0000 | 1 | **OVERFLOW**: Sum exceeds 15 |
| 15 | 1 | 16 | 0000 | 1 | **OVERFLOW**: Max + 1 |
| 7 | 8 | 15 | 1111 | 0 | No overflow, result valid |
| 14 | 3 | 17 | 0001 | 1 | **OVERFLOW**: Sum wraps around |

### How It Works
- 4-bit unsigned range: 0 to 15
- When A + B > 15, the result wraps around and `cout = 1`
- **True Result** = `(cout << 4) | s[3:0]` (5-bit representation)
- To detect overflow in code: `if (cout == 1) { /* overflow detected */ }`

### Example: 12 + 4 = 16
```
  1100 (12)
+ 0100 (4)
-------
1 0000 (16 in 5-bit)
^ result = 0000, cout = 1

True value = (1 << 4) | 0000 = 10000 (16 in binary)
```

---

## Carry-Out in Subtraction Mode (m = 1)

### 2's Complement Representation
In subtraction mode, the circuit computes A - B using 2's complement arithmetic:
**A - B = A + NOT(B) + 1**

The `cout` signal has different interpretations depending on whether you're working with **signed** or **unsigned** numbers.

### Unsigned Subtraction (Borrowing)
For unsigned subtraction, `cout = 1` when **no borrow is needed** (result is non-negative).

| A | B | A-B | Result (4-bit) | Cout | Borrow | Interpretation |
|---|---|-----|---|------|--------|-----------------|
| 9 | 4 | 5 | 0101 | 1 | 0 | No borrow needed, result ≥ 0 |
| 3 | 7 | -4 | 1100 | 0 | 1 | **Borrow needed**, A < B |
| 10 | 10 | 0 | 0000 | 1 | 0 | Equal operands, result = 0 |
| 15 | 1 | 14 | 1110 | 1 | 0 | No borrow, result valid |
| 0 | 5 | -5 | 1011 | 0 | 1 | **Borrow**, A < B |

### Signed Subtraction (Sign Overflow)
For signed 4-bit numbers (range -8 to +7), `cout = 1` indicates **no overflow** occurred.

| A (Signed) | B (Signed) | A-B | Result (4-bit) | Cout | Signed Overflow |
|---|---|---|---|------|---|
| 3 | 2 | 1 | 0001 | 1 | No overflow |
| 7 | -1 | 8 | - | 0 | **OVERFLOW** (8 exceeds +7) |
| -8 | 1 | -9 | - | 0 | **OVERFLOW** (-9 exceeds -8) |
| -4 | -4 | 0 | 0000 | 1 | No overflow |

### Example: 3 - 7 = -4

```
A = 0011 (3 decimal)
B = 0111 (7 decimal)

Step 1: Invert B (1's complement)
NOT(B) = 1000 (inverted)

Step 2: Add 1 (2's complement)
1000 + 1 = 1001 (2's complement of 7, equals -7)

Step 3: Add with A
  0011 (3)
+ 1001 (-7 in 2's complement)
-------
0 1100 (result = 1100, which is -4 in 2's complement)
^ cout = 0 (borrow occurred, A < B)

Interpretation:
- Unsigned: Borrow is needed (cout=0)
- Signed: -4 is valid (in range -8 to +7)
```

---

## Hardware Implementation: Cout Interpretation

```verilog
// In subtraction mode (m = 1):
if (cout == 0) {
    // Borrow occurred: A < B (in unsigned)
    // Result is negative (in signed)
    // Actual result = -(2's complement of s[3:0])
    actual_result = -s;
} else if (cout == 1) {
    // No borrow: A >= B (in unsigned)
    // Result is positive or zero (in signed)
    // Actual result = s[3:0] directly
    actual_result = s;
}
```

---

## Summary Table

| Mode | Operation | Cout = 1 | Cout = 0 |
|------|-----------|----------|----------|
| **Addition (m=0)** | A + B | Result ≤ 15 (valid) | Result > 15 (overflow) |
| **Subtraction (m=1)** | A - B | A ≥ B (no borrow) | A < B (borrow needed) |

---

## Practical Examples

### Example 1: Addition with Overflow
```
m = 0 (addition mode)
a = 12, b = 4
Result: s = 0000, cout = 1
Interpretation: 12 + 4 = 16, overflow detected (cout=1)
True value: (1 << 4) | 0 = 16
```

### Example 2: Subtraction with Borrow
```
m = 1 (subtraction mode)
a = 3, b = 7
Result: s = 1100, cout = 0
Interpretation: 3 - 7 = -4
Cout = 0 indicates borrow (A < B)
2's complement decode: 1100 = -4
```

### Example 3: Subtraction without Borrow
```
m = 1 (subtraction mode)
a = 9, b = 4
Result: s = 0101, cout = 1
Interpretation: 9 - 4 = 5
Cout = 1 indicates no borrow (A ≥ B)
Result is positive: 5
```

---

## Design Rationale

The carry-out (`cout`) serves dual purposes:
1. **In Addition**: Overflow detection for unsigned arithmetic
2. **In Subtraction**: Borrow/Sign indicator for relative magnitude comparison

This design follows standard computer arithmetic conventions where:
- `cout = 1` in subtraction typically means "carry out" or "no borrow"
- The 4-bit result can be interpreted as either:
  - Unsigned: 0 to 15
  - Signed (2's complement): -8 to +7

---

## References
- IEEE 754 Floating Point Standard
- 2's Complement Arithmetic (Digital Design by Morris Mano)
- Computer Arithmetic: Algorithms and Hardware Designs by Milos Ercegovac
