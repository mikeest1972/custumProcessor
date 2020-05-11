// ALU control

module aluControl(

    opcode,
    functionCode,
    aluCode,
    clk
);

input [1:0] opcode;
input [3:0] functionCode; // op code + function code makes the entire opcode 
input clk;

output reg [3:0] aluCode;
reg [3:0] decoded;
// function codes
parameter noOpCoe = 'b0000;
parameter addCode = 'b0001;
parameter subCode = 'b0010;
parameter andCode = 'b0011;
parameter orCode = 'b0100;
parameter siltCode = 'b0101; // set if less than
parameter addICode = 'b0110; // add imidiet
parameter subICode = 'b0111;
parameter liCode = 'b1000; // lw imidiet
// op code
parameter opDecode = 'b00; // decode fucntion
parameter opAdd = 'b01; // add
parameter opSub = 'b10; // sub

always @(opcode or functionCode or clk)begin
    
    case (opcode) // opcode 
        opDecode : aluCode <= decoded; // decode funciton code
        opAdd    : aluCode <= addCode; // add
        opSub    : aluCode <= subCode; // subtract
    endcase
    
    case (functionCode) // decodes function code
        addCode  : decoded <= addCode;
        subCode  : decoded <= subCode;
        andCode  : decoded <= andCode;
        orCode   : decoded <= orCode;
        siltCode : decoded <= siltCode;
        addICode : decoded <= addCode;
        subICode : decoded <= subCode;
        liCode   : decoded <= noOpCoe;
    endcase
    

end




endmodule