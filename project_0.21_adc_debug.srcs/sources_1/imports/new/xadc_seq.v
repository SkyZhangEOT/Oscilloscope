`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/03/06 21:09:21
// Finish Date: 2019/03/06 23:40
// Design Name: 
// Module Name: xadc_seq
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


module xadc_seq(
    input DCLK,           //时钟输入 50MHz
    input clk25M_in,
    input clk20M_in,
    input clk10M_in,
    input clk5M_in,
    input clk1M_in,
    input RESET,
    input VAUXP6,VAUXN6,  //模拟辅助输入通道7，通道号17h
    input VAUXP7,VAUXN7,  //模拟辅助输入通道8，通道号17h
    input VAUXP14,VAUXN14,//模拟辅助输入通道12，通道号1ch
    input VAUXP15,VAUXN15,//模拟辅助输入通道14，通道号1eh
//    output reg[15:0] MEASURED_TEMP,MEASURED_VCCINT,
//    output reg[15:0] MEASURED_VCCBRAM,
    output reg[15:0] MEASURED_AUX6,
    output reg[15:0] MEASURED_AUX7,
    output reg[15:0] MEASURED_AUX14,
    output reg[15:0] MEASURED_AUX15
//    output [7:0] state//调试用
//    output [7:0] state
    );
    parameter init_read = 4'h0,
               read_waitdrdy = 4'h1,
               write_waitdrdy = 4'h2,
//               read_reg00 = 8'h04,//TEMPERATURE
//               reg00_waitdrdy = 8'h05,//
//               read_reg01 = 8'h06,//VCCINT
//               reg01_waitdrdy = 8'h07,
//               read_reg06 = 8'h08,//BRAM
//               reg06_waitdrdy = 8'h09,
               read_reg16 = 4'h3,//CHANNEL VAUX7
               reg16_waitdrdy = 4'h4,
               read_reg17 = 4'h5,
               reg17_waitdrdy = 4'h6,
               read_reg1e = 4'h7,
               reg1e_waitdrdy = 4'h8,
               read_reg1f = 4'h9,//CHANNEL VAUX14
               reg1f_waitdrdy = 4'ha;   

//    wire[4:0] CHANNEL;
//    wire OT;
    wire XADC_EOC;//未用到
    wire XADC_EOS;//用到一次，序列转换完成 状态reg00时用到
    wire busy;//初试状态中用到
    wire[4:0] channel;//未用到
    wire drdy;//用到
    reg[6:0] daddr;
    reg[15:0] di_drp;        //DRP总线输入
    wire[15:0] do_drp;       //DRP总线输出
    wire[15:0] aux_channel_p;//辅助通道输入高//未用到
    wire[15:0] aux_channel_n;//辅助通道输入低//未用到
    reg[1:0] den_reg;        //2位数据使能寄存器，位0送IP den
    reg[1:0] dwe_reg;        //2位数据写使能寄存器，位0送IP
    reg[3:0] state = init_read;//初始状态为读状态
    reg r_reset = 0;//未用到
    
    reg drdy_state = 0;
    reg drdy_state1 = 0;
    always@(posedge drdy)
        drdy_state = ~drdy_state;
    xadc_wiz_1 xadc1(
                     .daddr_in(daddr),            // DRP地址Address bus for the dynamic reconfiguration port
                     .dclk_in(DCLK),             // Clock input for the dynamic reconfiguration port
                     .den_in(den_reg[0]),              // Enable Signal for the dynamic reconfiguration port
                     .di_in(di_drp),               // Input data bus for the dynamic reconfiguration port
                     .dwe_in(dwe_reg[0]),              // Write Enable for the dynamic reconfiguration port
                     .reset_in(RESET),            // Reset signal for the System Monitor control logic
                     .vauxp7(VAUXP7),              // Auxiliary channel 7
                     .vauxn7(VAUXN7),
                     .vauxp6(VAUXP6),              // Auxiliary channel 8
                     .vauxn6(VAUXN6),
                     .vauxp15(VAUXP15),             // Auxiliary channel 12
                     .vauxn15(VAUXN15),
                     .vauxp14(VAUXP14),             // Auxiliary channel 14
                     .vauxn14(VAUXN14),
                     .busy_out(busy),            // ADC Busy signal
                     .channel_out(channel),         // Channel Selection Outputs
                     .do_out(do_drp),              // Output data bus for dynamic reconfiguration port
                     .drdy_out(drdy),            // Data ready signal for the dynamic reconfiguration port
                     .eoc_out(XADC_EOC),             // End of Conversion Signal
                     .eos_out(XADC_EOS),             // End of Sequence Signal
                     .ot_out(),              // Over-Temperature alarm output
                     .vccaux_alarm_out(),    // VCCAUX-sensor alarm output
                     .vccint_alarm_out(),    //  VCCINT-sensor alarm output
                     .user_temp_alarm_out(), // Temperature-sensor alarm output
                     .vbram_alarm_out(),
                     .alarm_out(),           // OR'ed output of all the Alarms    
                     .vp_in(0),               // Dedicated Analog Input Pair
                     .vn_in(0)
                     );

    always@(posedge DCLK)
        if(RESET) begin
            state = init_read;
            den_reg = 0;
            dwe_reg = 0;
            di_drp = 16'h0000;
          end
        else
            case(state)
                init_read: begin
                    daddr <= 7'h40;
                    //den_reg <= 2'h2;         //将执行读操作
                    den_reg <= 1'b0;
                    if(busy == 0)
                        state <= read_waitdrdy;
                  end
                  
                read_waitdrdy:
                    if((drdy == 1)&&(drdy_state != drdy_state1)) begin
                        drdy_state1 <= drdy_state;
                        di_drp <= do_drp & 16'h03_FF;
//                        di_drp <= do_drp;
                        daddr <= 7'h40;
                        //den_reg <= 2'h2;
                        den_reg <= 1'b0;
                        //dwe_reg <= 2'h2;         //将执行写操作
                        dwe_reg <= 1'b0;
                        state <= write_waitdrdy;     //疑问：这里是否需要非阻塞赋值
                      end
                    else begin
                        //den_reg = {1'b0,den_reg[1]};//使能置位，执行读操作
                        den_reg <= 1'b1;
                        //dwe_reg = {1'b0,dwe_reg[1]};
                        dwe_reg <= 1'b0;
                        state <= state;     //疑问：这里是否需要非阻塞赋值
                      end
                      
                write_waitdrdy:
                    if((drdy == 1)&&(drdy_state != drdy_state1)) begin
                        drdy_state1 <= drdy_state;
                        state <= read_reg16;     //疑问：这里是否需要非阻塞赋值
                      end
                    else begin
                        //den_reg <= {1'b0,den_reg[1]};        //使能
                        den_reg <= 1'b1;
                        //dwe_reg <= {1'b0,dwe_reg[1]};        //写第一次有效，写入40h寄存器
                        dwe_reg <= 1'b1;
                        state <= state;     //疑问：这里是否需要非阻塞赋值
                      end
                      
//                read_reg00: begin
//                    daddr = 7'h00;
//                    den_reg = 2'h2;     //使能无效，执行读操作
//                    if(XADC_EOS == 1)
//                        state <= reg00_waitdrdy;        //序列转换完成，进入下一状态
//                  end
                  
//                reg00_waitdrdy:             //序列转换完成，读取寄存器，获得测量值
//                    if(drdy == 1) begin
//                        MEASURED_TEMP = do_drp;     //从DRP读信号线获取寄存器00的值，温度
//                        state <= read_reg01;        //进入下一状态读寄存器01H的内核电压
//                      end
//                    else begin
//                        den_reg = {1'b0,den_reg[1]};        //使能
//                        dwe_reg = {1'b0,dwe_reg[1]};
//                        state = state;
//                      end
                      
//                read_reg01: begin
//                    daddr = 7'h01;      //设置目标寄存器为01H
//                    den_reg = 2'h2;     //除能，执行读操作
//                    state <= reg01_waitdrdy;
//                  end
                  
//                reg01_waitdrdy:
//                    if(drdy == 1) begin
//                        MEASURED_VCCINT = do_drp;       //从drp读信号线获取寄存器01的值，内核电压
//                        state <= read_reg06;
//                      end
//                    else begin
//                        den_reg = {1'b0,den_reg[1]};        //使能
//                        dwe_reg = {1'b0,dwe_reg[1]};
//                        state = state;
//                      end
                
//                read_reg06: begin                            //*******************这里为自己填写                                    
//                    daddr = 7'h06;      //设置目标寄存器为01H                                                    
//                    den_reg = 2'h2;     //除能，执行读操作                                                   
//                    state <= reg06_waitdrdy;                                                             
//                  end                                                                                    
                                                                                                         
//                reg06_waitdrdy:                                                                  
//                    if(drdy == 1) begin                                                          
//                        MEASURED_VCCBRAM = do_drp;       //从drp读信号线获取寄存器01的值，内核电压                 
//                        state <= read_reg16;                                                     
//                      end                                                                        
//                    else begin                                                                   
//                        den_reg = {1'b0,den_reg[1]};        //使能                                 
//                        dwe_reg = {1'b0,dwe_reg[1]};                                             
//                        state = state;                                                           
//                      end
                
                read_reg16: begin                            //******************读17              
                    daddr <= 7'h16;      //设置目标寄存器为01H                                                   
                    //den_reg <= 2'h2;     //除能，执行读操作
                    den_reg <= 1'b0;                                                      
                    state <= reg16_waitdrdy;                                                            
                  end                                                                                   

                reg16_waitdrdy:                                                                         
                    if((drdy == 1)&&(drdy_state != drdy_state1)) begin                                                                 
                        drdy_state1 <= drdy_state;
                        MEASURED_AUX6 <= do_drp;       //从drp读信号线获取寄存器01的值，内核电压                       
                        state <= read_reg17;                                                            
                      end                                                                               
                    else begin                                                                          
                        //den_reg <= {1'b0,den_reg[1]};        //使能
                        den_reg <= 1'b1;                                        
                        //dwe_reg <= {1'b0,dwe_reg[1]};
                        dwe_reg <= 1'b0;                                                          
                        state <= state;                                                                        
                      end                                                                                     
                
                read_reg17: begin                            //******************读18            
                    daddr <= 7'h17;      //设置目标寄存器为01H                                           
                    //den_reg <= 2'h2;     //除能，执行读操作
                    den_reg <= 1'b0;                                              
                    state <= reg17_waitdrdy;                                                    
                  end                                                                           
                                                                                                
                reg17_waitdrdy:                                                                 
                    if((drdy == 1)&&(drdy_state != drdy_state1)) begin                                                         
                        drdy_state1 <= drdy_state;
                        MEASURED_AUX7 <= do_drp;       //从drp读信号线获取寄存器01的值，内核电压                  
                        state <= read_reg1e;                                                    
                      end                                                                       
                    else begin                                                                  
                        //den_reg <= {1'b0,den_reg[1]};        //使能                                
                        den_reg <= 1'b1;
                        //dwe_reg <= {1'b0,dwe_reg[1]};                                            
                        dwe_reg <= 1'b0;
                        state <= state;                                                          
                      end
                      
                read_reg1e: begin                            //******************读1c            
                    daddr <= 7'h1e;      //设置目标寄存器为01H                                           
                    //den_reg <= 2'h2;     //除能，执行读操作                                              
                    den_reg <= 1'b0;
                    state <= reg1e_waitdrdy;                                                    
                  end                                                                           
                                                                                                
                reg1e_waitdrdy:                                                                 
                    if((drdy == 1)&&(drdy_state != drdy_state1)) begin                                                         
                        drdy_state1 <= drdy_state;
                        MEASURED_AUX14 <= do_drp;       //从drp读信号线获取寄存器1c的值，内核电压                  
                        state <= read_reg1f;                                                    
                      end                                                                       
                    else begin                                                                  
                        //den_reg <= {1'b0,den_reg[1]};        //使能                                
                        den_reg <= 1'b1;
                        //dwe_reg <= {1'b0,dwe_reg[1]};                                            
                        dwe_reg <= 1'b0;
                        state <= state;                                                          
                      end 
                      
                read_reg1f: begin                            //******************读1e            
                    daddr <= 7'h1f;      //设置目标寄存器为01H                                            
                    //den_reg <= 2'h2;     //除能，执行读操作                                               
                    den_reg <= 1'b0;
                    state <= reg1f_waitdrdy;                                                     
                  end                                                                            
                                                                                                
                reg1f_waitdrdy:                                                                                                                                        
                    if((drdy == 1)&&(drdy_state != drdy_state1)) begin                                                          
                        drdy_state1 <= drdy_state;
                        MEASURED_AUX15 <= do_drp;       //从drp读信号线获取寄存器01的值，内核电压                                                                                          
                        state <= read_reg16;             //回到00状态等待下一次转换结束，继续读取   
                        daddr <= 7'h00;                                                   
                      end                                                                        
                    else begin                                                                   
                        //den_reg = {1'b0,den_reg[1]};        //使能                                 
                        den_reg <= 1'b1;
                        //dwe_reg = {1'b0,dwe_reg[1]};                                             
                        dwe_reg <= 1'b0;
                        state <= state;                                                                 
                      end
               /****************这里是否需要加一步default***********************/
               default: state <= init_read;
           endcase
           
endmodule
