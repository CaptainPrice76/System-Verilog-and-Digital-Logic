//resettable registers
/*When simulation begins or power is first applied to a circuit, the output of
a flop or register is unknown. This is indicated with x in SystemVerilog.
Generally, it is good practice to use resettable registers so that
on powerup you can put your system in a known state.
The reset may be
either asynchronous or synchronous. Recall that asynchronous reset
occurs immediately, whereas synchronous reset clears the output only on
the next rising edge of the clock.*/

module flopr(input logic clk,
            input logic reset,
            input logic[3:0] d,
            output logic[3:0] q);
    
    //asynchronous reset
    always_ff @(posedge clk, posedge reset)
    if (reset) q<=4'b0;
    else    q<=d;

endmodule


module flopr(input logic clk,
            input logic reset,
            input logic[3:0] d,
            output logic[3:0] q);
    
    //synchronous reset
    always_ff @(posedge clk)
    if(reset) q<=4'b0;
    else      q<=d;
endmodule
