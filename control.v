// FSM that controlls the data lines of comptuer

module control(

    opcode,
    clk,
    zero,
    reset,
    pcWriteCondition, // conditon to overwrite pc coutner for branch
    pcWrite, // write new pc address from +1
    pcWriteAbsolute, // and and or of the two above
    pcOrData, // acces insctrction memory from pc addres or data adress
    memRead, // read enable for memoery reg
    memWrite, // write enable for memory reg
    memToReg, // write to Registers from memory or alu 
    instructionRegWrite, // write enable to instruction register
    RsDest, // not needed becaue we only do 2 regsiter in rtype instructions
    regWrite, // write enable to register file
    aluSourceA, // to a input of ALU
    aluSourceB, // to b input of ALU
    aluOp, // opcode for the alucontroll
    pcSourece // what to write to pc counter
    
);
`include "parameters.v"
// inputs
input [opCodeWidth-1:0] opcode;
input clk;
input zero;
input reset;
//outputs

output reg pcWriteCondition;
output reg pcWrite;
output reg pcWriteAbsolute;
output reg pcOrData;
output reg memRead;
output reg memWrite;
output reg [1:0] memToReg;
output reg instructionRegWrite;
output reg RsDest;
output reg regWrite;
output reg aluSourceA;
output reg [1:0] aluSourceB;
output reg [1:0] aluOp;
output reg [1:0] pcSourece;


// states

parameter stateReset = 0;
parameter stateInstructionFetch = 1;
parameter stateMemoryAdressComputation = 2;
parameter stateMemoryAccesLW = 3;
parameter stateWriteBack = 4;
parameter stateMemoryAccesSW = 5;
parameter stateExecution = 6;
parameter stateRtypeComp = 7;
parameter stateBranchCompletion = 8;
parameter stateJumpCompletion = 9;
parameter stateID = 10;
parameter stateRtypeI = 11;
parameter stateRtypeIExecute = 12;
parameter stateRtypeICompletion = 13;
parameter stateLWI = 14;
parameter stateLWIWrite = 15;

// 3 becaue we have 9 states and we need 4 bits to represnt it
reg [3:0] currentState; 
reg [3:0] nextState;


always @(posedge clk) begin
    if(reset) begin // go back to beginign
        currentState <= stateReset;
        
    end
    else // normaly progress thorugh state
        currentState <= nextState; 
end


always @(currentState or opcode or zero) begin
    // reset these values so it works properly
    pcWrite <= 1'b0;
    pcSourece <= 3;
    regWrite <= 'b0;
    case (currentState)


        stateReset : begin // 0 Reset
            
            aluOp <= 1;
            nextState <= stateInstructionFetch;
            // set all of the stuff 
            aluSourceA <= 1'b0; // add pc + 1
            memRead <= 1'b1;
            memWrite <= 1'b0;
            regWrite <= 1'b0;
            pcOrData <= 1'b0;
            pcWriteCondition <= 1'b0;
            RsDest = 1'b0;
            memToReg <= 1'b0;
            instructionRegWrite <= 1'b0;
            aluSourceB <= 2'b1;
            
            pcWrite <= 1'b1;
            pcSourece <= 3;

        end
        stateInstructionFetch :  begin // 1 get the instruciont
            //pc + 1
            pcWrite <= 'b1;//1'b0;
            aluOp <= 1;
            aluSourceA <= 1'b0;
            aluSourceB <= 2'b1;
            
            pcSourece <= 'b0;
            memToReg <= 'b0;
            // Ir <- [PC]
            pcOrData <= 'b0;
            memRead = 'b1;
            memWrite = 'b0;
            instructionRegWrite <= 'b1;
             // determin next state
            nextState = stateID;
            
           
        end
        stateID: begin // A what state to go next
            pcWrite = 'b0;
            instructionRegWrite = 0;
            case (opcode)
                // R type instructions
                instruction_NoOp : nextState <= stateExecution;
                instruction_Add : nextState <= stateExecution;
                instruction_Sub : nextState <= stateExecution;
                instruction_Or : nextState <= stateExecution;
                instruction_Addi : nextState <= stateRtypeI;
                instruction_Subi : nextState <= stateRtypeI;

                // Lw/Sw instructions
                instruction_Lw : nextState <= stateMemoryAdressComputation;
                instruction_Sw : nextState <= stateMemoryAdressComputation;
                instruction_Li : nextState <= stateLWI;
                // bneq instruction
                instruction_Bneq : nextState <= stateBranchCompletion;
                 
            endcase
            // try to predict branch
            aluOp <= 2'b1;
            aluSourceA <= 1'b0;
            aluSourceB <= 2'b10;
            

        end
        stateMemoryAdressComputation : begin // 2 
            aluOp <= 2'b1;
            aluSourceA <= 1'b1;
            aluSourceB <= 2'b10;
            // determin nex state

            case (opcode)
                instruction_Lw : nextState <= stateMemoryAccesLW;
                instruction_Sw : nextState <= stateMemoryAccesSW; 
                 
            endcase

        end

        stateMemoryAccesLW : begin // 3 
            
            pcOrData <= 1'b1;
            
            instructionRegWrite = 0;
            memRead <= 'b1;
            memWrite <= 'b0;
            //determin next state
            nextState <= stateWriteBack;
        end

        stateWriteBack : begin // 4
            
            instructionRegWrite = 0;
            RsDest <= 1'b0;
            regWrite <= 1'b1;
            pcSourece <= 'b0;
            memToReg <= 1'b1;
            //determin nex state
            nextState <= stateInstructionFetch;

        end

        stateMemoryAccesSW : begin // 5
            instructionRegWrite = 0;
            pcOrData <= 1'b1;
            memRead = 'b0;
            memWrite = 'b1;
            

            nextState <= stateInstructionFetch;
            
        end

        stateExecution : begin // 6
            aluOp <= 2'b0;
            aluSourceA <= 1'b1;
            aluSourceB <= 2'b0;

            nextState <= stateRtypeComp;
        end

        stateRtypeComp : begin // 7
            instructionRegWrite = 0;
            RsDest <= 1'b1;
            regWrite <= 1'b1;
            memToReg <= 1'b0;

            nextState <= stateInstructionFetch;
            
        end

        stateBranchCompletion : begin // 8
            aluOp <= 2'b10; // subtract to check if they are equal
            instructionRegWrite = 0;
            aluSourceA <= 1'b1;
            aluSourceB <= 2'b0;
            if (zero) begin
                pcWrite <= 1'b0;
            end
            else begin
                pcWrite <= 1'b1;
                pcSourece <= 2'b1;
            end
            

            nextState <= stateInstructionFetch;
        end

        stateRtypeI : begin // detects if R i state
            
            nextState <= stateRtypeIExecute;

        end
        stateRtypeIExecute : begin
            aluSourceA <= 'b1;
            aluSourceB <= 'b10; // from signe extended from imidiet
            nextState <= stateRtypeICompletion;
        end
        stateRtypeICompletion : begin
            aluSourceA <= 'b0;
            regWrite <= 'b1; // saves to cpu register
            memToReg <= 'b0;
            nextState <= stateInstructionFetch;
        end

        stateLWI : begin
            
            nextState <= stateLWIWrite;

        end
        stateLWIWrite : begin
            memToReg <= 'b10;
            regWrite <= 'b1;
            
            nextState <= stateInstructionFetch;
        end

    endcase
    pcWriteAbsolute <= (zero & pcWriteCondition) | (pcWrite); 
end




endmodule