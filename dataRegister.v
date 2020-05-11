// Data register 
// stroes a data word in a reg


module dataRegister(

    inData,
    outData,
    clk,
    clear
);
`include "parameters.v"

input [registerDataWidth-1:0] inData;
input clk;
input clear;

output reg [registerDataWidth-1:0] outData;


always @(posedge clk)begin
    // store and output 
    //blocking becaue you want that to happen befoe overwiting it
    if(clear)begin
        outData =0;
    end
    else begin
        outData <= inData;
    end
    
end


endmodule

module dataRegisterInstruction(
    inData,
    outData,
    clk,
    irWrite,
    clear
);

`include "parameters.v"

input [instructionWidth-1:0] inData;
input clk;
input clear;
input irWrite;
output reg [instructionWidth-1:0] outData;



always @(posedge clk)begin
    

    if(irWrite) begin
        //$display(inData);
        outData <= inData;
    end
    
    
end


endmodule