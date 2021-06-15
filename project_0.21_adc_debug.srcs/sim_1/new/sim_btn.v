`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 20:29:01
// Design Name: 
// Module Name: sim_btn
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


module sim_btn;
    reg clk = 0;
    reg[3:0] col = 4'b0000;
    wire[3:0] row;
    wire[15:0] keyval;
    
    always #10
        clk = ~clk;
     always@(*)
           if (row == 4'b1000)
             col = 4'b0001;
           else
            col = 4'b0000;
           
    keyscan uut_key(
        .clk_in(clk),   
        .reset_in(0),
        .keycol_in(col),
        .keyrow_out(row),    //给输出的列置位             
        .keyval_out(keyval)          //输出按键的值
        );
endmodule
