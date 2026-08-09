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
    
    logic[3:0] ALUFlags;
    logic       RegWrite,
                ALUSrc, MemtoReg, PCSrc;
    logic[1:0]  RegSrc, ImmSrc, ALUControl;

    controller c(clk, reset,
                Instr[31:12] , ALUFlags,
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

    //Register File logic
mux2 #(4) RA1mux(Instr[19:16], 4'b1111, RegSrc[0] , RA1);
mux2 #(4) RA2mux(Instr[3:0] , Instr[15:12] , RegSrc[1] , RA2);
regfile   rf(clk, RegWrite, RA1, RA2, 
            Instr[15:12] , Result, PCPlus8,
            SrcA, WriteData);
mux2 #(32) resMux(ALUResult, ReadData, MemtoReg, Result);

//ALU Logic
mux2 #(32) SrcBmux(WriteData, ExtImm, ALUSrc, SrcB);

//Arithmetic Logic Unit
ALU     alu(SrcA, SrcB,  ALUControl,  ALUResult, ALUFlags);

endmodule



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



//Adder
module adder #(parameter N=32) 
            (input logic [N-1:0] a,b,
            output logic [N-1:0] y);

    assign y = a + b;
endmodule





//Register file module
module regfile(input logic  clk,
                input logic WE3, //->Write enable signal
                input logic [3:0] RA1, RA2, WA3,
                input logic[31:0] WD3, R15,
                output logic[31:0] RD1,RD2);

    logic [31:0] rf[14:0];

    //three ported register file
    //read two ports combinationally
    //write third port on rising edge of clock
    //register 15 read PC+8 instead

    initial
        begin
            for(integer i=0; i<15; i++)
                rf[i] = 32'b0;
        end


    always_ff @(posedge clk)
        if (WE3) rf[WA3] <= WD3;

    assign RD1 = (RA1 == 4'b1111) ? R15 : rf[RA1];
    assign RD2 = (RA2 == 4'b1111) ? R15 : rf[RA2]; 

endmodule






//Immediate Extension
//extend  ext(Instr[23:0] , ImmSrc, ExtImm);
module extend(input logic [23:0] Instr,
            input logic [1:0] ImmSrc,
            output logic [31:0] ExtImm);

    always_comb
        case(ImmSrc)
    //8-bit unsigned Immediate constant
    2'b00: ExtImm = {24'b00, Instr[7:0] }; //Data Processing Instructions

    2'b01: ExtImm = {20'b00, Instr[11:0] }; //Memory Transfer, 12-Bit unsigned Immediate

    //24-bit two's complement shifted branch
    2'b10: ExtImm = { {6{Instr[23]}}, Instr[23:0], 2'b00 }; //6 times replicating(copying) the sign bit , Preserving it

    default: ExtImm = 32'bx;
        endcase
endmodule


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





//Controller
module controller(input logic   clk,reset,
                input logic  [31:12] Instr,
                input logic  [3:0]  ALUFlags,
                output logic [1:0]  RegSrc,
                output logic        RegWrite,
                output logic [1:0 ] ImmSrc,
                output logic        ALUSrc,
                output logic [1:0]  ALUControl,
                output logic        MemWrite, MemtoReg,
                output logic        PCSrc);
            
        logic [1:0] FlagW;
        logic       PCS,RegW, MemW;


        //Module Instances

        decoder dec(Instr[27:26] , Instr[25:20] , Instr[15:12],
                    FlagW, PCS, RegW, MemW,
                    MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl);

        condlogic cl(clk, reset, Instr[31:28] , ALUFlags,
                    FlagW, PCS, RegW, MemW,
                    PCSrc, RegWrite, MemWrite);

endmodule



// Decoder
module decoder(input logic [1:0] Op,
                input logic[5:0] funct,
                input logic[3:0] RD,
                output logic [1:0] FlagW,
                output logic    PCS, RegW, MemW,
                output logic    MemtoReg, ALUSrc,
                output logic [1:0] ImmSrc, RegSrc, ALUControl);
            
    logic[9:0] controls;
    logic      Branch, ALUOp;


//Main Decoder
always_comb
    case(Op) //casex to treat don't care values of x(undefined),z(high impedance) as any binary 0 or 1

    2'b00: if(funct[5]) controls = 10'b0001001001; //Data-Processing Immediate, Each bit stands for in the truth table like branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp
           
           else   controls = 10'b0000001001; //Data-Processing Register

    2'b01: if(funct[0])  controls = 10'b0101011000;  //LDR instruction, load instruction from memory and write back to register

            else  controls = 10'b0011010100; //STR instruction to store/load data from register to memory

    2'b10: controls = 10'b1001100010;  //B branch instructions

    default: controls = 10'bx;

    endcase

assign {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp} = controls;


//ALU Decoder

always_comb

    if(ALUOp) begin  //Which datapath instruction to execute
        case(funct[4:1])
            4'b0100: ALUControl = 2'b00; //ADD
            4'b0010: ALUControl = 2'b01; //Subtract
            4'b0000: ALUControl = 2'b10; //AND
            4'b1100: ALUControl = 2'b11; //OR
            default: ALUControl = 2'b00; //Undefined
        endcase
    
    //Flag updates if S bit is set. Carry C and overflow V only for arithmetic operations
    /*FLAG W[1] AND AND OR for only updating the N,Z flags, and ADD,SUB for updating all flags including flagW[0] to update carry, overflow */
    FlagW[1] = funct[0];
    FlagW[0] = funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01);
    end

    else begin
        ALUControl = 2'b00; //ADD for non-datapath instructions
        FlagW  = 2'b00; //donot update flags
    end

    //Program Counter PC logic
    assign PCS = Branch | ((RD == 4'b1111) & RegW);

endmodule




//Conditional Logic
module condlogic(input logic  clk, reset,
                input logic [3:0] Cond,
                input logic [3:0] ALUFlags,  //N,Z,C,V
                input logic [1:0] FlagW,
                input logic    PCS,RegW,MemW,
                output logic   PCSrc, RegWrite, MemWrite);

logic [1:0] FlagWrite;
logic [3:0] Flags;
logic       CondEx;

flopenr #(2) flagreg1(clk, reset, FlagWrite[1],
                    ALUFlags[3:2] , Flags[3:2]); //N,Z by logical operators AND, ORR

flopenr #(2) flagreg0(clk, reset, FlagWrite[0],
                    ALUFlags[1:0] , Flags[1:0]);


//Write Control Signals
condcheck cc(Cond, Flags, CondEx);
assign FlagWrite = FlagW & {2{CondEx}};
assign RegWrite = RegW & CondEx;
assign MemWrite = MemW & CondEx;
assign PCSrc = PCS & CondEx;
endmodule


module flopenr #(parameter Width = 2) 
                (input logic clk, reset,
                input logic               en,
                input logic  [Width-1:0]   d,    
                output logic [Width-1:0]   q);

    always_ff @(posedge clk, posedge reset)
        
        if(reset) q<=0;
        else if(en) q<=d;
endmodule



module condcheck(input logic [3:0] Cond,
                    input logic [3:0] Flags,
                    output logic      CondEx);
        
    logic neg,zero,carry,overflow, ge;
    assign {neg,zero,carry,overflow} = Flags;

    assign ge = (neg == overflow);

    always_comb
        case(Cond)
        4'b0000: CondEx = zero;  //EQ  
        4'b0001: CondEx = ~zero; //NE Cond Field
        4'b0010: CondEx =  carry; //CS(Carry Set) / Hs(unsigned higher or same)
        4'b0011: CondEx = ~carry; //CC(carry clear) / LO(unsigned lower)
        4'b0100: CondEx = neg;  //Minus / Negative
        4'b0101: CondEx = ~neg; //PL->Positive or zero
        4'b0110: CondEx = overflow; //overflow / overflow set
        4'b0111: CondEx = ~overflow; //No overflow / overflow clear
        4'b1000: CondEx = ~zero & carry; //Unsigned Higher
        4'b1001: CondEx = ~(~zero & carry); // equivalent to(by De Moivre's Theorem) zero | ~carry ->unsiged lower or same
        4'b1010: CondEx = ge;  //signed greater than or equal
        4'b1011: CondEx = ~ge;  //signed less than
        4'b1100: CondEx = ~zero & ge;
        4'b1101: CondEx = ~(~zero & ge); // equivalent to zero | ~ge
        4'b1110: CondEx = 1'b1; //Always Case
        default: CondEx = 1'bx; //undefined case. 
    endcase
endmodule



//32-Bit ALU with condition flags
/*N = result[31] signed bit
Z = result==0
C = Carry(for add) and NOT Borrow for SUB
V = different result sign overflow

*/
module ALU (input logic [31:0] a,b,
            input logic[1:0] ALUControl,
            output logic [31:0] Result,
            output logic[3:0] ALUFlags);
        
    logic neg,zero,carry,overflow;
    logic [31:0] binvert;
    logic[32:0] sum;

    assign binvert = ALUControl[0] ? ~b : b;
    assign sum = a + binvert + ALUControl[0];


    always_comb
    case(ALUControl[1:0])
        2'b00: Result = sum;
        2'b01: Result = sum;
        2'b10: Result = a & b;
        2'b11: Result = a | b;
        default: Result = 32'bx;
    endcase

    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry = sum[32] & (ALUControl[1] == 1'b0);
    assign overflow = (ALUControl[1] == 1'b0) &
                        ~(a[31] ^ b[31] ^ ALUControl[0]) &
                        (a[31] ^ sum[31]);

    assign ALUFlags = {neg, zero, carry, overflow};

endmodule



//module to connect processor, Instruction memory and data memory
module top(input logic clk,reset,
            output logic [31:0] WriteData, ALUResult,
            output logic        MemWrite);

    logic [31:0] PC, Instr, ReadData;

    //Instance of ARM Processor Core main module
    arm processor(clk, reset, PC, Instr, MemWrite, ALUResult, WriteData, ReadData);

    //Instance of Instruction Memory ROM
    Imem imem(PC, Instr);

    //Data Memory RAM instance
    Dmem dmem(clk, MemWrite, ALUResult, WriteData, ReadData);

endmodule


//Instruction Memory Module
module Imem(input logic [31:0] a,
            output logic [31:0] rd);
        
    logic [31:0] RAM[0:63]; // 32-bit word size, each entry being 32 bits wide(4 bits),  depth(number of words) being 64

    initial 
        begin
            for(integer i=0, i < 64, i++)
                RAM[i] = 32'b0;

            //Loading machine code instructions 
            $readmemh("memfile.dat", RAM);
        
        end
    
    assign rd = RAM[a[31:2]]; 
endmodule



//Data Memory Module
module Dmem(input logic clk, WE,
            input logic [31:0] a, WD,
            output logic [31:0] rd);
        
    logic [31:0] RAM[0:63];

    assign rd = RAM[a[31:2]];

    always_ff @(posedge clk)
        
        if(WE) RAM[a[31:2]] <= WD;

endmodule 