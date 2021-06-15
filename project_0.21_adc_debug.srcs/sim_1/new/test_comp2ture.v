`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 13:29:36
// Design Name: 
// Module Name: test_comp2ture
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


module test_comp2ture;
reg clk = 0;
always #10
    clk = ~clk;
    reg[15:0] comp = 16'h8000;
    always #20
        comp = comp + 1;
    wire[15:0] ture;
    
    comp2ture_16 uut_comp2ture(
        .clk_in(clk),
        .complement_in(comp),
        .ture_out(ture)
        );


endmodule
