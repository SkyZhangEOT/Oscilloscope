`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/26 21:29:21
// Design Name: 
// Module Name: edgeliner
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


module edgeliner(
    ////状态输入////////

//    input [2:0] top_state_in,//最多几种状态
    //input ext_code_valid_in,//用于在第二行的数据显示
    //input [71:0] ext_code_in,
    /////控制输入/////////
    input choosed_in,//反色信号
    input last_in,//去除尾线信号
    ////////位置输入/////////
    //input [6:0] horiz_pixel_in,//横向108个像素 用七位数据表示
    input [5:0] verti_pixel_in,//纵向62个像素 0-61
    
    output reg title_valid_out,
    /////////字符信息通信//////////
//    output []
    output reg[3:0] char_height_out,//字符高度
    //input [3:0] char_bit_in,//最高13.5个字
    //output [5:0] char_code_out,//字符数据
    input pixel_color_in,
    output reg pixel_color_out
    );
    


    
    always@(*)
        if(verti_pixel_in < 6'd10)
            begin
                title_valid_out <= 0;
                char_height_out <= 0;
                pixel_color_out <= choosed_in;
            end
        else if(verti_pixel_in < 6'd26)
            begin
                title_valid_out <= 1;
                char_height_out <= verti_pixel_in - 6'd10;
                pixel_color_out <= (choosed_in & (~pixel_color_in)) + (~choosed_in & pixel_color_in);
            end
        else if(verti_pixel_in < 6'd36)
            begin
                title_valid_out <= 0;
                char_height_out <= 0;
                pixel_color_out <= choosed_in;
            end
        else if(verti_pixel_in < 6'd52)
            begin
                title_valid_out <= 0;
                char_height_out <= verti_pixel_in - 6'd36;
                pixel_color_out <= (choosed_in & (~pixel_color_in)) + (~choosed_in & pixel_color_in);
            end
        else if(verti_pixel_in < 6'd61)
            begin
                title_valid_out <= 0;
                char_height_out <= 0;
                pixel_color_out <= choosed_in;
            end
        else
            begin
                title_valid_out <= 0;
                char_height_out <= 0;
                pixel_color_out <= ~last_in;
            end
endmodule
