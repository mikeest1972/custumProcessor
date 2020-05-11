// Top module of multycylce machine
`include "pcCounter.v"
`include "mux2To1.v"
`include "mux4To1.v"
`include "control.v"
`include "instructionDecoder.v"
`include "memory.v"
`include "registerFile.v"
`include "dataRegister.v"
`include "signExtender.v"
`include "leftShift.v"
`include "alu.v"
`include "aluControl.v"

module multiCycleMachine(
    clk,
    clear,
    programOut
);

`include "parameters.v"

input clk;
input clear;

output [instructionWidth-1:0] programOut;
wire clockDelay;


//control wires/buses
wire memReadCon;
wire memWriteCon;
wire pcOrALUCon;
wire pcEnableCon;
wire [1:0] memToRegCon;
wire instructionRegWriteCon;
wire RsDestCont;
wire regWriteCont;
wire aluSourceACont;
wire aluZeroSignal;
wire [1:0] aluSourceBContBus;
wire [1:0] aluOpContBus;
wire [1:0] pcSourceContBus;
// control bus
wire [opCodeWidth-1:0] opCodeBus;

wire [adressBusWidth-1:0] pcInBus;
wire [adressBusWidth-1:0] pcOutBus;
wire [dataBusWidth-1:0] aluOutRegBus;
wire [adressBusWidth-1:0] adressBus;

// insturction bus
wire [instructionWidth-1:0] instructionBus;
wire [registerFileAdressBits-1:0] RsBus;
wire [registerFileAdressBits-1:0] RdBus;
wire [sizeImmediate-1:0] immediateBus;

wire [registerFileAdressBits-1:0] writeRegAdressBus;
wire [dataBusWidth-1:0] memoryRegisterDataBus;
wire [dataBusWidth-1:0] writeDataRegisterBus;
wire [dataBusWidth-1:0] writeDataMemoryBusFromB;

// alu
wire [dataBusWidth-1:0] aluDataToAluRegBus;
wire [dataBusWidth-1:0] data1OutBus;
wire [dataBusWidth-1:0] data2OutBus;
wire [dataBusWidth-1:0] data1RegToMuxA;
wire [dataBusWidth-1:0] data2RegToMuxB;
wire [dataBusWidth-1:0] aluAportInputBus;
wire [dataBusWidth-1:0] aluBportInputBus;
wire [3:0] aluControlSignalBus;

wire [registerDataWidth-1:0] signExtendedBus;
wire [registerDataWidth-1:0] shifterToAluBBus;

wire [instructionWidth-1:0] instructionRegToInstruciton;


assign programOut = writeDataRegisterBus;

pcCounter pc(
    .counterIn(pcInBus),
    .counterOut(pcOutBus),
    .clk(clk),
    .clear(clear),
    .pcWrite(pcEnableCon)
);
//muxes
mux2To1 memoryMux(
    .selector(pcOrALUCon),
    .a(pcOutBus),
    .b(aluOutRegBus),
    .out(adressBus)
);

mux4To1 writeDataMux(
    .selector(memToRegCon),
    .a(aluOutRegBus),
    .b(memoryRegisterDataBus),
    .c(signExtendedBus),
    .d(),
    .out(writeDataRegisterBus)
);
mux2To1 aluMuxA(
    .selector(aluSourceACont),
    .a(pcOutBus),
    .b(data1RegToMuxA),
    .out(aluAportInputBus)
);

mux4To1 aluMuxB(
    .selector(aluSourceBContBus),
    .a(data2RegToMuxB),
    .b(1),//pc + 1
    .c(signExtendedBus), // from sign extendeer
    .d(shifterToAluBBus), // from shift left 2
    .out(aluBportInputBus)
);
mux4To1 pcInSourceMux(
    .selector(pcSourceContBus),
    .a(aluDataToAluRegBus),
    .b(aluOutRegBus),
    .c(), // usused
    .d('h400), 
    .out(pcInBus)

);
// instruction memory
assign #1 clockDelay = clk;
memory instructionMemory(
    .address(adressBus),
    .writeData(data2RegToMuxB),//// here
    .memRead(memReadCon),
    .memWrite(memWriteCon),
    .clk(clockDelay),
    .clear(clear),
    .dataOutput(instructionBus) // to add instrucion reg
);



instructionDecoder instructionRegister(
    .instruction(instructionRegToInstruciton),
    .opcode(opCodeBus),
    .Rd(RdBus),
    .Rs(RsBus),
    .immediate(immediateBus),
    .clk(clk),
    .irWrite(instructionRegWriteCon),
    .clear(clear)
);

registerFile cpuRegisters(
    .readReg1(RsBus),
    .readReg2(RdBus),
    .writeReg(RdBus), // from mux
    .writeData(writeDataRegisterBus), // from mux
    .dataReg1(data1OutBus), 
    .dataReg2(data2OutBus),
    .clk(clk),
    .regWrite(regWriteCont),
    .clear(clear)
);



dataRegister memoryDataRegister(
    .inData(instructionBus[dataBusWidth-1:0]),
    .outData(memoryRegisterDataBus),
    .clk(clk),
    .clear(clear)
);
dataRegister aluADataRegister(
    .inData(data1OutBus),
    .outData(data1RegToMuxA),
    .clk(clk),
    .clear(clear)
);
dataRegister aluBDataRegister(
    .inData(data2OutBus),
    .outData(data2RegToMuxB),
    .clk(clk),
    .clear(clear)
);
dataRegister aluOutDataRegister(
    .inData(aluDataToAluRegBus),
    .outData(aluOutRegBus),
    .clk(clk),
    .clear(clear)
);

dataRegisterInstruction decodeInstrucitonReg(
    .inData(instructionBus),
    .outData(instructionRegToInstruciton),
    .clk(clk),
    .irWrite(instructionRegWriteCon),
    .clear(clear)
);

signExtender signExtend(
    .inData(immediateBus),
    .outData(signExtendedBus)
);

shifter leftShift2Data(
    .shift_in(signExtendedBus),
    .shift_out(shifterToAluBBus)
);



//alu

alu AluModule(
    .a(aluAportInputBus),
    .b(aluBportInputBus),
    .aluResult(aluDataToAluRegBus),
    .zeroFlag(aluZeroSignal),
    .aluControl(aluControlSignalBus)
);

aluControl aluControlModule(
    .opcode(aluOpContBus),
    .functionCode(opCodeBus[3:0]),
    .aluCode(aluControlSignalBus),
    .clk(clk)
);



control computerControl(

    .opcode(opCodeBus),
    .clk(clk),
    .zero(aluZeroSignal),
    .reset(clear),
    .pcWriteCondition(), // conditon to overwrite pc coutner for branch
    .pcWrite(pcEnableCon), // write new pc address from +4
    .pcWriteAbsolute(), // and and or of the two above
    .pcOrData(pcOrALUCon), // acces insctrction memory from pc addres or data adress
    .memRead(memReadCon), // read enable for memoery reg
    .memWrite(memWriteCon), // write enable for memory reg
    .memToReg(memToRegCon), // write to Registers from memory or alu 
    .instructionRegWrite(instructionRegWriteCon), // write enable to instruction register
    .RsDest(RsDestCont), // not needed becaue we only do 2 regsiter in rtype instructions
    .regWrite(regWriteCont), // write enable to register file
    .aluSourceA(aluSourceACont), // to a input of ALU
    .aluSourceB(aluSourceBContBus), // to b input of ALU
    .aluOp(aluOpContBus), // opcode for the alucontroll
    .pcSourece(pcSourceContBus) // what to write to pc counter
    
);
endmodule