`timescale 1ns / 1ps

module num_capture_4bit_TB;

  reg   rClk, rRst, rPush, rStop, rFunc, rsw0, rsw1;
  wire  [9:0] w_oAddr;
  wire  [11:0] w_oData;
  wire  w_oWe;
  
  num_capture_4bit    num_capture_4bit_INST
  ( .iClk(rClk), .iRst(rRst), .iPush(rPush), .iStop(rStop), .iFunc(rFunc), .sw0(rsw0), .sw1(rsw1),
  .oAddr(w_oAddr), .oData(w_oData), .oWe(w_oWe));
  
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
  
  // stimulus generator
  initial
  begin
    rRst = 1;       // assert reset
    rPush = 0;      // assert push
    #(2*T);         // wait
    rStop = 0;      // assert push
    rsw0 = 0;
    rsw1 = 0;
    rFunc = 0;
    #(2*T);         // wait
    rRst = 0;       // de-assert reset
    
    #(600*T);         // wait
    
    rPush = 1;      // assert push
    #(2*T);         // wait
    rPush = 0;      // de-assert push
    #(2*T);         // wait
    rPush = 1;      // assert push
    #(2*T);         // wait
    rPush = 0;      // de-assert push
    #(2*T);         // wait
    rPush = 1;      // assert push
    #(2*T);         // wait
    rPush = 0;      // de-assert push
    #(2*T);         // wait
    
    rStop = 1;
    #(5*T);
    rStop = 0;
    #(5*T);
    
    rPush = 1;      // assert push
    #(2*T);         // wait
    rPush = 0;      // de-assert push
    #(2*T);         // wait
    
    rStop = 1;
    #(5*T);
    rStop = 0;
    #(5*T);
    
    rPush = 1;      // assert push
    #(2*T);         // wait
    rPush = 0;      // de-assert push
    #(2*T);         // wait
    rPush = 1;      // assert push
    #(2*T);         // wait
    rPush = 0;      // de-assert push
    #(2*T);         // wait
    rPush = 1;      // assert push
    #(2*T);         // wait
    rPush = 0;      // de-assert push
    #(2*T);         // wait
    rPush = 1;      // assert push
    #(2*T);         // wait
    rPush = 0;      // de-assert push
    #(2*T);         // wait
    rPush = 1;      // assert push
    #(2*T);         // wait
    rPush = 0;      // de-assert push
    #(2*T);         // wait
    rPush = 1;      // assert push
    #(2*T);         // wait
    rPush = 0;      // de-assert push
    #(2*T);         // wait
    
    rStop = 1;
    #(5*T);
    rStop = 0;
    #(20*T);
    
    rFunc = 1;
    #(2*T); 
    rFunc = 0;
    #(2*T); 
    
    #(10*T); 
    
    rsw0 = 1;
    rFunc = 1;
    #(2*T); 
    rFunc = 0;
    #(2*T);
    
    #(10*T);
    
    rsw1 = 1;
    rFunc = 1;
    #(2*T); 
    rFunc = 0;
    #(2*T);
    
    // let the counter run for at least 1 frame
    #(100*T);
    
    $stop;        //stop simulation       
  end
  
endmodule