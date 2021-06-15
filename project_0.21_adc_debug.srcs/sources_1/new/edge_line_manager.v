`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/26 22:04:27
// Design Name: 
// Module Name: edge_line_manager
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


 module edge_line_manager(
    input clk_in,
    input clk1Hz_in,
//    input [11:0] sw_in,
    input key_pressed_in,
    input [15:0] keyval_in,//��λ����������
    
    input [3:0] clk_state_in,
    input [7:0] addr_ans_in,
    input no_data_in,
    
    output wire[2:0] h_state0,
    output wire[2:0] h_state1,
    output wire[2:0] h_state2,
    output wire[2:0] h_state3,
    output wire choosed4,
    output wire choosed5,
    
    output reg[15:0] edgeline_addr_out,//������Դ�A�ڵĵ�ַ
    output reg color_out,//Ҫд���Դ�����ݣ���ɫ��
    output reg wea_out//�Դ�A�ڵ�дʹ��
    );
    /////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////��������⣬�ַ��任�������أ�д�������½���////////////////////
    parameter ca = 6'd0,     cb = 6'd1,     cc = 6'd2,     cd = 6'd3,     ce = 6'd4,     cf = 6'd5,     cg = 6'd6,     ch = 6'd7,     
                   ci = 6'd8,     cj = 6'd9,     ck = 6'd10,    cl = 6'd11,    cm = 6'd12,    cn = 6'd13,    cp = 6'd14,    cq = 6'd15,    
                   cr = 6'd16,    cs = 6'd17,    ct = 6'd18,    cu = 6'd19,    cv = 6'd20,    cw = 6'd21,    cx = 6'd22,    cy = 6'd23,    
                   cz = 6'd24,    a = 6'd25,     b = 6'd26,     c = 6'd27,     d = 6'd28,     e = 6'd29,     f = 6'd30,     g = 6'd31,     
                   h = 6'd32,     i = 6'd33,     j = 6'd34,     k = 6'd35,     m = 6'd36,     n = 6'd37,     o = 6'd38,     p = 6'd39,     
                   q = 6'd40,     r = 6'd41,     s = 6'd42,     t = 6'd43,     u = 6'd44,     v = 6'd45,     w = 6'd46,     x = 6'd47,     
                   y = 6'd48,     z = 6'd49,     n0 = 6'd50,    n1 = 6'd51,    n2 = 6'd52,    n3 = 6'd53,    n4 = 6'd54,    n5 = 6'd55,    
                   n6 = 6'd56,    n7 = 6'd57,    n8 = 6'd58,    n9 = 6'd59,    div = 6'd60,   neg = 6'd61,  space = 6'd62,  point = 6'd63,
                   l = 6'd51,co = 6'd50;//��ĸl������1���棬����0�ô�д��ĸO����
    
    //////////////////////////////////////״̬ת��/////////////////////////////////////////
    wire[2:0] v_state;
    wire choosed0;
    wire choosed1;
    wire choosed2;
    wire choosed3;

//    wire[2:0] h_state0;
//    wire[2:0] h_state1;

//    wire[2:0] h_state3;
    wire[2:0] h_state4;
    wire[2:0] h_state5;
    assign choosed0 = (~v_state[2]) & (~v_state[1]) & (~v_state[0]);//000
    assign choosed1 = (~v_state[2]) & (~v_state[1]) & (v_state[0]);//001
    assign choosed2 = (~v_state[2]) & (v_state[1]) & (~v_state[0]);//010
    assign choosed3 = (~v_state[2]) & (v_state[1]) & (v_state[0]);//011
    assign choosed4 = (v_state[2]) & (~v_state[1]) & (~v_state[0]);//100
    assign choosed5 = (v_state[2]) & (~v_state[1]) & (v_state[0]);//101
    //state��Ϊ��λ
    edgeline_state(//״̬�л�
        .key_pressed_in(key_pressed_in),
        .keyval_in({keyval_in[10],keyval_in[14],keyval_in[13],keyval_in[15]}),//��λ����������
        .state(v_state),//0���������
        .state0(h_state0),
        .state1(h_state1),
        .state2(h_state2),
        .state3(h_state3),
        .state4(h_state4),
        .state5(h_state5)
        );
    
    wire[47:0] amp_freq_code;
    wire amp_data_valid;
    ampinfo_freq_processing(
        .clk_in(clk_in),
        .clk1Hz_in(clk1Hz_in),//ˢ������
        
        .clk_state_in(clk_state_in),
        .addr_ans_in(addr_ans_in),
        
        .search_en_in(choosed4),
        .no_data_in(no_data_in),
        
        .freq_code_out(amp_freq_code),
        .data_valid_out(amp_data_valid)
        );    
        
    
    /////////////////////////////////////ɨ��///////////////////////////////////
    reg[6:0] x_axis = 0;
//    wire[6:0] x;
//    assign x = (x_axis == 7'd107)? 7'b0000000 : x_axis + 1'b1;
    
    reg[8:0] y_axis = 0;
//    wire[8:0] y;
//    assign y = (x_axis == 7'd107)? ((y_axis == 9'd479)? 9'd0 : y_axis + 1'b1): y_axis;
    
    
    //////////////////////////////////////�ַ����////////////////////////////////////
    wire[3:0] char_height;
    wire[5:0] char_bit;
    wire[5:0] char_code;
    wire pixel_color;
    digit_write(//�����                                                                      
            .clk_in(clk_in),                                                               
        //    input dwen,//��ǰ�������ڣ�������ǰʹ��                                                   
        //�������Ҫ�Ҷ��룬��ô�Ͳ���Ҫ�����ܿ����    input [7:0] pixel_num_in,//���ؿ��                         
            .pixel_bit_in({2'b00,x_axis}),//��ǰ����λ,���512������ok[8:0]                                       
            .char_height_in(char_height),//��ǰ�߶ȣ�ok[3:0]                                               
        //�������Ҫ�Ҷ��룬��ô�Ͳ���Ҫ���ַ�����    input [4:0] char_num_in,//���ַ���                           
            .char_bit_out(char_bit),//��ǰ�ַ�λ��ok���64���ַ�[5:0]                                         
            .char_code_in(char_code),//��ǰ�ַ�����,ok[5:0]                                               
            .pixel_color_out(pixel_color)//������ɫ,ok                                                    
            );
    /////////////////////////////////////line1//////////////////////////////////////////
    reg[5:0] v_pixel0 = 0;
    reg[5:0] v_pixel1 = 0;
    reg[5:0] v_pixel2 = 0;
    reg[5:0] v_pixel3 = 0;
    reg[5:0] v_pixel4 = 0;
    reg[5:0] v_pixel5 = 0;
    wire[3:0] char_height0;
    wire[3:0] char_height1;
    wire[3:0] char_height2;
    wire[3:0] char_height3;
    wire[3:0] char_height4;
    wire[3:0] char_height5;
    wire[5:0] char_code0;
    wire[5:0] char_code1;
    wire[5:0] char_code2;
    wire[5:0] char_code3;
    wire[5:0] char_code4;
    wire[5:0] char_code5;
    wire color0;
    wire color1;
    wire color2;
    wire color3;
    wire color4;
    wire color5;

    wire title_valid0;
    wire title_valid1;
    wire title_valid2;
    wire title_valid3;
    wire title_valid4;
    wire title_valid5;
    edgeliner l0(                                                                                         
        ////״̬����////////                                           

    //    input [2:0] top_state_in,//��༸��״̬                        
        //.ext_code_valid_in(1),//�����ڵڶ��е�������ʾ                      
        //.ext_code_in(channel_info),//[47:0]                          
        /////��������/////////                                         
        .choosed_in(choosed0),//��ɫ�ź�                                    
        .last_in(0),//ȥ��β���ź�                                     
        ////////λ������/////////                                      
        //input [6:0] horiz_pixel_in,//����108������ ����λ���ݱ�ʾ            
        .verti_pixel_in(v_pixel0),//����62������ 0-61                  
        
        .title_valid_out(title_valid0),
        /////////�ַ���Ϣͨ��//////////                                  
    //    output []                                                
        .char_height_out(char_height0),//�ַ��߶�                     
        //.char_bit_in(char_bit[3:0]),//���13.5����                         
        //.char_code_out(char_code0),//�ַ�����                          
        .pixel_color_in(pixel_color),                                      
        .pixel_color_out(color0)
        );
        edgeline_rom0(
            .title_valid_in(title_valid0),
            .state_in(h_state0),
            .char_bit_in(char_bit[3:0]),
            .ext_code_valid_in(0),//�����ڵڶ��е�������ʾ           
            .ext_code_in(0),
            
            .char_code_out(char_code0)//�ַ�����
            );
edgeliner l1(
    ////״̬����////////
//    .state_in(h_state1),//���˸�״̬                              
////    input [2:0] top_state_in,//��༸��״̬                        
//    .ext_code_valid_in(0),//�����ڵڶ��е�������ʾ                      
//    .ext_code_in(0),//[47:0]
    /////��������/////////                                         
    .choosed_in(choosed1),//��ɫ�ź�                                    
    .last_in(0),//ȥ��β���ź�                                     
    ////////λ������/////////                                      
    //input [6:0] horiz_pixel_in,//����108������ ����λ���ݱ�ʾ            
    .verti_pixel_in(v_pixel1),//����62������ 0-61                  
    
    .title_valid_out(title_valid1),                                                           
    /////////�ַ���Ϣͨ��//////////                                  
//    output []                                                
    .char_height_out(char_height1),//�ַ��߶�                     
    //.char_bit_in(char_bit[3:0]),//���13.5����                         
    //.char_code_out(char_code1),//�ַ�����                          
    .pixel_color_in(pixel_color),                                      
    .pixel_color_out(color1)
    );
    edgeline_rom1(
        .title_valid_in(title_valid1),
        .state_in(h_state1),
        .char_bit_in(char_bit[3:0]),
        .ext_code_valid_in(0),//�����ڵڶ��е�������ʾ           
        .ext_code_in(0),
        
        .char_code_out(char_code1)//�ַ�����              
        );
edgeliner l2(                                                                                         
    /////��������/////////                                         
    .choosed_in(choosed2),//��ɫ�ź�                                    
    .last_in(0),//ȥ��β���ź�                                     
    ////////λ������/////////                                      
    //input [6:0] horiz_pixel_in,//����108������ ����λ���ݱ�ʾ            
    .verti_pixel_in(v_pixel2),//����62������ 0-61                  
    .title_valid_out(title_valid2),                                                           
    /////////�ַ���Ϣͨ��//////////                                  
//    output []                                                
    .char_height_out(char_height2),//�ַ��߶�                     
                 
    .pixel_color_in(pixel_color),                                      
    .pixel_color_out(color2)
    );
    edgeline_rom2(
            .title_valid_in(title_valid2),
            .state_in(h_state2),
            .char_bit_in(char_bit[3:0]),
            .ext_code_valid_in(0),//�����ڵڶ��е�������ʾ           
            .ext_code_in(0),
            
            .char_code_out(char_code2)//�ַ�����              
            );
edgeliner l3(                                                                                         
    ////״̬����////////                                           
                      
    /////��������/////////                                         
    .choosed_in(choosed3),//��ɫ�ź�                                    
    .last_in(0),//ȥ��β���ź�                                     
    ////////λ������/////////                                      
    //input [6:0] horiz_pixel_in,//����108������ ����λ���ݱ�ʾ            
    .verti_pixel_in(v_pixel3),//����62������ 0-61                  
    .title_valid_out(title_valid3),                                                           
    /////////�ַ���Ϣͨ��//////////                                  
//    output []                                                
    .char_height_out(char_height3),//�ַ��߶�                                           
    .pixel_color_in(pixel_color),                                      
    .pixel_color_out(color3)
    );
    edgeline_rom3(
            .title_valid_in(title_valid3),
            .state_in(h_state3),
            .char_bit_in(char_bit[3:0]),
            .ext_code_valid_in(0),//�����ڵڶ��е�������ʾ           
            .ext_code_in(0),
            
            .char_code_out(char_code3)//�ַ�����              
            );
edgeliner l4(                                                                                         
    ////״̬����////////                                           
                       
    /////��������/////////                                         
    .choosed_in(choosed4),//��ɫ�ź�                                    
    .last_in(0),//ȥ��β���ź�                                     
    ////////λ������/////////                                      
    //input [6:0] horiz_pixel_in,//����108������ ����λ���ݱ�ʾ            
    .verti_pixel_in(v_pixel4),//����62������ 0-61                  
    .title_valid_out(title_valid4),                                                           
    /////////�ַ���Ϣͨ��//////////                                  
//    output []                                                
    .char_height_out(char_height4),//�ַ��߶�                     
                       
    .pixel_color_in(pixel_color),                                      
    .pixel_color_out(color4)
    );
    edgeline_rom4(
            .title_valid_in(title_valid4),
            .state_in(h_state4),
            .char_bit_in(char_bit[3:0]),
            .ext_code_valid_in(amp_data_valid),//�����ڵڶ��е�������ʾ           
            .ext_code_in({space,space,amp_freq_code,space,space}),
            
            .char_code_out(char_code4)//�ַ�����              
            );
edgeliner l5(                                                                                         
    ////״̬����////////                                           
                      
    /////��������/////////                                         
    .choosed_in(choosed5),//��ɫ�ź�                                    
    .last_in(1),//ȥ��β���ź�                                     
    ////////λ������/////////                                      
    //input [6:0] horiz_pixel_in,//����108������ ����λ���ݱ�ʾ            
    .verti_pixel_in(v_pixel5),//����62������ 0-61                  
    .title_valid_out(title_valid5),                                                           
    /////////�ַ���Ϣͨ��//////////                                  
//    output []                                                
    .char_height_out(char_height5),//�ַ��߶�                     
                       
    .pixel_color_in(pixel_color),                                      
    .pixel_color_out(color5)
    );
    edgeline_rom5(
            .title_valid_in(title_valid5),
            .state_in(h_state5),
            .char_bit_in(char_bit[3:0]),
            .ext_code_valid_in(0),//�����ڵڶ��е�������ʾ           
            .ext_code_in(0),
            
            .char_code_out(char_code5)//�ַ�����              
            );

    reg [2:0] char_state = 0;
    edgeline_char_state(
                .char_state_in(char_state),
                
                .char_height_out(char_height),//��ǰ���ظ߶�
//                .char_bit_in(char_bit[3:0]),//���д13.5����/////////////////ע�⣬�ӿڲ���Ӧ
                .char_code_out(char_code),//��ǰ�ַ�����
//                .pixel_color_in(pixel_color),
                ////////////////////////�����ӿ�//////////////////////////////
                .char_height0_in(char_height0),
//                output reg[3:0] char_bit0_out,
                .char_code0_in(char_code0),//********************���ó�������
//                output reg pixel_color0_out,//*************************��Ӧ�ı��ߵ����ַ���ʾģ�����ó������ͣ����������ˣ������߲�ͨ����һ��ģ�飬ֱ��������ĳ����и�ֵ
                
                .char_height1_in(char_height1),  
//                output reg[3:0] char_bit1_out,
                .char_code1_in(char_code1),    
//                output reg pixel_color1_out,  
                
                .char_height2_in(char_height2),  
//                output reg[3:0] char_bit2_out,
                .char_code2_in(char_code2),    
//                output reg pixel_color2_out,  
                
                .char_height3_in(char_height3),  
//                output reg[3:0] char_bit3_out,
                .char_code3_in(char_code3),    
//                output reg pixel_color3_out,  
                
                .char_height4_in(char_height4),  
//                output reg[3:0] char_bit4_out,
                .char_code4_in(char_code4),    
//                output reg pixel_color4_out,  
                
                .char_height5_in(char_height5),  
//                output reg[3:0] char_bit5_out,
                .char_code5_in(char_code5)
//                output reg pixel_color5_out 
                );
    
    always@(posedge clk_in)//�½��ش����������ʾ�ڴ��������ش�������ʱ�ӱ�֤д�ڴ�ʱ��ַ�������ȶ�
        if(x_axis == 7'd107) 
            begin//��0��511
                x_axis = 0;
                if(y_axis == 9'd479)//�д�0��479,480������
                     y_axis = 0;
                else
                     y_axis = y_axis + 1;
            end
        else
            x_axis = x_axis + 1;
    reg btn_rom_ena;
    wire[6:0] btn_y_axis;
    reg[13:0] btninfo_addr;
    assign btn_y_axis = (y_axis >= 9'd372)? (y_axis - 9'd372) : 7'd0;
    //assign btninfo_addr = (btn_y_axis * 7'd108) + x_axis; //������
    wire btn_color;
    btninfo_rom(
        .clk_in(clk_in),
        .ena_in(btn_rom_ena),
        .btninfo_addra(btninfo_addr),//[13:0]
        .keyval_in(keyval_in),
        .x_axis_in(x_axis),
        .y_axis_in(btn_y_axis),
        .btninfo_douta(btn_color)
        );
    always@(negedge clk_in)
    begin
        edgeline_addr_out = (y_axis * 108) + x_axis;
        if(y_axis < 62)/////////////////////////////////////////////////��һ��
            begin
                v_pixel0 <= y_axis;
                v_pixel1 <= 0;
                v_pixel2 <= 0;
                v_pixel3 <= 0;
                v_pixel4 <= 0;
                v_pixel5 <= 0;
                btn_rom_ena <= 0;
                char_state <= 3'd0;
                color_out <= color0;
                wea_out <= 1'b1;
            end
        else if(y_axis < 124)
            begin
                v_pixel0 <= 0;
                v_pixel1 <= y_axis - 62;
                v_pixel2 <= 0;
                v_pixel3 <= 0;
                v_pixel4 <= 0;
                v_pixel5 <= 0;
                btn_rom_ena <= 0;
                char_state <= 3'd1; 
                color_out <= color1;
                wea_out <= 1'b1;    
            end
        else if(y_axis < 186)
            begin
                v_pixel0 <= 0;
                v_pixel1 <= 0;
                v_pixel2 <= y_axis - 124;
                v_pixel3 <= 0;
                v_pixel4 <= 0;
                v_pixel5 <= 0;
                btn_rom_ena <= 0;
                char_state <= 3'd2; 
                color_out <= color2;
                wea_out <= 1'b1;    
            end
        else if(y_axis < 248)
            begin
                v_pixel0 <= 0;
                v_pixel1 <= 0;
                v_pixel2 <= 0;
                v_pixel3 <= y_axis - 186;
                v_pixel4 <= 0;
                v_pixel5 <= 0;
                btn_rom_ena <= 0;
                char_state <= 3'd3; 
                color_out <= color3;
                wea_out <= 1'b1;    
            end
        else if(y_axis < 310)
            begin
                v_pixel0 <= 0;
                v_pixel1 <= 0;
                v_pixel2 <= 0;
                v_pixel3 <= 0;
                v_pixel4 <= y_axis - 248;
                v_pixel5 <= 0;
                btn_rom_ena <= 0;
                char_state <= 3'd4; 
                color_out <= color4;
                wea_out <= 1'b1;    
            end
        else if(y_axis < 372)
            begin
                v_pixel0 <= 0;
                v_pixel1 <= 0;
                v_pixel2 <= 0;
                v_pixel3 <= 0;
                v_pixel4 <= 0;
                v_pixel5 <= y_axis - 310;
                btn_rom_ena <= 0;
                char_state <= 3'd5; 
                color_out <= color5;
                wea_out <= 1'b1;    
            end
        else
            begin
                btn_rom_ena <= 1;
                if(btninfo_addr == 14'd11663)
                    btninfo_addr <= 14'd0;
                else
                    btninfo_addr <= (btn_y_axis * 7'd108) + x_axis;
                char_state <= 3'd0; 
                color_out <= ~btn_color;
                wea_out <= 1'b1;    
            end
    end
        
        
endmodule
