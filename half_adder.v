// Half Adder - Gate-Level Implementation
// Purpose: Basic 1-bit addition building block
// 
// Truth Table:
// | A | B | S | C |
// |---|---|---|---|
// | 0 | 0 | 0 | 0 |
// | 0 | 1 | 1 | 0 |
// | 1 | 0 | 1 | 0 |
// | 1 | 1 | 0 | 1 |
//
// Logic:
//   S (Sum)   = A XOR B  (outputs 1 if inputs are different)
//   C (Carry) = A AND B  (outputs 1 only if both inputs are 1)

module half_adder(
    input A,      // First 1-bit input
    input B,      // Second 1-bit input
    output S,     // Sum output (A XOR B)
    output C      // Carry output (A AND B)
    );
    
    // XOR gate: generates sum
    xor x1(S, A, B);
    
    // AND gate: generates carry
    and x2(C, A, B);
    
endmodule
