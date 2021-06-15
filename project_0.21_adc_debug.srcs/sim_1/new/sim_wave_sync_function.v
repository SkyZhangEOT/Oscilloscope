`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/21 12:20:16
// Design Name: 
// Module Name: sim_wave_sync_function
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


module sim_wave_sync_function(

    );
    reg clk_in = 0;
    always#10
        clk_in = ~clk_in;
    reg divclk_in = 0;
    always#20
        divclk_in = ~divclk_in;
    
    reg[11:0] sw_in = 12'b0000_0111_1111_1111;
    
    reg signed [11:0] level_in = 12'b0000_0000_0001_1111;
    reg[11:0] measured_temp_in = 0;
    reg [11:0] measured_vccint_in = 0;
    reg [11:0] measured_aux7_in = 0;
    reg [11:0] measured_aux14_in = 0;
    reg signed [7:0] test_square_in = 0;
    reg signed [7:0] test_tangle_in = 0;
    
    
    
    wire signed [7:0] test_sin_in;
    signal_generator uut_signal_generator(
        .clk_in(clk_in),
        .test_square_out(),
        .test_tangle_out(),
        .test_sin_out(test_sin_in)
        );
    
        
   
    reg wave_wea_out;
    wire[8:0] wave_addr_out;
    reg signed [11:0] wave_data_out;//保存的是补码
    wire[15:0] count_out;//结果输出时需要加2//一个是count1非阻塞导致小1，一个是触发条件开始时已经走过了一个时钟，没有计入count,在waveinfo_calculator中计算
    //    output reg signed [11:0] data,    
    //    //output reg signed [11:0] data_before2,
    //    output reg signed [11:0] data_before1,
    //    output reg signed [11:0] data_before0
    //    output [15:0] count,
    //    output counting,
    //    output [17:0] count_flag,
    //    output [17:0] count_judge_trigger




        reg signed [11:0] data = 0;
    //    reg signed [11:0] data_before2;
    //    reg signed [11:0] data_before1;
        reg signed [11:0] data_before0;
        always@(posedge divclk_in)
        begin
    //        data_before2 <= data_before1;
    //        data_before1 <= data_before0;
            data_before0 <= data;
            data <= {4'd0,test_sin_in};
        end
    
        reg[15:0] count_data = 0;//计数
        assign count_out = count_data;
        wire[17:0] count_judge;
        assign count_judge = (count_data == 0)? 18'h0ffff:{count_data,2'd0};//////////////这里还不够完善
        reg[15:0] count_high;
        reg[15:0] count_low;
        
        reg trigger = 0;
        reg[8:0] wave_addr = 0;
        assign wave_addr_out = wave_addr;
        
        reg signed [11:0] level;//判断触发以后的触发条件是否仍然满足(根据电平)
        
        reg signed [11:0] level_low;
        always@(negedge divclk_in)
            level_low = level_in - 6;
            
        reg[1:0] state = 0;//触发状态，0，不可触发，检测上升 1，达到上升条件，检测下降，2，达到触发条件，电平为0，检测上升3，达到触发条件，电平为1，检测下降
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
                              wave_data_out <= data;
                              wave_wea_out <= 1'b1;
                          end
                          else
                          begin
                              trigger <= 0;
                              state <= state;
                              wave_addr <= wave_addr + 1;
                              wave_data_out <= data;
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
                              wave_data_out <= data;     
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
                              wave_data_out <= data;     
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
                              if(wave_addr == 10'd511)
                              begin
                                  wave_addr <= wave_addr + 1;
                                  wave_data_out <= data;
                                  wave_wea_out <= 1'b1;
                              end
                              else
                              begin
                                  wave_addr <= wave_addr + 1;
                                  wave_data_out <= data;     
                                  wave_wea_out <= 1'b1;       
                              end
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
                                  wave_wea_out <= 1'b0;       
                              end                            
                              else                           
                              begin                          
                                  wave_addr <= wave_addr + 1;
                                  wave_data_out <= data;     
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
                                  wave_wea_out <= 1'b0;       
                              end                            
                              else                           
                              begin                          
                                  wave_addr <= wave_addr + 1;
                                  wave_data_out <= data;     
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
                                  wave_wea_out <= 1'b0;                               
                              end                                
                              else                               
                              begin                              
                                  wave_addr <= wave_addr + 1;    
                                  wave_data_out <= data;         
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
