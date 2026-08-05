module half_adder_tb;
    reg test_A; //reg helds the value we can change in sumulation.
    reg test_B;
    wire test_sum;  //wire observes what the output is.
    wire test_carry;


//Connect the half adder.
 half_adder uut ( //Creating an instance. unit under test.
    .A(test_A),  // Connect our test switch (t_A) to the chip's pin (A)
    .B(test_B),
    .sum(test_sum),
    .carry(test_carry)
);

initial begin 
    $dumpfile("dump.vcd");
    $dumpvars(0, half_adder_tb);

    test_A = 0; test_B = 0;

    #10;

    test_A = 0; test_B = 1; 
    #10;

    test_A = 1; test_B = 0;
    #10;

    test_A = 1; test_B = 1;
    #10;

    $finish;
end
endmodule