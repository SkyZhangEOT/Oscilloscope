`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 20:17:14
// Design Name: 
// Module Name: sim_seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim_seg;
    reg clk = 0;
    reg[23:0] segdata = 24'habcdef;
    wire[7:0] segout;
    wire[5:0] an;
    always #10
        clk = ~clk;
    disp_seg uut_seg(
            .clk_in(clk),
            .seg_data_in(segdata),
            .seg_out(segout),
            .an_out(an)
            );
endmodule
