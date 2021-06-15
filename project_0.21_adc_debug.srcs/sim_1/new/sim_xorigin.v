`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/21 16:59:41
// Design Name: 
// Module Name: sim_xorigin
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


module sim_xorigin;

reg[15:0] key_value = 0;
reg add = 0;
reg key = 0;
reg clk = 0;

    always@(*)
    if (add)
        key_value = {12'b0000_0000_0000,key,3'b000};
    else
        key_value = {8'b0000_0000,key,7'b000_0000};
always #10
    clk = ~clk;

always #10000
    key = ~key;
always #300000
    add = ~add;
    
    wire[7:0] wave_ori_pos;
    wave_xorigin sim_xorigin(
        .key_pressed_in(key),
        .keyval_in(key_value),
        .wave_ori_pos_out(wave_ori_pos)
        //output reg[4:0] state
        );
endmodule
