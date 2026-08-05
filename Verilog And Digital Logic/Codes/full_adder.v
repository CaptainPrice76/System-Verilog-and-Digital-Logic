module half_adder (
    input A,
    input B,
    output sum,
    output carry
);

assign sum = A ^ B;

assign carry = A & B;

endmodule

module full_adder (
    input A,
    input B,
    input Cin,
    output sum,
    output carry
);

//wires to connect half adders together.

wire s1, c1, c2;

//First instance of half adder. Adds A and B.

half_adder HA1 (
    .A(A), //.A and .B are physical pins on circuit. Take wire A and solder it to pin .A
    .B(B), //A and B are master wires on the main board. either input or sum.
    .sum(s1), //Wire the internal sum. .sum is the physical output pin of half adder.
    .carry(c1) //Wire the internal carry.
);

half_adder HA2 (
    .A(s1),
    .B(Cin),
    .sum(sum), //Final hardware sum output.
    .carry(c2) //Output wire to carry output sum. Soldered.
);

// Final Carry logic: If HA1 OR HA2 generated a carry
assign carry = c1 | c2;

endmodule




