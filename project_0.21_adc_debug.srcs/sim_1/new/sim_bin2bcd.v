`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/18 16:29:08
// Design Name: 
// Module Name: sim_bin2bcd
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


module sim_bin2bcd();
    reg clk = 0;
    always#10
        clk = ~clk;
    reg[25:0] bin = 0;
    always#1000
        bin = bin +1;
    reg start;
    always@(bin)
    begin
        start = 1;
        #20
        start = 0;
    end   
        
    wire[31:0] bcd;
    wire valid;
    bin2bcd uut_bin2bcd(
            .clk_in(clk), 
            .bin_in(bin),//最高26位输入
            .bcd_out(bcd),//最高32位输出
            .valid_out(valid)
            );
endmodule
