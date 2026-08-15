

module datapath(input logic        clk,reset,
                input logic        PCWrite,
                input logic [1:0]  AdrSrc,
                input logic        MemWrite,
                input logic [31:0] ReadData,
                input logic [31:0] WriteData,
                input logic [1:0]  RegSrc,
                input logic        RegWrite,
                input logic [1:0]  ImmSrc,
                input logic [1:0]  ALUControl,
                input logic [3:0]  ALUFlags,
                input logic [31:0] PC,
                input logic [31:0] ALUResult,
                input logic [31:0] ALUOut,
                input logic [1:0]  ResultSrc,
                input logic [1:0]  ALUSrcA,
                input logic [2:0]  ALUSrcB);
input logic [3:0]  RA1, RA2,
input logic [31:0] PCNext;
input logic [31:0] ExtIMM, SrcA, SrcB, Result;

















endmodule







//Intermediate Instruction register

module InstrReg(input logic  clk,
                input logic  a,
                input logic  en,
                input logic  y);
            
    always @(posedge clk)
    if (en)
        y = a;
endmodule

InstrReg instr(clk, RD, IRWrite, Instr);



module UnifiedMemory(input logic            clk,
                     input logic [31:0]  A, WD, WE,
                     output logic [31:0]  RD)

        always @(posedge clk)
        
