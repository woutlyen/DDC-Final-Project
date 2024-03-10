`timescale 1ns / 1ps

module eq_comp_1b #(
        parameter LIM = 1,
        parameter N = $clog2(LIM)
     
    )
    (
        input  wire [N-1:0] I0, I1,
        output wire wCmp
    );
    
    assign wCmp = (I0==I1) ? 1 : 0;
    
endmodule
