module shifter(
  input [15:0] shift_in,
  output [15:0] shift_out
  );
  
  assign shift_out[15:2] = shift_in[13:0];
  assign shift_out[1:0]  = 2'b0;
endmodule    

module pcshifter( input [11:0] shift_in, output [13:0] shift_out);
  // multiplys by 4 so that the imidietcan map to adresses 
  assign shift_out[13:2] = shift_in[11:0];
  assign shift_out[1:0]  = 2'b0;
endmodule    