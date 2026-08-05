module sillyFunction(
    input a, b , c,
    ouput y
);

assign y = ~a & ~b & ~c |
            a & ~b &~c  | 
            a & ~b & c;

endmodule


// test vectors.



module testbench();

reg a,b,c;
wire y;

//instantiate(to bring a blueprint to life) unit/device under test
sillyFunction dut(a,b,c,y);

//apply one inputs at a time
initial //The initial statement executes the statements in its body at
//the start of simulation.
begin
    a = 0, b = 0, c = 0;
    #10;        // # used for representing number of delays

    c = 1;
    #10;

    b=1;c=0;
    #10;

    c=1;
    #10;

    a=1;b=0;c=0;
    #10;

    c=1;
    #10;

    b=1;c=0;
    #10
    c=1;
    #10;
end
endmodule


//Self checking testbench

module testbench2();

reg a,b,c;
wire y;

sillyFunction dut(a,b,c,y);

//applying inputs one at a time
// and checking results

initial
begin
    a=0;b=0;c=0; 
    #10;
    if(t!==1) $display("000 failed.");
    
    c=1;
    #10;
    if(y!==0) $display("001 failed.");
    
    b=1;c=0;
    #10;
    if(y!==0) $display("010 failed.");

    c=1;
    #10;
    if(y!==0) $display("011 failed.");

    a=1;b=0;c=0;
    #10;
    if(y!==1) $display("100 failed.");

    c=1;
    #10;
    if(y!==1) $display("101 failed.");

    b=1;c=0;
    #10;
    if(y!==0) $display("110 failed.");

    c=1;
    #10;
    if(y!==0) $display("111 failed.");

end
endmodule




//testbench with test vector file

module testbench3();

reg clk,reset;
reg a,b,c,yexpected;
wire y;

reg[31:0] vectornum, errors;
reg[3:0] testvectors[10000:0];

sillyFunction uut(a,b,c,y);

//generate clock

always
begin
    clk = 1;
    #5;
    clk = 0;
    #5;
end

//load vectors at start of test
// and pulse reset

initial
begin
    $readmemb("example.tv", testvectors);
    vectornum = 0; errors = 0;
    reset = 1; 
    #27;
    reset = 0;
end

//applying test vectors on rising edge of clock
always @ (posedge clk)
begin
    #1;
    {a,b,c,yexpected} = testvectors[vectornum];
end

/*New inputs are applied on the rising edge of the clock, and the output
is checked on the falling edge of the clock*/

//check results on falling edge of clock
always @ (negedge clk)
if(~reset)
    begin   // skip during reset
        if(y !== yexpected) 
           begin
            $display("Error: inputs = %b", {a,b,c});
            $display("outputs = %b (%b expected)", y, yexpected),
            errors = errors + 1;
           end
           vectornum = vectornum + 1;
           if(testvectors[vectornum] == 4'bx)
           begin
            $display("%d tests completed with %d errors",
            vectornum, errors);
            $finish
           end
    end
    endmodule