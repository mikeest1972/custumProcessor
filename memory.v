// Memodry module


module memory(
    address,
    writeData,
    memRead,
    memWrite,
    clk,
    clear,
    dataOutput
);

`include "parameters.v"

input [adressBusWidth-1:0] address;
input [instructionWidth-1:0] writeData;
input memRead;
input memWrite;
input clk;
input clear;

output reg [instructionWidth-1:0] dataOutput;

reg  [instructionWidth-1:0] memoryAdresses [numOfAddresses-1:0]; 
reg [instructionWidth-1:0] dataOutTemp;


always @(posedge clear) begin
    begin:loop
        integer i;
        $display("Clearning memory...");
        for (i = 0; i < numOfAddresses; i = i+1 ) begin

            memoryAdresses[i] <= 0;
            
            
        end
    // All of these instruction are in instrucitons.txt
    
    // C <- A+B
    memoryAdresses['h400] <= 'hA8400010; 
    memoryAdresses['h401] <= 'hA8800020;
    memoryAdresses['h402] <= 'h8440000;
    memoryAdresses['h403] <= 'hB0C00003;
    memoryAdresses['h10] <= 'h1;
    memoryAdresses['h20] <= 'h2;
    
    // for loop
    // memoryAdresses['h400] <= 'h38400000;
    // memoryAdresses['h401] <= 'h38800000;
    // memoryAdresses['h402] <= 'h38C0000B; 
    // memoryAdresses['h403] <= 'h8820000;
    // memoryAdresses['h404] <= 'h28420001;
    // memoryAdresses['h405] <= 'h100460FFD;
    
    $display("Loaded program");
    end
    
    
end

always @(posedge clk)begin
    
    if(memRead && !memWrite)begin
        // read data from memoery addres
        dataOutput <= memoryAdresses[address];
        
        

    end
    if(memWrite && !memRead) begin
        // write to memory

        memoryAdresses[address] <= writeData;
    end
    

end

endmodule