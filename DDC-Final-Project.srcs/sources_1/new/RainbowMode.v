`timescale 1ns / 1ps

module RainbowMode(
    input  wire iClk, iRst, 
    input  wire [20:0] iEnable,
     
    output wire [3:0] oRed, oGreen, oBlue
  );
  
  reg [3:0] r_oRed, r_oGreen, r_oBlue;
    
  localparam sReset     = 3'b111;     //(7)
  localparam sRed       = 3'b000;     //(0)
  localparam sYellow    = 3'b001;     //(1)
  localparam sGreen     = 3'b010;     //(2)
  localparam sLiBlue    = 3'b011;     //(3)
  localparam sBlue      = 3'b100;     //(4)
  localparam sPurple    = 3'b101;     //(5)
  
  reg[2:0] rFSM_current, wFSM_next;
  
  always @(posedge iClk)
  begin
    if (iRst == 1)
      begin
        rFSM_current <= sReset;
      end
    else
      begin
        rFSM_current <= wFSM_next;
      end
    
  end
  
  reg[3:0] rRed_current, wRed_next;
  reg[3:0] rGreen_current, wGreen_next;
  reg[3:0] rBlue_current, wBlue_next;
  
  always @(posedge iClk)
  begin
    rRed_current <= wRed_next;
    rGreen_current <= wGreen_next;
    rBlue_current <= wBlue_next;
  end
  
  always @(*)
  begin
    case (rFSM_current)
    
      sReset:   if((rRed_current == 4'b1111) && (rGreen_current == 4'b0000) && (rBlue_current == 4'b0000))
                    wFSM_next <= sYellow;
                else
                    wFSM_next <= sReset;
      
      sYellow:  if(rGreen_current == 4'b1111)
                    wFSM_next <= sGreen;
                else
                    wFSM_next <= sYellow;
      
      sGreen:   if(rRed_current == 4'b0000)
                    wFSM_next <= sLiBlue;
                else
                    wFSM_next <= sGreen;
      
      sLiBlue:  if(rBlue_current == 4'b1111)
                    wFSM_next <= sBlue;
                else
                    wFSM_next <= sLiBlue;
                
      sBlue:    if(rGreen_current == 4'b0000)
                    wFSM_next <= sPurple;
                else
                    wFSM_next <= sBlue;
                
      sPurple:  if(rRed_current == 4'b1111)
                    wFSM_next <= sRed;
                else
                    wFSM_next <= sPurple;
      
      sRed:     if(rBlue_current == 4'b0000)
                    wFSM_next <= sYellow;
                else
                    wFSM_next <= sRed;
      
      default:  wFSM_next <= sYellow;
    endcase
  end
  
  always @(*)
  begin 
    if(iEnable == 21'b110011010001001111111)
      begin
        if (rFSM_current == sReset)
          begin
            wRed_next = 4'b1111;
            wGreen_next = 4'b0000;
            wBlue_next = 4'b0000;
          end
          
        else if (rFSM_current == sYellow)
          begin
            wRed_next = rRed_current;
            wGreen_next = rGreen_current + 1;
            wBlue_next = rBlue_current;
          end
          
        else if (rFSM_current == sGreen)
          begin
            wRed_next = rRed_current - 1;
            wGreen_next = rGreen_current;
            wBlue_next = rBlue_current;
          end
          
        else if (rFSM_current == sLiBlue)
          begin
            wRed_next = rRed_current;
            wGreen_next = rGreen_current;
            wBlue_next = rBlue_current + 1;
          end
          
        else if (rFSM_current == sBlue)
          begin
            wRed_next = rRed_current;
            wGreen_next = rGreen_current - 1;
            wBlue_next = rBlue_current;
          end
          
        else if (rFSM_current == sPurple)
          begin
            wRed_next = rRed_current + 1;
            wGreen_next = rGreen_current;
            wBlue_next = rBlue_current;
          end
          
        else if (rFSM_current == sRed)
          begin
            wRed_next = rRed_current;
            wGreen_next = rGreen_current;
            wBlue_next = rBlue_current - 1;
          end
          
       else   
        begin
          wRed_next = rRed_current;
          wGreen_next = rGreen_current;
          wBlue_next = rBlue_current;
        end
      end
      
    else
     begin
       wRed_next = rRed_current;
       wGreen_next = rGreen_current;
       wBlue_next = rBlue_current;
     end
     
  end
  
  
  
  
  assign oRed[3:0] = rRed_current[3:0];
  assign oGreen[3:0] = rGreen_current[3:0];
  assign oBlue[3:0] = rBlue_current[3:0];
  
  
    
endmodule
