// Mux 4 to 1 


module mux4To1(

    selector,
    a,
    b,
    c,
    d,
    out
);
`include "parameters.v"

input [1:0] selector;
input [registerDataWidth-1:0] a;
input [registerDataWidth-1:0] b;
input [registerDataWidth-1:0] c;
input [registerDataWidth-1:0] d;
output reg [registerDataWidth-1:0] out;



always @(*) begin: MUX

    case (selector)
        2'b00 : out <= a;
        2'b01 : out <= b;
        2'b10 : out <= c;
        2'b11 : out <= d;
    endcase
    
end

endmodule