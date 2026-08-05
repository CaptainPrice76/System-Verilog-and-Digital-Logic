







module sevenseg(
    input [3:0] data,
    output reg [6:0] segments
);

always @ (*)

case(data)
    0:
        segments = 7'b111_1110;
    1: segments = 7'b011_0000;
    2: segments = 7'b110_1101;
    3: segments = 7'b111_1001;
    4:
        segments = 7'b011_0011;
    5: segments 7'b101_1011;
6: segments 7'b101_1111;
7: segments 7'b111_0000;
8: segments 7'b111_1111;
9: segments 7'b111_1011;

default:
    segments = 7'b000_0000;

endcase
endmodule


//3:8 decoder

module decoder3_8(
    input [2:0] a,
    output reg [7:0] y
);

always @ (*)
case (a)
    3'b000:
        y = 8'b00000001;
    3'b001:
        y = 8'b00000010;
    3'b010:
        y = 8'b00001000;
    3'b011: 
        y  8'b00001000;
3'b100: y  8'b00010000;
3'b101: y  8'b00100000;
3'b110: y  8'b01000000;
3'b111: y  8'b10000000;
 
 //no default case needed as all necessary cases are covered.
endcase
endmodule 



//Priority Circuit

module priority(
    input [3:0] a,
    output reg [3:0] y
);

always @ (*)

//sets output based on most significant bit.
if(a[3]) y = 4'b1000;
else if(a[2])  y = 4'b0100;
else if(a[1]) y = 4'b0010;
else if(a[0]) y = 4'b0001;
else y = 4'b0000;
endmodule


//using cases

module priority_casez(
    input [3:0] a,
    output reg [3:0] y
);

always @ (*)
casez (a)
    4'b1???: y = 4'b1000;
    4'b01??: y = 4'b0100;
    4'b001?: y = 4'b0010;
    4'b0001: y = 4'b0001;

    default: y = 4'b0000;

endcase
endmodule