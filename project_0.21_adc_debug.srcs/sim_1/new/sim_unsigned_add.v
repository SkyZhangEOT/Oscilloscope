`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/19 22:01:24
// Design Name: 
// Module Name: sim_unsigned_add
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


module sim_unsigned_add;
    reg clk = 0;
    reg[7:0] row = 0;
    reg[7:0] line_in = 100;
    reg signed[7:0] ans;
    reg signed[15:0] out;
    reg signed[15:0] out2;
    always #10
        clk = !clk;
    always@(posedge clk)
    begin
        row = row + 1;
        ans = row - line_in;
    end
    always@(*)
    begin
        out = ans*2;//补码之间赋值自动转变，不用设计
        out2 = ans/2;
    end
    wire [7:0] addr;
       assign addr = row -2;
endmodule
