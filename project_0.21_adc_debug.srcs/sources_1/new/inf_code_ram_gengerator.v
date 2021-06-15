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


module inf_code_ram_gengerator(//管理四组RAM，计算数据，保存字型code，输入地址，输出字符代码，无延迟
    input clk_in,
    ///////////////数据计算部分////////////////
    input divclk_in,
    input clk1Hz_in,      
    input sync_trigger_in,
    input [15:0]sync_count_in,
    input [11:0] signal_in,
    input [3:0] clk_state_in,
    input [3:0] bit_choose_in,
    
    input [1:0] ram_addr_in,//ram寻址,4组ram
    input [5:0] char_addr_in,//字符位寻址，共64个字符
    output reg[5:0] char_code_out//字符代码
    );
parameter ca = 6'd0,     cb = 6'd1,     cc = 6'd2,     cd = 6'd3,     ce = 6'd4,     cf = 6'd5,     cg = 6'd6,     ch = 6'd7,     
           ci = 6'd8,     cj = 6'd9,     ck = 6'd10,    cl = 6'd11,    cm = 6'd12,    cn = 6'd13,    cp = 6'd14,    cq = 6'd15,    
           cr = 6'd16,    cs = 6'd17,    ct = 6'd18,    cu = 6'd19,    cv = 6'd20,    cw = 6'd21,    cx = 6'd22,    cy = 6'd23,    
           cz = 6'd24,    a = 6'd25,     b = 6'd26,     c = 6'd27,     d = 6'd28,     e = 6'd29,     f = 6'd30,     g = 6'd31,     
           h = 6'd32,     i = 6'd33,     j = 6'd34,     k = 6'd35,     m = 6'd36,     n = 6'd37,     o = 6'd38,     p = 6'd39,     
           q = 6'd40,     r = 6'd41,     s = 6'd42,     t = 6'd43,     u = 6'd44,     v = 6'd45,     w = 6'd46,     x = 6'd47,     
           y = 6'd48,     z = 6'd49,     n0 = 6'd50,    n1 = 6'd51,    n2 = 6'd52,    n3 = 6'd53,    n4 = 6'd54,    n5 = 6'd55,    
           n6 = 6'd56,    n7 = 6'd57,    n8 = 6'd58,    n9 = 6'd59,    div = 6'd60,   neg = 6'd61,  space = 6'd62,  point = 6'd63,
           l = 6'd51,co = 6'd50;//字母l用数字1代替，数字0用大写字母O代替

    wire[5:0] char_codeb_line1;
    wire[5:0] char_codeb_line2;
    wire[5:0] char_codeb_line3;
    wire[5:0] char_codeb_line4;
    always@(*)//分配输出的数据是哪一个ram的
        case(ram_addr_in)
            2'b00: char_code_out = char_codeb_line1;
            2'b01: char_code_out = char_codeb_line2;
            2'b10: char_code_out = char_codeb_line3;
            2'b11: char_code_out = char_codeb_line4;
        endcase
    
    //********************************为line1置位*****************************************/
    wire[5:0] char_bita_line1;//位数
    wire[5:0] char_code_line1;
    info_code_ram1_manager info_code_ram1_manager(//line1 用来显示波形的水平分划和垂直分划，目前只有水平,垂直分划待测
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
        .char_bitb_in(char_addr_in),//输入字符位[5:0]
        .char_codeb_out(char_codeb_line1)//输出字符代码
        );



/********************************************为line2置位*****************************************/
    //为line2置位
    wire[5:0] char_bita_line2;//位数
    wire[5:0] char_code_line2;
    info_code_ram2_manager info_code_ram2_manager(//输入时钟状态，计数状态，输出信号周期，频率，峰峰值，平均值的code给code ram2,当前只有频率
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
        .char_bitb_in(char_addr_in),//输入字符位[5:0]
        .char_codeb_out(char_codeb_line2)//输出字符代码
        );






    wire[5:0] char_bita_line3;//位数
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
        .char_bitb_in(char_addr_in),//输入字符位[5:0]
        .char_codeb_out(char_codeb_line3)//输出字符代码
        );

    reg[5:0] char_bita_line4 = 0;//位数
    reg[5:0] char_code_line4 = space;
    always@(posedge clk_in)//地址不断刷新
            char_bita_line4 = char_bita_line4 + 1;
    char_code_ram inf_line4(
            .clk_in(clk_in),
            .wea_in(1), 
            .char_bita_in(char_bita_line4),//[5:0]
            .char_codea_in(char_code_line4),//[5:0]
            .char_bitb_in(char_addr_in),//输入字符位[5:0]
            .char_codeb_out(char_codeb_line4)//输出字符代码
            );
endmodule
