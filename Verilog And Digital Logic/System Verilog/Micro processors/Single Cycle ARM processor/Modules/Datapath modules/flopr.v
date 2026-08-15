//reset-register
module flopr #(parameter Width=32)(input logic clk, reset,
            input logic  [Width-1:0] d,
            output logic [Width-1:0] q);

    always_ff @(posedge clk, posedge reset)
    if (reset) q<=0;
    else q<=d;

endmodule



//Adder
module adder #(parameter N=32) 
            (input logic [N-1:0] a,b,
            output logic [N-1:0] y);

    assign y = a + b;
endmodule
