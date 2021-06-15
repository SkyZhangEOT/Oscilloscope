`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/20 20:45:40
// Design Name: 
// Module Name: info_code_ram1_manager
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


module info_code_ram1_manager(//line1 用来显示波形的水平分划和垂直分划，目前只有水平,垂直分划待测
    input clk_in,
    
    input [3:0] clk_state_in,
    input [3:0] bit_choose_in,
    
    output reg[5:0] char_bit_out,
    output reg[5:0] char_code_out
    );
    initial
    begin
    char_bit_out = 0;
    char_code_out = 0;
    end
parameter ca = 6'd0,     cb = 6'd1,     cc = 6'd2,     cd = 6'd3,     ce = 6'd4,     cf = 6'd5,     cg = 6'd6,     ch = 6'd7,     
           ci = 6'd8,     cj = 6'd9,     ck = 6'd10,    cl = 6'd11,    cm = 6'd12,    cn = 6'd13,    cp = 6'd14,    cq = 6'd15,    
           cr = 6'd16,    cs = 6'd17,    ct = 6'd18,    cu = 6'd19,    cv = 6'd20,    cw = 6'd21,    cx = 6'd22,    cy = 6'd23,    
           cz = 6'd24,    a = 6'd25,     b = 6'd26,     c = 6'd27,     d = 6'd28,     e = 6'd29,     f = 6'd30,     g = 6'd31,     
           h = 6'd32,     i = 6'd33,     j = 6'd34,     k = 6'd35,     m = 6'd36,     n = 6'd37,     o = 6'd38,     p = 6'd39,     
           q = 6'd40,     r = 6'd41,     s = 6'd42,     t = 6'd43,     u = 6'd44,     v = 6'd45,     w = 6'd46,     x = 6'd47,     
           y = 6'd48,     z = 6'd49,     n0 = 6'd50,    n1 = 6'd51,    n2 = 6'd52,    n3 = 6'd53,    n4 = 6'd54,    n5 = 6'd55,    
           n6 = 6'd56,    n7 = 6'd57,    n8 = 6'd58,    n9 = 6'd59,    div = 6'd60,   neg = 6'd61,  space = 6'd62,  point = 6'd63,
           l = 6'd51,co = 6'd50;//字母l用数字1代替，数字0用大写字母O代替


    //水平时基最大显示位宽23 左5 右4

    always@(posedge clk_in)//地址不断刷新
        char_bit_out = char_bit_out + 1;
    
    reg[53:0] time_info;//时间字符信息,11位
    always@(posedge clk_in)
        case(clk_state_in)
            4'hf:time_info = {n1,u,s,div,d,i,v,space,space};//50m
            4'he:time_info = {n2,point,n5,u,s,div,d,i,v};//20m
            4'hd:time_info = {n5,u,s,div,d,i,v,space,space};//10m
            4'hc:time_info = {n1,n0,u,s,div,d,i,v,space};//5m
            4'hb:time_info = {n2,n5,u,s,div,d,i,v,space};//2m
            4'ha:time_info = {n5,n0,u,s,div,d,i,v,space};//1m
            4'h9:time_info = {n1,n0,n0,u,s,div,d,i,v};//500k
            4'h8:time_info = {n2,n5,n0,u,s,div,d,i,v};//200k
            4'h7:time_info = {n5,n0,n0,u,s,div,d,i,v};//100k
            4'h6:time_info = {n1,m,s,div,d,i,v,space,space};//50k
            4'h5:time_info = {n2,point,n5,m,s,div,d,i,v};//20k
            4'h4:time_info = {n5,m,s,div,d,i,v,space,space};//10k
            4'h3:time_info = {n1,n0,m,s,div,d,i,v,space};//5000
            4'h2:time_info = {n2,n5,m,s,div,d,i,v,space};//2000
            4'h1:time_info = {n5,n0,m,s,div,d,i,v,space};//1000
            4'h0:time_info = {n1,n0,n0,m,s,div,d,i,v};//500
        endcase
        
        reg[59:0] volt_info; 
        always@(posedge clk_in)
            case(bit_choose_in)
                4'hf:volt_info = {n2,n5,cv,div,d,i,v,space,space,space};
                4'he:volt_info = {n1,n2,point,n5,cv,div,d,i,v,space};
                4'hd:volt_info = {n6,point,n2,n5,cv,div,d,i,v,space};
                4'hc:volt_info = {n3,point,n1,n3,cv,div,d,i,v,space};
                4'hb:volt_info = {n1,point,n5,n6,cv,div,d,i,v,space};
                4'ha:volt_info = {n7,n8,n1,m,cv,div,d,i,v,space};
                4'h9:volt_info = {n3,n9,n1,m,cv,div,d,i,v,space};
                4'h8:volt_info = {n1,n9,n5,m,cv,div,d,i,v,space};
                4'h7:volt_info = {n9,n7,point,n7,m,cv,div,d,i,v};
                4'h6:volt_info = {n4,n8,point,n8,m,cv,div,d,i,v};
                4'h5:volt_info = {n2,n4,point,n4,m,cv,div,d,i,v};
                4'h4:volt_info = {n1,n2,point,n2,m,cv,div,d,i,v};
                4'h3:volt_info = {n6,point,n1,m,cv,div,d,i,v,space};
                4'h2:volt_info = {n3,point,n0,n5,m,cv,div,d,i,v};
                4'h1:volt_info = {n1,point,n5,n3,m,cv,div,d,i,v};
                4'h0:volt_info = {n7,n6,n3,u,cv,div,d,i,v,space};
            endcase
    
    always@(char_bit_out)
        case(char_bit_out)
            6'd6:char_code_out = ch;//第6位  
            6'd7:char_code_out = o;        
            6'd8:char_code_out = r;        
            6'd9:char_code_out = i;        
            6'd10:char_code_out = z;        
            6'd11:char_code_out = neg;     
            6'd12:char_code_out = ct;      
            6'd13:char_code_out = i;       
            6'd14:char_code_out = m;       
            6'd15:char_code_out = e;       
            6'd16:char_code_out = space;
            6'd17:char_code_out = time_info[53:48];
            6'd18:char_code_out = time_info[47:42];
            6'd19:char_code_out = time_info[41:36];
            6'd20:char_code_out = time_info[35:30];
            6'd21:char_code_out = time_info[29:24];
            6'd22:char_code_out = time_info[23:18];
            6'd23:char_code_out = time_info[17:12];
            6'd24:char_code_out = time_info[11:6]; 
            6'd25:char_code_out = time_info[5:0];  
            6'd38:char_code_out = cv; 
            6'd39:char_code_out = e;  
            6'd40:char_code_out = r;  
            6'd41:char_code_out = t;  
            6'd42:char_code_out = i;  
            6'd43:char_code_out = neg;
            6'd44:char_code_out = cv; 
            6'd45:char_code_out = o;  
            6'd46:char_code_out = l;  
            6'd47:char_code_out = t;
            6'd48:char_code_out = space;
            6'd49:char_code_out = volt_info[59:54];
            6'd50:char_code_out = volt_info[53:48];
            6'd51:char_code_out = volt_info[47:42];
            6'd52:char_code_out = volt_info[41:36];
            6'd53:char_code_out = volt_info[35:30];
            6'd54:char_code_out = volt_info[29:24];
            6'd55:char_code_out = volt_info[23:18];
            6'd56:char_code_out = volt_info[17:12];
            6'd57:char_code_out = volt_info[11:6]; 
            6'd58:char_code_out = volt_info[5:0];  
            default:char_code_out = space;
        endcase
endmodule
