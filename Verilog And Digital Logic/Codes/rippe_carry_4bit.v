module ripple_carry_4bit_tb;
    reg [3:0] test_A; //reg helds the value we can change in sumulation.
    reg [3:0] test_B;
    reg  test_Cin;
    wire [3:0] test_sum;  //wire observes what the output is.
    wire  test_Cout;
 


//Connect the 4-bit adder.
 ripple_carry_4bit uut ( //Creating an instance. unit under test.
    .A(test_A),  // Connect our test switch (t_A) to the chip's pin (A)
    .B(test_B),
    .sum(test_sum),
   .Cout(test_Cout),
    .Cin(test_Cin)
);

initial begin 
    $dumpfile("dump.vcd");
  $dumpvars(0, ripple_carry_4bit_tb);

    
    //test 2+3 = 5
    //Binary: 0010 + 0011 = 0101 (Cout = 0) 
    test_A = 4'b0010; //A 4bit number written in binary as 0010
    test_B = 4'b0011;
    test_Cin = 0;
    #10;

    //test 7 + 1 = 8
    // = 1000(8) Carry output = 0
    test_A = 4'b0111;
    test_B = 4'b0001;
    test_Cin = 0;
    #10;

    // 12 + 5 = 17. as 4 bits can max 17. it will overflow 4 bits.
    // 1100 + 0101 = 0001 with Carry output = 1
    test_A = 4'b1100;
    test_B = 4'b0101;
    test_Cin = 0;
    #10;


    $finish;
end
endmodule