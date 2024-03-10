`timescale 1ns / 1ps

module RainbowCounter #(
        //parameter LIM = 1680000,
        parameter LIM = 840000,
        parameter N = $clog2(LIM)
    )
    (
        input  wire iClk, iRst,
        output wire [20:0] oQ
    );
    
    reg     [20:0] r_CntCurr;
    wire    [20:0] w_CntNext;
    
    always @(posedge iClk)
    begin
        if(iRst == 1)
            r_CntCurr <= 0;
        else
            r_CntCurr <= w_CntNext;
    end
    
    assign w_CntNext = (r_CntCurr != 1680000) ? r_CntCurr + 1 : 0;
    assign oQ = r_CntCurr;
    
endmodule