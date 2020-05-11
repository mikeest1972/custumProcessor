// Top module of multycylce machine
`include "multiCycleMachine.v"
module multiCycleMachineTB;
    `include "parameters.v"
    reg clk;
    reg clear;

    wire [instructionWidth-1:0] programOut;
    
    //supply1 Vdd;

    multiCycleMachine uut(

        .clk(clk),
        .clear(clear),
        .programOut(programOut)

    );
    integer c;
    initial begin
        $dumpfile("multiCycleMachine.vcd");
        $dumpvars(0,multiCycleMachineTB);
        clk = 0;
        clear = 0;
        #5;
        //wait to finish reset
        for (c = 0; c<= 4; c = c+1) begin
            clk <= c;
            clear = 1;
            #5;
        end

        for(c = 0; c <= 300; c = c + 1)begin
            clk <= c;
            clear = 0;
            #5;
        end
        clear = 0;
        #5;
        
        #5;
        
        #500;
        $display("Finished running program");
        $finish;
    end

    // always
    //     #5 clk = ~clk;


endmodule