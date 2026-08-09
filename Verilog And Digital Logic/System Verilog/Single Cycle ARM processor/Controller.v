


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



//Decoder
module decoder(input logic [1:0] Op,
                input logic[5:0] Funct,
                input logic[3:0] Rd,
                output logic [1:0] FlagW,
                output logic    PCS, RegW, MemW,
                output logic    MemtoReg, ALUSrc,
                output logic [1:0] ImmSrc, RegSrc, ALUControl);
            
    logic[9:0] controls;
    logic      Branch, ALUOp;

//Main Decoder
always_comb
    case(Op)






//Conditional Logic
module condlogic(input logic  clk,reset,
                input logic [3:0] Cond,
                input logic    RegW,
                output logic   RegWrite,
                input logic    MemW,
                output logic   MemWrite,
                input logic    PCS,
                output logic   PCSrc,
                input logic [3:0] ALUFlags,  //N,Z,C,V
                input logic [1:0] FLagW,
                    ) 

logic [1:0] FlagWrite;
logic [3:0] Flags;
logic       CondEx;

flopenr #(2) flagreg1(clk, reset, FlagWrite[1],
                    ALUFlags[3:2] , Flags[3:2]); //N,Z by logical operators AND, ORR

flopenr #(2) flagreg0(clk, reset, FlagWrite[0],
                    ALUFlags[1:0] , Flags[1:0]);

module flopenr #(parameter Width = 2) 
                (input logic clk, reset,
                input logic               en,
                input logic  [Width-1:0]   d,    
                output logic [Width-1:0]   q);
    
    always_ff @(posedge clk, posedge reset)
        
        if(reset) q<=2'b0;
        else if(en) q<=d;
endmodule


//Write Controls




