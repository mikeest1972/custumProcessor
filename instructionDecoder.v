// Instruction decoder
// Miguel Cota
// 2 operand architecture
// I tried to do it similar to the Zilog z80
// like it has an accumulator I didnt pre determin the accumulato register
// insted it uses Rd and Rs for opertions and overwites Rd

module instructionDecoder(
    instruction,
    opcode,
    Rd,     // used as accumulator (gets overwriten)
    Rs,     // dosnt get overwriten
    immediate,
    clk,
    irWrite,
    clear
    
);


`include "parameters.v"

parameter opcodeLSB = instructionWidth - opCodeWidth;
parameter RdLSB = opcodeLSB-registerFileAdressBits;
parameter RsLSB = RdLSB-registerFileAdressBits;

input [instructionWidth-1:0]instruction;
input clk;
input clear;
input irWrite;
output [opCodeWidth-1:0]opcode;
output [registerFileAdressBits-1:0]Rd;
output [registerFileAdressBits-1:0]Rs;
output [sizeImmediate-1:0]immediate;


//assigne the way to split up the instruction

// instrution: add Rd,Rs
// Rd = Rs + Rd
// | opcode | Rd | Rs | unused |
//      6      5    5      17  
// instuciton: addi Rd,Rs,immediate
// Rs = Rs + imidiet
// | opcode | Rd | unused | unused | immediate |
//      6      5    5      5        12
// instruction lw Rd,Rs[immediate]:
// Rd = (Rs + imidiet)
// | opcode | Rd | Rs | unused | immediate |
//      6      5    5      5        12
// instruction li Rd, immediate
// Rd = imidiet
// | opcode | Rd | unused | immediate |
//      6      5      10       12
// instruction bneq Rd,Rs,immediate
// PC = PC + 4(imidiet); if Rd == Rs; 
// | opcode | Rd | Rs | unused | immediate |
//      6      5    5      5        12
// instruction sw Rd,Rs[immediate]
// | opcode | Rd | Rs | unused | immediate |
//      6      5    5      5        12
// instrution noop
// R0 = R0 + 0

assign opcode = instruction[32:27];//instructionWidth-1:opcodeLSB]; // op code is msb
assign Rd = instruction[26:22];//opcodeLSB-1:RdLSB];
assign Rs = instruction[21:17];
assign immediate = instruction[sizeImmediate-1:0];



endmodule // instructionDecoder