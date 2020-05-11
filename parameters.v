// Parameters that are shared for the entire project

parameter adressBusWidth = 11;
parameter numOfAddresses = 2048;
parameter programLoadAdress = 'h400;//1024;
parameter dataBusWidth = 16;
parameter registerFileAdressBits = 5;
parameter numRegisters = 32;
parameter registerDataWidth = 16;
parameter instructionWidth = 33;
parameter sizeImmediate = 12;
parameter opCodeWidth = 6;
parameter numOfInstructions = 64;

// Instuctions

parameter instruction_NoOp = 'h0;
parameter instruction_Add = 'h1;

parameter instruction_Sub = 'h2;
parameter instruction_Or = 'h3;
parameter instruction_Addi = 'h5;
parameter instruction_Subi = 'h6;

parameter instruction_Lw = 'h15;
parameter instruction_Sw = 'h16;
parameter instruction_Li = 'h7;
parameter instruction_Bneq = 'h20;


