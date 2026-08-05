//Conditional Logic
module condlogic(input logic  clk,reset,
                input logic [3:0] Cond,
                input logic    RegW,
                output logic   RegWrite,
                input logic    MemW,
                output logic   MemWrite,
                input logic    PCS,
                output logic   PCSrc,
                input logic [3:0] ALUFlags,  //->N,Z,C,V
                input logic [1:0] FLagW,
                    ) 

logic [1:0] FlagWrite;
logic [3:0] Flags;
logic       CondEx;

flopenr #(2) flagreg1(clk, reset, FlagWrite[1],
                    ALUFlags[3:2] , Flags[3:2]); //->N,Z by logical operators AND, ORR

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


//Write Control Signals
condcheck cc(Cond, Flags, CondEx);
assign FlagWrite = FlagW & {2{CondEx}};
assign RegWrite = RegW & CondEx;
assign MemWrite = MemW & CondEx;
assign PCSrc = PCS & CondEx


module condcheck cc(input logic [3:0] Cond,
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