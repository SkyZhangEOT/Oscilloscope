`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/14 23:10:24
// Design Name: 
// Module Name: sim_compoment
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


module sim_compoment;
        reg signed [7:0] trigger_level_ans = 8'b1000_0000;
        always#10
        trigger_level_ans = trigger_level_ans + 1;
        
        reg signed [11:0] trigger_level_out;
               always@(*)
            trigger_level_out = trigger_level_ans*2048;
endmodule
