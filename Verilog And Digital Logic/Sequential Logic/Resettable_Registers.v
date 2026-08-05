







module flopr(
    input clk,
    input reset,
    input [3:0] d,
    output reg [3:0] q
);

//asynchronous reset

always @ (posedge clk, posedge reset)
if(reset) q<=4'b0;
else      q <= d;
endmodule

module flopr(
    input clk,
    input reset,
    input [3:0] d,
    output reg [3:0] q
);

always @ (posedge clk)
if(reset) q <= 4'b0;
else      q <= d;
endmodule


//enabled registers

module flopr(
    input clk,
    input reset,
    input en,
    input [3:0] d,
    output reg [3:0] q
);

always @ (posedge clk)
if(reset) q <= 4'b0;
else if(en)  q <= d;
endmodule


//multiple registers
//a synchronizer

module sync(
    input clk,
    input d,
    output reg q
);

reg n1;


always @ (poedge clk)
begin
    n1 <= d;
    q  <= n1;
end
endmodule



//Latches

module latch(
    input clk,
    input [3:0] d,
    output reg [3:0] q
);

always @ (posedge clk , d)
if (clk) q <= d;

endmodule


//Inverter using always/process

module inv(
    input [3:0] a,
    output reg [3:0] y
);

always @ (*)
y = ~a; // = -> blcoking assignment.
endmodule


//full adder using always/process

module fulladder(
    input a,b,Cin,
    output reg s, Cout
);

reg p,g;

always @ (*) 
begin
    p = a ^ b;
    g = a & b;
    s = p ^ Cin;
    Cout = g | (p & Cin);
end
endmodule
    