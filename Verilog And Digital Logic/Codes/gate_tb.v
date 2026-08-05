module basic_and_gate_tb;
    reg test_A;
    reg test_B;
    wire test_Y;

    basic_and_gate uut (
        .A(test_A),
        .B(test_B),
        .Y(test_Y)
    );

//Feeding different inputs over time
initial begin   

    //Time = 0ns. Set both inputs to 0.
    test_A = 0; test_B = 0;
    #10;

    //Flip B to 1
    test_A = 0; test_B = 1;
    #10;

    //Time = 20ns. Flip.
    test_A = 1; test_B = 0;
    #10;

    //Time = 30ns. Flip.
    test_A = 1; test_B = 1;
    #10;

    $finish;
end
endmodule