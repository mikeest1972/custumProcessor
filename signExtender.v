// Sign extender

module signExtender(
    inData,
    outData
);
`include "parameters.v"


input [sizeImmediate-1:0] inData;
output [registerDataWidth-1:0]outData;

parameter diffrence = registerDataWidth - sizeImmediate;


assign outData = {{diffrence{inData[sizeImmediate-1]}},inData};

endmodule // signExtender