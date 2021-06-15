`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/03/10 22:48:40
// Design Name: 
// Module Name: wave_generator
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


module wave_generator(
    input clk_in,//DCLK 50MHz
    input reset_in,//RESET ��λ�źţ���ʱ����
    output wire[8:0] col_val_out,//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!������9λ������Ϊ��ַ�᲻�����
    input [7:0] wave_in,
    output [16:0] disp_wave_addr_out,//������Դ�A�ڵĵ�ַ
    output reg[1:0] color_out,//Ҫд���Դ�����ݣ���ɫ��
    output reg wea_out//�Դ�A�ڵ�дʹ��
    
    );
    parameter wave_color = 2'b10;//
    parameter grid_color = 2'b01;//
    parameter bg_color = 2'b00;//
    
    reg[7:0] row = 0;
    reg[8:0] col = 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!������9λ������Ϊ��ַ�᲻�����
    reg[3:0] cnt = 0;//����ֵ�����������ڴ�����ʱ����Ч״̬
    reg[7:0] wave;//190-wave_in��ֵ
    reg[7:0] wave_before;
    wire[16:0] row_col;
    initial
    begin
        row = 0;
        col = 0;
        color_out = 0;
        wea_out = 0;
    end
    
    assign col_val_out = col + 2;
    
    assign disp_wave_addr_out = row * 512 + col;//��ʾ�ڴ��ַ����**********************************
    assign row_col = {row,col};//�����ж�����
    always@(negedge clk_in )//�½��ش����������ʾ�ڴ��������ش�������ʱ�ӱ�֤д�ڴ�ʱ��ַ�������ȶ�,��ʱ12��cnt
        if(cnt == 12)
            cnt = cnt;
        else begin
            if(cnt == 6)//��6��ʱ�Ӻ�Ϳ��Կ�ʼ����д�ź�
                wea_out = 1;
            else
                wea_out = wea_out;
            cnt = cnt + 1;
        end
    
    always@(negedge clk_in)//�½��ش����������ʾ�ڴ��������ش�������ʱ�ӱ�֤д�ڴ�ʱ��ַ�������ȶ�
        if(reset_in) begin
            color_out = 0;
            row = 0;
            col = 0;
        end 
        else begin
            if(cnt == 12) begin
                if(col == 511) begin//��0��511
                    col = 0;
                    if(row == 199)//�д�0��199
                        row = 0;
                    else
                        row = row + 1;
                end
                else
                    col = col + 1;
            end
            if(col == 0)
            begin
                wave <= wave_in;
                wave_before = wave;
            end
            else
            begin
                wave_before <= wave;//Ŀ���Ǳ������ݵľ�ֵ�����ڻ���
                wave <= wave_in;//��������任����bit_choose���ж���
            end


            if((wave <= row)&&(wave_before > row)&&(wave_before != 8'hff))//���ĳ��col�ɼ���ֵwave(col)�ǵ�����ֵ�ģ���ôӦ����ɫ
                color_out = wave_color;//������Ϊ��ɫ����ɫf60
            else if((wave == 8'hff)&&(wave_before > row)&&(wave_before != 8'hff))
                color_out = wave_color;//������Ϊ��ɫ����ɫf60
            else if((wave == row)&&(wave_before == row))
                color_out = wave_color;//������Ϊ��ɫ����ɫf60
            else if((wave >= row)&&(wave_before < row)&&(wave != 8'hff))//������������ֵ�����ֵ��ˮƽ�ߣ���ɫ�����򻭰�ɫ
                color_out = wave_color;//������Ϊ��ɫ����ɫf60
            else if((wave >= row)&&(wave_before == 8'hff)&&(wave != 8'hff))
                color_out = wave_color;//������Ϊ��ɫ����ɫf60
            else
                case(row_col)
                17'b00000000_000000101: color_out = grid_color;
                17'b00000000_000001111: color_out = grid_color;
                17'b00000000_000011001: color_out = grid_color;
                17'b00000000_000100011: color_out = grid_color;
                17'b00000000_000101101: color_out = grid_color;
                17'b00000000_000110111: color_out = grid_color;
                17'b00000000_001000001: color_out = grid_color;
                17'b00000000_001001011: color_out = grid_color;
                17'b00000000_001010101: color_out = grid_color;
                17'b00000000_001011111: color_out = grid_color;
                17'b00000000_001101001: color_out = grid_color;
                17'b00000000_001110011: color_out = grid_color;
                17'b00000000_001111101: color_out = grid_color;
                17'b00000000_010000111: color_out = grid_color;
                17'b00000000_010010001: color_out = grid_color;
                17'b00000000_010011011: color_out = grid_color;
                17'b00000000_010100101: color_out = grid_color;
                17'b00000000_010101111: color_out = grid_color;
                17'b00000000_010111001: color_out = grid_color;
                17'b00000000_011000011: color_out = grid_color;
                17'b00000000_011001101: color_out = grid_color;
                17'b00000000_011010111: color_out = grid_color;
                17'b00000000_011100001: color_out = grid_color;
                17'b00000000_011101011: color_out = grid_color;
                17'b00000000_011110101: color_out = grid_color;
                17'b00000000_011111111: color_out = grid_color;
                17'b00000000_100001001: color_out = grid_color;
                17'b00000000_100010011: color_out = grid_color;
                17'b00000000_100011101: color_out = grid_color;
                17'b00000000_100100111: color_out = grid_color;
                17'b00000000_100110001: color_out = grid_color;
                17'b00000000_100111011: color_out = grid_color;
                17'b00000000_101000101: color_out = grid_color;
                17'b00000000_101001111: color_out = grid_color;
                17'b00000000_101011001: color_out = grid_color;
                17'b00000000_101100011: color_out = grid_color;
                17'b00000000_101101101: color_out = grid_color;
                17'b00000000_101110111: color_out = grid_color;
                17'b00000000_110000001: color_out = grid_color;
                17'b00000000_110001011: color_out = grid_color;
                17'b00000000_110010101: color_out = grid_color;
                17'b00000000_110011111: color_out = grid_color;
                17'b00000000_110101001: color_out = grid_color;
                17'b00000000_110110011: color_out = grid_color;
                17'b00000000_110111101: color_out = grid_color;
                17'b00000000_111000111: color_out = grid_color;
                17'b00000000_111010001: color_out = grid_color;
                17'b00000000_111011011: color_out = grid_color;
                17'b00000000_111100101: color_out = grid_color;
                17'b00000000_111101111: color_out = grid_color;
                17'b00000000_111111001: color_out = grid_color;
                17'b00001001_000000101: color_out = grid_color;
                17'b00001001_000110111: color_out = grid_color;
                17'b00001001_001101001: color_out = grid_color;
                17'b00001001_010011011: color_out = grid_color;
                17'b00001001_011001101: color_out = grid_color;
                17'b00001001_011111110: color_out = grid_color;
                17'b00001001_011111111: color_out = grid_color;
                17'b00001001_100000000: color_out = grid_color;
                17'b00001001_100110001: color_out = grid_color;
                17'b00001001_101100011: color_out = grid_color;
                17'b00001001_110010101: color_out = grid_color;
                17'b00001001_111000111: color_out = grid_color;
                17'b00001001_111111001: color_out = grid_color;
                17'b00010011_000000101: color_out = grid_color;
                17'b00010011_000110111: color_out = grid_color;
                17'b00010011_001101001: color_out = grid_color;
                17'b00010011_010011011: color_out = grid_color;
                17'b00010011_011001101: color_out = grid_color;
                17'b00010011_011111110: color_out = grid_color;
                17'b00010011_011111111: color_out = grid_color;
                17'b00010011_100000000: color_out = grid_color;
                17'b00010011_100110001: color_out = grid_color;
                17'b00010011_101100011: color_out = grid_color;
                17'b00010011_110010101: color_out = grid_color;
                17'b00010011_111000111: color_out = grid_color;
                17'b00010011_111111001: color_out = grid_color;
                17'b00011101_000000101: color_out = grid_color;
                17'b00011101_000110111: color_out = grid_color;
                17'b00011101_001101001: color_out = grid_color;
                17'b00011101_010011011: color_out = grid_color;
                17'b00011101_011001101: color_out = grid_color;
                17'b00011101_011111110: color_out = grid_color;
                17'b00011101_011111111: color_out = grid_color;
                17'b00011101_100000000: color_out = grid_color;
                17'b00011101_100110001: color_out = grid_color;
                17'b00011101_101100011: color_out = grid_color;
                17'b00011101_110010101: color_out = grid_color;
                17'b00011101_111000111: color_out = grid_color;
                17'b00011101_111111001: color_out = grid_color;
                17'b00100111_000000101: color_out = grid_color;
                17'b00100111_000110111: color_out = grid_color;
                17'b00100111_001101001: color_out = grid_color;
                17'b00100111_010011011: color_out = grid_color;
                17'b00100111_011001101: color_out = grid_color;
                17'b00100111_011111110: color_out = grid_color;
                17'b00100111_011111111: color_out = grid_color;
                17'b00100111_100000000: color_out = grid_color;
                17'b00100111_100110001: color_out = grid_color;
                17'b00100111_101100011: color_out = grid_color;
                17'b00100111_110010101: color_out = grid_color;
                17'b00100111_111000111: color_out = grid_color;
                17'b00100111_111111001: color_out = grid_color;
                17'b00110001_000000101: color_out = grid_color;
                17'b00110001_000001111: color_out = grid_color;
                17'b00110001_000011001: color_out = grid_color;
                17'b00110001_000100011: color_out = grid_color;
                17'b00110001_000101101: color_out = grid_color;
                17'b00110001_000110111: color_out = grid_color;
                17'b00110001_001000001: color_out = grid_color;
                17'b00110001_001001011: color_out = grid_color;
                17'b00110001_001010101: color_out = grid_color;
                17'b00110001_001011111: color_out = grid_color;
                17'b00110001_001101001: color_out = grid_color;
                17'b00110001_001110011: color_out = grid_color;
                17'b00110001_001111101: color_out = grid_color;
                17'b00110001_010000111: color_out = grid_color;
                17'b00110001_010010001: color_out = grid_color;
                17'b00110001_010011011: color_out = grid_color;
                17'b00110001_010100101: color_out = grid_color;
                17'b00110001_010101111: color_out = grid_color;
                17'b00110001_010111001: color_out = grid_color;
                17'b00110001_011000011: color_out = grid_color;
                17'b00110001_011001101: color_out = grid_color;
                17'b00110001_011010111: color_out = grid_color;
                17'b00110001_011100001: color_out = grid_color;
                17'b00110001_011101011: color_out = grid_color;
                17'b00110001_011110101: color_out = grid_color;
                17'b00110001_011111110: color_out = grid_color;
                17'b00110001_011111111: color_out = grid_color;
                17'b00110001_100000000: color_out = grid_color;
                17'b00110001_100001001: color_out = grid_color;
                17'b00110001_100010011: color_out = grid_color;
                17'b00110001_100011101: color_out = grid_color;
                17'b00110001_100100111: color_out = grid_color;
                17'b00110001_100110001: color_out = grid_color;
                17'b00110001_100111011: color_out = grid_color;
                17'b00110001_101000101: color_out = grid_color;
                17'b00110001_101001111: color_out = grid_color;
                17'b00110001_101011001: color_out = grid_color;
                17'b00110001_101100011: color_out = grid_color;
                17'b00110001_101101101: color_out = grid_color;
                17'b00110001_101110111: color_out = grid_color;
                17'b00110001_110000001: color_out = grid_color;
                17'b00110001_110001011: color_out = grid_color;
                17'b00110001_110010101: color_out = grid_color;
                17'b00110001_110011111: color_out = grid_color;
                17'b00110001_110101001: color_out = grid_color;
                17'b00110001_110110011: color_out = grid_color;
                17'b00110001_110111101: color_out = grid_color;
                17'b00110001_111000111: color_out = grid_color;
                17'b00110001_111010001: color_out = grid_color;
                17'b00110001_111011011: color_out = grid_color;
                17'b00110001_111100101: color_out = grid_color;
                17'b00110001_111101111: color_out = grid_color;
                17'b00110001_111111001: color_out = grid_color;
                17'b00111011_000000101: color_out = grid_color;
                17'b00111011_000110111: color_out = grid_color;
                17'b00111011_001101001: color_out = grid_color;
                17'b00111011_010011011: color_out = grid_color;
                17'b00111011_011001101: color_out = grid_color;
                17'b00111011_011111110: color_out = grid_color;
                17'b00111011_011111111: color_out = grid_color;
                17'b00111011_100000000: color_out = grid_color;
                17'b00111011_100110001: color_out = grid_color;
                17'b00111011_101100011: color_out = grid_color;
                17'b00111011_110010101: color_out = grid_color;
                17'b00111011_111000111: color_out = grid_color;
                17'b00111011_111111001: color_out = grid_color;
                17'b01000101_000000101: color_out = grid_color;
                17'b01000101_000110111: color_out = grid_color;
                17'b01000101_001101001: color_out = grid_color;
                17'b01000101_010011011: color_out = grid_color;
                17'b01000101_011001101: color_out = grid_color;
                17'b01000101_011111110: color_out = grid_color;
                17'b01000101_011111111: color_out = grid_color;
                17'b01000101_100000000: color_out = grid_color;
                17'b01000101_100110001: color_out = grid_color;
                17'b01000101_101100011: color_out = grid_color;
                17'b01000101_110010101: color_out = grid_color;
                17'b01000101_111000111: color_out = grid_color;
                17'b01000101_111111001: color_out = grid_color;
                17'b01001111_000000101: color_out = grid_color;
                17'b01001111_000110111: color_out = grid_color;
                17'b01001111_001101001: color_out = grid_color;
                17'b01001111_010011011: color_out = grid_color;
                17'b01001111_011001101: color_out = grid_color;
                17'b01001111_011111110: color_out = grid_color;
                17'b01001111_011111111: color_out = grid_color;
                17'b01001111_100000000: color_out = grid_color;
                17'b01001111_100110001: color_out = grid_color;
                17'b01001111_101100011: color_out = grid_color;
                17'b01001111_110010101: color_out = grid_color;
                17'b01001111_111000111: color_out = grid_color;
                17'b01001111_111111001: color_out = grid_color;
                17'b01011001_000000101: color_out = grid_color;
                17'b01011001_000110111: color_out = grid_color;
                17'b01011001_001101001: color_out = grid_color;
                17'b01011001_010011011: color_out = grid_color;
                17'b01011001_011001101: color_out = grid_color;
                17'b01011001_011111110: color_out = grid_color;
                17'b01011001_011111111: color_out = grid_color;
                17'b01011001_100000000: color_out = grid_color;
                17'b01011001_100110001: color_out = grid_color;
                17'b01011001_101100011: color_out = grid_color;
                17'b01011001_110010101: color_out = grid_color;
                17'b01011001_111000111: color_out = grid_color;
                17'b01011001_111111001: color_out = grid_color;
                17'b01100010_000000101: color_out = grid_color;
                17'b01100010_000001111: color_out = grid_color;
                17'b01100010_000011001: color_out = grid_color;
                17'b01100010_000100011: color_out = grid_color;
                17'b01100010_000101101: color_out = grid_color;
                17'b01100010_000110111: color_out = grid_color;
                17'b01100010_001000001: color_out = grid_color;
                17'b01100010_001001011: color_out = grid_color;
                17'b01100010_001010101: color_out = grid_color;
                17'b01100010_001011111: color_out = grid_color;
                17'b01100010_001101001: color_out = grid_color;
                17'b01100010_001110011: color_out = grid_color;
                17'b01100010_001111101: color_out = grid_color;
                17'b01100010_010000111: color_out = grid_color;
                17'b01100010_010010001: color_out = grid_color;
                17'b01100010_010011011: color_out = grid_color;
                17'b01100010_010100101: color_out = grid_color;
                17'b01100010_010101111: color_out = grid_color;
                17'b01100010_010111001: color_out = grid_color;
                17'b01100010_011000011: color_out = grid_color;
                17'b01100010_011001101: color_out = grid_color;
                17'b01100010_011010111: color_out = grid_color;
                17'b01100010_011100001: color_out = grid_color;
                17'b01100010_011101011: color_out = grid_color;
                17'b01100010_011110101: color_out = grid_color;
                17'b01100010_011111111: color_out = grid_color;
                17'b01100010_100001001: color_out = grid_color;
                17'b01100010_100010011: color_out = grid_color;
                17'b01100010_100011101: color_out = grid_color;
                17'b01100010_100100111: color_out = grid_color;
                17'b01100010_100110001: color_out = grid_color;
                17'b01100010_100111011: color_out = grid_color;
                17'b01100010_101000101: color_out = grid_color;
                17'b01100010_101001111: color_out = grid_color;
                17'b01100010_101011001: color_out = grid_color;
                17'b01100010_101100011: color_out = grid_color;
                17'b01100010_101101101: color_out = grid_color;
                17'b01100010_101110111: color_out = grid_color;
                17'b01100010_110000001: color_out = grid_color;
                17'b01100010_110001011: color_out = grid_color;
                17'b01100010_110010101: color_out = grid_color;
                17'b01100010_110011111: color_out = grid_color;
                17'b01100010_110101001: color_out = grid_color;
                17'b01100010_110110011: color_out = grid_color;
                17'b01100010_110111101: color_out = grid_color;
                17'b01100010_111000111: color_out = grid_color;
                17'b01100010_111010001: color_out = grid_color;
                17'b01100010_111011011: color_out = grid_color;
                17'b01100010_111100101: color_out = grid_color;
                17'b01100010_111101111: color_out = grid_color;
                17'b01100010_111111001: color_out = grid_color;
                17'b01100011_000000101: color_out = grid_color;
                17'b01100011_000001111: color_out = grid_color;
                17'b01100011_000011001: color_out = grid_color;
                17'b01100011_000100011: color_out = grid_color;
                17'b01100011_000101101: color_out = grid_color;
                17'b01100011_000110111: color_out = grid_color;
                17'b01100011_001000001: color_out = grid_color;
                17'b01100011_001001011: color_out = grid_color;
                17'b01100011_001010101: color_out = grid_color;
                17'b01100011_001011111: color_out = grid_color;
                17'b01100011_001101001: color_out = grid_color;
                17'b01100011_001110011: color_out = grid_color;
                17'b01100011_001111101: color_out = grid_color;
                17'b01100011_010000111: color_out = grid_color;
                17'b01100011_010010001: color_out = grid_color;
                17'b01100011_010011011: color_out = grid_color;
                17'b01100011_010100101: color_out = grid_color;
                17'b01100011_010101111: color_out = grid_color;
                17'b01100011_010111001: color_out = grid_color;
                17'b01100011_011000011: color_out = grid_color;
                17'b01100011_011001101: color_out = grid_color;
                17'b01100011_011010111: color_out = grid_color;
                17'b01100011_011100001: color_out = grid_color;
                17'b01100011_011101011: color_out = grid_color;
                17'b01100011_011110101: color_out = grid_color;
                17'b01100011_011111110: color_out = grid_color;
                17'b01100011_011111111: color_out = grid_color;
                17'b01100011_100000000: color_out = grid_color;
                17'b01100011_100001001: color_out = grid_color;
                17'b01100011_100010011: color_out = grid_color;
                17'b01100011_100011101: color_out = grid_color;
                17'b01100011_100100111: color_out = grid_color;
                17'b01100011_100110001: color_out = grid_color;
                17'b01100011_100111011: color_out = grid_color;
                17'b01100011_101000101: color_out = grid_color;
                17'b01100011_101001111: color_out = grid_color;
                17'b01100011_101011001: color_out = grid_color;
                17'b01100011_101100011: color_out = grid_color;
                17'b01100011_101101101: color_out = grid_color;
                17'b01100011_101110111: color_out = grid_color;
                17'b01100011_110000001: color_out = grid_color;
                17'b01100011_110001011: color_out = grid_color;
                17'b01100011_110010101: color_out = grid_color;
                17'b01100011_110011111: color_out = grid_color;
                17'b01100011_110101001: color_out = grid_color;
                17'b01100011_110110011: color_out = grid_color;
                17'b01100011_110111101: color_out = grid_color;
                17'b01100011_111000111: color_out = grid_color;
                17'b01100011_111010001: color_out = grid_color;
                17'b01100011_111011011: color_out = grid_color;
                17'b01100011_111100101: color_out = grid_color;
                17'b01100011_111101111: color_out = grid_color;
                17'b01100011_111111001: color_out = grid_color;
                17'b01100100_000000101: color_out = grid_color;
                17'b01100100_000001111: color_out = grid_color;
                17'b01100100_000011001: color_out = grid_color;
                17'b01100100_000100011: color_out = grid_color;
                17'b01100100_000101101: color_out = grid_color;
                17'b01100100_000110111: color_out = grid_color;
                17'b01100100_001000001: color_out = grid_color;
                17'b01100100_001001011: color_out = grid_color;
                17'b01100100_001010101: color_out = grid_color;
                17'b01100100_001011111: color_out = grid_color;
                17'b01100100_001101001: color_out = grid_color;
                17'b01100100_001110011: color_out = grid_color;
                17'b01100100_001111101: color_out = grid_color;
                17'b01100100_010000111: color_out = grid_color;
                17'b01100100_010010001: color_out = grid_color;
                17'b01100100_010011011: color_out = grid_color;
                17'b01100100_010100101: color_out = grid_color;
                17'b01100100_010101111: color_out = grid_color;
                17'b01100100_010111001: color_out = grid_color;
                17'b01100100_011000011: color_out = grid_color;
                17'b01100100_011001101: color_out = grid_color;
                17'b01100100_011010111: color_out = grid_color;
                17'b01100100_011100001: color_out = grid_color;
                17'b01100100_011101011: color_out = grid_color;
                17'b01100100_011110101: color_out = grid_color;
                17'b01100100_011111111: color_out = grid_color;
                17'b01100100_100001001: color_out = grid_color;
                17'b01100100_100010011: color_out = grid_color;
                17'b01100100_100011101: color_out = grid_color;
                17'b01100100_100100111: color_out = grid_color;
                17'b01100100_100110001: color_out = grid_color;
                17'b01100100_100111011: color_out = grid_color;
                17'b01100100_101000101: color_out = grid_color;
                17'b01100100_101001111: color_out = grid_color;
                17'b01100100_101011001: color_out = grid_color;
                17'b01100100_101100011: color_out = grid_color;
                17'b01100100_101101101: color_out = grid_color;
                17'b01100100_101110111: color_out = grid_color;
                17'b01100100_110000001: color_out = grid_color;
                17'b01100100_110001011: color_out = grid_color;
                17'b01100100_110010101: color_out = grid_color;
                17'b01100100_110011111: color_out = grid_color;
                17'b01100100_110101001: color_out = grid_color;
                17'b01100100_110110011: color_out = grid_color;
                17'b01100100_110111101: color_out = grid_color;
                17'b01100100_111000111: color_out = grid_color;
                17'b01100100_111010001: color_out = grid_color;
                17'b01100100_111011011: color_out = grid_color;
                17'b01100100_111100101: color_out = grid_color;
                17'b01100100_111101111: color_out = grid_color;
                17'b01100100_111111001: color_out = grid_color;
                17'b01101101_000000101: color_out = grid_color;
                17'b01101101_000110111: color_out = grid_color;
                17'b01101101_001101001: color_out = grid_color;
                17'b01101101_010011011: color_out = grid_color;
                17'b01101101_011001101: color_out = grid_color;
                17'b01101101_011111110: color_out = grid_color;
                17'b01101101_011111111: color_out = grid_color;
                17'b01101101_100000000: color_out = grid_color;
                17'b01101101_100110001: color_out = grid_color;
                17'b01101101_101100011: color_out = grid_color;
                17'b01101101_110010101: color_out = grid_color;
                17'b01101101_111000111: color_out = grid_color;
                17'b01101101_111111001: color_out = grid_color;
                17'b01110111_000000101: color_out = grid_color;
                17'b01110111_000110111: color_out = grid_color;
                17'b01110111_001101001: color_out = grid_color;
                17'b01110111_010011011: color_out = grid_color;
                17'b01110111_011001101: color_out = grid_color;
                17'b01110111_011111110: color_out = grid_color;
                17'b01110111_011111111: color_out = grid_color;
                17'b01110111_100000000: color_out = grid_color;
                17'b01110111_100110001: color_out = grid_color;
                17'b01110111_101100011: color_out = grid_color;
                17'b01110111_110010101: color_out = grid_color;
                17'b01110111_111000111: color_out = grid_color;
                17'b01110111_111111001: color_out = grid_color;
                17'b10000001_000000101: color_out = grid_color;
                17'b10000001_000110111: color_out = grid_color;
                17'b10000001_001101001: color_out = grid_color;
                17'b10000001_010011011: color_out = grid_color;
                17'b10000001_011001101: color_out = grid_color;
                17'b10000001_011111110: color_out = grid_color;
                17'b10000001_011111111: color_out = grid_color;
                17'b10000001_100000000: color_out = grid_color;
                17'b10000001_100110001: color_out = grid_color;
                17'b10000001_101100011: color_out = grid_color;
                17'b10000001_110010101: color_out = grid_color;
                17'b10000001_111000111: color_out = grid_color;
                17'b10000001_111111001: color_out = grid_color;
                17'b10001011_000000101: color_out = grid_color;
                17'b10001011_000110111: color_out = grid_color;
                17'b10001011_001101001: color_out = grid_color;
                17'b10001011_010011011: color_out = grid_color;
                17'b10001011_011001101: color_out = grid_color;
                17'b10001011_011111110: color_out = grid_color;
                17'b10001011_011111111: color_out = grid_color;
                17'b10001011_100000000: color_out = grid_color;
                17'b10001011_100110001: color_out = grid_color;
                17'b10001011_101100011: color_out = grid_color;
                17'b10001011_110010101: color_out = grid_color;
                17'b10001011_111000111: color_out = grid_color;
                17'b10001011_111111001: color_out = grid_color;
                17'b10010101_000000101: color_out = grid_color;
                17'b10010101_000001111: color_out = grid_color;
                17'b10010101_000011001: color_out = grid_color;
                17'b10010101_000100011: color_out = grid_color;
                17'b10010101_000101101: color_out = grid_color;
                17'b10010101_000110111: color_out = grid_color;
                17'b10010101_001000001: color_out = grid_color;
                17'b10010101_001001011: color_out = grid_color;
                17'b10010101_001010101: color_out = grid_color;
                17'b10010101_001011111: color_out = grid_color;
                17'b10010101_001101001: color_out = grid_color;
                17'b10010101_001110011: color_out = grid_color;
                17'b10010101_001111101: color_out = grid_color;
                17'b10010101_010000111: color_out = grid_color;
                17'b10010101_010010001: color_out = grid_color;
                17'b10010101_010011011: color_out = grid_color;
                17'b10010101_010100101: color_out = grid_color;
                17'b10010101_010101111: color_out = grid_color;
                17'b10010101_010111001: color_out = grid_color;
                17'b10010101_011000011: color_out = grid_color;
                17'b10010101_011001101: color_out = grid_color;
                17'b10010101_011010111: color_out = grid_color;
                17'b10010101_011100001: color_out = grid_color;
                17'b10010101_011101011: color_out = grid_color;
                17'b10010101_011110101: color_out = grid_color;
                17'b10010101_011111110: color_out = grid_color;
                17'b10010101_011111111: color_out = grid_color;
                17'b10010101_100000000: color_out = grid_color;
                17'b10010101_100001001: color_out = grid_color;
                17'b10010101_100010011: color_out = grid_color;
                17'b10010101_100011101: color_out = grid_color;
                17'b10010101_100100111: color_out = grid_color;
                17'b10010101_100110001: color_out = grid_color;
                17'b10010101_100111011: color_out = grid_color;
                17'b10010101_101000101: color_out = grid_color;
                17'b10010101_101001111: color_out = grid_color;
                17'b10010101_101011001: color_out = grid_color;
                17'b10010101_101100011: color_out = grid_color;
                17'b10010101_101101101: color_out = grid_color;
                17'b10010101_101110111: color_out = grid_color;
                17'b10010101_110000001: color_out = grid_color;
                17'b10010101_110001011: color_out = grid_color;
                17'b10010101_110010101: color_out = grid_color;
                17'b10010101_110011111: color_out = grid_color;
                17'b10010101_110101001: color_out = grid_color;
                17'b10010101_110110011: color_out = grid_color;
                17'b10010101_110111101: color_out = grid_color;
                17'b10010101_111000111: color_out = grid_color;
                17'b10010101_111010001: color_out = grid_color;
                17'b10010101_111011011: color_out = grid_color;
                17'b10010101_111100101: color_out = grid_color;
                17'b10010101_111101111: color_out = grid_color;
                17'b10010101_111111001: color_out = grid_color;
                17'b10011111_000000101: color_out = grid_color;
                17'b10011111_000110111: color_out = grid_color;
                17'b10011111_001101001: color_out = grid_color;
                17'b10011111_010011011: color_out = grid_color;
                17'b10011111_011001101: color_out = grid_color;
                17'b10011111_011111110: color_out = grid_color;
                17'b10011111_011111111: color_out = grid_color;
                17'b10011111_100000000: color_out = grid_color;
                17'b10011111_100110001: color_out = grid_color;
                17'b10011111_101100011: color_out = grid_color;
                17'b10011111_110010101: color_out = grid_color;
                17'b10011111_111000111: color_out = grid_color;
                17'b10011111_111111001: color_out = grid_color;
                17'b10101001_000000101: color_out = grid_color;
                17'b10101001_000110111: color_out = grid_color;
                17'b10101001_001101001: color_out = grid_color;
                17'b10101001_010011011: color_out = grid_color;
                17'b10101001_011001101: color_out = grid_color;
                17'b10101001_011111110: color_out = grid_color;
                17'b10101001_011111111: color_out = grid_color;
                17'b10101001_100000000: color_out = grid_color;
                17'b10101001_100110001: color_out = grid_color;
                17'b10101001_101100011: color_out = grid_color;
                17'b10101001_110010101: color_out = grid_color;
                17'b10101001_111000111: color_out = grid_color;
                17'b10101001_111111001: color_out = grid_color;
                17'b10110011_000000101: color_out = grid_color;
                17'b10110011_000110111: color_out = grid_color;
                17'b10110011_001101001: color_out = grid_color;
                17'b10110011_010011011: color_out = grid_color;
                17'b10110011_011001101: color_out = grid_color;
                17'b10110011_011111110: color_out = grid_color;
                17'b10110011_011111111: color_out = grid_color;
                17'b10110011_100000000: color_out = grid_color;
                17'b10110011_100110001: color_out = grid_color;
                17'b10110011_101100011: color_out = grid_color;
                17'b10110011_110010101: color_out = grid_color;
                17'b10110011_111000111: color_out = grid_color;
                17'b10110011_111111001: color_out = grid_color;
                17'b10111101_000000101: color_out = grid_color;
                17'b10111101_000110111: color_out = grid_color;
                17'b10111101_001101001: color_out = grid_color;
                17'b10111101_010011011: color_out = grid_color;
                17'b10111101_011001101: color_out = grid_color;
                17'b10111101_011111110: color_out = grid_color;
                17'b10111101_011111111: color_out = grid_color;
                17'b10111101_100000000: color_out = grid_color;
                17'b10111101_100110001: color_out = grid_color;
                17'b10111101_101100011: color_out = grid_color;
                17'b10111101_110010101: color_out = grid_color;
                17'b10111101_111000111: color_out = grid_color;
                17'b10111101_111111001: color_out = grid_color;
                17'b11000111_000000101: color_out = grid_color;
                17'b11000111_000001111: color_out = grid_color;
                17'b11000111_000011001: color_out = grid_color;
                17'b11000111_000100011: color_out = grid_color;
                17'b11000111_000101101: color_out = grid_color;
                17'b11000111_000110111: color_out = grid_color;
                17'b11000111_001000001: color_out = grid_color;
                17'b11000111_001001011: color_out = grid_color;
                17'b11000111_001010101: color_out = grid_color;
                17'b11000111_001011111: color_out = grid_color;
                17'b11000111_001101001: color_out = grid_color;
                17'b11000111_001110011: color_out = grid_color;
                17'b11000111_001111101: color_out = grid_color;
                17'b11000111_010000111: color_out = grid_color;
                17'b11000111_010010001: color_out = grid_color;
                17'b11000111_010011011: color_out = grid_color;
                17'b11000111_010100101: color_out = grid_color;
                17'b11000111_010101111: color_out = grid_color;
                17'b11000111_010111001: color_out = grid_color;
                17'b11000111_011000011: color_out = grid_color;
                17'b11000111_011001101: color_out = grid_color;
                17'b11000111_011010111: color_out = grid_color;
                17'b11000111_011100001: color_out = grid_color;
                17'b11000111_011101011: color_out = grid_color;
                17'b11000111_011110101: color_out = grid_color;
                17'b11000111_011111110: color_out = grid_color;
                17'b11000111_011111111: color_out = grid_color;
                17'b11000111_100000000: color_out = grid_color;
                17'b11000111_100001001: color_out = grid_color;
                17'b11000111_100010011: color_out = grid_color;
                17'b11000111_100011101: color_out = grid_color;
                17'b11000111_100100111: color_out = grid_color;
                17'b11000111_100110001: color_out = grid_color;
                17'b11000111_100111011: color_out = grid_color;
                17'b11000111_101000101: color_out = grid_color;
                17'b11000111_101001111: color_out = grid_color;
                17'b11000111_101011001: color_out = grid_color;
                17'b11000111_101100011: color_out = grid_color;
                17'b11000111_101101101: color_out = grid_color;
                17'b11000111_101110111: color_out = grid_color;
                17'b11000111_110000001: color_out = grid_color;
                17'b11000111_110001011: color_out = grid_color;
                17'b11000111_110010101: color_out = grid_color;
                17'b11000111_110011111: color_out = grid_color;
                17'b11000111_110101001: color_out = grid_color;
                17'b11000111_110110011: color_out = grid_color;
                17'b11000111_110111101: color_out = grid_color;
                17'b11000111_111000111: color_out = grid_color;
                17'b11000111_111010001: color_out = grid_color;
                17'b11000111_111011011: color_out = grid_color;
                17'b11000111_111100101: color_out = grid_color;
                17'b11000111_111101111: color_out = grid_color;
                17'b11000111_111111001: color_out = grid_color;
                default:color_out = bg_color;
                endcase
//                if((row == 190)||(row == 62))
//                    color_out = 6'b111111;//���±߽���Ϊ��ɫ
//                else
//                    color_out = 6'b000001;//������Ϊ��ɫ,����ɫ117,226
        end
        
           
endmodule
