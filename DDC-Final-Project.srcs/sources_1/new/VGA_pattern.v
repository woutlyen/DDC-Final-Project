`timescale 1ns / 1ps

module VGA_pattern #(
        parameter WIDTH     = 640,
        parameter H_FP      = 16,
        parameter H_PW      = 96,
        parameter H_BP      = 48,
        parameter H_TOT     = WIDTH + H_FP + H_PW + H_BP,
        
        parameter HEIGHT    = 480,
        parameter V_FP      = 10,
        parameter V_PW      = 2,
        parameter V_BP      = 33,
        parameter V_TOT     = HEIGHT + V_FP + V_PW + V_BP
    )
    (
        input  wire iClk, iRst, iHS, iVS, sw0, sw1,
        input  wire [$clog2(H_TOT)-1:0] iCountH,
        input  wire [$clog2(V_TOT)-1:0] iCountV,
        input  wire [11:0] iDataA,
        input  wire [15:0] iDataB,
        output wire oHS, oVS,
        
        input wire [3:0] iRed, iGreen, iBlue,
        output wire [3:0] oRed, oGreen, oBlue,
        
        output wire [9:0] oAddrA,
        output wire [11:0] oAddrB
       
    );
    
    reg [3:0] r_oRed, r_oGreen, r_oBlue;
    reg [9:0] r_oAddrA;
    reg [11:0] r_oAddrB;
    reg [$clog2(40)-1:0] Cx;
    reg [$clog2(15)-1:0] Cy;
    
    assign oHS = ((iCountH >= (WIDTH + H_FP)) && (iCountH <( H_TOT-H_BP))) ? 0 : 1;
    assign oVS = ((iCountV >= (HEIGHT + V_FP)) && (iCountV < (V_TOT-V_BP))) ? 0 : 1;
    
    always @(*)
    begin
        if((iCountH < WIDTH) && (iCountV < HEIGHT))
            begin
                Cx = iCountH/16;
                Cy = iCountV/32;
                r_oAddrA = Cy * 40 + Cx;
            end  
        
        if((iCountH < WIDTH) && (iCountV < HEIGHT))
            begin
                r_oAddrB = iDataA + iCountV % 32;
            end  
        
        if((iCountH < WIDTH) && (iCountV < HEIGHT))
            begin
                if(iDataB[16 - (iCountH % 16)] == 1)
                    begin
                        if(sw1 == 1 && sw0 == 0)
                          begin
                              //r_oRed = 4'hF;
                              r_oRed = 4'h0;
                              r_oGreen = 4'h0;
                              r_oBlue = 4'h0;
                          end
                        else
                          begin
                            r_oRed = 4'hF;
                            //r_oRed = iRed;
                            //r_oGreen = iGreen;
                            //r_oBlue = iBlue;
                            //r_oRed = 4'h0;
                            //r_oGreen = 4'h0;
                            //r_oBlue = 4'h0;
                          end
                   end
        
                else
                    begin
                      if(sw1 == 1 && sw0 == 0)
                        begin
                          r_oRed = iRed;
                          r_oGreen = iGreen;
                          r_oBlue = iBlue;
                        end
                      else
                        begin
                          r_oRed = 4'h0;
                          r_oGreen = 4'h0;
                          r_oBlue = 4'h0;
                        end
                    end
            end
        else
            begin
                r_oRed = 4'h0;
                r_oGreen = 4'h0;
                r_oBlue = 4'h0;
            end
        
        /*
        if((iCountH < WIDTH) && (iCountV < HEIGHT))
            begin
                r_oRed = iDataA[11:8];
                r_oGreen = iDataA[7:4];
                r_oBlue = iDataA[3:0];
            end
        else
            begin
                r_oRed = 4'h0;
                r_oGreen = 4'h0;
                r_oBlue = 4'h0;
            end
        */
    
    end
    
    assign oRed = r_oRed;
    assign oGreen = r_oGreen;
    assign oBlue = r_oBlue;
    assign oAddrA = r_oAddrA;
    assign oAddrB = r_oAddrB;
    
endmodule
