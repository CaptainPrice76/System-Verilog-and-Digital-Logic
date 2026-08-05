module inv(
    input [3:0] a,
    output [3:0] y
);

assign y = ~a;
// [0:3] big endian order
endmodule


module gates (
    input [3:0] a,b,
    output [3:0] y1, y2, y3, y4, y5
);

assign y1 = a & b;
assign y2 = a | b;
assign y3 = a ^ b;
assign y4 = ~(a & b); // ~= ~a |(+) ~b NAND
assign y5 = ~(a | b); //Nor

endmodule

module AND8(
    input [7:0] a,
    output y
);

assign y = &a; // & 1 if all bits are 1, ~& NAND
/*   | OR,  ~| NOR, 
^ XOR
~^ or ^~ XNOR*/
endmodule

