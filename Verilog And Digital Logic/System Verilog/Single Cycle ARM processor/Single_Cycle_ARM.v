/*Status elements:
Program counter
status Clock
register file
data memory*/
module arm(input logic clk, reset,
        output logic[31:0] PC,
        input logic[31:0] Instr,
        output logic MemWrite,
        output logic[31:0] ALUResult, WriteData,
        input logic[31:0] ReadData);
    
    logic[31:0] ALUFlags;
    logic       RegWrite,
                ALUSrc, MemtoReg, PCSrc;
    logic[1:0]  RegSrc, ImmSrc, ALUControl;

    controller c(clk, reset,
                Instr[31:12] , ALUFlags
                RegSrc, RegWrite, ImmSrc,
                ALUSrc, ALUControl,
                MemWrite, MemtoReg, PCSrc);
    
    datapath dp(clk, reset, 
                RegSrc, RegWrite, ImmSrc,
                ALUSrc, ALUControl,
                MemtoReg, PCSrc,
                ALUFlags, PC, Instr,
                ALUResult, WriteData, ReadData);
endmodule

// ____________________________________________


//DataPath
module datapath(input logic     clk, reset,
                input logic [1:0] RegSrc,
                input logic      RegWrite,
                input logic [1:0] ImmSrc,
                input logic     ALUSrc,
                input logic[1:0] ALUControl,
                input logic     MemtoReg,
                input logic     PCSrc,
                output logic [3:0] ALUFlags,
                output logic [31:0] PC,
                input logic [31:0] Instr,
                output logic[31:0] ALUResult, WriteData,
                input logic [31:0] ReadData);

    logic [31:0] PCNext, PCPlus4, PCPlus8;
    logic [31:0] ExtImm, SrcA, SrcB, Result;
    logic [3:0] RA1, RA2;

    //Next program counter logic
    mux2 #(32)  pcMux(PCPlus4, Result, PCSrc, PCNext);
    flopr #(32) pcreg(clk, reset, PCNext, PC);
    //PCPLUS4 Adder
    adder #(32) pcAdd4(PC, 32'b100, PCPlus4);
    //PCPLUS8 Adder
    adder #(32) pcAdd8(PCPlus4, 32'b100, PCPlus8);
    //Immediate Extension Logic
    extend  ext(Instr[23:0] , ImmSrc, ExtImm);


//Necessary Modules
//Multiplexer
module mux2 #(parameter N=32)(input logic [N-1:0] a,b,
            input logic s,
            output logic [N-1:0] y);

    assign y = s ? b : a;
endmodule

//reset-register
module flopr #(parameter Width=32)(input logic clk, reset,
            input logic  [Width-1:0] d,
            output logic [Width-1:0] q);

    always_ff @(posedge clk, posedge reset)
    if (reset) q<=0;
    else q<=d;

endmodule

//reset-enable register
module flopr #(parameter Width=32)(input logic clk, reset, en,
            input logic  [Width-1:0] d,
            output logic [Width-1:0] q);

    always_ff @(posedge clk, posedge reset)
    if (reset) q<=0;
    else if (en) q<=d;
endmodule


//Adder
module adder #(parameter N=32) 
            (input logic[N-1:0] a,b,
            input logic     Cin,
            output logic [N-1:0] S,
            output logic    Cout);

    assign {Cout, S} = a + b + Cin;
endmodule

//Register File logic
mux2 #(4) RA1mux(Instr[19:16], 4'b1111, RegSrc[0] , RA1);
mux2 #(4) RA2mux(Instr[3:0] , Instr[15:12] , RegSrc[1] , RA2);
regfile   rf(clk, RegWrite, RA1, RA2, 
            Instr[15:12] , Result, PCPlus8,
            SrcA, WriteData);
mux2 #(32) resMux(ALUResult, ReadData, MemtoReg, Result);



//Register file module
module regFile(input logic  clk,
                input logic WE3, //->Write enable signal
                input logic [3:0] RA1, RA2, WA3,
                input logic[31:0] WD3, R15,
                output logic[31:0] RD1,RD2);

    logic [31:0] rf[14:0];

    //three ported register file
    //read two ports combinationally
    //write third port on rising edge of clock
    //register 15 read PC+8 instead

    always_ff @(posedge clk)
        if (WE3) rf[WA3] <= WD3;

    assign RD1 = (RA1 == 4'b1111) ? R15 : rf[RA1];
    assign RD2 = (RA2 == 4'b1111) ? R15 : rf[RA2]; 

endmodule


//ALU Logic
mux2 #(32) SrcBmux(WriteData, ExtImm, AluSrc, SrcB);
ALU     alu(SrcA, Srcb,  ALUControl,  ALUResult, ALUFlags);



//Immediate Extension
//extend  ext(Instr[23:0] , ImmSrc, ExtImm);
module extend(input logic [23:0] Instr,
            input logic [1:0] ImmSrc,
            output logic [31:0] ExtImm);

    always_comb
        case(ImmSrc)
    //8-bit unsigned Immediate constant
    2'b00: ExtImm = {24'b00, Instr[7:0] }; //->Data Processing Instructions

    2'b01: ExtImm = {20'b00, Instr[11:0] }; //->Memory Transfer, 12-Bit unsigned Immediate

    //24-bit two's complement shifted branch
    2'b10 ExtImm = { {6[Instr[23]]}, Instr[23:0], 2'b00 }; //-> 6 times replicating(copying) the sign bit -> Preserving it

    default: ExtImm = 32'bx;
        endcase
endmodule


// ____________________________________

//Control Unit
//decoder example
/*
A1 A0  Y3 Y2 Y1 Y0
0  0   0  0  0  1 ~A . ~B
0  1   0  0  1  0 ~A.B 
1  0   0  1  0  0 A.~B
1  1   1  0  0  0 A.B

    Y = (~A & ~B) + (~A & B) + (A & ~B) + (A & B)
    Y = ~A(B + ~B) + A & ~B + A & B
    Y = ~A + (A & ~B) + (A & B)
    
*/
