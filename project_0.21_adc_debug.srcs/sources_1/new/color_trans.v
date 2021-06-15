`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/04/09 10:34:23
// Design Name: 
// Module Name: color_trans
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


module color_trans(
    input[1:0] color_in,
    input[11:0] set_color_in,
    output reg[11:0] color_out
    );
    parameter     window_bg_color = 12'h012,
                   grid_color = 12'hfff,
                   error_color = 12'hf00;
    always@(*)
        case(color_in)
            2'd0:color_out <= window_bg_color;
            2'd1:color_out <= grid_color;
            2'd2:color_out <= set_color_in;
            2'd3:color_out <= error_color;
       endcase
endmodule
