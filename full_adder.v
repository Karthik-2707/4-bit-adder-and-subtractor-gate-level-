module full_adder(
    input A,
    input B,
    input CIN,
    output COUT,
    output SUM
    );
    wire s1, c1, c2;
    half_adder ha1(.A(A), .B(B), .S(s1), .C(c1));
    half_adder ha2(.A(s1), .B(CIN), .S(SUM), .C(c2));
    or y1(COUT, c1, c2);
endmodule