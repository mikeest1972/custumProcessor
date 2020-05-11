// ALU

module alu(
    a,
    b,
    aluResult,
    zeroFlag,
    aluControl
);
`include "parameters.v"
input [registerDataWidth-1:0] a;
input [registerDataWidth-1:0] b;

input [3:0] aluControl; // recived from the ALU control

output reg [registerDataWidth-1:0] aluResult;
output reg zeroFlag;

reg [registerDataWidth-1:0] aluOutTemp;

always @(*)begin
    case(aluControl)
        4'b0000 : aluResult <= 4'b0; // no op
        4'b0001 : aluResult <= a + b; // add
        4'b0010 : aluResult <= a - b; // sub
        4'b0011 : aluResult <= a && b; // and
        4'b0100 : aluResult <= a || b; // or
        4'b0101: aluResult <= (~a) && b; // a < b 
    endcase
    zeroFlag <= ((a - b) == 0)? 1 : 0;
end


endmodule