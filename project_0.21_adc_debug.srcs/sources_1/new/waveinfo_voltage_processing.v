`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/24 20:07:40
// Design Name: 
// Module Name: waveinfo_voltage_processing
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


module waveinfo_voltage_processing(
    input clk_in,              
    input divclk_in,           
    input clk1Hz_in,
               
    input sync_trigger_in,     
    input [15:0] sync_count_in,
    input [11:0] signal_in,
    
    output wire[47:0] vpp_code_out, 
    output wire[47:0] mean_code_out
    );
    wire[23:0] signal_vpp_bit;
    wire[23:0] signal_mean_bit; 
    wire mean_neg;
    wire mean_carry;
    voltage_calculator(
        .clk_in(clk_in),
        .divclk_in(divclk_in),
        .clk1Hz_in(clk1Hz_in),
        .sync_trigger_in(sync_trigger_in),
        .sync_count_in(sync_count_in),
        .signal_in(signal_in),
        .signal_vpp_out(signal_vpp_bit),//单位uV，带1个零
        .signal_mean_out(signal_mean_bit),//单位uV，带1个零
        .mean_carry_out(mean_carry),//带一个0
        .mean_neg_out(mean_neg)//平均值负号
        ////////////test//////////
        );
    reg[31:0] vpp_bcd;
    wire[31:0] vpp_bcd_out;
    wire vpp_valid;
    bin2bcd(
            .clk_in(clk_in),
            .bin_in({2'd0,signal_vpp_bit}),//最高26位输入
            .bcd_out(vpp_bcd_out),//最高32位输出
            .valid_out(vpp_valid)
            );
   always@(posedge vpp_valid)
       vpp_bcd <= vpp_bcd_out;
   bcd2code(
          .clk_in(clk_in),
     
          .negative_in(0),
          .bcd_in(vpp_bcd),
          .carried_in(1),
          .carry_in(3'd1),//最多带了7个0
          .loosed_in(0),
          .loose_in(0),//最多去了7个0
          
          .units_in(3'b010),//0:p，1:n, 2:u, 3:m, 4:无单位 5:k, 6:M，7:G
          .units_code_in({6'd20,6'd62}),//V_////最多两位符号输入//如果增加，要改units_code,code_out
          
          .code_out(vpp_code_out)//8个字符，小数点保留2位
      
          );

       wire[31:0] mean_bcd_out;
       wire mean_valid;
        bin2bcd(
                .clk_in(clk_in),
                .bin_in({2'd0,signal_mean_bit}),//最高26位输入
                .bcd_out(mean_bcd_out),//最高32位输出
                .valid_out(mean_valid)
                );
                
       reg[31:0] mean_bcd;
      always@(posedge mean_valid)
          mean_bcd <= mean_bcd_out;
      
      bcd2code(
                    .clk_in(clk_in),
               
                    .negative_in(mean_neg),
                    .bcd_in(mean_bcd),
                    .carried_in(1),
                    .carry_in({2'b00,mean_carry}),//最多带了7个0
                    .loosed_in(0),
                    .loose_in(0),//最多去了7个0
                    
                    .units_in(3'b010),//0:p，1:n, 2:u, 3:m, 4:无单位 5:k, 6:M，7:G
                    .units_code_in({6'd20,6'd62}),//V_////最多两位符号输入//如果增加，要改units_code,code_out
                    
                    .code_out(mean_code_out)//8个字符，小数点保留2位
                
                    );
       
endmodule
