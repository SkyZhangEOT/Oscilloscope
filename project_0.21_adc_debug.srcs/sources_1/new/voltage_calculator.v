`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/23 16:22:15
// Design Name: 
// Module Name: voltage_calculator
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


module voltage_calculator(
    input clk_in,
    input divclk_in,
    input clk1Hz_in,
    input sync_trigger_in,
    input [15:0] sync_count_in,
    input signed [11:0] signal_in,
    output reg[23:0] signal_vpp_out,//单位uV，带1个零
    output wire[23:0] signal_mean_out,//单位uV，带1个零
    output reg mean_carry_out,//带一个0
    output reg mean_neg_out,//平均值负号
    ////////////test//////////
    output wire[31:0] volt_sum_temp_out,
    output wire[31:0] volt_sum_data_out,
    output wire[31:0] volt_sum_data_abs_out
    );
    //////////////////码型转换/////////////////////
    wire [31:0] signal;//转换后的信号
    assign signal = signal_in[11]? {20'hfffff,signal_in} : {20'd0,signal_in};
    
    
    ///////////////////求和////////////////////////
    reg flag = 0;
    reg[31:0] volt_sum_temp = 0;
    assign volt_sum_temp_out = volt_sum_temp;
    reg[31:0] volt_sum_data = 0;
    assign volt_sum_data_out = volt_sum_data;
    
    always@(posedge sync_trigger_in)
        flag = ~flag;
    always@(posedge divclk_in)
        if(flag)
            volt_sum_temp <= volt_sum_temp + signal;
        else
            begin
                if(volt_sum_temp != 0)
                    begin
                        volt_sum_data <= volt_sum_temp;
                        volt_sum_temp <= 0;
                    end
                else
                    begin
                        volt_sum_data <= volt_sum_data;
                        volt_sum_temp <= volt_sum_temp;
                    end
            end
            
            
    ////////////求绝对值////////////////////////
    reg[31:0] volt_sum_data_abs;
    assign volt_sum_data_abs_out = volt_sum_data_abs;
    always@(volt_sum_data)
        if(volt_sum_data[31])
            volt_sum_data_abs = (~volt_sum_data) + 1;
        else
            volt_sum_data_abs = volt_sum_data;
    
    
    //////////////除法运算////////////////
    wire valid;
    wire[35:0] ans;
    wire carry_out;
    reg [35:0] signal_mean_abs;////////////待测
    divider(//除数为零时，结果全一
        .clk_in(clk_in),
        .dividend_in(volt_sum_data_abs), 
        .divisor_in({16'd0,sync_count_in}),
            
        .valid_out(valid),
        .ans10_out(ans),
        .carry10_out(carry_out)
            );
            
            
      ////////////结果赋值//////////////////
      always@(posedge clk1Hz_in)
          if(valid)
          begin
              signal_mean_abs <= ans;
              mean_carry_out <= carry_out;
              mean_neg_out <= volt_sum_data[31];//负号
          end
      assign signal_mean_out = signal_mean_abs[15:0] * 8'd244;
      
      
    ////////////////峰峰值计算/////////////////
    reg signed [11:0] voltage_max = 0;
    reg signed [11:0] voltage_min = 0;
    always@(posedge divclk_in)
        if(clk1Hz_in)
        begin
            if(signal_in > voltage_max)
                voltage_max <= signal_in;
            else
                voltage_max <= voltage_max;
            if(signal_in < voltage_min)
                voltage_min <= signal_in;
            else
                voltage_min <= voltage_min;
        end
        else
        begin
            voltage_max <= 12'h800;
            voltage_min <= 12'h7ff;
        end
    always@(negedge clk1Hz_in)
        signal_vpp_out <= (voltage_max + (~voltage_min) + 1) * 2442;
endmodule
