`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/04/19 23:12:46
// Design Name: 
// Module Name: wave_xorigin
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


module wave_xorigin(
    input key_pressed_in,
    input[15:0] keyval_in,
    output reg[7:0] wave_ori_pos_out
    );

       
    initial
    begin
        wave_ori_pos_out = 8'd100;
        
    end

    always@(posedge key_pressed_in)
        case(keyval_in)//根据拨码开关的位置向npv赋值
                16'b0000_0000_0000_0001://增加
                    if (wave_ori_pos_out == 8'd0)
                        wave_ori_pos_out = wave_ori_pos_out;
                    else
                        wave_ori_pos_out = wave_ori_pos_out - 4'd10;
                16'b0000_0000_0001_0000://减小
                    if (wave_ori_pos_out >= 8'd200)
                        wave_ori_pos_out = 8'd200;
                    else
                        wave_ori_pos_out = wave_ori_pos_out + 4'd10;
                default:                      
                    wave_ori_pos_out = wave_ori_pos_out;
            endcase
endmodule
