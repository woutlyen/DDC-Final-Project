`timescale 1ns / 1ps

module num_capture_4bit (
  input   wire  iClk, iRst, iPush, iStop, iFunc, sw0, sw1,
  output  wire  [9:0] oAddr,
  output  wire  [11:0] oData,
  output  wire  oWe 
    );
    
  // 0. State definition
  localparam sReset   = 4'b0111;     //(7)  |
  localparam sInit    = 4'b0000;     //(0)  |
  localparam sIdle    = 4'b0001;     //(1)  |
  localparam sPush    = 4'b0010;     //(2)  |   Set & Change Decimal
  localparam sCount   = 4'b0011;     //(3)  |
  localparam sStop    = 4'b0100;     //(4)  |
  localparam sNext    = 4'b0101;     //(5)  |
  
  localparam sPreSpace= 4'b0110;     //(6)  |
  localparam sSpace   = 4'b1000;     //(8)  |   Add Space (Extra function)
  localparam sSpace2  = 4'b1001;     //(9)  |
  
  localparam sPreNL   = 4'b1010;     //(10) |
  localparam sNL      = 4'b1011;     //(11) |   Move to New Line (Extra function)
  localparam sNL2     = 4'b1100;     //(12) |
  
  localparam sPreDEL  = 4'b1101;     //(13) |
  localparam sDEL     = 4'b1110;     //(14) |   Delete last decimal (Extra function)
  localparam sDEL2    = 4'b1111;     //(15) |
  
  reg[3:0] rFSM_current, wFSM_next;
  
  reg[9:0]  rReset_current, wReset_next;
  
  // 1. State register
  //  - with synchronous reset
  always @(posedge iClk)
  begin
    if (iRst == 1)
      begin
        rFSM_current <= sReset;
        rReset_current <= 0;
      end
    else
      begin
        rFSM_current <= wFSM_next;
        rReset_current <= wReset_next;
      end
  end
  
  // 2. Next state logic
  //  - only defines the value of wFSM_next
  //  - in function of inputs and rFSM_current
  always @(*)
  begin
    case (rFSM_current)
    
      sReset:   if (rReset_current == 599)
                  wFSM_next <= sInit;
                else
                  wFSM_next <= sReset;
      
      sInit:    wFSM_next <= sIdle;
      
      sIdle:    if (iPush == 1)
                  begin
                    wFSM_next <= sPush;
                  end
                else if (iStop == 1)
                  begin
                      wFSM_next <= sStop;
                  end
                else if ((iFunc == 1) && (sw0 == 0) && (sw1 == 0))
                  begin
                      wFSM_next <= sPreSpace;
                  end
                else if ((iFunc == 1) && (sw0 == 1) && (sw1 == 0))
                  begin
                      wFSM_next <= sPreNL;
                  end
                else if ((iFunc == 1) && (sw0 == 1) && (sw1 == 1))
                  begin
                      wFSM_next <= sPreDEL;
                  end
                else
                  begin
                    wFSM_next <= sIdle;
                  end
                
      sPush:    if (iPush == 1)
                  wFSM_next <= sPush;
                else
                  wFSM_next <= sCount;
                
      sCount:   wFSM_next <= sIdle;
      
      sStop:    if (iStop == 1)
                  wFSM_next <= sStop;
                else
                  wFSM_next <= sNext;
      
      sNext:    wFSM_next <= sInit;
      
      sPreSpace:if ((iFunc == 1) && (sw0 == 0) && (sw1 == 0))
                  wFSM_next <= sPreSpace;
                else
                  wFSM_next <= sSpace;
      
      sSpace:   wFSM_next <= sSpace2;
      
      sSpace2:  wFSM_next <= sInit;
      
      sPreNL:   if ((iFunc == 1) && (sw0 == 1) && (sw1 == 0))
                  wFSM_next <= sPreNL;
                else
                  wFSM_next <= sNL;
      
      sNL:      wFSM_next <= sNL2;
      
      sNL2:     wFSM_next <= sInit;
      
      sPreDEL:  if ((iFunc == 1) && (sw0 == 1) && (sw1 == 1))
                  wFSM_next <= sPreDEL;
                else
                  wFSM_next <= sDEL;
      
      sDEL:      wFSM_next <= sDEL2;
      
      sDEL2:     wFSM_next <= sInit;
      
      
      
      default:  wFSM_next <= sInit;
    endcase
  end
  
  // 3. Output logic
  // In this case, we need a register to keep track of the toggling
  
  // 3.1 Define the register
  //reg  rToggle_current, wToggle_next;
  reg[3:0] rCount_current, wCount_next;
  reg r_oWe;
  reg[11:0] r_oData;
  
  reg[9:0] rAddr_current, wAddr_next;
  
  always @(posedge iClk)
  begin
    rCount_current <= wCount_next;
    rAddr_current <= wAddr_next;
  end
  
  // 3.2 Define the value of wToggle_next
  //  - in function of rFSM_current
  //    * when sInit, we reset the register
  //    * when sToggle, we toggle the register
  //    * when others, we keep the value in the register
  always @(*)
  begin
    if (rFSM_current == sReset)
      begin
        wCount_next = 4'b0000;
        wAddr_next = 599- rReset_current;
        wReset_next = rReset_current + 1;
        r_oWe = 1;
        r_oData = 0;
      end
      
    else if (rFSM_current == sInit)
      begin
        wCount_next = 4'b0000;
        wAddr_next = rAddr_current;
        wReset_next = rReset_current;
        r_oWe = 1;
        r_oData = 512;
      end
      
    else if (rFSM_current == sIdle)
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current;
        wReset_next = rReset_current;
        r_oWe = 0;
        r_oData = 512;
      end
      
    else if (rFSM_current == sPush)
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current;
        wReset_next = rReset_current;
        r_oWe = 0;
        r_oData = 512;
      end
      
    else if (rFSM_current == sCount)
      begin
        wCount_next = rCount_current+1;
        wAddr_next = rAddr_current;
        wReset_next = rReset_current;
        
        if(wCount_next == 4'b000)
            r_oData = 512;
        else if(wCount_next == 4'b0001)
            r_oData = 512+32*1;
        else if(wCount_next == 4'b0010)
            r_oData = 512+32*2;
        else if(wCount_next == 4'b0011)
            r_oData = 512+32*3;
        else if(wCount_next == 4'b0100)
            r_oData = 512+32*4;
        else if(wCount_next == 4'b0101)
            r_oData = 512+32*5;
        else if(wCount_next == 4'b0110)
            r_oData = 512+32*6;
        else if(wCount_next == 4'b0111)
            r_oData = 512+32*7;
        else if(wCount_next == 4'b1000)
            r_oData = 512+32*8;
        else if(wCount_next == 4'b1001)
            r_oData = 512+32*9;
        else if(wCount_next == 4'b1010)
            r_oData = 1056;
        else if(wCount_next == 4'b1011)
            r_oData = 1056+32*1;
        else if(wCount_next == 4'b1100)
            r_oData = 1056+32*2;
        else if(wCount_next == 4'b1101)
            r_oData = 1056+32*3;
        else if(wCount_next == 4'b1110)
            r_oData = 1056+32*4;
        else
            r_oData = 1056+32*5;
        r_oWe = 1;
      end

    else if (rFSM_current == sStop)
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current;
        wReset_next = rReset_current;
        r_oWe = 0;
        r_oData = 512;
      end

    else if (rFSM_current == sNext)
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current+1;
        wReset_next = rReset_current;
        r_oWe = 0;
        r_oData = 512;
      end
      
    else if (rFSM_current == sPreSpace)
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current;
        wReset_next = rReset_current;
        r_oWe = 0;
        r_oData = 512;
      end
      
    else if (rFSM_current == sSpace)
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current;
        wReset_next = rReset_current;
        r_oWe = 1;
        r_oData = 0;
      end
      
    else if (rFSM_current == sSpace2)
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current+1;
        wReset_next = rReset_current;
        r_oWe = 0;
        r_oData = 0;
      end
      
    else if (rFSM_current == sPreNL)
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current;
        wReset_next = rReset_current;
        r_oWe = 0;
        r_oData = 512;
      end
    
    else if (rFSM_current == sNL)
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current;
        wReset_next = rReset_current;
        r_oWe = 1;
        r_oData = 0;
      end
      
    else if (rFSM_current == sNL2)
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current + 40 - rAddr_current%40;
        wReset_next = rReset_current;
        r_oWe = 0;
        r_oData = 512;
      end
      
    else if (rFSM_current == sPreDEL)
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current;
        wReset_next = rReset_current;
        r_oWe = 0;
        r_oData = 512;
      end
    
    else if (rFSM_current == sDEL)
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current;
        wReset_next = rReset_current;
        r_oWe = 1;
        r_oData = 0;
      end
      
    else if (rFSM_current == sDEL2)
      begin
        wCount_next = rCount_current;
        if (rAddr_current != 0)
          begin
            wAddr_next = rAddr_current-1;
          end
        else
          begin
            wAddr_next = rAddr_current;
          end 
        wReset_next = rReset_current;
        r_oWe = 0;
        r_oData = 512;
      end
      
    else
      begin
        wCount_next = rCount_current;
        wAddr_next = rAddr_current;
        wReset_next = rReset_current;
        r_oWe = 0;
        r_oData = 512;
      end
  end
  
  // the oLED connects to the toggle register
  assign oAddr[9:0] = wAddr_next[9:0];
  assign oData[11:0] = r_oData[11:0];
  assign oWe = r_oWe;
  
endmodule

