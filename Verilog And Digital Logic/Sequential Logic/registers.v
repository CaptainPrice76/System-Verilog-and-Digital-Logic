






module flop(
    input clk,
    input [3:0] d,
    output reg[3:0] q
);

always @ (posedge clk) //positive edge of clock or positive clock edge

    q <= d; //q gets d

endmodule