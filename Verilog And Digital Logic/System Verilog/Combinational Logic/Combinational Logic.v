
module sillyfunction(input logic a,b,c,
                    output logic y); //logic used in system verilog instead of reg to avoid confusion(0's and 1's)

assign y = ~a & ~b & ~c | a & b &~c | a & ~b & c
endmodule

//bitwise inverters on 4-Bit buses

module inv(input logic[3:0] a, //a[3], a[2] , a[1] , a[0] -> little-endian order
            output logic[3:0] y);
    
    assign y = ~a;
endmodule


//logic gates
module gates(input logic[3:0] a,b,
            output logic[3:0] y1,y2, y3, y4, y5);

/*Five different two-input logic gates acting on 4-bit buses*/

assign y1 = a & b;
assign y2 = a | b;
assign y3 = a ^ b;
assign y4 = ~(a & b); // == ~a | ~b
assign y5 = ~(a | b) // == ~a & ~b 

endmodule


/*SystemVerilog reduction operators are unary operators that
apply a logical operation across
all the bits of a single vector operand to collapse it into a 1-bit result.*/

module and8(input logic[7:0] a,
        output logic y);

assign y = &a; //-> acts on whole bus like checks if whole bus signals are all 1

/*&a is much easier to write than a[7] & a[6] & a[5] &........*/

endmodule



//Condistion assignment
//A 2:1 multiplexer

module mux2(input logic[3:0] a,b
            input logic s,
            output logic[3:0] y);
    
    assign y = s ? b : a; //->compressed if-else in c
endmodule


//4:1 Multiplexer but stages of selecting signals and using AND gate to trigger
//second select signal

module mux4(input logic[3:0] a,b,c,d,
            input logic [1:0] s,
            output logic [3:0] y);

    assign y = s[1] ? (s[0] ? d : c) : (s[0] ? b : a);

endmodule



//Full_Adder
module fulladder(input logic a,b,Cin,
                output logic s,Cout);

logic p,g; //-? internal variables -> same as local variables

assign p = a ^ b;
assign g = a & b;

assign s = p ^ Cin;
assign Cout = g | (p & Cin);

endmodule


//Numbers in systemVerilog
// underscores are ignored in numbers and can be helpful in breaking long numbers

Constans -> N'Bvalue, N->size in bits, B->Letter indicating base, Value->Value of constant

9'h25 -> indicates 9-bit number with a value of 25 to the base 16 = 000100101 to the base 2

'b -> binary, 'o -> octal, 'd -> decimal, 'h -> hexadecimal

zeros are automatically padded

if w is a 6-bit bus, assign w = 'b11 gives w the value 000011.

'0 and '1 in systemVerilog to fill full bus with all 0's or all 1's

If the size is not given, the number is assumed to have as
many bits as the expression in which it is being used.

Examples:   Bits    Base    Value   Stored
3'b101      3       2       5       101->2^2 + 2^0 = 4+1 = 5
'b11        ?       2       3       000........0011
8'b11       8       2       3       00000011
8'b1010_1011 8      2       171     10101011
3'd6        3       10      6       110
6'o42       6       8       34      100010
8'hAB       8       16      171     10101011
42          ?       10      42      000......0101010


/
Z's and X's
z->floating-point value, 
z is particularly useful for describ-
ing a tristate buffer, whose output floats when the enable is 0. 
Recall from
Section 2.6.2 that a bus can be driven by several tristate buffers, exactly one
of which should be enabled. HDL Example 4.10 shows the idiom for a tri-
state buffer. If the buffer is enabled, the output is the same as the input. If the
buffer is disabled, the output is assigned a floating value (z).

x->invalid logic level
/* If a bus is
simultaneously driven to 0 and 1 by two enabled tristate buffers (or other
gates), the result is x, indicating contention. If all the tristate buffers driv-
ing a bus are simultaneously OFF, the bus will float, indicated by z.*/

/*Because CPU B is in the High-Z (z) state, its transistors act like an open switch,
 completely disconnecting it from the wire*/

 module tristate(input logic[3:0] a,
                input logic en,
                output tri[3:0] y);

assign y = en ? a : 4'z;
 
endmodule


/
//Bit-swizzling
/*Often it is necessary to operate on a subset of a bus or to concatenate
(join together) signals to form busses. These operations are collectively
known as bit swizzling.*/

// assign y = { c[2:1] , {3 { d[0] } } , c[0] , 3'b101};
//bit slicing
logic [31:0] instruction;
logic [3:0] rd;
assign rd = instruction[15:12];

//concatenation
logic [7:0] byte0,byte1;
logic [15:0] half_word;
assign half_word = {byte1,byte0} //->Pacts byte1(MSB) and byte0(LSB) together

//replication
/*Repeats a bit or vector $N$ times using the syntax {N{pattern}}.
This is indispensable for sign extension when expanding
a smaller signed number into a larger vector.*/
logic [15:0] imm16;
logic [31:0] sign_ext_imm32;
/*// Replicates the sign bit (imm16[15]) 16 times,
then attaches the original 16-bit immediate value*/
assign sign_ext_imm32 = {{ 16{imm16[15]}} , imm16};

logic [7:0] val_8;

assign val_16 = { {8{val_8[7]}} , val_8};

//byte-swapping
//e.g -> big-endian -> little-endian
logic [31:0] data_in;
assign data_out = { data_in[7:0] , data_in[15:8] , data_in[23:16] , data_in[31:24]};


//Delays
/*include timescale derective -> 'timescale 1ns/1ps , assign #4 y = ..... -> 4ns delay in output
In this file, each unit is 1 ns, and
the simulation has 1 ps precision*/

