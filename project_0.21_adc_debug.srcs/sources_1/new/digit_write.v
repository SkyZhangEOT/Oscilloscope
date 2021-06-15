`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/15 22:26:36
// Design Name: 
// Module Name: digit_write
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


module digit_write(//左对齐
    input clk_in,
//    input dwen,//提前两个周期，所以提前使能
//如果不需要右对齐，那么就不需要像素总宽度了    input [7:0] pixel_num_in,//像素宽度
    input [8:0] pixel_bit_in,//当前像素位,最大512个像素ok
    input [3:0] char_height_in,//当前高度，ok
//如果不需要右对齐，那么就不需要总字符数了    input [4:0] char_num_in,//总字符数 
    output wire[5:0] char_bit_out,//当前字符位，ok最大64个字符
    input [5:0] char_code_in,//当前字符代码,ok
    output reg pixel_color_out//像素颜色,ok
    );
//    reg[2:0] digit_char_bit;//横向字模的第几位
//    always@(*)
//        if(dwen)
//            digit_char_bit = pixel_in[2:0];
///////////////////////根据像素位数输出字符位
assign char_bit_out = pixel_bit_in/8;

  /////////////////根据高度输出颜色          
    wire[15:0] digit_char_matrix_data;
    always@(*)
        case(char_height_in)
            4'h0:pixel_color_out = digit_char_matrix_data[15];
            4'h1:pixel_color_out = digit_char_matrix_data[14];
            4'h2:pixel_color_out = digit_char_matrix_data[13];
            4'h3:pixel_color_out = digit_char_matrix_data[12];
            4'h4:pixel_color_out = digit_char_matrix_data[11];
            4'h5:pixel_color_out = digit_char_matrix_data[10];
            4'h6:pixel_color_out = digit_char_matrix_data[9];
            4'h7:pixel_color_out = digit_char_matrix_data[8];
            4'h8:pixel_color_out = digit_char_matrix_data[7];
            4'h9:pixel_color_out = digit_char_matrix_data[6];
            4'ha:pixel_color_out = digit_char_matrix_data[5];
            4'hb:pixel_color_out = digit_char_matrix_data[4];
            4'hc:pixel_color_out = digit_char_matrix_data[3];
            4'hd:pixel_color_out = digit_char_matrix_data[2];
            4'he:pixel_color_out = digit_char_matrix_data[1];
            4'hf:pixel_color_out = digit_char_matrix_data[0];
        endcase
        ////////////////////////提前字符数据
    digit_char_rom ins_digit_char_rom(//需要提前一个时钟周期
            .clk_in(clk_in),
            .digit_char_code_in(char_code_in),//哪个字符
            .digit_char_bit_in(pixel_bit_in[2:0]),//字符的第几个像素(横向)[2:0]
            .digit_char_matrix_data_out(digit_char_matrix_data)//输出字符的列数据
            );
endmodule
