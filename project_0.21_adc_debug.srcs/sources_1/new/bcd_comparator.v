`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/18 17:48:58
// Design Name: 
// Module Name: bcd_comparator
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


module bcd_comparator(
    input[3:0] code_in,
    output wire[3:0] code_out
    );
    assign code_out = (code_in > 4)? code_in + 3 : code_in;
endmodule
