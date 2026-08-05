module decoder_2to4 (
    //Ports themselves are declared as wires
    input wire E, //A physical wire coming from a switch
    input wire I0,
    input wire I1,
    output wire O0,

);

assign O0 = E & ~I1 & ~I0; //Solders the gates to output pin
assign O1 = E & ~I1 & I0;
assign O2 = E & ~I0 & I1;
assign O3 = E & I1 & I0;

endmodule

