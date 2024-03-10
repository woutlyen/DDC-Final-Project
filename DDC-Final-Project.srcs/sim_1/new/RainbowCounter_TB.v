`timescale 1ns / 1ps

module RainbowCounter_TB;

    reg rClk, rRst;
    wire w_oEnable;

RainbowCounter  RainbowCounter_inst(
    .iClk(rClk),
    .iRst(rRst),
    .oEnable(w_oEnable));
    
    localparam  T = 20;  
  
  // generation of clock signal
  always 
  begin
    rClk = 1;
    #(T/2);
    rClk = 0;
    #(T/2);
  end
  
  // stimulus generator
  initial
  begin
    rRst = 1;       // assert reset
    #(5*T);         // wait
    rRst = 0;       // de-assert reset
    #(5*T);         // wait
    
    #(1680000*T);
    
    $stop;        //stop simulation       
  end
    


endmodule
