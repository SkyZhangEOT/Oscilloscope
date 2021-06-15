`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/08 21:39:30
// Design Name: 
// Module Name: comp2ture
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


module comp2ture_24(
    //input clk_in,
    input [23:0] complement_in,
    output reg[23:0] ture_out
    );
    wire flag;
    assign flag = complement_in[23];
    always@(*)
        if(flag)
            ture_out = (~complement_in) + 1'b1;
        else
            ture_out = complement_in;
        
endmodule
