//unsigned multiplier
module multiplier(input logic[3:0] a,b,
                output logic[7:0] y);
        
    assign y = a * b;

endmodule

//signed
module multiplier(input logic signed[3:0] a,b,
                output logic signed [7:0] y);
        
    assign y = a * b;

endmodule