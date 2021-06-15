`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/03/01 21:08:54
// Design Name: 
// Module Name: btn
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


module keyscan(
    input clk_in,   
    input reset_in,
    input [3:0] keycol_in,
    output reg[3:0] keyrow_out = 4'b0001,    //给输出的列置位             
    output wire[15:0] keyval_out,          //输出按键的值
    output reg key_pressed_out
    );
/**********时钟分频模块，消抖时钟频率是扫描时钟频率的1/16***************/
    reg[2:0] div_clk_cnt = 3'b000;
    parameter max_cnt = 3'b111;
    reg key_clk = 0;                //消抖时钟////////////////50Hz为佳
    reg[15:0] btn = 0;//////////
    always@(posedge clk_in)
      if(div_clk_cnt == max_cnt)
        begin
          key_clk = ~key_clk;
          div_clk_cnt = 0;
        end
      else
        div_clk_cnt= div_clk_cnt+1;
/**********时钟分频模块，结束***************/    
    
/*************扫描模块*******************/

    always @(posedge clk_in,posedge reset_in)
      if (reset_in)
        keyrow_out = 4'b0001;
      else if (keyrow_out[3:0] == 4'b1000)
        keyrow_out[3:0] = 4'b0001;
      else
        keyrow_out[3:0] = keyrow_out[3:0]<<1;
    
    always@(negedge clk_in,posedge reset_in)
      if (reset_in)
        btn = 0;
      else
        case(keyrow_out[3:0])
          4'b0001: btn[3:0] = keycol_in;
          4'b0010: btn[7:4] = keycol_in;
          4'b0100: btn[11:8] = keycol_in;
          4'b1000: btn[15:12] = keycol_in;
          default: btn = 0;
        endcase
/*************扫描模块结束*******************/
       
/***************消抖模块*****************/ 
      reg[15:0] btn0 = 0;
      reg[15:0] btn1 = 0;
      reg[15:0] btn2 = 0;
    always@(posedge key_clk)
      begin
        btn0 <= btn;
        btn1 <= btn0;
        btn2 <= btn1;
      end

    assign keyval_out = btn2&btn1&btn0;
    
    always@(posedge key_clk)
        key_pressed_out = |keyval_out;//归约或
    
endmodule

