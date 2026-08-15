module mux2 #(parameter width=8) (input logic[width-1:0] a,b ,
                                input logic s,
                                output logic[width-1:0] y);

        assign y = s ? b : a;
endmodule

/*SystemVerilog allows a #(parameter . . . ) statement before
the inputs and outputs to define parameters. The parameter
statement includes a default value (8) of the parameter, in this
case called width. The number of bits in the inputs and out-
puts can depend on this parameter.*/


module mux4_8(input logic[7:0] a,b,c,d,
            input logic[1:0] s,
            output logic[7:0] y);

    logic[7:0] low,high;

    mux2 lowmux(a,b,s[0], low);
    mux2 highmux(c,d,s[0] , high);
    mux2 outmux(low, high, s[1] , y);

endmodule

/*The 8-bit 4:1 multiplexer instantiates three 2:1 multiplex-
ers using their default widths.*/




