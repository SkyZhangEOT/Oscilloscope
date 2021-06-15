//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: uestc
//// Engineer: zhangwenxiang
//// 
//// Create Date: 2019/05/22 22:57:05
//// Design Name: 
//// Module Name: info_code_ram4_manager
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


//module info_code_ram4_manager(
//    input clk_in,
//    input clk1Hz_in,
//    input [3:0] clk_state_in,
//    output reg[5:0] char_bit_out,
//    output reg[5:0] char_code_out
//    );
    
//     parameter ca = 6'd0,     cb = 6'd1,     cc = 6'd2,     cd = 6'd3,     ce = 6'd4,     cf = 6'd5,     cg = 6'd6,     ch = 6'd7,     
//                ci = 6'd8,     cj = 6'd9,     ck = 6'd10,    cl = 6'd11,    cm = 6'd12,    cn = 6'd13,    cp = 6'd14,    cq = 6'd15,   
//                cr = 6'd16,    cs = 6'd17,    ct = 6'd18,    cu = 6'd19,    cv = 6'd20,    cw = 6'd21,    cx = 6'd22,    cy = 6'd23,   
//                cz = 6'd24,    a = 6'd25,     b = 6'd26,     c = 6'd27,     d = 6'd28,     e = 6'd29,     f = 6'd30,     g = 6'd31,    
//                h = 6'd32,     i = 6'd33,     j = 6'd34,     k = 6'd35,     m = 6'd36,     n = 6'd37,     o = 6'd38,     p = 6'd39,    
//                q = 6'd40,     r = 6'd41,     s = 6'd42,     t = 6'd43,     u = 6'd44,     v = 6'd45,     w = 6'd46,     x = 6'd47,    
//                y = 6'd48,     z = 6'd49,     n0 = 6'd50,    n1 = 6'd51,    n2 = 6'd52,    n3 = 6'd53,    n4 = 6'd54,    n5 = 6'd55,   
//                n6 = 6'd56,    n7 = 6'd57,    n8 = 6'd58,    n9 = 6'd59,    div = 6'd60,   neg = 6'd61,  space = 6'd62,  point = 6'd63,
//                l = 6'd51,co = 6'd50;//字母l用数字1代替，数字0用大写字母O代替                                                                           
                                                                                                                                       
    
    
    
//    initial
//        begin
//        char_bit_out = 0;
//        char_code_out = 0;
//        info[0] = sd;
//        info[1] = e;
//        info[2] = s;
//        info[3] = i;
//        info[4] = g;
//        info[5] = n;
//        info[6] = e;
//        info[7] = d;
//        info[8] = space;
//        info[9] = sb;
//        info[10] = y;
//        info[11] = space;
//        info[12] = sz;
//        info[13] = h;
//        info[14] = a;
//        info[15] = n;
//        info[16] = g;
//        info[17] = sw;
//        info[18] = e;
//        info[19] = n;
//        info[20] = x;
//        info[21] = i;
//        info[22] = a;
//        info[23] = n;
//        info[24] = g;
//        end
   
    
    
    
    
    
    
   
   
   
    
//        //水平时基最大显示位宽23 左5 右4
    
//        always@(posedge clk_in)//地址不断刷新
//            char_bit_out = char_bit_out + 1;
    
    
//    reg[5:0] info[0:63];//时间字符信息,11位
//        always@(posedge clk1Hz_in)
//            begin
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
//                info[] <= info[];
            
            
            
            
            
            
            
            
            
            
            
            
//            end
//                always@(posedge clk_in)
//                    case(clk_state_in)
//                        4'hf: info = {n2,n5,cm,ch,z,space};   
//                        4'he: info = {n1,n0,cm,ch,z,space};   
//                        4'hd: info = {n5,cm,ch,z,space,space};
//                        4'hc: info = {n2,point,n5,cm,ch,z};    
//                        4'hb: info = {n1,cm,ch,z,space,space}; 
//                        4'ha: info = {n5,n0,n0,k,ch,z};        
//                        4'h9: info = {n2,n5,n0,k,ch,z};        
//                        4'h8: info = {n1,n0,n0,k,ch,z};        
//                        4'h7: info = {n5,n0,k,ch,z,space};         
//                        4'h6: info = {n2,n5,k,ch,z,space};             
//                        4'h5: info = {n1,n0,k,ch,z,space};              
//                        4'h4: info = {n5,k,ch,z,space,space};         
//                        4'h3: info = {n2,point,n5,k,ch,z};                 
//                        4'h2: info = {n1,k,ch,z,space,space};            
//                        4'h1: info = {n5,n0,n0,ch,z,space};                
//                        4'h0: info = {n2,n5,n0,ch,z,space};                 
//                    endcase
                
//                always@(char_bit_out)
//                    case(char_bit_out)
//                        6'd0:char_code_out = ch;
//                        6'd1:char_code_out = o;
//                        6'd2:char_code_out = r;
//                        6'd3:char_code_out = i;
//                        6'd4:char_code_out = z;
//                        6'd5:char_code_out = neg;//第6位
//                        6'd6:char_code_out = cs;
//                        6'd7:char_code_out = p;
//                        6'd8:char_code_out = e;
//                        6'd9:char_code_out = c;
//                        6'd10:char_code_out = space;
//                        6'd11:char_code_out = horiz_spec[71:66]; 
//                        6'd12:char_code_out = horiz_spec[65:60]; 
//                        6'd13:char_code_out = horiz_spec[59:54]; 
//                        6'd14:char_code_out = horiz_spec[53:48]; 
//                        6'd15:char_code_out = horiz_spec[47:42]; 
//                        6'd16:char_code_out = horiz_spec[41:36]; 
//                        6'd17:char_code_out = horiz_spec[35:30]; 
//                        6'd18:char_code_out = horiz_spec[29:24]; 
//                        6'd19:char_code_out = horiz_spec[23:18]; 
//                        6'd20:char_code_out = horiz_spec[17:12]; 
//                        6'd21:char_code_out = horiz_spec[11:6];  
//                        6'd22:char_code_out = horiz_spec[5:0];   
////                        6'd23:char_code_out = horiz_spec[5:0];   
////                        6'd24:char_code_out = horiz_spec[5:0];   
////                        6'd25:char_code_out = horiz_spec[5:0];   
//                        /////////////////////////////////////////////
//                        6'd26:char_code_out = cb;
//                        6'd27:char_code_out = a;
//                        6'd28:char_code_out = n;
//                        6'd29:char_code_out = d;
//                        6'd30:char_code_out = neg;
//                        6'd31:char_code_out = cw;
//                        6'd32:char_code_out = i;
//                        6'd33:char_code_out = d;
//                        6'd34:char_code_out = t;
//                        6'd35:char_code_out = h;
//                        6'd36:char_code_out = space;
//                        6'd37:char_code_out = band_info[35:30];
//                        6'd38:char_code_out = band_info[29:24];
//                        6'd39:char_code_out = band_info[23:18];
//                        6'd40:char_code_out = band_info[17:12];
//                        6'd41:char_code_out = band_info[11:6]; 
//                        6'd42:char_code_out = band_info[5:0];  
//                        //////////////////////////////////////////
//                        6'd46:char_code_out =cr;
//                        6'd47:char_code_out = e;
//                        6'd48:char_code_out = s;
//                        6'd49:char_code_out = o;
//                        6'd50:char_code_out = l;
//                        6'd51:char_code_out = u;
//                        6'd52:char_code_out = t;
//                        6'd53:char_code_out = i;
//                        6'd54:char_code_out = o;
//                        6'd55:char_code_out = n;
//                        6'd56:char_code_out = space;
//                        6'd57:char_code_out = reso_info[41:36];
//                        6'd58:char_code_out = reso_info[35:30];
//                        6'd59:char_code_out = reso_info[29:24];
//                        6'd60:char_code_out = reso_info[23:18];
//                        6'd61:char_code_out = reso_info[17:12];
//                        6'd62:char_code_out = reso_info[11:6]; 
//                        6'd63:char_code_out = reso_info[5:0];  
//                        default:char_code_out = space;
//                    endcase
//endmodule
