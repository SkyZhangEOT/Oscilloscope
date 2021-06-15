`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/31 23:33:00
// Design Name: 
// Module Name: test_posedge
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


module test_posedge(

    );
    reg clk = 0;
    always#10
        clk = ~clk;
    reg test;
    reg test1;
    reg test2;
    always@(posedge clk)
        test = clk;
    always@(posedge clk)
        test1 <= clk;
    always@(posedge clk)
        if(clk)
            test2 = 1;
        else
            test2 = 0;
endmodule
