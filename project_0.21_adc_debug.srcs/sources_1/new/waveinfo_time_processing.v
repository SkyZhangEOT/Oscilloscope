`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/19 13:47:40
// Design Name: 
// Module Name: waveinfo_time_processing
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


module waveinfo_time_processing(//����ʱ�Ӻͼ��������㣬ת����BCD�룬ת�����ַ���Ϣ�������6λcode�͵�λ
    input clk_in,
    input clk1Hz_in,      
    input sync_trigger_in,
    input [15:0]sync_count_in,
    input [3:0] clk_state_in,//ʱ��Ƶ��״̬
    output wire[47:0] freq_code_out,//Ƶ�ʵ�code�ַ�
    output wire[47:0] period_code_out
    );
    
    //////*************************������****************************//////
    ////////////////////////////�������ں�Ƶ�ʣ�bin�룬��carry��loose
//    wire[25:0] freq;//������ԭ��
//    wire[2:0] freq_carry;
//    wire freq_wrong;
    wire[31:0] freq_bcd;
    wire[18:0] period_bit;
    wire[2:0] period_loosed;
    waveinfo_time_calculator(//�������ں�Ƶ�ʣ�����32���ַ�
       .clk_in(clk_in),
       .clk1Hz_in(clk1Hz_in),            
       .sync_trigger_in(sync_trigger_in),
       .sync_count_in(sync_count_in),
       .clk_state_in(clk_state_in),//ʱ��Ƶ��״̬           
       .freq_bcd_out(freq_bcd),
       .period_bit_out(period_bit),
       .period_loosed_out(period_loosed)
//       .freq_out(freq),//26λ��������
//       .freq_carry_out(freq_carry),//Ƶ�׺��������
//       .freq_wrong_out(freq_wrong)//Ƶ�ʳ���
       );
       
       /////********************ת��Ƶ��***************************/////
       bcd2code(
           .clk_in(clk_in),
      
           .negative_in(0),
           .bcd_in(freq_bcd),
           .carried_in(0),
           .carry_in(0),//������7��0
           .loosed_in(0),
           .loose_in(0),//���ȥ��7��0
           
           .units_in(3'b100),//0:p��1:n, 2:u, 3:m, 4:�޵�λ 5:k, 6:M��7:G
           .units_code_in({6'd7,6'd49}),//Hz////�����λ��������//������ӣ�Ҫ��units_code,code_out
           
           .code_out(freq_code_out)//8���ַ���С���㱣��2λ
       
           );

       
       
       
       /////********************ת������***************************/////
       wire[31:0] period_bcd_out;
       reg[31:0] period_bcd;
       wire period_bcd_valid;
           bin2bcd(
              .clk_in(clk_in),
              .bin_in({7'b000_0000,period_bit}),//���26λ����
              .bcd_out(period_bcd_out),//���32λ���
              .valid_out(period_bcd_valid)
                 );
      always@(posedge period_bcd_valid)
         period_bcd <= period_bcd_out;
         
     bcd2code(
             .clk_in(clk_in),
        
             .negative_in(0),
             .bcd_in(period_bcd),
             .carried_in(0),
             .carry_in(0),//������7��0
             .loosed_in(1),
             .loose_in(period_loosed),//���ȥ��7��0
             
             .units_in(3'b001),//0:p��1:n, 2:u, 3:m, 4:�޵�λ 5:k, 6:M��7:G
             .units_code_in({6'd42,6'd62}),//s_////�����λ��������//������ӣ�Ҫ��units_code,code_out
             
             .code_out(period_code_out)//8���ַ���С���㱣��2λ
         
             );

endmodule
