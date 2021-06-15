`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/10 00:17:45
// Design Name: 
// Module Name: wave_bit_choose
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


module wave_bit_choose(//12λ���ݣ�
    input [11:0] wave_data_in,
    input[7:0] wave_ori_pos_in,
    input key_pressed_in,
    input [15:0] keyval_in,
    output wire[3:0] bit_choose_out,
    output reg[7:0] wave_data_out = 0//���8λֱ�ӻ������ݣ�Ӧ�����ӳ�
    //////////����/////////
    );

    
    parameter neg_edge = 8'hfe,
               pos_edge = 8'hff;
    
    reg[3:0] state = 4'd12;//һ����16��״̬����Сʱȡ��λ��4λ�����ʱȡ���һλ���ݣ�
    assign bit_choose_out = state;
    always@(posedge key_pressed_in)
        casex(keyval_in)//���ݲ��뿪�ص�λ����npv��ֵ
            16'b0000_0000_0100_0000://��С
                if (state == 4'd15)
                    state <= state;
                else
                    state <= state + 1'b1;
            16'b0000_0000_0000_0100://�Ŵ�
                if (state == 4'd0)
                    state <= state;
                else
                    state <= state - 1'b1;
            default:                      
                state <= state;
        endcase
        ///////////////////////////////////
        
        
    reg[11:0] wave_data_abs;
    always@(*)//ȡ����ֵ
        if(wave_data_in[11])
            wave_data_abs = (~wave_data_in) + 1'b1;
        else
            wave_data_abs = wave_data_in;
           /////////////////////////////////// 
           
           
    always@(*)
        case(state)
            4'd0:
            begin
                if(|wave_data_abs[11:4])//���ֵ���ڵ�ǰ��λ�������ֵ���Ͳ�����
                    if(wave_data_in[11])//����Ǹ�ֵ
                        wave_data_out = neg_edge;//��wave_g�޷�����
                    else
                        wave_data_out = pos_edge;//��wave_g�޷�����
                else
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + {wave_data_abs[3:0],4'h0}) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + {wave_data_abs[3:0],4'h0};
                    else//�������ֵ
                        if(wave_ori_pos_in < {wave_data_abs[3:0],4'h0})//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - {wave_data_abs[3:0],4'h0};
            end
            4'd1:
            begin
                if(|wave_data_abs[11:5])//���ֵ���ڵ�ǰ��λ�������ֵ���Ͳ�����
                    if(wave_data_in[11])//����Ǹ�ֵ
                        wave_data_out = neg_edge;//��wave_g�޷�����
                    else
                        wave_data_out = pos_edge;//��wave_g�޷�����
                else
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + {wave_data_abs[4:0],3'b000}) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + {wave_data_abs[4:0],3'b000};
                    else//�������ֵ
                        if(wave_ori_pos_in < {wave_data_abs[4:0],3'b000})//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - {wave_data_abs[4:0],3'b000};
            end
            4'd2:
            begin
                if(|wave_data_abs[11:6])//���ֵ���ڵ�ǰ��λ�������ֵ���Ͳ�����
                    if(wave_data_in[11])//����Ǹ�ֵ
                        wave_data_out = neg_edge;//��wave_g�޷�����
                    else
                        wave_data_out = pos_edge;//��wave_g�޷�����
                else
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + {wave_data_abs[5:0],2'b00}) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + {wave_data_abs[5:0],2'b00};
                    else//�������ֵ
                        if(wave_ori_pos_in < {wave_data_abs[5:0],2'b00})//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - {wave_data_abs[5:0],2'b00};
            end
            4'd3:
            begin
                if(|wave_data_abs[11:7])//���ֵ���ڵ�ǰ��λ�������ֵ���Ͳ�����
                    if(wave_data_in[11])//����Ǹ�ֵ
                        wave_data_out = neg_edge;//��wave_g�޷�����
                    else
                        wave_data_out = pos_edge;//��wave_g�޷�����
                else
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + {wave_data_abs[6:0],1'b0}) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + {wave_data_abs[6:0],1'b0};
                    else//�������ֵ
                        if(wave_ori_pos_in < {wave_data_abs[6:0],1'b0})//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - {wave_data_abs[6:0],1'b0};
            end
            4'd4:
            begin
                if(|wave_data_abs[11:8])//���ֵ���ڵ�ǰ��λ�������ֵ���Ͳ�����
                    if(wave_data_in[11])//����Ǹ�ֵ
                        wave_data_out = neg_edge;//��wave_g�޷�����
                    else
                        wave_data_out = pos_edge;//��wave_g�޷�����
                else
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + wave_data_abs[7:0]) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + wave_data_abs[7:0];
                    else//�������ֵ
                        if(wave_ori_pos_in < wave_data_abs[7:0])//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - wave_data_abs[7:0];
            end
            4'd5:
            begin
                if(|wave_data_abs[11:9])//���ֵ���ڵ�ǰ��λ�������ֵ���Ͳ�����
                    if(wave_data_in[11])//����Ǹ�ֵ
                        wave_data_out = neg_edge;//��wave_g�޷�����
                    else
                        wave_data_out = pos_edge;//��wave_g�޷�����
                else
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + wave_data_abs[8:1]) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + wave_data_abs[8:1];
                    else//�������ֵ
                        if(wave_ori_pos_in < wave_data_abs[8:1])//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - wave_data_abs[8:1];
            end
            4'd6:
            begin
                if(|wave_data_abs[11:10])//���ֵ���ڵ�ǰ��λ�������ֵ���Ͳ�����
                    if(wave_data_in[11])//����Ǹ�ֵ
                        wave_data_out = neg_edge;//��wave_g�޷�����
                    else
                        wave_data_out = pos_edge;//��wave_g�޷�����
                else
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + wave_data_abs[9:2]) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + wave_data_abs[9:2];
                    else//�������ֵ
                        if(wave_ori_pos_in < wave_data_abs[9:2])//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - wave_data_abs[9:2];
            end
            4'd7:
            begin
                if(wave_data_abs[11])//���ֵ���ڵ�ǰ��λ�������ֵ���Ͳ�����
                    if(wave_data_in[11])//����Ǹ�ֵ
                        wave_data_out = neg_edge;//��wave_g�޷�����
                    else
                        wave_data_out = pos_edge;//��wave_g�޷�����
                else
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + wave_data_abs[10:3]) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + wave_data_abs[10:3];
                    else//�������ֵ
                        if(wave_ori_pos_in < wave_data_abs[10:3])//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - wave_data_abs[10:3];
            end
            4'd8:
            begin
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + wave_data_abs[11:4]) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + wave_data_abs[11:4];
                    else//�������ֵ
                        if(wave_ori_pos_in < wave_data_abs[11:4])//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - wave_data_abs[11:4];
            end
            4'd9:
            begin 
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + {1'b0,wave_data_abs[11:5]}) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + {1'b0,wave_data_abs[11:5]};
                    else//�������ֵ
                        if(wave_ori_pos_in < {1'b0,wave_data_abs[11:5]})//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - {1'b0,wave_data_abs[11:5]};
            end
            4'd10:
            begin
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + {2'b00,wave_data_abs[11:6]}) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + {2'b00,wave_data_abs[11:6]};
                    else//�������ֵ
                        if(wave_ori_pos_in < {2'b00,wave_data_abs[11:6]})//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - {2'b00,wave_data_abs[11:6]};
            end
            4'd11:
            begin
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + {3'b000,wave_data_abs[11:7]}) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + {3'b000,wave_data_abs[11:7]};
                    else//�������ֵ
                        if(wave_ori_pos_in < {3'b000,wave_data_abs[11:7]})//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - {3'b000,wave_data_abs[11:7]};
            end
            4'd12:
            begin
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + {4'h0,wave_data_abs[11:8]}) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + {4'h0,wave_data_abs[11:8]};
                    else//�������ֵ
                        if(wave_ori_pos_in < {4'h0,wave_data_abs[11:8]})//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - {4'h0,wave_data_abs[11:8]};
            end
            4'd13:
            begin
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + {5'd0,wave_data_abs[11:9]}) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + {5'd0,wave_data_abs[11:9]};
                    else//�������ֵ
                        if(wave_ori_pos_in < {5'd0,wave_data_abs[11:9]})//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - {5'd0,wave_data_abs[11:9]};
            end
            4'd14:
            begin
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + {6'd0,wave_data_abs[11:10]}) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + {6'd0,wave_data_abs[11:10]};
                    else//�������ֵ
                        if(wave_ori_pos_in < {6'd0,wave_data_abs[11:10]})//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - {6'd0,wave_data_abs[11:10]};
            end
            4'd15:
            begin
                    if(wave_data_in[11])//����Ǹ�ֵ
                        if((wave_ori_pos_in + {7'd0,wave_data_abs[11]}) >= 200)//���������Ļ�½�
                            wave_data_out = neg_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in + {7'd0,wave_data_abs[11]};
                    else//�������ֵ
                        if(wave_ori_pos_in < {7'd0,wave_data_abs[11]})//���������Ļ�Ͻ�
                            wave_data_out = pos_edge;//��wave_g�޷�����
                        else//�������ԭ��λ�ü���
                            wave_data_out = wave_ori_pos_in - {7'd0,wave_data_abs[11]};
            end
        endcase
    
  endmodule
