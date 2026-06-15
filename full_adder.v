// Full Adder - Gate-Level Implementation
// Purpose: 3-bit addition (adds two bits plus a carry-in)
// 
// Truth Table:
// | A | B | CIN | SUM | COUT |
// |---|---|-----|-----|------|
// | 0 | 0 |  0  |  0  |  0   |
// | 0 | 0 |  1  |  1  |  0   |
// | 0 | 1 |  0  |  1  |  0   |
// | 0 | 1 |  1  |  0  |  1   |
// | 1 | 0 |  0  |  1  |  0   |
// | 1 | 0 |  1  |  0  |  1   |
// | 1 | 1 |  0  |  0  |  1   |
// | 1 | 1 |  1  |  1  |  1   |
//
// Implementation:
//   - Uses two half adders in cascade
//   - First half adder: adds A and B
//   - Second half adder: adds sum from first adder with CIN
//   - Final carry: OR of carries from both half adders

module full_adder(
    input A,          // First 1-bit input
    input B,          // Second 1-bit input
    input CIN,        // Carry-in from previous stage
    output COUT,      // Carry-out to next stage
    output SUM        // Sum output
    );
    
    // Internal signals
    wire s1;          // Sum output from first half adder
    wire c1;          // Carry output from first half adder
    wire c2;          // Carry output from second half adder
    
    // First half adder: adds A and B
    half_adder ha1(
        .A(A), 
        .B(B), 
        .S(s1),      // s1 = A XOR B
        .C(c1)       // c1 = A AND B
    );
    
    // Second half adder: adds s1 (from first adder) and CIN
    half_adder ha2(
        .A(s1), 
        .B(CIN), 
        .S(SUM),     // SUM = s1 XOR CIN = (A XOR B) XOR CIN
        .C(c2)       // c2 = s1 AND CIN
    );
    
    // Output carry: combination of carries from both stages
    // COUT = c1 OR c2 = (A AND B) OR ((A XOR B) AND CIN)
    or y1(COUT, c1, c2);
    
endmodule
