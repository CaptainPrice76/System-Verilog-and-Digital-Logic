module mux2(
    input [3:0] d0, d1,
    input  s,
    output [3:0] y

  
);



assign y = s ? d1 : d0;
  tristate t0( d0, ~s, y);
    tristate t1( d1, s, y);

endmodule 




module mux4(
    input [3:0] d0, d1, d2, d3,
    input [1:0] s,
    output [3:0] y
);

wire [3:0] low , high;

mux2 lowmux( d0, d1, s[0] , low);
mux2 highmux( d2, d3, s[0], high);
mux2 finalmux( low, high, s[1], y);

endmodule


//Accessing Parts of buses

module mux2_8(
    input [7:0] d0, d1,
    input s,
    output [7:0] y
);

mux2 isbmux( d0[3:0] , d1[3:0] , s , y[3:0]);
mux2 msbmux( d0[7:4] , d1[7:4] , s, y[7:4]);

endmodule

