`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/03/11 22:51:46
// Design Name: 
// Module Name: display_vga
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


module display_vga(
    input clk_in,//时钟输入
    
    input [1:0] wave_color_in,//显示数据输入
    input [1:0] spec_color_in,
    input info_color_in,
    input edgeline_color_in,
    
    input [7:0] wave_ori_pos_in,
    input [7:0] trigger_level_in,
    input [7:0] spec_level_in,
    
    output reg Hsync_out,//水平同步输出
    output reg Vsync_out,//垂直同步输出
    output reg[3:0] vgaRed_out,
    output reg[3:0] vgaGreen_out,
    output reg[3:0] vgaBlue_out,
    
    output reg[1:0] state_out,
    
    output reg[16:0] wave_addr_out,//输出地址读取显存数据
    output reg wave_enb_out,//使能信号
    output reg[16:0] spec_addr_out,//输出地址读取显存数据
    output reg spec_enb_out,//使能信号
    output reg [14:0] info_addr_out,
    output reg info_enb_out,
    output reg[15:0] edgeline_addr_out = 0,
    output reg edgeline_enb_out
    );
    reg divclk0 = 0;
    reg divclk1 = 0;
    always@(posedge clk_in)
        divclk0 <= ~divclk0;
    always@(negedge clk_in)
        divclk1 <= ~divclk1;
        
    parameter x_axis1 = 10,
               x_axis2 = 522,
               x_axis3 = 532,
               y_axis1 = 10,
               y_axis2 = 210,
               y_axis3 = 245,
               y_axis4 = 445,
               y_axis5 = 480;
    
    parameter bg_color = 12'hfff,
               window_bg_color = 12'h012,
               waveform_color = 12'h0f0,
               spectrum_color = 12'h2df,
               grid_color = 12'h777,
               error_color = 12'hf0f,
               font_color = 12'h000;
    
    //640*480 60Hz点刷新率
    parameter ta = 96,//同步信号宽度a
                tb = 48, //消隐后延b
                tc = 640,//行显示c
                td = 16,//消隐前沿d
                te = 800,//行时序共1056
                to = 2,//场同步信号
                tp = 33,//消隐后延p
                tq = 480,//场显示q
                tr = 10,//消隐前沿r
                ts = 525;//场时序共625
    reg[9:0] x_counter = 0;//行同步计数
    reg[9:0] y_counter = 0;//场同步计数
    reg[11:0] color1 = 0;//颜色寄存器
    wire[11:0] wave_color;
    wire[11:0] spec_color;
//    assign wave_color = (wave_color_in == 2'd0)? window_bg_color :((wave_color_in == 2'd1)? grid_color :((wave_color_in == 2'd2)? waveform_color : error_color));
//    assign spec_color = (spec_color_in == 2'd0)? window_bg_color :((wave_color_in == 2'd1)? grid_color :((wave_color_in == 2'd2)? spectrum_color : error_color));
    color_trans ct1(//将显存中6位的数据转换成12位的数据
        .color_in(wave_color_in),
        .set_color_in(waveform_color),
        .color_out(wave_color)
        );
    color_trans ct2(//将显存中6位的数据转换成12位的数据
        .color_in(spec_color_in),
        .set_color_in(spectrum_color),
        .color_out(spec_color)
        );

    wire[11:0] info_color;
    assign info_color = info_color_in? font_color : bg_color;    
    wire[11:0] edgeline_color;
    assign edgeline_color = edgeline_color_in? font_color : bg_color;
    always@(negedge divclk0)//下降沿有效
        begin
            if(x_counter == te - 1) 
            begin//水平像素点0~te-1，行计数到了最后一位
                x_counter = 0;
                if(y_counter == ts - 1)//行0~ts-1，场计数也到了最后一位
                    y_counter = 0;
                else
                    y_counter = y_counter + 1;
            end
            else begin //begin生成地址获取颜色，设置颜色
                x_counter = x_counter + 1;
            end
        end
        
    always@(posedge divclk1)//同样是下降沿有效//////////////改变地址，50m下降沿，25m上升沿
        begin
                //***************************************************这里往下是波形数据的显示区域******************************************************
                if(x_counter < (ta + tb + x_axis1))//位于坐标轴箭头区域
                    begin
                        wave_enb_out <= 0;///////////////////////////////不需要显存口 置零
                        spec_enb_out <= 0;///////////////////////////////不需要显存口 置零
                        info_enb_out <= 0;///////////////////////////////不需要显存口 置零
                        edgeline_addr_out <= edgeline_addr_out;
                    end
                else if(x_counter < (ta + tb + x_axis2))//提前一个时钟
                    begin
                        if(((to + tp + y_axis1) <= y_counter) && (y_counter < (to + tp + y_axis2)))//波形显示区域
                            begin
                                wave_enb_out <= 1;
                                wave_addr_out <= wave_addr_out + 1;
                                edgeline_addr_out <= edgeline_addr_out;
                            end
                        else if(((to + tp + y_axis2) <= y_counter) && (y_counter < (to + tp + y_axis3)))//信息显示区域
                            begin
                                info_enb_out <= 1;                      
                                info_addr_out <= info_addr_out + 1;
                                edgeline_addr_out <= edgeline_addr_out;
                            end
                        else if(((to + tp + y_axis3) <= y_counter) && (y_counter < (to + tp + y_axis4)))//频谱显示区域
                            begin
                                info_addr_out <= 15'd0;
                                info_enb_out <= 0;
                                spec_enb_out <= 1;                                                     
                                spec_addr_out <= spec_addr_out + 1;
                                edgeline_addr_out <= edgeline_addr_out;
                            end
                        else if(((to + tp + y_axis4 + 2) <= y_counter) && (y_counter < (to + tp + y_axis5 + 2)))//信息显示区域
                            begin
                                info_enb_out <= 1;                      
                                info_addr_out <= info_addr_out + 1;
                                edgeline_addr_out <= edgeline_addr_out;
                            end
                        else//////////////////////////////////////////////////////////上部区域
                            begin
                                wave_addr_out <= 17'd0;
                                wave_enb_out <= 0;                                                  
                                spec_addr_out <= 17'd0;
                                spec_enb_out <= 0;                                                  
                                info_addr_out <= 15'd0;
                                info_enb_out <= 0;
                                edgeline_addr_out <= edgeline_addr_out;
                            end
                    end
                else if(x_counter < (ta + tb + x_axis3))//////////////////右侧十像素
                    begin                 
                        wave_enb_out <= 0;///////////////////////////////不需要显存口 置零
                        spec_enb_out <= 0;///////////////////////////////不需要显存口 置零
                        info_enb_out <= 0;///////////////////////////////不需要显存口 置零
                        edgeline_addr_out <= edgeline_addr_out;
                    end
                else if(x_counter < (ta + tb + tc))/////////////////////////////////////////////////////////////右侧显示框
                    if(((to + tp) <= y_counter) && (y_counter < (to + tp + tq)))
                        begin                                                                
                            wave_enb_out <= 0;///////////////////////////////不需要显存口 置零        
                            spec_enb_out <= 0;///////////////////////////////不需要显存口 置零        
                            info_enb_out <= 0;///////////////////////////////不需要显存口 置零        
                            edgeline_enb_out <= 1;
                            if((x_counter == 10'd783)&(y_counter == 10'd514))
                                edgeline_addr_out <= 16'd0;
                            else                                    
                                edgeline_addr_out <= edgeline_addr_out + 1;                                 
                        end
                else
                    begin
                        wave_enb_out <= 0;////
                        spec_enb_out <= 0;////
                        info_enb_out <= 0;////
                        edgeline_enb_out <= 0;
                    end                                                                  
            end
    always@(posedge divclk1)//同样是下降沿有效//////////////改变地址，50m下降沿，25m上升沿
            begin
                            //***************************************************这里往下是波形数据的显示区域******************************************************
                            if(x_counter < (ta + tb + x_axis1))//位于坐标轴箭头区域
                                    //color1 = bg_color;            
                                    if((y_counter < (to + tp + y_axis1 + wave_ori_pos_in))&&(y_counter > (to + tp + y_axis1 + wave_ori_pos_in - 4)))//如果在x轴上侧4点
                                    begin
                                        if(x_counter < (ta + tb + x_axis1 - 1 - ((to + tp + y_axis1 + wave_ori_pos_in) - y_counter)))//画梯形
                                            color1 <= 12'h000;
                                        else
                                            color1 <= bg_color;
                                    end
                                    else 
                                        if((y_counter >= (to + tp + y_axis1 + wave_ori_pos_in))&&(y_counter < (to + tp + y_axis1 + wave_ori_pos_in + 4)))//如果在x轴下侧4点
                                            begin
                                                if(x_counter < (ta + tb + x_axis1 - 1 - (y_counter - (to + tp + x_axis1 + wave_ori_pos_in))))//画梯形
                                                    color1 <= 12'h000;
                                                else
                                                    color1 <= bg_color;
                                            end
                                        else//如果不在x轴附近
                                            color1 = bg_color;
                                
                            else if(x_counter < (ta + tb + x_axis2))//提前一个时钟
                                begin
                                    if(y_counter < (to + tp + y_axis1))
                                            color1 <= bg_color;
                                    if(((to + tp + y_axis1) <= y_counter) && (y_counter < (to + tp + y_axis2)))//波形显示区域
                                            color1 <= wave_color;
                                    else if(((to + tp + y_axis2) <= y_counter) && (y_counter < (to + tp + y_axis3)))//信息显示区域
                                            color1 <= info_color;                   
                                    else if(((to + tp + y_axis3) <= y_counter) && (y_counter < (to + tp + y_axis4)))//频谱显示区域                     
                                            color1 <= spec_color;                   
                                    else if(((to + tp + y_axis4 + 2) <= y_counter) && (y_counter < (to + tp + y_axis5 + 2)))//信息显示区域
                                            color1 <= info_color;                   
                                    else//////////////////////////////////////////////////////////上部区域                                                  
                                            color1 <= bg_color;                  
                                end
                            else if(x_counter < (ta + tb + x_axis3))//////////////////右侧十像素
                            begin
                                if((y_counter < (to + tp + y_axis1 + trigger_level_in))&&(y_counter > (to + tp + y_axis1 + trigger_level_in - 4)))//如果在x轴上侧4点
                                    begin
                                        if(x_counter > (ta + tb + x_axis2 - 1 + ((to + tp + y_axis1 + trigger_level_in) - y_counter)))//画梯形
                                            color1 <= 12'h000;
                                        else
                                            color1 <= bg_color;
                                    end
                                else if((y_counter >= (to + tp + y_axis1 + trigger_level_in))&&(y_counter < (to + tp + y_axis1 + trigger_level_in + 4)))//如果在x轴下侧4点
                                            begin
                                                if(x_counter > (ta + tb + x_axis2 - 1 + (y_counter - (to + tp + y_axis1 + trigger_level_in))))//画梯形
                                                    color1 <= 12'h000;
                                                else
                                                    color1 <= bg_color;
                                            end
                                else if((y_counter < (to + tp + y_axis3 + spec_level_in))&&(y_counter > (to + tp + y_axis3 + spec_level_in - 4)))//如果在x轴上侧4点             
                                                begin                                                                                                                                 
                                                    if(x_counter > (ta + tb + x_axis2 - 1 + ((to + tp + y_axis3 + spec_level_in) - y_counter)))//画梯形                                   
                                                        color1 <= 12'h000;                                                                                                            
                                                    else                                                                                                                              
                                                        color1 <= bg_color;                                                                                                           
                                                end                                                                                                                                   
                                else if((y_counter >= (to + tp + y_axis3 + spec_level_in))&&(y_counter < (to + tp + y_axis3 + spec_level_in + 4)))//如果在x轴下侧4点       
                                                        begin                                                                                                                         
                                                            if(x_counter > (ta + tb + x_axis2 - 1 + (y_counter - (to + tp + y_axis3 + spec_level_in))))//画梯形                           
                                                                color1 <= 12'h000;                                                                                                    
                                                            else                                                                                                                      
                                                                color1 <= bg_color;                                                                                                   
                                                        end 
                                else                                                                                                                          //如果不在x轴附近
                                    color1 = bg_color;
                            end
                            
                            else/////////////////////////////////////////////////////////////右侧显示框               
                                    color1 <= edgeline_color;
                            
                            vgaRed_out[3:0] <= color1[11:8];
                            vgaGreen_out[3:0] <= color1[7:4];
                            vgaBlue_out[3:0] <= color1[3:0];                                                     
                            Hsync_out <= !(x_counter < ta);
                            Vsync_out <= !(y_counter < to);
            end
    
    always@(posedge divclk1)
        if(y_counter < to + tp + 210)
            state_out <= 2'd0;
        else if(y_counter < to + tp + 245)
            state_out <= 2'd2;
        else if(y_counter < to + tp + 445)
            state_out <= 2'd1;
        else
            state_out <= 2'd3;

            
endmodule
