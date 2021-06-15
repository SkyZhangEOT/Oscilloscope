`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/16 15:48:22
// Design Name: 
// Module Name: inf_code_ram_gengerator
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


module inf_code_ram_gengerator(//��������RAM���������ݣ���������code�������ַ������ַ����룬���ӳ�
    input clk_in,
    ///////////////���ݼ��㲿��////////////////
    input divclk_in,
    input clk1Hz_in,      
    input sync_trigger_in,
    input [15:0]sync_count_in,
    input [11:0] signal_in,
    input [3:0] clk_state_in,
    input [3:0] bit_choose_in,
    
    input [1:0] ram_addr_in,//ramѰַ,4��ram
    input [5:0] char_addr_in,//�ַ�λѰַ����64���ַ�
    output reg[5:0] char_code_out//�ַ�����
    );
parameter ca = 6'd0,     cb = 6'd1,     cc = 6'd2,     cd = 6'd3,     ce = 6'd4,     cf = 6'd5,     cg = 6'd6,     ch = 6'd7,     
           ci = 6'd8,     cj = 6'd9,     ck = 6'd10,    cl = 6'd11,    cm = 6'd12,    cn = 6'd13,    cp = 6'd14,    cq = 6'd15,    
           cr = 6'd16,    cs = 6'd17,    ct = 6'd18,    cu = 6'd19,    cv = 6'd20,    cw = 6'd21,    cx = 6'd22,    cy = 6'd23,    
           cz = 6'd24,    a = 6'd25,     b = 6'd26,     c = 6'd27,     d = 6'd28,     e = 6'd29,     f = 6'd30,     g = 6'd31,     
           h = 6'd32,     i = 6'd33,     j = 6'd34,     k = 6'd35,     m = 6'd36,     n = 6'd37,     o = 6'd38,     p = 6'd39,     
           q = 6'd40,     r = 6'd41,     s = 6'd42,     t = 6'd43,     u = 6'd44,     v = 6'd45,     w = 6'd46,     x = 6'd47,     
           y = 6'd48,     z = 6'd49,     n0 = 6'd50,    n1 = 6'd51,    n2 = 6'd52,    n3 = 6'd53,    n4 = 6'd54,    n5 = 6'd55,    
           n6 = 6'd56,    n7 = 6'd57,    n8 = 6'd58,    n9 = 6'd59,    div = 6'd60,   neg = 6'd61,  space = 6'd62,  point = 6'd63,
           l = 6'd51,co = 6'd50;//��ĸl������1���棬����0�ô�д��ĸO����

    wire[5:0] char_codeb_line1;
    wire[5:0] char_codeb_line2;
    wire[5:0] char_codeb_line3;
    wire[5:0] char_codeb_line4;
    always@(*)//�����������������һ��ram��
        case(ram_addr_in)
            2'b00: char_code_out = char_codeb_line1;
            2'b01: char_code_out = char_codeb_line2;
            2'b10: char_code_out = char_codeb_line3;
            2'b11: char_code_out = char_codeb_line4;
        endcase
    
    //********************************Ϊline1��λ*****************************************/
    wire[5:0] char_bita_line1;//λ��
    wire[5:0] char_code_line1;
    info_code_ram1_manager info_code_ram1_manager(//line1 ������ʾ���ε�ˮƽ�ֻ��ʹ�ֱ�ֻ���Ŀǰֻ��ˮƽ,��ֱ�ֻ�����
        .clk_in(clk_in),
        .clk_state_in(clk_state_in),
        .bit_choose_in(bit_choose_in),
        .char_bit_out(char_bita_line1),
        .char_code_out(char_code_line1)
        );
    char_code_ram inf_line1(
        .clk_in(clk_in),
        .wea_in(1), 
        .char_bita_in(char_bita_line1),//[5:0]
        .char_codea_in(char_code_line1),//[5:0]
        .char_bitb_in(char_addr_in),//�����ַ�λ[5:0]
        .char_codeb_out(char_codeb_line1)//����ַ�����
        );



/********************************************Ϊline2��λ*****************************************/
    //Ϊline2��λ
    wire[5:0] char_bita_line2;//λ��
    wire[5:0] char_code_line2;
    info_code_ram2_manager info_code_ram2_manager(//����ʱ��״̬������״̬������ź����ڣ�Ƶ�ʣ����ֵ��ƽ��ֵ��code��code ram2,��ǰֻ��Ƶ��
        .clk_in(clk_in),
        .divclk_in(divclk_in),
        .clk1Hz_in(clk1Hz_in),      
        .sync_trigger_in(sync_trigger_in),
        .signal_in(signal_in),
        .clk_state_in(clk_state_in),
        .sync_count_in(sync_count_in),        
        .char_bit_out(char_bita_line2),
        .char_code_out(char_code_line2)
        );

    char_code_ram inf_line2(
        .clk_in(clk_in),
        .wea_in(1), 
        .char_bita_in(char_bita_line2),//[5:0]
        .char_codea_in(char_code_line2),//[5:0]
        .char_bitb_in(char_addr_in),//�����ַ�λ[5:0]
        .char_codeb_out(char_codeb_line2)//����ַ�����
        );






    wire[5:0] char_bita_line3;//λ��
    wire[5:0] char_code_line3;
    info_code_ram3_manager info_code_ram3_manager(
        .clk_in(clk_in),
        .clk_state_in(clk_state_in),
        .char_bit_out(char_bita_line3),
        .char_code_out(char_code_line3)
        );
    char_code_ram inf_line3(
        .clk_in(clk_in),
        .wea_in(1), 
        .char_bita_in(char_bita_line3),//[5:0]
        .char_codea_in(char_code_line3),//[5:0]
        .char_bitb_in(char_addr_in),//�����ַ�λ[5:0]
        .char_codeb_out(char_codeb_line3)//����ַ�����
        );

    reg[5:0] char_bita_line4 = 0;//λ��
    reg[5:0] char_code_line4 = space;
    always@(posedge clk_in)//��ַ����ˢ��
            char_bita_line4 = char_bita_line4 + 1;
    char_code_ram inf_line4(
            .clk_in(clk_in),
            .wea_in(1), 
            .char_bita_in(char_bita_line4),//[5:0]
            .char_codea_in(char_code_line4),//[5:0]
            .char_bitb_in(char_addr_in),//�����ַ�λ[5:0]
            .char_codeb_out(char_codeb_line4)//����ַ�����
            );
endmodule
