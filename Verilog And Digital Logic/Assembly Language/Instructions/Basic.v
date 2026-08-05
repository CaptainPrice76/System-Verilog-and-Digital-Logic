ADD a,b,c

SUB a,b,c

//a=b+c-d

SUB t,c,d

ADD a,b,t


ADD R0,R1,R2



ADD R4,R1,R2

SUB R0,R4,R3


/
//HExadecimal in ARM start with 0x
ADD R7,R7,#4

SUB R8,R7,#0xC

/
MOV R4,#0  //Move instructions.

MOV R5,#0xFF0

/
//ARM uses 32-Bit memory addresses and 32-Bit data words
//And uses a byte-addressable memory.
/*A 32-bit word consists of
four 8-bit bytes, so each word address is a multiple of 4. The most signif-
icant byte (MSB) is on the left and the least significant byte (LSB) is on the
right. Both the 32-bit word address and the data value in Figure 6.1(b) are
given in hexadecimal. For example, data word 0xF2F1AC07 is stored at
memory address 4. By convention, memory is drawn with low memory
addresses toward the bottom and high memory addresses toward the top.*/

/
//Reading memory a = mem[2]
MOV R5,#0
LDR R7, [R5,#8]  //R5 is base register  Holds 0x01EE2842 =  32385090 stored at memory address 8, as R5=0, and multiples of 4 so 
//word address is four times the word number , at address 8-> 8/4 = word 2 

/
//Writing Memory
//mem[5] = 42
MOV R1,#0

MOV R9,#42

STR R9,[R1,#0x14]

/
//Data Processing Instructions

//Logical instructions
//AND, ORR, EOR, BIC(bit clear)
//MVN (move and NOTE)
//BIC R1 AND NOT R2

/*Source Registers
R1 = 0100 0110 | 1010 0001 | 1111 0001 | 1011 0111 
R2 = 1111 1111 | 1111 1111 | 0000 0000 | 0000 0000 */

AND R3,R1,R2 // = 0100 0110 | 1010 0001 | 0000 0000 | 0000 0000 ->also used for bit masking

ORR R4,R1,R2 // = 1111 1111 | 1111 1111 | 1111 0001 | 1011 0111 ->combined bitfields

EOR R5,R1,R2 // = 1011 1001 | 0101 1110 | 1111 0001 | 1011 0111

BIC R6,R1,R2 // = 0000 0000 | 0000 0000 | 1111 0001 | 1011 0111

/*BIC R6, R1, R2 computes R1 AND NOT R2. In
other words, BIC clears the bits that are asserted in R2. In this case, the
top two bytes of R1 are cleared or masked, and the unmasked bottom
two bytes of R1, 0xF1B7, are placed in R6. Any subset of register bits
can be masked.*/

MVN R7,R2   // = 0000 0000 | 0000 0000 | 1111 1111 | 1111 1111

/
//Shift instructions
//rotation and shift
/*LSL(logical shift left), LSR(logical shift right), 
ASR(arithmetic shift right),
ROR(rotate right), rotate left can be performed by complementing a right rotation

right shifts can be either logical (0’s shift into the
most significant bits) or arithmetic (the sign bit shifts into the most signifi-
cant bits)*/


//Source Register
//R5 = 1111 1111 | 0001 1100 | 0001 0000 | 1110 0111

LSL R0,R5,#7  // = 1111 1111 | 0001 1100 | 0001 0000 | 1000 0000

LSR R1,R5,#17 // = 0000 0000 | 0000 0000 | 0111 1111 | 1000 1110 ->SHIFTED 17 BITS BUT FILLED SPACES WITH ZEROS BUT DOESN'T MOVE ALL BITS

/*ASR (Arithmetic Shift Right) in ARM assembly shifts all bits in a register to the right by a specified number of positions
while copying the original sign bit into the vacant bit positions on the left*/

ASR R2,R5,#3  // = 1111 1111 | 1110 0011 | 1000 0010 | 0001 1100

RSR R3,R5,#21 // = 1110 0000 | 1000 0111 | 0011 1111 | 1111 1000

/*Shifting a value left by N is equivalent to multiplying it by 2N. Likewise, arith-
metically shifting a value right by N is equivalent to dividing it by 2N, as
discussed in Section 5.2.5. Logical shifts are also used to extract or assemble
bitfields.*/

//Shifting instructions by register amounts

//R8 = 0000 1000 | 0001 1100 | 0001 0110 | 1110 0111
//R6 = 0000 0000 | 0000 0000 | 0000 0000 | 0001 0100 -> 20

LSL R4,R8,R6 // = 0110 1110 | 0111 0000 | 0000 0000 | 0000 0000 ->R8 SHIFTED BY 20



/
// Multiply Instructions
https://armasm.com/docs/arithmetic/multiplication/


/
//Comparison Flags and Methods
//Current Program Status Register(CPSR)
MOV R0,#5
MOV R1,#2
CMP R0,R1 //SUBTRACTS R1 FROM R0

//The s suffix to trigger comparison

MOV R0,#2
MOV R1,#3
ADDS R0,R1 // = 5-> N=0,Z=0,C=0,V=0


//Zero Flag
MOV R0,#5
MOV R1,#5
SUBS R2,R0,R1 // R2 = R0-R1-> 5-5 = 0-> Z == 1

ADDEQ R3,R0,#10 // stands for add if equal ->EXECUTE THIS BRANCH IF Z == 1 -> TRUE SO-> R3=5+10=15
SUBNE R3,R0,#2 // subtract if equal ->EXECUTE IF Z==0(NUMBERS NOT EQUAL) -> FALSE SO SKIPPED
//FINAL STATE->R3 = 15

//THE NEGATIVE FLAG
MOV R0,#2
MOV R1,#10
SUBS R2,R0,R1 //-> 2-10 -> -8 SO Negative flag is set -> N==1 AND Z==0(as all 32-BITS are not zero)

ADDMI R4,R0,#1 // add if negative(minus) -> As N===1 true -> R4 = 2+1 = 3 EXECUTES
ADDPL R4,R0,#100 // add if plus(positive or zero) -> N==1 -> FALSE -> SKIPPED

//TRACING TEST
MOV R0,#10
MOV R1,#4
CMP R0,R1 //->R0-R1 -> 10-4 = 6 -> Z==0, N==0(PL FLAG SET)

MOVMI R3,#1 // AS N==0 -> FALSE
MOVEQ R3,#2 // AS Z!=1(means all bits are not zero) FLAG SET, SO IT EXECUTES -> R3=2
MOVNE R3,#3 //AS Z==0, SO TRUE -> bits are not equal -> EXECUTES -> R3 = 3

/
//Carry flag -> tracks the BIT-32 -> the overflow bit after addition or subtraction
//two's complement -> -B -> flip all its bits(NOT) and add 1
// B = NOT(B) - 1
//so cmp A,B -> A = A + NOT(B) + 1
/* if A>B i.e like 10>4 -> generates a carry-out as proved by two's complement
Meaning: Because $10 \ge 4$, the sum overflowed the top bit, setting $C = 1$. $C = 1$ means NO borrow occurred.
Meaning: Because $4 < 10$, the addition wasn't big enough to produce a carry-out. $C = 0$ means a borrow WAS needed.*/


// CS -> carry set -> for raw bit manipulation
// HS -> unsigned higher or same -> like ADDHS R0,R1 -> add R0 and R1 if R0 is greater or same as R1


MOV R0,#10
MOV R1,#4
CMP R0,R1

MOVCS R3,#100 //-> Execute if carry is set C==1 (R0>=R1)
MOVCC R3,#200 //->Execute if carry out is zero -> C==0 -> R0<R1

//CC -> carry clear -> execute if carry is clear -> C==0
//LO -> unsigned lower -> execute if R0<R1


MOV R0,#15
MOV R1,#15
CMP R0,R1

MOVHS R2,#50 //move instructions if unsigned higher or same -> C==1 -> true and no borrow happens
MOVLO R2,#99 //move if lower -> C==0


/
//The overflow flag
//while C handles unsigned
/*Signed overflow occurs when an operation produces a result that is too large or too small
to fit in a 32-bit signed integer (range: $-2,147,483,648$ to $+2,147,483,647$).*/

//4-bit signed range: -8 to +7(because does not includes -0 but includes +0 -> 2^4 = 16 posibilities).

MOV  R0, #10
MOV  R1, #20
CMP R0,R1

MOVGE R3,#1 //->EXECUTE if greater than or equal to -> N==V -> N=0 and V=0(if like 5>2)
MOVLT R3,#2 //Execute if less than passes -> -6 < 5 -> -11 but 4-bit gave +5 -> V=1 and N=0 -> opposite -> LT passes ->True

