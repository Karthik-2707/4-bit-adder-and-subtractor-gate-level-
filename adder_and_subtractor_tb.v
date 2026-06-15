`timescale 1ns / 1ps

// ========================================================
// 4-Bit Adder/Subtractor Testbench
// Purpose: Comprehensive testing of addition and subtraction
//
// Test Coverage:
//   - Basic addition cases
//   - Overflow detection in addition
//   - Basic subtraction cases
//   - Negative number handling (2's complement)
//   - Edge cases (zero, max values)
// ========================================================

module tb_adder_subtractor_4bit;

    // ========== Test Signal Declarations ==========
    reg [3:0] a;       // 4-bit first operand (input)
    reg [3:0] b;       // 4-bit second operand (input)
    reg m;             // Mode control (input): 0=Add, 1=Subtract

    wire [3:0] s;      // 4-bit result (output)
    wire cout;         // Carry-out/Overflow (output)

    // ========== Module Instantiation ==========
    // Connect DUT (Device Under Test) with test signals
    adder_subtractor_4bit uut (
        .a(a), 
        .b(b), 
        .s(s), 
        .cout(cout), 
        .m(m)
    );

    // ========== Test Stimulus ==========
    initial begin
        // Print header with column labels
        $display("========================================================");
        $display("4-BIT ADDER/SUBTRACTOR TEST RESULTS");
        $display("========================================================");
        $display("Time\t M \t A \t B \t | \t COUT \t S \t Operation");
        $display("========================================================");
        
        // ========== ADDITION TESTS (m = 0) ==========
        $display("\n--- ADDITION MODE (m=0): A + B ---\n");
        
        // Test 1: 5 + 3 = 8
        m = 1'b0;
        a = 4'd5;  b = 4'd3;  #10; 
        
        // Test 2: 12 + 4 = 16 (overflow, result wraps to 0)
        a = 4'd12; b = 4'd4;  #10; 
        
        // Test 3: 0 + 0 = 0
        a = 4'd0;  b = 4'd0;  #10;
        
        // Test 4: 15 + 1 = 16 (overflow, max + 1)
        a = 4'd15; b = 4'd1;  #10;
        
        // Test 5: 7 + 8 = 15
        a = 4'd7;  b = 4'd8;  #10;
        
        // Test 6: 10 + 5 = 15
        a = 4'd10; b = 4'd5;  #10;
        
        // ========== SUBTRACTION TESTS (m = 1) ==========
        $display("\n--- SUBTRACTION MODE (m=1): A - B (2's Complement) ---\n");
        
        // Test 7: 9 - 4 = 5
        m = 1'b1;
        a = 4'd9;  b = 4'd4;  #10; 
        
        // Test 8: 3 - 7 = -4 (represented as 1100 in 2's complement)
        a = 4'd3;  b = 4'd7;  #10; 
        
        // Test 9: 10 - 10 = 0 (identity test)
        a = 4'd10; b = 4'd10; #10;
        
        // Test 10: 0 - 5 = -5 (represented as 1011 in 2's complement)
        a = 4'd0;  b = 4'd5;  #10;
        
        // Test 11: 15 - 1 = 14
        a = 4'd15; b = 4'd1;  #10;
        
        // Test 12: 8 - 1 = 7
        a = 4'd8;  b = 4'd1;  #10;
        
        $display("\n========================================================");
        $display("TEST COMPLETE");
        $display("========================================================\n");
        
        $finish;
    end
    
    // ========== Output Monitoring ==========
    // Display real-time results as simulation progresses
    initial begin
        $monitor("%0dt\t %b \t %2d \t %2d \t | \t %b \t %d \t (bin: %b)", 
                 $time, m, a, b, cout, s, s);
    end
    
    // ========== Additional Test Statistics ==========
    // (Optional: Uncomment to add assertions or coverage)
    
    // Overflow detection helper
    wire unsigned_overflow = (m == 1'b0) && cout;  // Overflow in unsigned addition
    wire signed_underflow = (m == 1'b1) && cout;   // Potential underflow in subtraction
    
endmodule
