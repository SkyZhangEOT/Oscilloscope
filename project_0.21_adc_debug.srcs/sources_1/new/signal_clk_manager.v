`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/29 21:38:23
// Design Name: 
// Module Name: signal_clk_manager
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


module signal_clk_manager(
    input [2:0] state_in,
    input clk50M_in,
    input clk20M_in,
    input clk10M_in,
    input clk5M_in,
    input clk2M_in,
    input clk1M_in,
    input clk500k_in,
    input clk200k_in,
    output reg signal_clk_out
    );
    always@(*)
        case(state_in)
            3'd0: signal_clk_out <= clk200k_in;
            3'd1: signal_clk_out <= clk500k_in;
            3'd2: signal_clk_out <= clk1M_in;
            3'd3: signal_clk_out <= clk2M_in;
            3'd4: signal_clk_out <= clk5M_in;
            3'd5: signal_clk_out <= clk10M_in;
            3'd6: signal_clk_out <= clk20M_in;
            3'd7: signal_clk_out <= clk50M_in;
        endcase
endmodule
