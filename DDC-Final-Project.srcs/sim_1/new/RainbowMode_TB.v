`timescale 1ns / 1ps

module RainbowMode_TB;

    reg  rClk, rRst, rEnable;
    wire [3:0] wRed, wGreen, wBlue;
    
    RainbowMode
    
    RainbowMode_inst(
        .iClk(rClk), 
        .iRst(rRst),
        .iEnable(rEnable),
        .oRed(wRed),
        .oGreen(wGreen),
        .oBlue(wBlue));
        
  // definition of clock period
  localparam  T = 20;  
  
  // generation of clock signal
  always 
  begin
    rClk = 1;
    #(T/2);
    rClk = 0;
    #(T/2);
  end
  
  initial
  begin
    rRst = 1;       // assert reset
    #(5*T);         // wait
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    rRst = 0;       // de-assert reset
    #(5*T);         // wait
    
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    rEnable = 1;
    #(T/2);
    rEnable = 0;
    #(T/2);
    
    #(5*T);
    
    $stop;        //stop simulation       
  end


endmodule
