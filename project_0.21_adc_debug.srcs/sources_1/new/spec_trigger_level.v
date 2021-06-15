`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/06/01 20:34:30
// Design Name: 
// Module Name: spec_trigger_level
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


module spec_trigger_level(
    input spec_level_en_in,
    input key_pressed_in,
    input[1:0] keyval_in,//10:���Ӹ߶�ֵ�����ͣ� 01:��С�߶�ֵ������
    output reg[7:0] spec_level_out
);

   
initial
begin
    spec_level_out = 8'd100;
    
end

always@(posedge key_pressed_in)
    if(spec_level_en_in)
    case(keyval_in)//���ݲ��뿪�ص�λ����npv��ֵ
            2'b01://����
                if (spec_level_out == 8'd0)
                    spec_level_out = spec_level_out;
                else
                    spec_level_out = spec_level_out - 4'd10;
            2'b10://��С
                if (spec_level_out >= 8'd200)
                    spec_level_out = 8'd200;
                else
                    spec_level_out = spec_level_out + 4'd10;
            default:                      
                spec_level_out = spec_level_out;
        endcase
endmodule
