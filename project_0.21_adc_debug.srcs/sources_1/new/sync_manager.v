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
    input [2:0] h_state0_in,//ͨ������
    input [1:0] h_state2_in,//��λ��4��ѡ�� ������ʽ���� 0:��ͳ������1:��ͳ�½��� 2:˲̬�� 3:���˲̬
    input [2:0] h_state3_in,//��ƽλ�ÿ���
    
    input signed [11:0] level_in,
    input freq_trigger_in,//Ƶ�ʴ���
    
    input [11:0] measured_aux14_in,
    input [11:0] measured_aux7_in,
    input [11:0] measured_aux6_in,
    input [11:0] measured_aux15_in,
    input signed [7:0] test_square_in,
    input signed [7:0] test_tangle_in,
    input signed [7:0] test_sin_in,
    
    output reg wave_wea_out,
    output reg[8:0] wave_addr_out,
    output reg signed [11:0] wave_data_out,//������ǲ���
    
    output wire signed [11:0] wave_data_cnt_out,
    output wire trigger_out,
    output wire[15:0] count_out//������ʱ��Ҫ��2//һ����count1����������С1��һ���Ǵ���������ʼʱ�Ѿ��߹���һ��ʱ�ӣ�û�м���count,��waveinfo_calculator�м���
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
        casex(h_state0_in)//���ݲ��뿪�ص�λ����npv��ֵ
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
        .h_state3_in(h_state3_in),//0��1�У�2��
        .data_in(data_temp),
        .data_out(data_now_temp),
        .data_before_out(data_before_temp),
        .data_save_out(data_save)
        );
    
    wire trans_wave_wea;
    wire[8:0] trans_wave_addr;
    wire[11:0] trans_wave_data;
    
    reg trans_en;
    //˲̬����ģ��
    wave_sync_trans(
        .clk_in(clk_in),//div_clk����
        .divclk_in(divclk_in),
        .en_in(trans_en),//״̬ 0���رչ��ܣ��������  1���򿪹���
        .freq_trigger_in(freq_trigger_in),//Ƶ�ʴ����ź�
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
        .wave_data_out(cla_wave_data),//������ǲ���
        
        .wave_data_cnt_out(wave_data_cnt_out),
        .trigger_out(trigger_out),
        .count_out(count_out)//������ʱ��Ҫ��2//һ����count1����������С1��һ���Ǵ���������ʼʱ�Ѿ��߹���һ��ʱ�ӣ�û�м���count,��waveinfo_calculator�м���

        );
    
    always@(*)
         case(h_state2_in)
              2'd0:begin//������
                       level_LH <= level_low;
                       
                       data_now <= data_now_temp;
                       data_before <= data_before_temp;
                       
                       wave_wea_out <= cla_wave_wea;
                       wave_addr_out <= cla_wave_addr;
                       wave_data_out <= cla_wave_data;
                       
                       trans_en <= 0;
                   end
              2'd1:begin//�½���
                       level_LH <= level_high;//�������·����½���
                       
                       data_now <= data_before_temp;      
                       data_before <= data_now_temp;
                       
                       wave_wea_out <= cla_wave_wea;
                       wave_addr_out <= cla_wave_addr;
                       wave_data_out <= cla_wave_data;
                       
                       trans_en <= 0;
                   end
              2'd2:begin//˲̬
                       level_LH <= level_low;
                       
                       data_now <= data_now_temp;      
                       data_before <= data_before_temp;
                       
                       trans_en <= 1;
                       
                       wave_wea_out <= trans_wave_wea;
                       wave_addr_out <= trans_wave_addr;
                       wave_data_out <= trans_wave_data;
                       
                   end
              2'd3:begin//���       
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
