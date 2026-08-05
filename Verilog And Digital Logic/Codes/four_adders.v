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

//Creating buses.
module ripple_carry_4bit (
    input [3:0] A, //means a 4-bit bus. wires 0,1,2,3. A[3,2,1,0]
    inout [3:0] B, 
    input Cin, //First Carry from input to output
    output [3:0] sum, //Four bit bus for final mathematical sum
    output Cout //Final carry output if numbers overflow.


);

//Three internal wires to ass carry from one block to the next.
wire c1, c2, c3;

//Adds the first coloumn Bit 0
full_adder FA0(
    .A(A[0]),
    .B(B[0]),
    .Cin(Cin),
    .sum(sum[0]),
    .carry(c1) //c1 carries the output carry wire from 1st adder to the next
);


//Adds the 2nd coloumn Bit 1
full_adder FA1 (
    .A(A[1]),
    .B(B[1]),
    .Cin(c1), //Solders the output c1 to input carry pin of second adder.
    .sum(sum[1]),
    .carry(c2) //second carry wire soldered floating to third adder 
);


//Adds the third adder Bit 2
full_adder FA2 (
    .A(A[2]),
    .B(B[2]),
    .Cin(c2), //Solderes c2 to carry input pin of third adder
    .sum(sum[2]),
    .carry(c3) //Soldere a wire from carry output of third adder to fourth adder
);

//Adds the 4th coloum Bit 3

full_adder FA3 (
    .A(A[3]),
    .B(B[3]),
    .Cin(c3),
    .sum(sum[3]),
    .carry(Cout)  //The final overflow bit.
);


endmodule


