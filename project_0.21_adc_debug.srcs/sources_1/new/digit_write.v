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


module digit_write(//�����
    input clk_in,
//    input dwen,//��ǰ�������ڣ�������ǰʹ��
//�������Ҫ�Ҷ��룬��ô�Ͳ���Ҫ�����ܿ����    input [7:0] pixel_num_in,//���ؿ��
    input [8:0] pixel_bit_in,//��ǰ����λ,���512������ok
    input [3:0] char_height_in,//��ǰ�߶ȣ�ok
//�������Ҫ�Ҷ��룬��ô�Ͳ���Ҫ���ַ�����    input [4:0] char_num_in,//���ַ��� 
    output wire[5:0] char_bit_out,//��ǰ�ַ�λ��ok���64���ַ�
    input [5:0] char_code_in,//��ǰ�ַ�����,ok
    output reg pixel_color_out//������ɫ,ok
    );
//    reg[2:0] digit_char_bit;//������ģ�ĵڼ�λ
//    always@(*)
//        if(dwen)
//            digit_char_bit = pixel_in[2:0];
///////////////////////��������λ������ַ�λ
assign char_bit_out = pixel_bit_in/8;

  /////////////////���ݸ߶������ɫ          
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
        ////////////////////////��ǰ�ַ�����
    digit_char_rom ins_digit_char_rom(//��Ҫ��ǰһ��ʱ������
            .clk_in(clk_in),
            .digit_char_code_in(char_code_in),//�ĸ��ַ�
            .digit_char_bit_in(pixel_bit_in[2:0]),//�ַ��ĵڼ�������(����)[2:0]
            .digit_char_matrix_data_out(digit_char_matrix_data)//����ַ���������
            );
endmodule
