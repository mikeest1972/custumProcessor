In my computer 
R-type instruciton write in state 7
R-type imidiet instruciotn wrie in state D
load imidiet instruitons writes in state F

To choose which program is to run you can go to memory.v and un comment the code for loop or the add program depending on what you wish to run by default it has the add program


programOut is connected to the write data input in register file 
so you can see what is writen at end of program

Inside instruciton.txt I wrote all the instruciton for both programs in detail
Inside instrucionTemplet.txt I wrote how the instrucions are made

I have taken the liberty to compile it and run it to generate the simulation file
I have also included the simulation file


How to compile and run

iverilog -o multiCycleMachineTB.vvp multiCycleMachineTB.v
vvp multiCycleMachineTB.vvp
