// Register file 

module registerFile(
    readReg1,
    readReg2,
    writeReg,
    writeData,
    dataReg1,
    dataReg2,
    clk,
    regWrite,
    clear
);
`include "parameters.v"

//inputs
input [registerFileAdressBits-1:0]readReg1;
input [registerFileAdressBits-1:0]readReg2;
input [registerFileAdressBits-1:0]writeReg;
input [registerDataWidth-1:0] writeData;
input clk;
input regWrite;
input clear;

// outputs

output [registerDataWidth-1:0] dataReg1;
output [registerDataWidth-1:0] dataReg2;

// registers

reg  [registerDataWidth-1:0] registers[numRegisters-1:0];

always @(posedge clear)
begin
    // clear all registers
   begin: loop
   integer i; 
   $display("Cleaning registers ...");
    for ( i = 0 ;i < numRegisters; i = i + 1) begin
        registers[i] <= 0;
        //$display("Clearing register %0d ",i);
    end
    end
    
end
always @(posedge clk)
    begin
    if (regWrite) begin
        // finds the register we want to write to
       registers[writeReg] <= writeData;
       // used to debug wihtout looking at all signals
       // inside of the terminal
       $display("Write data to: ");
       $display(writeReg);
       $display("Data: ");
       $display(registers[writeReg]);
        
    end
    
    end


assign dataReg1 = (readReg1 ? registers[readReg1] : 16'b0 ) ;
assign dataReg2 = (readReg2 ? registers[readReg2] : 16'b0 ) ;

endmodule