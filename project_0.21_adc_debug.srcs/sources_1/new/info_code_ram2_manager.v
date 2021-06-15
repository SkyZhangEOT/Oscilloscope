`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/20 21:30:00
// Design Name: 
// Module Name: info_code_ram2_manager
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


module info_code_ram2_manager(//输入时钟状态，计数状态，输出信号周期，频率，峰峰值，平均值的code给code ram2,当前只有频率
    input clk_in,
    input divclk_in,
    input clk1Hz_in, 
         
    input sync_trigger_in,
    input [3:0] clk_state_in,
    input [15:0]sync_count_in, 
    input [11:0] signal_in,       
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
    /*********************时钟频率和周期*******************************/
    wire[47:0] freq_code;
    wire[47:0] period_code;   
    waveinfo_time_processing(//输入时钟和计数，计算，转换成BCD码，转换成字符信息，输出的6位code和单位
        .clk_in(clk_in),
        .clk1Hz_in(clk1Hz_in),            
        .sync_trigger_in(sync_trigger_in),
        .sync_count_in(sync_count_in),
        .clk_state_in(clk_state_in),//时钟频率状态
        .freq_code_out(freq_code),//频率的code字符
        .period_code_out(period_code)
        );
    
    wire[47:0] vpp_code;
    wire[47:0] mean_code;         
    waveinfo_voltage_processing(
            .clk_in(clk_in),              
            .divclk_in(divclk_in),           
            .clk1Hz_in(clk1Hz_in),
                       
            .sync_trigger_in(sync_trigger_in),     
            .sync_count_in(sync_count_in),
            .signal_in(signal_in),
            
            .vpp_code_out(vpp_code), 
            .mean_code_out(mean_code)
            );
    

    always@(posedge clk_in)//地址不断刷新
        char_bit_out = char_bit_out + 1;
    
    
    //频率显示最大用14位，左右各空一个字符
    always@(char_bit_out)
        case(char_bit_out)
            6'd0:char_code_out = cf;///////////频率
            6'd1:char_code_out = r; 
            6'd2:char_code_out = e; 
            6'd3:char_code_out = q; 
            6'd4:char_code_out = space;
            6'd5:char_code_out = freq_code[47:42];
            6'd6:char_code_out = freq_code[41:36];
            6'd7:char_code_out = freq_code[35:30];
            6'd8:char_code_out = freq_code[29:24];
            6'd9:char_code_out = freq_code[23:18];
            6'd10:char_code_out = freq_code[17:12];
            6'd11:char_code_out = freq_code[11:6];  
            6'd12:char_code_out = freq_code[5:0];  
            6'd16:char_code_out = cp;///////////周期
            6'd17:char_code_out = e;
            6'd18:char_code_out = r;
            6'd19:char_code_out = i;
            6'd20:char_code_out = o;
            6'd21:char_code_out = d;
            6'd22:char_code_out = space;
            6'd23:char_code_out = period_code[47:42];
            6'd24:char_code_out = period_code[41:36];
            6'd25:char_code_out = period_code[35:30];
            6'd26:char_code_out = period_code[29:24];
            6'd27:char_code_out = period_code[23:18];     
            6'd28:char_code_out = period_code[17:12];
            6'd29:char_code_out = period_code[11:6]; 
            6'd30:char_code_out = period_code[5:0];  
            6'd32:char_code_out = cp;//峰峰值
            6'd33:char_code_out = k;
            6'd34:char_code_out = neg;
            6'd35:char_code_out = cp;
            6'd36:char_code_out = k;
            6'd37:char_code_out = space;
            6'd38:char_code_out = vpp_code[47:42];
            6'd39:char_code_out = vpp_code[41:36];
            6'd40:char_code_out = vpp_code[35:30];
            6'd41:char_code_out = vpp_code[29:24];
            6'd42:char_code_out = vpp_code[23:18];
            6'd43:char_code_out = vpp_code[17:12];
            6'd44:char_code_out = vpp_code[11:6]; 
            6'd45:char_code_out = vpp_code[5:0];  
            6'd48:char_code_out = cm;//平均值
            6'd49:char_code_out = e;
            6'd50:char_code_out = a;
            6'd51:char_code_out = n;
            6'd52:char_code_out = space;
            6'd53:char_code_out = mean_code[47:42];
            6'd54:char_code_out = mean_code[41:36];
            6'd55:char_code_out = mean_code[35:30];
            6'd56:char_code_out = mean_code[29:24];
            6'd57:char_code_out = mean_code[23:18];
            6'd58:char_code_out = mean_code[17:12];
            6'd59:char_code_out = mean_code[11:6]; 
            6'd60:char_code_out = mean_code[5:0];  
            default:char_code_out = space;
        endcase
endmodule
