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
    input clk_in,//ʱ������
    
    input [1:0] wave_color_in,//��ʾ��������
    input [1:0] spec_color_in,
    input info_color_in,
    input edgeline_color_in,
    
    input [7:0] wave_ori_pos_in,
    input [7:0] trigger_level_in,
    input [7:0] spec_level_in,
    
    output reg Hsync_out,//ˮƽͬ�����
    output reg Vsync_out,//��ֱͬ�����
    output reg[3:0] vgaRed_out,
    output reg[3:0] vgaGreen_out,
    output reg[3:0] vgaBlue_out,
    
    output reg[1:0] state_out,
    
    output reg[16:0] wave_addr_out,//�����ַ��ȡ�Դ�����
    output reg wave_enb_out,//ʹ���ź�
    output reg[16:0] spec_addr_out,//�����ַ��ȡ�Դ�����
    output reg spec_enb_out,//ʹ���ź�
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
    
    //640*480 60Hz��ˢ����
    parameter ta = 96,//ͬ���źſ��a
                tb = 48, //��������b
                tc = 640,//����ʾc
                td = 16,//����ǰ��d
                te = 800,//��ʱ��1056
                to = 2,//��ͬ���ź�
                tp = 33,//��������p
                tq = 480,//����ʾq
                tr = 10,//����ǰ��r
                ts = 525;//��ʱ��625
    reg[9:0] x_counter = 0;//��ͬ������
    reg[9:0] y_counter = 0;//��ͬ������
    reg[11:0] color1 = 0;//��ɫ�Ĵ���
    wire[11:0] wave_color;
    wire[11:0] spec_color;
//    assign wave_color = (wave_color_in == 2'd0)? window_bg_color :((wave_color_in == 2'd1)? grid_color :((wave_color_in == 2'd2)? waveform_color : error_color));
//    assign spec_color = (spec_color_in == 2'd0)? window_bg_color :((wave_color_in == 2'd1)? grid_color :((wave_color_in == 2'd2)? spectrum_color : error_color));
    color_trans ct1(//���Դ���6λ������ת����12λ������
        .color_in(wave_color_in),
        .set_color_in(waveform_color),
        .color_out(wave_color)
        );
    color_trans ct2(//���Դ���6λ������ת����12λ������
        .color_in(spec_color_in),
        .set_color_in(spectrum_color),
        .color_out(spec_color)
        );

    wire[11:0] info_color;
    assign info_color = info_color_in? font_color : bg_color;    
    wire[11:0] edgeline_color;
    assign edgeline_color = edgeline_color_in? font_color : bg_color;
    always@(negedge divclk0)//�½�����Ч
        begin
            if(x_counter == te - 1) 
            begin//ˮƽ���ص�0~te-1���м����������һλ
                x_counter = 0;
                if(y_counter == ts - 1)//��0~ts-1��������Ҳ�������һλ
                    y_counter = 0;
                else
                    y_counter = y_counter + 1;
            end
            else begin //begin���ɵ�ַ��ȡ��ɫ��������ɫ
                x_counter = x_counter + 1;
            end
        end
        
    always@(posedge divclk1)//ͬ�����½�����Ч//////////////�ı��ַ��50m�½��أ�25m������
        begin
                //***************************************************���������ǲ������ݵ���ʾ����******************************************************
                if(x_counter < (ta + tb + x_axis1))//λ���������ͷ����
                    begin
                        wave_enb_out <= 0;///////////////////////////////����Ҫ�Դ�� ����
                        spec_enb_out <= 0;///////////////////////////////����Ҫ�Դ�� ����
                        info_enb_out <= 0;///////////////////////////////����Ҫ�Դ�� ����
                        edgeline_addr_out <= edgeline_addr_out;
                    end
                else if(x_counter < (ta + tb + x_axis2))//��ǰһ��ʱ��
                    begin
                        if(((to + tp + y_axis1) <= y_counter) && (y_counter < (to + tp + y_axis2)))//������ʾ����
                            begin
                                wave_enb_out <= 1;
                                wave_addr_out <= wave_addr_out + 1;
                                edgeline_addr_out <= edgeline_addr_out;
                            end
                        else if(((to + tp + y_axis2) <= y_counter) && (y_counter < (to + tp + y_axis3)))//��Ϣ��ʾ����
                            begin
                                info_enb_out <= 1;                      
                                info_addr_out <= info_addr_out + 1;
                                edgeline_addr_out <= edgeline_addr_out;
                            end
                        else if(((to + tp + y_axis3) <= y_counter) && (y_counter < (to + tp + y_axis4)))//Ƶ����ʾ����
                            begin
                                info_addr_out <= 15'd0;
                                info_enb_out <= 0;
                                spec_enb_out <= 1;                                                     
                                spec_addr_out <= spec_addr_out + 1;
                                edgeline_addr_out <= edgeline_addr_out;
                            end
                        else if(((to + tp + y_axis4 + 2) <= y_counter) && (y_counter < (to + tp + y_axis5 + 2)))//��Ϣ��ʾ����
                            begin
                                info_enb_out <= 1;                      
                                info_addr_out <= info_addr_out + 1;
                                edgeline_addr_out <= edgeline_addr_out;
                            end
                        else//////////////////////////////////////////////////////////�ϲ�����
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
                else if(x_counter < (ta + tb + x_axis3))//////////////////�Ҳ�ʮ����
                    begin                 
                        wave_enb_out <= 0;///////////////////////////////����Ҫ�Դ�� ����
                        spec_enb_out <= 0;///////////////////////////////����Ҫ�Դ�� ����
                        info_enb_out <= 0;///////////////////////////////����Ҫ�Դ�� ����
                        edgeline_addr_out <= edgeline_addr_out;
                    end
                else if(x_counter < (ta + tb + tc))/////////////////////////////////////////////////////////////�Ҳ���ʾ��
                    if(((to + tp) <= y_counter) && (y_counter < (to + tp + tq)))
                        begin                                                                
                            wave_enb_out <= 0;///////////////////////////////����Ҫ�Դ�� ����        
                            spec_enb_out <= 0;///////////////////////////////����Ҫ�Դ�� ����        
                            info_enb_out <= 0;///////////////////////////////����Ҫ�Դ�� ����        
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
    always@(posedge divclk1)//ͬ�����½�����Ч//////////////�ı��ַ��50m�½��أ�25m������
            begin
                            //***************************************************���������ǲ������ݵ���ʾ����******************************************************
                            if(x_counter < (ta + tb + x_axis1))//λ���������ͷ����
                                    //color1 = bg_color;            
                                    if((y_counter < (to + tp + y_axis1 + wave_ori_pos_in))&&(y_counter > (to + tp + y_axis1 + wave_ori_pos_in - 4)))//�����x���ϲ�4��
                                    begin
                                        if(x_counter < (ta + tb + x_axis1 - 1 - ((to + tp + y_axis1 + wave_ori_pos_in) - y_counter)))//������
                                            color1 <= 12'h000;
                                        else
                                            color1 <= bg_color;
                                    end
                                    else 
                                        if((y_counter >= (to + tp + y_axis1 + wave_ori_pos_in))&&(y_counter < (to + tp + y_axis1 + wave_ori_pos_in + 4)))//�����x���²�4��
                                            begin
                                                if(x_counter < (ta + tb + x_axis1 - 1 - (y_counter - (to + tp + x_axis1 + wave_ori_pos_in))))//������
                                                    color1 <= 12'h000;
                                                else
                                                    color1 <= bg_color;
                                            end
                                        else//�������x�ḽ��
                                            color1 = bg_color;
                                
                            else if(x_counter < (ta + tb + x_axis2))//��ǰһ��ʱ��
                                begin
                                    if(y_counter < (to + tp + y_axis1))
                                            color1 <= bg_color;
                                    if(((to + tp + y_axis1) <= y_counter) && (y_counter < (to + tp + y_axis2)))//������ʾ����
                                            color1 <= wave_color;
                                    else if(((to + tp + y_axis2) <= y_counter) && (y_counter < (to + tp + y_axis3)))//��Ϣ��ʾ����
                                            color1 <= info_color;                   
                                    else if(((to + tp + y_axis3) <= y_counter) && (y_counter < (to + tp + y_axis4)))//Ƶ����ʾ����                     
                                            color1 <= spec_color;                   
                                    else if(((to + tp + y_axis4 + 2) <= y_counter) && (y_counter < (to + tp + y_axis5 + 2)))//��Ϣ��ʾ����
                                            color1 <= info_color;                   
                                    else//////////////////////////////////////////////////////////�ϲ�����                                                  
                                            color1 <= bg_color;                  
                                end
                            else if(x_counter < (ta + tb + x_axis3))//////////////////�Ҳ�ʮ����
                            begin
                                if((y_counter < (to + tp + y_axis1 + trigger_level_in))&&(y_counter > (to + tp + y_axis1 + trigger_level_in - 4)))//�����x���ϲ�4��
                                    begin
                                        if(x_counter > (ta + tb + x_axis2 - 1 + ((to + tp + y_axis1 + trigger_level_in) - y_counter)))//������
                                            color1 <= 12'h000;
                                        else
                                            color1 <= bg_color;
                                    end
                                else if((y_counter >= (to + tp + y_axis1 + trigger_level_in))&&(y_counter < (to + tp + y_axis1 + trigger_level_in + 4)))//�����x���²�4��
                                            begin
                                                if(x_counter > (ta + tb + x_axis2 - 1 + (y_counter - (to + tp + y_axis1 + trigger_level_in))))//������
                                                    color1 <= 12'h000;
                                                else
                                                    color1 <= bg_color;
                                            end
                                else if((y_counter < (to + tp + y_axis3 + spec_level_in))&&(y_counter > (to + tp + y_axis3 + spec_level_in - 4)))//�����x���ϲ�4��             
                                                begin                                                                                                                                 
                                                    if(x_counter > (ta + tb + x_axis2 - 1 + ((to + tp + y_axis3 + spec_level_in) - y_counter)))//������                                   
                                                        color1 <= 12'h000;                                                                                                            
                                                    else                                                                                                                              
                                                        color1 <= bg_color;                                                                                                           
                                                end                                                                                                                                   
                                else if((y_counter >= (to + tp + y_axis3 + spec_level_in))&&(y_counter < (to + tp + y_axis3 + spec_level_in + 4)))//�����x���²�4��       
                                                        begin                                                                                                                         
                                                            if(x_counter > (ta + tb + x_axis2 - 1 + (y_counter - (to + tp + y_axis3 + spec_level_in))))//������                           
                                                                color1 <= 12'h000;                                                                                                    
                                                            else                                                                                                                      
                                                                color1 <= bg_color;                                                                                                   
                                                        end 
                                else                                                                                                                          //�������x�ḽ��
                                    color1 = bg_color;
                            end
                            
                            else/////////////////////////////////////////////////////////////�Ҳ���ʾ��               
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
