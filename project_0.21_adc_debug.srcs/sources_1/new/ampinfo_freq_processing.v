`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/06/03 18:52:54
// Design Name: 
// Module Name: ampinfo_freq_processing
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


module ampinfo_freq_processing(
    input clk_in,
    input clk1Hz_in,
    
    input [3:0] clk_state_in,
    input [7:0] addr_ans_in,
    
    input search_en_in,
    input no_data_in,
    
    output wire[47:0] freq_code_out,
    output wire data_valid_out
    );
    parameter ca = 6'd0,     cb = 6'd1,     cc = 6'd2,     cd = 6'd3,     ce = 6'd4,     cf = 6'd5,     cg = 6'd6,     ch = 6'd7,     
               ci = 6'd8,     cj = 6'd9,     ck = 6'd10,    cl = 6'd11,    cm = 6'd12,    cn = 6'd13,    cp = 6'd14,    cq = 6'd15,    
               cr = 6'd16,    cs = 6'd17,    ct = 6'd18,    cu = 6'd19,    cv = 6'd20,    cw = 6'd21,    cx = 6'd22,    cy = 6'd23,    
               cz = 6'd24,    a = 6'd25,     b = 6'd26,     c = 6'd27,     d = 6'd28,     e = 6'd29,     f = 6'd30,     g = 6'd31,     
               h = 6'd32,     i = 6'd33,     j = 6'd34,     k = 6'd35,     m = 6'd36,     n = 6'd37,     o = 6'd38,     p = 6'd39,     
               q = 6'd40,     r = 6'd41,     s = 6'd42,     t = 6'd43,     u = 6'd44,     v = 6'd45,     w = 6'd46,     x = 6'd47,     
               y = 6'd48,     z = 6'd49,     n0 = 6'd50,    n1 = 6'd51,    n2 = 6'd52,    n3 = 6'd53,    n4 = 6'd54,    n5 = 6'd55,    
               n6 = 6'd56,    n7 = 6'd57,    n8 = 6'd58,    n9 = 6'd59,    div = 6'd60,   neg = 6'd61,  space = 6'd62,  point = 6'd63,
               l = 6'd51,     co = 6'd50;//字母l用数字1代替，数字0用大写字母O代替
     
     
     assign data_valid_out = (~no_data_in) && search_en_in;
     
     reg[15:0] reso;
     reg[2:0] carry;

     reg[2:0] loose;

     always@(posedge clk_in)
         case(clk_state_in)
             4'hf: begin reso = 16'd9766;carry = 3'd0; loose = 3'd1; end
             4'he: begin reso = 16'd39063;carry = 3'd0; loose = 3'd0; end
             4'hd: begin reso = 16'd19531;carry = 3'd0; loose = 3'd0; end
             4'hc: begin reso = 16'd9766;carry = 3'd0; loose = 3'd0; end
             4'hb: begin reso = 16'd39063;carry = 3'd1; loose = 3'd0; end
             4'ha: begin reso = 16'd19531;carry = 3'd1; loose = 3'd0; end
             4'h9: begin reso = 16'd9766;carry = 3'd1; loose = 3'd0; end
             4'h8: begin reso = 16'd39063;carry = 3'd2; loose = 3'd0; end
             4'h7: begin reso = 16'd19531;carry = 3'd2; loose = 3'd0; end
             4'h6: begin reso = 16'd9766;carry = 3'd2; loose = 3'd0; end
             4'h5: begin reso = 16'd39063;carry = 3'd3; loose = 3'd0; end
             4'h4: begin reso = 16'd19531;carry = 3'd3; loose = 3'd0; end
             4'h3: begin reso = 16'd9766;carry = 3'd3; loose = 3'd0; end
             4'h2: begin reso = 16'd39063;carry = 3'd4; loose = 3'd0; end
             4'h1: begin reso = 16'd19531;carry = 3'd4; loose = 3'd0; end
             4'h0: begin reso = 16'd9766;carry = 3'd4; loose = 3'd0; end
         endcase
     
     reg[23:0] freq_ans;
     reg carried;
     reg[2:0] carry_ans;
     reg loosed;
     reg[2:0] loose_ans;
     always@(posedge clk1Hz_in)
     begin
         freq_ans = reso * addr_ans_in;
         carry_ans = carry;
         carried = |carry_ans;
         loose_ans = loose;
         loosed = |loose_ans;
     end
    
    wire[31:0] freq_bcd_out;
    wire freq_bcd_valid;
    bin2bcd(
        .clk_in(clk_in),
        .bin_in({2'b00,freq_ans}),//最高26位输入
        .bcd_out(freq_bcd_out),//最高32位输出
        .valid_out(freq_bcd_valid)
           );
    reg[31:0] freq_bcd;
    always@(posedge freq_bcd_valid)
       freq_bcd <= freq_bcd_out;
    bcd2code(
       .clk_in(clk_in),
  
       .negative_in(0),
       .bcd_in(freq_bcd),
       .carried_in(carried),
       .carry_in(carry_ans),//最多带了7个0
       .loosed_in(loosed),
       .loose_in(loose_ans),//最多去了7个0
       
       .units_in(3'd4),//0:p，1:n, 2:u, 3:m, 4:无单位 5:k, 6:M，7:G
       .units_code_in({ch,z}),//s_////最多两位符号输入//如果增加，要改units_code,code_out
       
       .code_out(freq_code_out)//8个字符，小数点保留2位
   
       );
endmodule
