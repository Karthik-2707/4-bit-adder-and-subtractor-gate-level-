module adder_subtractor_4bit(
    input [3:0]a,
    input [3:0]b,
    output [3:0]s,
    output cout,
    input m
    );
    wire c0,c1,c2;
    wire x1,x2,x3,x4;
    xor y1(x1,m,b[0]);
    xor y2(x2,m,b[1]);
    xor y3(x3,m,b[2]);
    xor y4(x4,m,b[3]);
    full_adder fa0(.A(a[0]),.B(x1),.CIN(m),.COUT(c0),.SUM(s[0]));
    full_adder fa1(.A(a[1]),.B(x2),.CIN(c0),.COUT(c1),.SUM(s[1]));
    full_adder fa2(.A(a[2]),.B(x3),.CIN(c1),.COUT(c2),.SUM(s[2]));
    full_adder fa3(.A(a[3]),.B(x4),.CIN(c2),.COUT(cout),.SUM(s[3]));
endmodule