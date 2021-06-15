`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/22 18:23:36
// Design Name: 
// Module Name: freq_frac
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


module freq_frac(//Ê®·ÖÆµ
    input clk_in,
    output reg clk_out = 0
    );
    reg[2:0] cnt = 0;
    always@(posedge clk_in)
        if(cnt == 4)
        begin
            clk_out <= ~clk_out;
            cnt <= 0;
        end
        else
            cnt <= cnt + 1;
endmodule
