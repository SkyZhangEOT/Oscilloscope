`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/16 14:18:58
// Design Name: 
// Module Name: inf_calculate_display
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


module inf_calculate_display(//计算，扫描和给显存赋值功能
    input clk_in,
    input [1:0] state_in,//0:计算wave并写显存；1:计算spec并写显存：2,3:读取显存
    ///////////数据计算部分//////
    input clk1Hz_in,
    input divclk_in,
    input sync_trigger_in,
    input [15:0]sync_count_in,
    input [11:0] signal_in,
    input [3:0] clk_state_in,
    input [3:0] bit_choose_in,
    ///////////写字部分//////////
    output wire[8:0] pixel_bit_out,//当前像素位
    output reg[3:0] char_height_out,
    input [5:0] char_bit_in,
    output wire[5:0] char_code_out,
    input pixel_color_in,
    //////////显存部分////////////
    output reg inf_disp_ram_wea_out,
    output wire[14:0] inf_disp_ram_addr_out,
    output reg color_out
    );
    reg wave_refreshed = 0;
    reg spec_refreshed = 0;
    
    reg[8:0] x_counter = 0;
    assign pixel_bit_out = x_counter + 1;
    reg[5:0] y_counter = 0;
    always@(*)
        if(y_counter < 6'd17)//三条边界没有考虑
            char_height_out = y_counter - 1'b1;
        else
            char_height_out = y_counter - 5'd18;
            
    
    reg[1:0] ram_addr = 0;
    inf_code_ram_gengerator inf_code_ram_gengerator(//管理四组RAM，计算数据，保存字型code，输入地址，输出字符代码，无延迟///目前暂时没有计算
                .clk_in(clk_in),
                ///////////数据计算部分//////
                .clk1Hz_in(clk1Hz_in),
                .divclk_in(divclk_in),    
                .sync_trigger_in(sync_trigger_in),
                .sync_count_in(sync_count_in),
                .signal_in(signal_in),
                .clk_state_in(clk_state_in),
                .bit_choose_in(bit_choose_in),
                ////////////////////////////////
                .ram_addr_in(ram_addr),//ram寻址,4组ram
                .char_addr_in(char_bit_in),//字符位寻址，共64个字符
                .char_code_out(char_code_out)//字符代码
                );
    
      
    always@(negedge clk_in)
        case(state_in)
            2'b00:
                    begin
                        //////////////初始化//////////////
                            spec_refreshed = 0;
                        //////////////////////////////////
                        if(wave_refreshed)//如果已经刷新了一次，就清零不再刷新
                        begin
                            x_counter = 0;
                            y_counter = 0;
                            inf_disp_ram_wea_out = 0;
                        end////////////////////////////////////////////////////////////////////////////结束
                        else///////////////////////////////否则，开始刷新
                        begin
                            inf_disp_ram_wea_out = 1;
                        ////////////////////////这里累加计数////////////////////////////
                            
                            if(x_counter == 511)
                            begin
                                x_counter = 0;
                                if(y_counter == 34)//共35行//？？？？？？？？？？？？？？？？？？？如果刷新不完怎么办？
                                begin
                                    y_counter = 0;
                                    wave_refreshed = 1;
                                end
                                else
                                    y_counter = y_counter + 1;
                            end
                            else
                                x_counter = x_counter + 1;
                            /////////////////////这里选择要显示的字符组//////////////////////////////    
                            if(y_counter < 6'd17)
                                ram_addr = 2'd0;
                            else
                                ram_addr = 2'd1;
                            ////////////////这里开始给显存置位/////////////////
                            case(y_counter)
                                6'd0:color_out = 1'b0;
                                6'd17:color_out = 1'b0;
                                6'd34:color_out = 1'b0;
                                default:color_out = pixel_color_in;
                            endcase
                        end
                    end
            2'b01:
                    begin
                        //////////////初始化//////////////
                        wave_refreshed = 0;
                        //////////////////////////////////
                        if(spec_refreshed)//如果已经刷新了一次，就清零不再刷新
                        begin
                            x_counter = 0;
                            y_counter = 0;
                            inf_disp_ram_wea_out = 0;
                        end////////////////////////////////////////////////////////////////////////////结束
                        else///////////////////////////////否则，开始刷新
                        begin
                            inf_disp_ram_wea_out = 1;
                        ////////////////////////这里累加计数////////////////////////////
                            if(x_counter == 511)
                            begin
                                x_counter = 0;
                                if(y_counter == 34)//共35行//？？？？？？？？？？？？？？？？？？？如果刷新不完怎么办？
                                begin
                                    y_counter = 0;
                                    spec_refreshed = 1;
                                end
                                else
                                    y_counter = y_counter + 1;
                            end
                            else
                                x_counter = x_counter + 1;
                            /////////////////////这里选择要显示的字符组//////////////////////////////    
                                if(y_counter < 6'd17)
                                    ram_addr = 2'd2;
                                else
                                    ram_addr = 2'd3;
                                
                                
                            ////////////////这里开始给显存置位/////////////////
                            case(y_counter)
                                6'd0:color_out = 1'b0;
                                6'd17:color_out = 1'b0;
                                6'd34:color_out = 1'b0;
                                default:color_out = pixel_color_in;
                            endcase
                        end
                    end
            default:
                    begin
                        x_counter = 0;
                        y_counter = 0;
                        wave_refreshed = 0;
                        spec_refreshed = 0;
                        inf_disp_ram_wea_out = 0;
                    end
        endcase
        
        
////////////显存控制部分/////////////
    assign inf_disp_ram_addr_out = (y_counter * 512) + x_counter;

endmodule
