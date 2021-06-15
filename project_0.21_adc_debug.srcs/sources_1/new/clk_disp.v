`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/15 11:39:49
// Design Name: 
// Module Name: clk_disp
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


module clk_disp(
input [3:0] clk_state_in,
output reg[23:0] seg_data_out
    );
    always@(*)
        case(clk_state_in)
            4'h0:seg_data_out = 24'h000500;
            4'h1:seg_data_out = 24'h001000;
            4'h2:seg_data_out = 24'h002000;
            4'h3:seg_data_out = 24'h005000;
            4'h4:seg_data_out = 24'h0010e3;
            4'h5:seg_data_out = 24'h0020e3;
            4'h6:seg_data_out = 24'h0050e3;
            4'h7:seg_data_out = 24'h0100e3;
            4'h8:seg_data_out = 24'h0200e3;
            4'h9:seg_data_out = 24'h0500e3;
            4'ha:seg_data_out = 24'h0001e6;
            4'hb:seg_data_out = 24'h0002e6;
            4'hc:seg_data_out = 24'h0005e6;
            4'hd:seg_data_out = 24'h0010e6;
            4'he:seg_data_out = 24'h0020e6;
            4'hf:seg_data_out = 24'h0050e6;
        endcase
endmodule
