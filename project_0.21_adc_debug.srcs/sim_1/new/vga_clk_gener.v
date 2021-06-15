`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/05 15:44:17
// Design Name: 
// Module Name: vga_clk_gener
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


module vga_clk_gener(

    );
    reg clk = 0;
    always#10
        clk = ~clk;
    
    reg clk1 = 0;
    reg clk2 = 0;
    always@(posedge clk)
    clk1 = ~clk1;
    always@(negedge clk)
        clk2 = ~clk2;
endmodule

