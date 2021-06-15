`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 20:35:08
// Design Name: 
// Module Name: test_chengfa
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


module test_chengfa;
    reg [7:0] count = 0;
    reg [15:0] freq;
    always#10
    begin
        count = count+1;
        freq = count*2;
    end
endmodule
