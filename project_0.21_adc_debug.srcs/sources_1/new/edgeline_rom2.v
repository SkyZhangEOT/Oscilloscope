`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/29 22:10:33
// Design Name: 
// Module Name: edgeline_rom2
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


module edgeline_rom2(
    input title_valid_in,
input [2:0] state_in,
input [3:0] char_bit_in,
input ext_code_valid_in,//用于在第二行的数据显示           
input [71:0] ext_code_in,

output reg[5:0] char_code_out//字符数据              
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

    reg[5:0] title_code[0:13];//最大十三个字符
    wire[5:0] title_code_out;
    assign title_code_out = title_code[char_bit_in];

    reg[5:0] info_code0[0:13];
    wire[5:0] info_code0_out;
    assign info_code0_out = info_code0[char_bit_in];
    reg[5:0] info_code1[0:13];
    wire[5:0] info_code1_out;                       
    assign info_code1_out = info_code1[char_bit_in];
    reg[5:0] info_code2[0:13];
    wire[5:0] info_code2_out;                       
    assign info_code2_out = info_code2[char_bit_in];
    reg[5:0] info_code3[0:13];
    wire[5:0] info_code3_out;                       
    assign info_code3_out = info_code3[char_bit_in];

           
           
    initial
    begin
        title_code[0] = space;
        title_code[1] = space;
        title_code[2] = ct;
        title_code[3] = cr;
        title_code[4] =  ci;
        title_code[5] =  cg; 
        title_code[6] =  space; 
        title_code[7] =  cm; 
        title_code[8] =  co; 
        title_code[9] =  cd; 
        title_code[10] = ce; 
        title_code[11] = space;
        title_code[12] = space;
        title_code[13] = space;
        info_code0[0] = space;    info_code0[1] = cr;      info_code0[2] = i;    info_code0[3] = s;    info_code0[4] = i;  info_code0[5] = n;     info_code0[6] = g;
        info_code0[7] = space;    info_code0[8] = ce;      info_code0[9] = d;    info_code0[10] = g;   info_code0[11] = e; info_code0[12] = space;info_code0[13] = space;
        
        info_code1[0] = space;  info_code1[1] = cf;  info_code1[2] = a;  info_code1[3] = l;  info_code1[4] = l;   info_code1[5] = i;     info_code1[6] = n;
        info_code1[7] = g;    info_code1[8] = space;      info_code1[9] = ce;      info_code1[10] = d;   info_code1[11] = g; info_code1[12] = e; info_code1[13] = space;
        
        info_code2[0] = space;  info_code2[1] = space;  info_code2[2] = ct;  info_code2[3] = r;  info_code2[4] = a;     info_code2[5] = n;    info_code2[6] = s;
        info_code2[7] = i;    info_code2[8] = e;      info_code2[9] = n;      info_code2[10] = t;    info_code2[11] = space;  info_code2[12] = space;    info_code2[13] = space;
        
        info_code3[0] = space;    info_code3[1] = space;  info_code3[2] = space;  info_code3[3] = space;  info_code3[4] = cr;        info_code3[5] = e;    info_code3[6] = s;
        info_code3[7] = e;      info_code3[8] = t;      info_code3[9] = space;      info_code3[10] = space;     info_code3[11] = space; info_code3[12] = space;   info_code3[13] = space;
    end
    
    
always@(*)
    if(title_valid_in)
        char_code_out <= title_code_out;
    else if(ext_code_valid_in)
        case(char_bit_in)
            4'h0: char_code_out <= space;
            4'h1: char_code_out <= ext_code_in[71:66];
            4'h2: char_code_out <= ext_code_in[65:60];
            4'h3: char_code_out <= ext_code_in[59:54];
            4'h4: char_code_out <= ext_code_in[53:48];
            4'h5: char_code_out <= ext_code_in[47:42];
            4'h6: char_code_out <= ext_code_in[41:36];
            4'h7: char_code_out <= ext_code_in[35:30];
            4'h8: char_code_out <= ext_code_in[29:24];
            4'h9: char_code_out <= ext_code_in[23:18];
            4'ha: char_code_out <= ext_code_in[17:12];
            4'hb: char_code_out <= ext_code_in[11:6]; 
            4'hc: char_code_out <= ext_code_in[5:0];  
            4'hd: char_code_out <= space;
            default:char_code_out <= space;
        endcase
    else
        case(state_in)
            3'd0: char_code_out <= info_code0_out;
            3'd1: char_code_out <= info_code1_out;
            3'd2: char_code_out <= info_code2_out;
            3'd3: char_code_out <= info_code3_out;
            default:char_code_out <= space;
        endcase
endmodule
