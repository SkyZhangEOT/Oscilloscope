`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/16 13:26:17
// Design Name: 
// Module Name: char_code_ram
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


module char_code_ram(
    input clk_in,
    input wea_in,
    input [5:0] char_bita_in,
    input [5:0] char_codea_in,
    input [5:0] char_bitb_in,//ÊäÈë×Ö·ûÎ»
    output wire[5:0] char_codeb_out//Êä³ö×Ö·û´úÂë
    );
    reg[5:0] char_code_reg[0:63];//±£´æ64¸ö×Ö·ûÂë
    always@(posedge clk_in)
        if(wea_in)
            char_code_reg[char_bita_in] = char_codea_in;
            
    assign char_codeb_out = char_code_reg[char_bitb_in];
endmodule
