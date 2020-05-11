
//pc counter

module pcCounter(
    counterIn,
    counterOut,
    clk,
    clear,
    pcWrite
);
`include "parameters.v"
input [adressBusWidth-1:0] counterIn;
input clk;
input clear;
input pcWrite;
output reg [adressBusWidth-1:0] counterOut;
parameter startAdress = programLoadAdress;//'h400; // address where the programs start
reg [adressBusWidth-1:0] count;
always @(posedge clear) begin
    counterOut <= startAdress;
end

always @(posedge clk)begin
    
    if (pcWrite)
        counterOut <= counterIn;
    
end

endmodule // pcCounter