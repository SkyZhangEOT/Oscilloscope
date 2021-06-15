`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/30 16:51:04
// Design Name: 
// Module Name: wave_sync_trans
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


module wave_sync_trans(
    input clk_in,
    input divclk_in,//div_clk输入
    input en_in,//状态 0：关闭功能，清空数据  1：打开功能
    input freq_trigger_in,//频率触发信号
    input signed [11:0] trigger_level_in,
    input signed [11:0] data_in,
    input signed [11:0] data_save_in,
    output reg wave_wea_out,
    output reg[8:0] wave_addr_out,
    output reg signed [11:0] data_out
    );
    
    wire[11:0] data_abs;
    assign data_abs = data_in[11]? ~data_in + 1: data_in;
    wire[11:0] trigger_level_abs;
    assign trigger_level_abs = trigger_level_in[11]? ~trigger_level_in + 1: trigger_level_in;
    reg clear = 0;
    reg[9:0] clear_cnt = 0;
    always@(posedge divclk_in)
        if(~en_in)
            clear <= 1'b1;
        else if(clear_cnt == 10'd1023)
            clear <= 1'b0;
        else
            clear <= clear;
            
    reg state = 0; //0:等待触发 1:满足条件,保存数据
    always@(negedge divclk_in)
        if(clear)
            begin
                wave_wea_out <= 1'b1;
                wave_addr_out <= wave_addr_out + 1'b1;
                data_out <= 12'd0;
                clear_cnt <= clear_cnt + 1'b1;
                state <= 2'd0;
            end
        else
            begin
                clear_cnt <= 10'd0;
                case(state)
                    1'b0: begin
                              if(data_abs >= trigger_level_abs)
                                  begin
                                      state <= 1'b1;
                                      wave_wea_out <= 1'b1;
                                      wave_addr_out <= 9'd0;
                                      data_out <= data_save_in;
                                  end
                              else if(freq_trigger_in)
                                  begin
                                      state <= 1'b1;
                                      wave_wea_out <= 1'b1;
                                      wave_addr_out <= 9'd0;
                                      data_out <= data_save_in;
                                  end
                              else
                                  begin
                                      state <= state;
                                      wave_wea_out <= 1'b1;               
                                      wave_addr_out <= wave_addr_out + 1'b1;
                                      data_out <= data_save_in;
                                  end
                          end
                    1'd1: begin
                              if(wave_addr_out == 9'd511)
                                  begin
                                      state <= state;
                                      wave_wea_out <= 1'b0;
                                      wave_addr_out <= wave_addr_out;
                                      data_out <= 12'd0;
                                  end
                              else
                                  begin
                                      state <= state;
                                      wave_wea_out <= 1'b1;               
                                      wave_addr_out <= wave_addr_out + 1'b1;
                                      data_out <= data_save_in;
                                  end
                          end
                endcase
            end

endmodule
