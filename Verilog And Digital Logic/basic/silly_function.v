

module sillyFunction(
    input a, b , c,
    ouput y
);

assign Y = ~a & ~b & ~c |
            a & ~b &~c  | 
            a & ~b & c;

endmodule