module sillyfunction(input logic a,b,c,
                    output logic y);//logic used in system verilog instead of reg to avoid confusion(0's and 1's)

assign y = ~a & ~b & ~c | a & b &~c | a & ~b & c;
endmodule