// 4-Bit Adder/Subtractor - Gate-Level Implementation
// Purpose: Performs 4-bit addition or subtraction based on mode input
//
// Operation Modes:
//   m = 0 (Addition):    Result = A + B
//   m = 1 (Subtraction): Result = A - B (using 2's complement)
//
// 2's Complement Subtraction Logic:
//   To compute A - B, we compute A + NOT(B) + 1
//   - XOR gates invert B when m=1: NOT(B)
//   - Setting initial carry-in to m=1 adds the +1
//   - When m=0, XOR gates pass B unchanged and carry-in=0
//
// Example - Subtraction (m=1): 9 - 4
//   A = 1001 (9 decimal)
//   B = 0100 (4 decimal)
//   NOT(B) = 1011 (inverted)
//   1011 + 1 = 1100 (2's complement of 4, which is -4)
//   1001 + 1100 = 0101 (5 decimal), with cout=1 (overflow in unsigned)

module adder_subtractor_4bit(
    input [3:0] a,     // 4-bit first operand
    input [3:0] b,     // 4-bit second operand
    output [3:0] s,    // 4-bit result
    output cout,       // Carry-out (overflow indicator)
    input m            // Mode control: 0=Add, 1=Subtract
    );
    
    // Internal wires for XOR outputs (2's complement conversion)
    wire x1, x2, x3, x4;
    
    // Internal wires for carry propagation between full adders
    wire c0;           // Carry out from FA0 (bit 0)
    wire c1;           // Carry out from FA1 (bit 1)
    wire c2;           // Carry out from FA2 (bit 2)
    // cout is the final carry out (from bit 3)
    
    // ========== 2's Complement Conversion ==========
    // XOR with mode input: when m=1, inverts b for subtraction
    // XOR Truth Table: A XOR B
    //   0 XOR 0 = 0  (m=0: pass b unchanged)
    //   0 XOR 1 = 1  (m=1: invert b)
    //   1 XOR 0 = 1  (m=0: pass b unchanged)
    //   1 XOR 1 = 0  (m=1: invert b)
    
    xor y1(x1, m, b[0]);  // Bit 0: x1 = m XOR b[0]
    xor y2(x2, m, b[1]);  // Bit 1: x2 = m XOR b[1]
    xor y3(x3, m, b[2]);  // Bit 2: x3 = m XOR b[2]
    xor y4(x4, m, b[3]);  // Bit 3: x4 = m XOR b[3]
    
    // ========== 4-Bit Ripple Carry Adder ==========
    // Cascades four full adders with carry rippling through stages
    // Initial carry-in is the mode bit (m):
    //   m=0 → cin=0 for addition
    //   m=1 → cin=1 for +1 in 2's complement
    
    // Full Adder 0 (Least Significant Bit)
    // Adds a[0] and x1 (modified b[0]) with cin=m
    full_adder fa0(
        .A(a[0]),
        .B(x1),
        .CIN(m),        // Initial carry = mode
        .COUT(c0),      // Carry to next stage
        .SUM(s[0])      // Result bit 0
    );
    
    // Full Adder 1
    // Adds a[1] and x2 with cin from FA0
    full_adder fa1(
        .A(a[1]),
        .B(x2),
        .CIN(c0),       // Carry from FA0
        .COUT(c1),      // Carry to next stage
        .SUM(s[1])      // Result bit 1
    );
    
    // Full Adder 2
    // Adds a[2] and x3 with cin from FA1
    full_adder fa2(
        .A(a[2]),
        .B(x3),
        .CIN(c1),       // Carry from FA1
        .COUT(c2),      // Carry to next stage
        .SUM(s[2])      // Result bit 2
    );
    
    // Full Adder 3 (Most Significant Bit)
    // Adds a[3] and x4 with cin from FA2
    full_adder fa3(
        .A(a[3]),
        .B(x4),
        .CIN(c2),       // Carry from FA2
        .COUT(cout),    // Final carry-out (overflow)
        .SUM(s[3])      // Result bit 3
    );
    
    // ========== Overflow Detection ==========
    // cout = 1 indicates:
    //   In UNSIGNED mode (m=0): A + B > 15 (4-bit overflow)
    //   In SIGNED mode (m=1): Sign overflow in subtraction
    //   Discard cout to get 4-bit result; cout signals overflow
    
endmodule
