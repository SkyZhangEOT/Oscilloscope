`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/24 22:01:49
// Design Name: 
// Module Name: test_mod
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


module test_mod(

    );
    reg[3:0] a = 0;
    always#10
        a = a + 1;
    reg [3:0] b;
    reg [1:0] c;
    always@(*)
    begin
        b = a/3;
        c = a%3;
    end
endmodule
