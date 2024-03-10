`timescale 1ns / 1ps

module VGA_timings #(
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
        input  wire iClk, iRst,
        output wire oHS, oVS,
        output wire [$clog2(H_TOT)-1:0] oCountH,
        output wire [$clog2(V_TOT)-1:0] oCountV
    );
    
    
    counter_lim #(
        .LIM(H_TOT-1))
   
    counter_lim_inst(
        .iClk(iClk),
        .iRst(iRst),
        .oQ(oCountH));
    
    counter_lim_en #(
        .LIM(V_TOT-1))
        
    counter_lim_en_inst(
        .iClk(iClk),
        .iRst(iRst),
        .iEn(wCmp),
        .oQ(oCountV));
        
    eq_comp_1b #(
        .LIM(H_TOT-1))
    
    eq_comp_1b_inst(
        .I0(oCountH),
        .I1(H_TOT-1),
        .wCmp(wCmp));
        
    //assign wCmp =((oCountH == (H_TOT-1)) && (oCountH == (H_TOT-1))) ? 1 : 0;    
    assign oHS = ((oCountH >= (WIDTH + H_FP)) && (oCountH < (H_TOT - H_BP))) ? 0 : 1;
    assign oVS = ((oCountV >= (HEIGHT + V_FP)) && (oCountV < (V_TOT - V_BP))) ? 0 : 1;
    
endmodule
