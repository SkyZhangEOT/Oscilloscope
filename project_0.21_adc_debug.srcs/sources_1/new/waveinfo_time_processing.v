`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/19 13:47:40
// Design Name: 
// Module Name: waveinfo_time_processing
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


module waveinfo_time_processing(//输入时钟和计数，计算，转换成BCD码，转换成字符信息，输出的6位code和单位
    input clk_in,
    input clk1Hz_in,      
    input sync_trigger_in,
    input [15:0]sync_count_in,
    input [3:0] clk_state_in,//时钟频率状态
    output wire[47:0] freq_code_out,//频率的code字符
    output wire[47:0] period_code_out
    );
    
    //////*************************输出结果****************************//////
    ////////////////////////////计算周期和频率，bin码，待carry和loose
//    wire[25:0] freq;//二进制原码
//    wire[2:0] freq_carry;
//    wire freq_wrong;
    wire[31:0] freq_bcd;
    wire[18:0] period_bit;
    wire[2:0] period_loosed;
    waveinfo_time_calculator(//计算周期和频率，管理32个字符
       .clk_in(clk_in),
       .clk1Hz_in(clk1Hz_in),            
       .sync_trigger_in(sync_trigger_in),
       .sync_count_in(sync_count_in),
       .clk_state_in(clk_state_in),//时钟频率状态           
       .freq_bcd_out(freq_bcd),
       .period_bit_out(period_bit),
       .period_loosed_out(period_loosed)
//       .freq_out(freq),//26位二进制数
//       .freq_carry_out(freq_carry),//频谱后面带的零
//       .freq_wrong_out(freq_wrong)//频率出错
       );
       
       /////********************转换频率***************************/////
       bcd2code(
           .clk_in(clk_in),
      
           .negative_in(0),
           .bcd_in(freq_bcd),
           .carried_in(0),
           .carry_in(0),//最多带了7个0
           .loosed_in(0),
           .loose_in(0),//最多去了7个0
           
           .units_in(3'b100),//0:p，1:n, 2:u, 3:m, 4:无单位 5:k, 6:M，7:G
           .units_code_in({6'd7,6'd49}),//Hz////最多两位符号输入//如果增加，要改units_code,code_out
           
           .code_out(freq_code_out)//8个字符，小数点保留2位
       
           );

       
       
       
       /////********************转换周期***************************/////
       wire[31:0] period_bcd_out;
       reg[31:0] period_bcd;
       wire period_bcd_valid;
           bin2bcd(
              .clk_in(clk_in),
              .bin_in({7'b000_0000,period_bit}),//最高26位输入
              .bcd_out(period_bcd_out),//最高32位输出
              .valid_out(period_bcd_valid)
                 );
      always@(posedge period_bcd_valid)
         period_bcd <= period_bcd_out;
         
     bcd2code(
             .clk_in(clk_in),
        
             .negative_in(0),
             .bcd_in(period_bcd),
             .carried_in(0),
             .carry_in(0),//最多带了7个0
             .loosed_in(1),
             .loose_in(period_loosed),//最多去了7个0
             
             .units_in(3'b001),//0:p，1:n, 2:u, 3:m, 4:无单位 5:k, 6:M，7:G
             .units_code_in({6'd42,6'd62}),//s_////最多两位符号输入//如果增加，要改units_code,code_out
             
             .code_out(period_code_out)//8个字符，小数点保留2位
         
             );

endmodule
