module conditional(
    input [3:0] input1, input2,
    input s,
    output [3:0] y
);

assign y = s ? input1 : input2;

endmodule


//multiplexer with 4 inputs

module mux4(
    input [3:0] input1,input2,input3,input4,
    input [1:0] s,
    output [3:0] y
);

assign y = s[1] ? (s[0] ? input4 : input3) : (s[0] ? input2 : input1);

endmodule


//FULL Adder

module fulladder(
    input a,b,Cin,
    output s, Cout
);


wire p,g;

assign p = a ^ b;
assign g = a & b;

assign s = p ^ Cin;

assign Cout = g | (p & Cin);

endmodule


// 9'h25 A 9 bit number with a value of 25 to the base 16(hexa)

//tristate buffer

module tristate(
    input [3:0] a,
    input en,
    output [3:0] y
);

assign y = en ? a : 4'bz;

endmodule

//bit swizzling


assign y = { c[2:1] , { 3 {d[0]}}, c[0] , 3'b101};

// {} for concatenating buses

//Logic gates with delays

`timescale  1ns/1ps //1ns for each unit and 1ps precision.

module delay_example(
    input a,b,c,
    output y
);

wire ab, bb, cb, n1, n2, n3;

//1 unit delay
assign #1 {ab, bb, c} = ~{a, b, c};

//2 unit delay
assign #2 n1 = ab & bb & cb;
assign #2 n2 = a & bb &cb;
assign #2 n3 = a & b & c;
//4 units delay
assign #4 y = n1 | n2 | n3;

endmodule 