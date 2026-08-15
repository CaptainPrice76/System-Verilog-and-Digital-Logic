
//4:1 mux from two 2:1 mux
module mu4(input logic [3:0] a,b,c,d,
        input logic [1:0] s,
        output logic [3:0] y);
    
// assign y = s[1] ? (s[0] ? b : a) : (s[0] ? d : c);
// endmodule
    
    logic [3:0] low,high;



module mux2(input logic[3:0] a,b,
        input logic s,
        output logic[3:0] y);

assign y = s ? b : a;


    mux2 lowmux(a,b,s[0] , low);
    mux2 highmux(c,d,s[0],high);
    mux2 finalmux(low,high,s[1],y);
endmodule 


//Accessing parts of a bus by modules

module mux2_8(input logic[7:0] a,b,
            input logic s,
            output logic[7:0] y);
    
    mux2 lsbmux(a[3:0] , b[3:0] , s , y[3:0]);
    mux2 msbmux(a[7:4] , b[7:4] , s , y[7:4]);

endmodule



