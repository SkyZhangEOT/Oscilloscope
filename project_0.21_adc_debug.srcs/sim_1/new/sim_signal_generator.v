`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/06 00:48:42
// Design Name: 
// Module Name: sim_signal_generator
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


module sim_signal_generator;
    reg clk = 0;
    always #10
        clk = !clk;
    wire[7:0] test_square;
    wire[7:0] test_tangle;
    wire[7:0] test_sin;



signal_generator uut_signal_generator(
    .clk_in(clk),
    .test_square(test_square),
    .test_tangle(test_tangle),
    .test_sin(test_sin)
    );
endmodule
