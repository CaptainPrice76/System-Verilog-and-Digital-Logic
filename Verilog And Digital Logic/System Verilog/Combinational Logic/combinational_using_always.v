module inv(input logic[3:0] a,
            output logic[3:0] y);
    
    always_comb
    y = ~a;
endmodule

always/process
statements can also be used to describe combinational logic behaviorally if
the sensitivity list is written to respond to changes in all of the inputs and
the body prescribes the output value for every possible input combination.

HDLs support blocking and nonblocking assignments in an always/
process statement. A group of blocking assignments are evaluated in the
order in which they appear in the code, just as one would expect in a stan-
dard programming language. A group of nonblocking assignments are
evaluated concurrently; all of the statements are evaluated before any of
the signals on the left hand sides are updated.