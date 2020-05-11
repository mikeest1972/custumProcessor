// Mux 2 to 1 


module mux2To1(

    selector,
    a,
    b,
    out
);
`include "parameters.v"

input selector;
input [registerDataWidth-1:0] a;
input [registerDataWidth-1:0] b;
output [registerDataWidth-1:0] out;

assign out = selector ? b : a;
endmodule