`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/30 20:55:48
// Design Name: 
// Module Name: sync_manager
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


module sync_manager(
    input clk_in,
    input divclk_in,
    //    input [11:0] sw_in,
    input [2:0] h_state0_in,//通道控制
    input [1:0] h_state2_in,//两位，4个选项 触发方式控制 0:传统上升，1:传统下降， 2:瞬态， 3:清空瞬态
    input [2:0] h_state3_in,//电平位置控制
    
    input signed [11:0] level_in,
    input freq_trigger_in,//频率触发
    
    input [11:0] measured_aux14_in,
    input [11:0] measured_aux7_in,
    input [11:0] measured_aux6_in,
    input [11:0] measured_aux15_in,
    input signed [7:0] test_square_in,
    input signed [7:0] test_tangle_in,
    input signed [7:0] test_sin_in,
    
    output reg wave_wea_out,
    output reg[8:0] wave_addr_out,
    output reg signed [11:0] wave_data_out,//保存的是补码
    
    output wire signed [11:0] wave_data_cnt_out,
    output wire trigger_out,
    output wire[15:0] count_out//结果输出时需要加2//一个是count1非阻塞导致小1，一个是触发条件开始时已经走过了一个时钟，没有计入count,在waveinfo_calculator中计算
    );
    
    reg signed [11:0] level_low;
    reg signed [11:0] level_high;
    
    reg signed [11:0] level_LH;
    always@(level_in)
        begin
        level_low = level_in - 12'd6;
        level_high = level_in + 12'd6;
        end
   
    reg signed [11:0] data_temp = 0;
    always@(posedge clk_in)
    begin
//        data_before2 <= data_before1;
//        data_before1 <= data_before0;
//        data_before0 <= data;
        casex(h_state0_in)//根据拨码开关的位置向npv赋值
            3'd0:
                data_temp <= measured_aux14_in;
            3'd1:
                data_temp <= measured_aux7_in - 12'h800;
            3'd2:                           
                data_temp <= measured_aux6_in - 12'h800; 
            3'd3:                      
                data_temp <= measured_aux15_in - 12'h800;
            3'd4:
                data_temp <= {4'd0,test_square_in};
            3'd5:
                data_temp <= {4'd0,test_tangle_in};
            3'd6:
                data_temp <= {4'd0,test_sin_in};
            3'd7:
                data_temp <= {4'd0,test_sin_in - 31};
            default:                      
                data_temp <= 0;
        endcase
    end
    
    wire signed [11:0] data_now_temp;
    wire signed [11:0] data_before_temp;
    reg signed [11:0] data_now;
    reg signed [11:0] data_before;
    wire signed [11:0] data_save;
    data_delay(
        .clk_in(divclk_in),
        .h_state3_in(h_state3_in),//0左，1中，2右
        .data_in(data_temp),
        .data_out(data_now_temp),
        .data_before_out(data_before_temp),
        .data_save_out(data_save)
        );
    
    wire trans_wave_wea;
    wire[8:0] trans_wave_addr;
    wire[11:0] trans_wave_data;
    
    reg trans_en;
    //瞬态触发模块
    wave_sync_trans(
        .clk_in(clk_in),//div_clk输入
        .divclk_in(divclk_in),
        .en_in(trans_en),//状态 0：关闭功能，清空数据  1：打开功能
        .freq_trigger_in(freq_trigger_in),//频率触发信号
        .trigger_level_in(level_in),
        .data_in(data_now),
        .data_save_in(data_save),
        .wave_wea_out(trans_wave_wea),
        .wave_addr_out(trans_wave_addr),
        .data_out(trans_wave_data)
    );
    
    wire cla_wave_wea;
    wire[8:0] cla_wave_addr;
    wire[11:0] cla_wave_data;
    wave_sync(
        .divclk_in(divclk_in),
    //    input [11:0] sw_in,
        .level_in(level_in),
        .level_low_in(level_LH),
        
        .data_in(data_now),
        .data_before0_in(data_before),
        .data_save_in(data_save),
        
        .wave_wea_out(cla_wave_wea),
        .wave_addr_out(cla_wave_addr),
        .wave_data_out(cla_wave_data),//保存的是补码
        
        .wave_data_cnt_out(wave_data_cnt_out),
        .trigger_out(trigger_out),
        .count_out(count_out)//结果输出时需要加2//一个是count1非阻塞导致小1，一个是触发条件开始时已经走过了一个时钟，没有计入count,在waveinfo_calculator中计算

        );
    
    always@(*)
         case(h_state2_in)
              2'd0:begin//上升沿
                       level_LH <= level_low;
                       
                       data_now <= data_now_temp;
                       data_before <= data_before_temp;
                       
                       wave_wea_out <= cla_wave_wea;
                       wave_addr_out <= cla_wave_addr;
                       wave_data_out <= cla_wave_data;
                       
                       trans_en <= 0;
                   end
              2'd1:begin//下降沿
                       level_LH <= level_high;//这里上下反向，下降沿
                       
                       data_now <= data_before_temp;      
                       data_before <= data_now_temp;
                       
                       wave_wea_out <= cla_wave_wea;
                       wave_addr_out <= cla_wave_addr;
                       wave_data_out <= cla_wave_data;
                       
                       trans_en <= 0;
                   end
              2'd2:begin//瞬态
                       level_LH <= level_low;
                       
                       data_now <= data_now_temp;      
                       data_before <= data_before_temp;
                       
                       trans_en <= 1;
                       
                       wave_wea_out <= trans_wave_wea;
                       wave_addr_out <= trans_wave_addr;
                       wave_data_out <= trans_wave_data;
                       
                   end
              2'd3:begin//清空       
                       level_LH <= level_low;
                       
                       data_now <= data_now_temp;      
                       data_before <= data_before_temp;
                       
                       wave_wea_out <= trans_wave_wea;  
                       wave_addr_out <= trans_wave_addr;
                       wave_data_out <= trans_wave_data;
                       
                       trans_en <= 0;
                   end
              endcase
endmodule
