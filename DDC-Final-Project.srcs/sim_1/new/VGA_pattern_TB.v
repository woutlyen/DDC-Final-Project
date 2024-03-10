`timescale 1ns / 1ps

module VGA_pattern_TB;

    reg r_iClk, r_iRst;
    reg [$clog2(800)-1:0] r_iCountH;
    reg [$clog2(525)-1:0] r_iCountV;
    wire [9:0] r_oAddrA;
    
    VGA_pattern VGA_pattern_inst (
        .iClk(r_iClk),
        .iRst(r_iRst),
        .iCountH(r_iCountH),
        .iCountV(r_iCountV),
        .oAddrA(r_oAddrA));

    localparam T = 20;

    always
    begin
        r_iClk = 1;
        #(T/2);
        r_iClk = 0;
        #(T/2);
    end
    
    initial
    begin
        r_iRst = 1;
        #50;
        r_iRst = 0;
        #(T/2);
        
        for (r_iCountV = 0; r_iCountV<525; r_iCountV=r_iCountV+1)
        begin
            for (r_iCountH = 0; r_iCountH<800; r_iCountH=r_iCountH+1)
                #(T);
        end
        $stop;
    end
    
endmodule
