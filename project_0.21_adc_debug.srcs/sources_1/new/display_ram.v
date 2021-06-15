`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/03/09 23:59:40
// Design Name: 
// Module Name: display_ram
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


module display_ram(
    input clk_in,
    input dispwave_wea_in,//дʹ��
    input [16:0] dispwave_addra_in,//�˿�a��ַ//17λ��ַ
    input [1:0] dispwave_dina_in,//�˿�a��ַ
    input dispwave_enb_in,//�˿�bʹ��
    input [16:0] dispwave_addrb_in,//�˿�b��ַ//17λ��ַ
//    output [5:0] douta_out,//�˿�a�������
    output [1:0] dispwave_doutb_out,//�˿�b��� 
    
    input dispspec_wea_in,//дʹ��
    input [16:0] dispspec_addra_in,//�˿�a��ַ//17λ��ַ
    input [1:0] dispspec_dina_in,//�˿�����6λ
    input dispspec_enb_in,//�˿�bʹ��
    input [16:0] dispspec_addrb_in,//�˿�b��ַ//17λ��ַ
    output [1:0] dispspec_doutb_out,//�˿�b���6λ
    
    input edgeline_wea_in,
    input [15:0] edgeline_addra_in,//�˿�a��ַ//17λ��ַ  
    input edgeline_dina_in,//�˿�����6λ          
    input edgeline_enb_in,//�˿�bʹ��                  
    input [15:0] edgeline_addrb_in,//�˿�b��ַ//17λ��ַ  
    output edgeline_doutb_out//�˿�b���6λ      
    );

      
    blk_mem_gen_0 instance_waveram(
          .clka(clk_in),
          .ena(1),//һֱʹ��a�˿���Ϊд��
          .wea(dispwave_wea_in),
          .addra(dispwave_addra_in),//a�˿ڵ�ַ
          .dina(dispwave_dina_in),//a�˿�����д��
          .clkb(clk_in),
          .enb(dispwave_enb_in),
          .addrb(dispwave_addrb_in),
          .doutb(dispwave_doutb_out)
        );
        
    blk_mem_gen_1 instance_specram(
              .clka(clk_in),
              .ena(1),//һֱʹ��a�˿���Ϊд��
              .wea(dispspec_wea_in),
              .addra(dispspec_addra_in),//a�˿ڵ�ַ
              .dina(dispspec_dina_in),//a�˿�����д��
              .clkb(clk_in),
              .enb(dispspec_enb_in),
              .addrb(dispspec_addrb_in),
              .doutb(dispspec_doutb_out)
            );
     blk_mem_gen_7 instance_edgeline(
              .clka(clk_in),
              .ena(1),//һֱʹ��a�˿���Ϊд��
              .wea(edgeline_wea_in),
              .addra(edgeline_addra_in),//a�˿ڵ�ַ
              .dina(edgeline_dina_in),//a�˿�����д��
              .clkb(clk_in),
              .enb(edgeline_enb_in),
              .addrb(edgeline_addrb_in),
              .doutb(edgeline_doutb_out)
            );
endmodule
