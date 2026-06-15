module half_adder(
    input A,
    input B,
    output S,
    output C
    );
    xor x1(S,A,B);
    and x2(C,A,B);
endmodule