`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/16 00:18:17
// Design Name: 
// Module Name: test_chufa_char_write
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


module test_chufa_char_write;
reg[7:0] bit = 0;
reg[7:0] clkinfo = 8'hff;
always#10
    bit = bit + 1;
wire [8:0]char_bit;
assign char_bit = clkinfo/bit;
endmodule
