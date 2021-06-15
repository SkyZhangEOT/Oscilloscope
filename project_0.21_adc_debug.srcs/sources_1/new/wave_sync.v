`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/09 12:57:04
// Design Name: 
// Module Name: wave_sync
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


module wave_sync(
    input divclk_in,
//    input [11:0] sw_in,


    input signed [11:0] level_in,
    input signed [11:0] level_low_in,
    
    input signed [11:0] data_in,
    input signed [11:0] data_before0_in,
    input signed [11:0] data_save_in,
    
    output reg wave_wea_out,
    output wire[8:0] wave_addr_out,
    output reg signed [11:0] wave_data_out,//保存的是补码
    
    output reg signed [11:0] wave_data_cnt_out,
    output wire trigger_out,
    output wire[15:0] count_out//结果输出时需要加2//一个是count1非阻塞导致小1，一个是触发条件开始时已经走过了一个时钟，没有计入count,在waveinfo_calculator中计算
    ////////////test////////////
//    output wire[1:0] state_out
//    output reg signed [11:0] data,    
//    //output reg signed [11:0] data_before2,
//    output reg signed [11:0] data_before1,
//    output reg signed [11:0] data_before0
//    output [15:0] count,
//    output counting,
//    output [17:0] count_flag,
//    output [17:0] count_judge_trigger
    );
    
    wire signed [11:0] data;
    assign data = data_in;
//    reg signed [11:0] data_before2;
//    reg signed [11:0] data_before1;
    wire signed [11:0] data_before0;
    assign data_before0 = data_before0_in;
    wire signed [11:0] data_save;
    assign data_save = data_save_in;

        
//    ila_0 instance_ila_0(
//                             .clk(),
//                              .probe0(state),
//                              .probe1(daddr),
//                              .probe2(busy),
//                              .probe3(drdy),
//                              .probe4(do_drp),
//                              .probe5(di_drp),
//                              .probe6(den_reg),
//                              .probe7(dwe_reg)
//        //                      .probe8(sync_state)
//        //                      .probe9(lenth),
//        //                      .probe10(real_lenth)
//                                      );

    reg[15:0] count_data = 0;//计数
    assign count_out = count_data + 1;//count1延迟一个时钟周期，
    wire[17:0] count_judge;
    assign count_judge = (count_data == 0)? 18'h0ffff:{count_data,2'd0};//////////////这里还不够完善
    reg[15:0] count_high;
    reg[15:0] count_low;
    
    reg trigger = 0;
    assign trigger_out = trigger;
    reg[8:0] wave_addr = 0;
    assign wave_addr_out = wave_addr;
    
    reg signed [11:0] level;//判断触发以后的触发条件是否仍然满足(根据电平)
    
    wire signed [11:0] level_low;
    assign level_low = level_low_in;
        
    reg[1:0] state = 0;//触发状态，0，不可触发，检测上升 1，达到上升条件，检测下降，2，达到触发条件，电平为0，检测上升3，达到触发条件，电平为1，检测下降
//    assign state_out = state;
    always@(posedge divclk_in)
        case(state)
            2'd0: begin//0，不可触发，检测上升  初始状态
                      count_low <= 0;
                      count_high <= 0;
                      if((data >= level_in) && (level_in > data_before0))
                      begin
                          trigger <= 0;
                          level <= level_in;//保存电平
                          state <= 2'd1;
                          wave_addr <= wave_addr + 1;
                          wave_data_out <= data_save;
                          wave_data_cnt_out <= data_save;
                          wave_wea_out <= 1'b1;
                      end
                      else
                      begin
                          trigger <= 0;
                          state <= state;
                          wave_addr <= wave_addr + 1;
                          wave_data_out <= data_save;
                          wave_data_cnt_out <= data_save;
                          wave_wea_out <= 1'b1;
                      end
                  end
            2'd1: begin//1，达到上升条件，检测下降  初始状态
                      if((data <= level_low)&&(level_low < data_before0))
                      begin
                          if(level != level_in)
                              state <= 2'd0;
                          else
                              state <= 2'd2;
                          trigger <= 0;
                          wave_addr <= wave_addr + 1;
                          wave_data_out <= data_save;
                          wave_data_cnt_out <= data_save;
                          wave_wea_out <= 1'b1;       
                      end
                      else
                      begin              
                          if(level != level_in)
                              state <= 2'd0;    
                          else                 
                              state <= state;
                          trigger <= 0;        
                          wave_addr <= wave_addr + 1;
                          wave_data_out <= data_save;
                          wave_data_cnt_out <= data_save;     
                          wave_wea_out <= 1'b1;
                      end
                  end
            2'd2: begin//2，达到触发条件，电平为0，检测上升
                      if((data >= level_in) && (level_in > data_before0))
                      begin
                          if(level != level_in)
                              state <= 2'd0;
                          else if(count_low > count_judge)
                              state <= 2'd0;
                          else
                              state <= 2'd3;
                          trigger <= 1;
                          count_low <= 0;

                              wave_addr <= wave_addr + 1;
                              wave_data_out <= data_save;
                              wave_data_cnt_out <= data_save;
                              wave_wea_out <= 1'b1;

                      end
                      else//如果没有满足上升触发条件
                      begin
                          if(level != level_in)           
                              state <= 2'd0;              
                          else if(count_low > count_judge)
                              state <= 2'd0;              
                          else                            
                              state <= state;              
                          
                          trigger <= 0;
                          count_low <= count_low + 1;
                          if(wave_addr == 10'd511)       
                          begin                          
                              wave_addr <= wave_addr;
                              wave_data_out <= wave_data_out;
                              wave_data_cnt_out <= data_save;
                              wave_wea_out <= 1'b0;       
                          end                            
                          else                           
                          begin                          
                              wave_addr <= wave_addr + 1;
                              wave_data_out <= data_save;
                              wave_data_cnt_out <= data_save;
                              wave_wea_out <= 1'b1;       
                          end                            
                      end
                  end
            2'd3: begin//3，达到触发条件，电平为1，检测下降
                      if((data <= level_low)&&(level_low < data_before0))
                      begin                                              
                          if(level != level_in)           
                              state <= 2'd0;              
                          else if(count_high > count_judge)
                              state <= 2'd0;              
                          else                            
                              state <= 2'd2;              

                          trigger <= 0;
                          count_high <= 0;
                          if(wave_addr == 10'd511)
                          begin
                              wave_addr <= wave_addr;
                              wave_data_out <= wave_data_out;
                              wave_data_cnt_out <= data_save;
                              wave_wea_out <= 1'b0;
                          end
                          else
                          begin
                              wave_addr <= wave_addr + 1;
                              wave_data_out <= data_save;
                              wave_data_cnt_out <= data_save;
                              wave_wea_out <= 1'b1;
                          end
                      end                                                 
                      else                                               
                      begin
                          if(level != level_in)           
                              state <= 2'd0;              
                          else if(count_high > count_judge)
                              state <= 2'd0;              
                          else                            
                              state <= state;              

                          trigger <= 1;
                          count_high <= count_high + 1;
                          if(wave_addr == 10'd511)           
                          begin                              
                              wave_addr <= wave_addr;        
                              wave_data_out <= wave_data_out;
                              wave_data_cnt_out <= data_save;              
                              wave_wea_out <= 1'b0;                               
                          end                                
                          else                               
                          begin                              
                              wave_addr <= wave_addr + 1;    
                              wave_data_out <= data_save;
                              wave_data_cnt_out <= data_save;
                              wave_wea_out <= 1'b1;           
                          end                                
                      end
                  end
        endcase
    reg data_bit = 0;
    always@(posedge trigger)
        data_bit = ~data_bit;
    
    reg[15:0] count = 0;
    reg[15:0] count1 = 0;
    
    always@(negedge divclk_in)
        if(data_bit)
        begin
            count <= count + 1;
            count1 <= count;
        end
        else
        begin
            count <= 0;
            count1 <= count;
        end
    always@(negedge data_bit)
        count_data <= count1;

endmodule
