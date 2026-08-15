//IF statements

MOV R0,#10
MOV R1,#7
CMP R0,R1

BNE lblne //BRANCH TO LBLNE IF R0!=R1 i.e Z==0

ADD R1,#3 //ELSE ADD 3 TO R1

B lblexit //jump to end of code(unconditional branching)

lblne
    add R0,#3
lblexit
    .............


/
//While loops

//while R0<5

CMP R0,#5
BGE EXIT

loop operations......
.....

B loop

EXIT
    ...........




ADD R1,R2,#17
B TARGET //->unconditional branching
ORR R1,R1,R3 //NOT EXECUTED
AND R3,R1,#0xFF  //NOT EXECUTED
TARGET
    SUB R1,R1,#78


MOV R0,#4
ADD R1,R0,R0
CMP R0,R1
BEQ THERE //->if Z==1 -> jump to branch
ORR R1,R1,#1 //else do this
THERE
    R1,R1,#78


//if-else statement -> if the IF statement is True-> skip else block
R0 = apples, R1 = oranges, R2 = f, R3 = i
CMP R0,R1
BEQ L1
SUB R2,R2,R3
B L2
L1
    ADD R2,R3,#1
L2


/
//switch/case statements

//traffic light controller example
/*R0 = 0: RED $\rightarrow$ Set output R1 = 10 (Stop)
R0 = 1: YELLOW $\rightarrow$ Set output R1 = 20 (Caution)
R0 = 2: GREEN $\rightarrow$ Set output R1 = 30 (Go)
Default (Any other value): Set output R1 = 0 (Error state)*/

MOV R0,#1

CMP R0,#0
MOVEQ R1,#10
BEQ DONE

CMP R0,#1
MOVEQ R1,#20
BEQ DONE

CMP R0,#2
MOVEQ R1,#30
BEQ DONE

MOV R1,#0 //->default error state
B DONE

DONE



/
//WHILE LOOPS
//R0 = POW, R1 = X
MOV R0,#1
MOV R1,#0

WHILE
    CMP R0,#128
    BEQ DONE
    LSL R0,R0,#1
    ADD R1,R1,#1
    B WHILE //->REPEAT

DONE


/
//For loops
//R0 = i, R1 = sum
//execute until i < 10, i+1

MOV R0,#0
MOV R1,#0

FOR
    CMP R0,#10
    BEQ DONE
    ADD R1,R1,R0
    ADD R0,R0,#1
    B FOR
DONE
