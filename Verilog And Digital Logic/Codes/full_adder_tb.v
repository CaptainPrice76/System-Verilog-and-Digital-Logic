module full_adder_tb;
    reg test_A; //reg helds the value we can change in sumulation.
    reg test_B;
    wire test_sum;  //wire observes what the output is.
    wire test_carry;
    reg test_Cin;


//Connect the half adder.
 full_adder uut ( //Creating an instance. unit under test.
    .A(test_A),  // Connect our test switch (t_A) to the chip's pin (A)
    .B(test_B),
    .sum(test_sum),
   .carry(test_carry),
    .Cin(test_Cin)
);

initial begin 
    $dumpfile("dump.vcd");
    $dumpvars(0, full_adder_tb);

    //test case: 0+1 + cin=0:   sum = 1 and (final)carry = 0
    test_A = 0; test_B = 1; test_Cin = 0; #10; 

    
    //test 1+1 + cin = 0: SUm = 0, Carry = 1
    test_A = 1; test_B = 1; test_Cin = 0;  
    #10;

    //test 1+1+ cin = 1: sum = 1, carry = 1
    test_A = 1; test_B = 1; test_Cin = 1;
    #10;


    $finish;
end
endmodule