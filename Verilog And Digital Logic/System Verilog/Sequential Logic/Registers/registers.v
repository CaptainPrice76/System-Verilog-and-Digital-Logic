/*In contrast, SystemVerilog continuous assignment statements
(assign) and VHDL concurrent assignment statements (<=) are reevalu-
ated anytime any of the inputs on the right hand side changes. Therefore,
such code necessarily describes combinational logic.*/

/* q<= d (pronounced “q gets d” Hence, the flip-flop copies d
to q on the positive edge of the clock and otherwise remembers
the old state of q. Note that sensitivity lists are also referred to
as stimulus lists.*/


module flipflop(input logic clk,
                input logic[3:0] d,
                output logic[3:0] q);

    always_ff @(posedge clk)
    q<=d; //-? pronounced as "q gets d"

endmodule

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


