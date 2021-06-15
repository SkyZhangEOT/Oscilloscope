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
    ////״̬����////////

//    input [2:0] top_state_in,//��༸��״̬
    //input ext_code_valid_in,//�����ڵڶ��е�������ʾ
    //input [71:0] ext_code_in,
    /////��������/////////
    input choosed_in,//��ɫ�ź�
    input last_in,//ȥ��β���ź�
    ////////λ������/////////
    //input [6:0] horiz_pixel_in,//����108������ ����λ���ݱ�ʾ
    input [5:0] verti_pixel_in,//����62������ 0-61
    
    output reg title_valid_out,
    /////////�ַ���Ϣͨ��//////////
//    output []
    output reg[3:0] char_height_out,//�ַ��߶�
    //input [3:0] char_bit_in,//���13.5����
    //output [5:0] char_code_out,//�ַ�����
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
