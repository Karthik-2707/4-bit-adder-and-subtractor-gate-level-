`timescale 1ns / 1ps

module tb_adder_subtractor_4bit;

    
    reg [3:0] a;
    reg [3:0] b;
    reg m;

    
    wire [3:0] s;
    wire cout;

    
    adder_subtractor_4bit uut (
        .a(a), 
        .b(b), 
        .s(s), 
        .cout(cout), 
        .m(m)
    );

    initial begin
        
        $display("Time\t M \t A \t B \t | \t COUT \t S");
        $display("---------------------------------------------------------");
        
        m = 1'b0;
        
        a = 4'd5;  b = 4'd3;  #10; 
        a = 4'd12; b = 4'd4;  #10; 
        a = 4'd0;  b = 4'd0;  #10; 

        
        m = 1'b1;
        
        a = 4'd9;  b = 4'd4;  #10; 
        a = 4'd3;  b = 4'd7;  #10; 
        a = 4'd10; b = 4'd10; #10; 
        $finish;
    end
    initial begin
        $monitor("%0dt\t %b \t %d \t %d \t | \t %b \t %d (bin: %b)", $time, m, a, b, cout, s, s);
    end
      
endmodule
