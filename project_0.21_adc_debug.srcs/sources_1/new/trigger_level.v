`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/10 00:01:34
// Design Name: 
// Module Name: trigger_level
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


module trigger_level(//只改了接口16位改12位
    input key_pressed_in,
    input [15:0] keyval_in,
    input [3:0] bit_choose_in,//bit放大倍数
    input [7:0] wave_ori_pos_in,//x轴位置
    output wire[7:0] trigger_level_raw_out,//屏幕上的绝对位置
    output reg [11:0] trigger_level_out
    );

    reg[7:0] trigger_level = 8'd100;//屏幕上的绝对位置
    assign trigger_level_raw_out = trigger_level;

    always@(posedge key_pressed_in)//调整屏幕上的绝对位置
        case(keyval_in)//根据拨码开关的位置向npv赋值
                16'b0000_0000_0000_0010://增加电平
                    if (trigger_level == 8'd0)
                        trigger_level = trigger_level;
                    else
                        trigger_level = trigger_level - 4'd10;
                16'b0000_0000_0010_0000://减小电平
                    if (trigger_level == 8'd200)
                        trigger_level = trigger_level;
                    else
                        trigger_level = trigger_level + 4'd10;
                default:                      
                    trigger_level = trigger_level;
            endcase
            
    reg signed [7:0] trigger_level_comp;//相对于X轴的位置
    always@(*)
        trigger_level_comp = wave_ori_pos_in - trigger_level;
    reg signed [18:0] trigger_level_ans;
    
    always@(*)//输出16位的相对x轴的电平，不用左移是因为这是补码
        case(bit_choose_in)
            4'd0: trigger_level_ans = trigger_level_comp/16;
            4'd1: trigger_level_ans = trigger_level_comp/8;
            4'd2: trigger_level_ans = trigger_level_comp/4;
            4'd3: trigger_level_ans = trigger_level_comp/2;
            4'd4: trigger_level_ans = trigger_level_comp;
            4'd5: trigger_level_ans = trigger_level_comp*2;
            4'd6: trigger_level_ans = trigger_level_comp*4;
            4'd7: trigger_level_ans = trigger_level_comp*8;
            4'd8: trigger_level_ans = trigger_level_comp*16;
            4'd9: trigger_level_ans = trigger_level_comp*32;
            4'd10: trigger_level_ans = trigger_level_comp*64;
            4'd11: trigger_level_ans = trigger_level_comp*128;
            4'd12: trigger_level_ans = trigger_level_comp*256;
            4'd13: trigger_level_ans = trigger_level_comp*512;
            4'd14: trigger_level_ans = trigger_level_comp*1024;
            4'd15: trigger_level_ans = trigger_level_comp*2048;
       endcase
       reg [18:0] trigger_level_ans_abs;
       always@(*)//取绝对值
           if(trigger_level_ans[18])
               trigger_level_ans_abs = (~trigger_level_ans) + 1;
           else
               trigger_level_ans_abs = ~trigger_level_ans;
               
       always@(*)
           if(trigger_level_ans[18])//如果是负值
           begin
               if(|trigger_level_ans_abs[18:12])//如果大于当前位数
                   trigger_level_out = 12'b1000_0000_0000;//最小的负值
               else//如果小于当前位数
                   trigger_level_out = trigger_level_ans[11:0];
           end
           else//如果是正值
           begin
               if(|trigger_level_ans[18:12])//如果大于当前位数
                   trigger_level_out = 12'b0111_1111_1111;//最大的正值
               else
                   trigger_level_out = trigger_level_ans[11:0];
           end
       
endmodule
