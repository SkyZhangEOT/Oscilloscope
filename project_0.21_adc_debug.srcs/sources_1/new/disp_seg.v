`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/02/22 21:46:59
// Design Name: 
// Module Name: v1
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


module disp_seg(
    input clk_in,//1000Hzʱ��
    input [3:0] clk_state_in,
    output reg [7:0] seg_out = 0,
    output reg[5:0] an_out = 6'b111110    //λ��
    );
    
    wire [23:0] seg_data;
    clk_disp(
        .clk_state_in(clk_state_in),
        .seg_data_out(seg_data)
        );
    
    
//    reg[7:0] seg_out = 0;           //����
//    reg[5:0] an_out = 6'b111110;    //λ��
    reg[3:0] disp_dat = 0;      //Ҫ��ʾ������
    reg[2:0] disp_bit = 0;      //Ҫ��ʾ��λ

      always@(posedge clk_in) //ÿһ�������أ�����ͬ����ܵı�����һ
      begin
        if (disp_bit>=5)
          disp_bit = 0;
        else
          disp_bit = disp_bit+1;
          
        case(disp_bit)  //��ͬ������ܱ��������������ܺ���ʾ������
          3'h0:
          begin
            disp_dat = seg_data[3:0];
            an_out = 6'b111110;
          end
          
          3'h1:
          begin
            disp_dat = seg_data[7:4];
            an_out = 6'b111101;
          end
          
          3'h2:
          begin
            disp_dat = seg_data[11:8];
            an_out = 6'b111011;
          end
          
          3'h3:
          begin
            disp_dat = seg_data[15:12];
            an_out = 6'b110111;
          end
          
          3'h4:
          begin
            disp_dat = seg_data[19:16];
            an_out = 6'b101111;
          end
          
          3'h5:
          begin
            disp_dat = seg_data[23:20];
            an_out = 6'b011111;
          end
          
          default:
          begin
            disp_dat = 0;
            an_out = 6'b111111;
          end
        endcase
      end
      
      always @ (disp_dat)
        begin
          case (disp_dat)
          4'h0 : seg_out= 8'h3f; //��ʾ"0"
          4'h1 : seg_out= 8'h06; //��ʾ"1"
          4'h2 : seg_out= 8'h5b; //��ʾ"2"
          4'h3 : seg_out= 8'h4f; //��ʾ"3"
          4'h4 : seg_out= 8'h66; //��ʾ"4"
          4'h5 : seg_out= 8'h6d; //��ʾ"5" 01101101
          4'h6 : seg_out= 8'h7d; //��ʾ"6"
          4'h7 : seg_out= 8'h07; //��ʾ"7"
          4'h8 : seg_out= 8'h7f; //��ʾ"8"
          4'h9 : seg_out= 8'h6f; //��ʾ"9"
          4'ha : seg_out= 8'h77; //��ʾ"a"
          4'hb : seg_out= 8'h7c; //��ʾ"b"
          4'hc : seg_out= 8'h39; //��ʾ"c"
          4'hd : seg_out= 8'h5e; //��ʾ"d"
          4'he : seg_out= 8'h79; //��ʾ"e"
          4'hf : seg_out= 8'h71; //��ʾ"f"
          endcase
        end
                
endmodule

