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
    input DCLK,           //ʱ������ 50MHz
    input clk25M_in,
    input clk20M_in,
    input clk10M_in,
    input clk5M_in,
    input clk1M_in,
    input RESET,
    input VAUXP6,VAUXN6,  //ģ�⸨������ͨ��7��ͨ����17h
    input VAUXP7,VAUXN7,  //ģ�⸨������ͨ��8��ͨ����17h
    input VAUXP14,VAUXN14,//ģ�⸨������ͨ��12��ͨ����1ch
    input VAUXP15,VAUXN15,//ģ�⸨������ͨ��14��ͨ����1eh
//    output reg[15:0] MEASURED_TEMP,MEASURED_VCCINT,
//    output reg[15:0] MEASURED_VCCBRAM,
    output reg[15:0] MEASURED_AUX6,
    output reg[15:0] MEASURED_AUX7,
    output reg[15:0] MEASURED_AUX14,
    output reg[15:0] MEASURED_AUX15
//    output [7:0] state//������
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
    wire XADC_EOC;//δ�õ�
    wire XADC_EOS;//�õ�һ�Σ�����ת����� ״̬reg00ʱ�õ�
    wire busy;//����״̬���õ�
    wire[4:0] channel;//δ�õ�
    wire drdy;//�õ�
    reg[6:0] daddr;
    reg[15:0] di_drp;        //DRP��������
    wire[15:0] do_drp;       //DRP�������
    wire[15:0] aux_channel_p;//����ͨ�������//δ�õ�
    wire[15:0] aux_channel_n;//����ͨ�������//δ�õ�
    reg[1:0] den_reg;        //2λ����ʹ�ܼĴ�����λ0��IP den
    reg[1:0] dwe_reg;        //2λ����дʹ�ܼĴ�����λ0��IP
    reg[3:0] state = init_read;//��ʼ״̬Ϊ��״̬
    reg r_reset = 0;//δ�õ�
    
    reg drdy_state = 0;
    reg drdy_state1 = 0;
    always@(posedge drdy)
        drdy_state = ~drdy_state;
    xadc_wiz_1 xadc1(
                     .daddr_in(daddr),            // DRP��ַAddress bus for the dynamic reconfiguration port
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
                    //den_reg <= 2'h2;         //��ִ�ж�����
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
                        //dwe_reg <= 2'h2;         //��ִ��д����
                        dwe_reg <= 1'b0;
                        state <= write_waitdrdy;     //���ʣ������Ƿ���Ҫ��������ֵ
                      end
                    else begin
                        //den_reg = {1'b0,den_reg[1]};//ʹ����λ��ִ�ж�����
                        den_reg <= 1'b1;
                        //dwe_reg = {1'b0,dwe_reg[1]};
                        dwe_reg <= 1'b0;
                        state <= state;     //���ʣ������Ƿ���Ҫ��������ֵ
                      end
                      
                write_waitdrdy:
                    if((drdy == 1)&&(drdy_state != drdy_state1)) begin
                        drdy_state1 <= drdy_state;
                        state <= read_reg16;     //���ʣ������Ƿ���Ҫ��������ֵ
                      end
                    else begin
                        //den_reg <= {1'b0,den_reg[1]};        //ʹ��
                        den_reg <= 1'b1;
                        //dwe_reg <= {1'b0,dwe_reg[1]};        //д��һ����Ч��д��40h�Ĵ���
                        dwe_reg <= 1'b1;
                        state <= state;     //���ʣ������Ƿ���Ҫ��������ֵ
                      end
                      
//                read_reg00: begin
//                    daddr = 7'h00;
//                    den_reg = 2'h2;     //ʹ����Ч��ִ�ж�����
//                    if(XADC_EOS == 1)
//                        state <= reg00_waitdrdy;        //����ת����ɣ�������һ״̬
//                  end
                  
//                reg00_waitdrdy:             //����ת����ɣ���ȡ�Ĵ�������ò���ֵ
//                    if(drdy == 1) begin
//                        MEASURED_TEMP = do_drp;     //��DRP���ź��߻�ȡ�Ĵ���00��ֵ���¶�
//                        state <= read_reg01;        //������һ״̬���Ĵ���01H���ں˵�ѹ
//                      end
//                    else begin
//                        den_reg = {1'b0,den_reg[1]};        //ʹ��
//                        dwe_reg = {1'b0,dwe_reg[1]};
//                        state = state;
//                      end
                      
//                read_reg01: begin
//                    daddr = 7'h01;      //����Ŀ��Ĵ���Ϊ01H
//                    den_reg = 2'h2;     //���ܣ�ִ�ж�����
//                    state <= reg01_waitdrdy;
//                  end
                  
//                reg01_waitdrdy:
//                    if(drdy == 1) begin
//                        MEASURED_VCCINT = do_drp;       //��drp���ź��߻�ȡ�Ĵ���01��ֵ���ں˵�ѹ
//                        state <= read_reg06;
//                      end
//                    else begin
//                        den_reg = {1'b0,den_reg[1]};        //ʹ��
//                        dwe_reg = {1'b0,dwe_reg[1]};
//                        state = state;
//                      end
                
//                read_reg06: begin                            //*******************����Ϊ�Լ���д                                    
//                    daddr = 7'h06;      //����Ŀ��Ĵ���Ϊ01H                                                    
//                    den_reg = 2'h2;     //���ܣ�ִ�ж�����                                                   
//                    state <= reg06_waitdrdy;                                                             
//                  end                                                                                    
                                                                                                         
//                reg06_waitdrdy:                                                                  
//                    if(drdy == 1) begin                                                          
//                        MEASURED_VCCBRAM = do_drp;       //��drp���ź��߻�ȡ�Ĵ���01��ֵ���ں˵�ѹ                 
//                        state <= read_reg16;                                                     
//                      end                                                                        
//                    else begin                                                                   
//                        den_reg = {1'b0,den_reg[1]};        //ʹ��                                 
//                        dwe_reg = {1'b0,dwe_reg[1]};                                             
//                        state = state;                                                           
//                      end
                
                read_reg16: begin                            //******************��17              
                    daddr <= 7'h16;      //����Ŀ��Ĵ���Ϊ01H                                                   
                    //den_reg <= 2'h2;     //���ܣ�ִ�ж�����
                    den_reg <= 1'b0;                                                      
                    state <= reg16_waitdrdy;                                                            
                  end                                                                                   

                reg16_waitdrdy:                                                                         
                    if((drdy == 1)&&(drdy_state != drdy_state1)) begin                                                                 
                        drdy_state1 <= drdy_state;
                        MEASURED_AUX6 <= do_drp;       //��drp���ź��߻�ȡ�Ĵ���01��ֵ���ں˵�ѹ                       
                        state <= read_reg17;                                                            
                      end                                                                               
                    else begin                                                                          
                        //den_reg <= {1'b0,den_reg[1]};        //ʹ��
                        den_reg <= 1'b1;                                        
                        //dwe_reg <= {1'b0,dwe_reg[1]};
                        dwe_reg <= 1'b0;                                                          
                        state <= state;                                                                        
                      end                                                                                     
                
                read_reg17: begin                            //******************��18            
                    daddr <= 7'h17;      //����Ŀ��Ĵ���Ϊ01H                                           
                    //den_reg <= 2'h2;     //���ܣ�ִ�ж�����
                    den_reg <= 1'b0;                                              
                    state <= reg17_waitdrdy;                                                    
                  end                                                                           
                                                                                                
                reg17_waitdrdy:                                                                 
                    if((drdy == 1)&&(drdy_state != drdy_state1)) begin                                                         
                        drdy_state1 <= drdy_state;
                        MEASURED_AUX7 <= do_drp;       //��drp���ź��߻�ȡ�Ĵ���01��ֵ���ں˵�ѹ                  
                        state <= read_reg1e;                                                    
                      end                                                                       
                    else begin                                                                  
                        //den_reg <= {1'b0,den_reg[1]};        //ʹ��                                
                        den_reg <= 1'b1;
                        //dwe_reg <= {1'b0,dwe_reg[1]};                                            
                        dwe_reg <= 1'b0;
                        state <= state;                                                          
                      end
                      
                read_reg1e: begin                            //******************��1c            
                    daddr <= 7'h1e;      //����Ŀ��Ĵ���Ϊ01H                                           
                    //den_reg <= 2'h2;     //���ܣ�ִ�ж�����                                              
                    den_reg <= 1'b0;
                    state <= reg1e_waitdrdy;                                                    
                  end                                                                           
                                                                                                
                reg1e_waitdrdy:                                                                 
                    if((drdy == 1)&&(drdy_state != drdy_state1)) begin                                                         
                        drdy_state1 <= drdy_state;
                        MEASURED_AUX14 <= do_drp;       //��drp���ź��߻�ȡ�Ĵ���1c��ֵ���ں˵�ѹ                  
                        state <= read_reg1f;                                                    
                      end                                                                       
                    else begin                                                                  
                        //den_reg <= {1'b0,den_reg[1]};        //ʹ��                                
                        den_reg <= 1'b1;
                        //dwe_reg <= {1'b0,dwe_reg[1]};                                            
                        dwe_reg <= 1'b0;
                        state <= state;                                                          
                      end 
                      
                read_reg1f: begin                            //******************��1e            
                    daddr <= 7'h1f;      //����Ŀ��Ĵ���Ϊ01H                                            
                    //den_reg <= 2'h2;     //���ܣ�ִ�ж�����                                               
                    den_reg <= 1'b0;
                    state <= reg1f_waitdrdy;                                                     
                  end                                                                            
                                                                                                
                reg1f_waitdrdy:                                                                                                                                        
                    if((drdy == 1)&&(drdy_state != drdy_state1)) begin                                                          
                        drdy_state1 <= drdy_state;
                        MEASURED_AUX15 <= do_drp;       //��drp���ź��߻�ȡ�Ĵ���01��ֵ���ں˵�ѹ                                                                                          
                        state <= read_reg16;             //�ص�00״̬�ȴ���һ��ת��������������ȡ   
                        daddr <= 7'h00;                                                   
                      end                                                                        
                    else begin                                                                   
                        //den_reg = {1'b0,den_reg[1]};        //ʹ��                                 
                        den_reg <= 1'b1;
                        //dwe_reg = {1'b0,dwe_reg[1]};                                             
                        dwe_reg <= 1'b0;
                        state <= state;                                                                 
                      end
               /****************�����Ƿ���Ҫ��һ��default***********************/
               default: state <= init_read;
           endcase
           
endmodule
