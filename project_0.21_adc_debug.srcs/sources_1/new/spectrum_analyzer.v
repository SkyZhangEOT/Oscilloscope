`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/03/12 22:43:05
// Design Name: 
// Module Name: spectrum_analyzer
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


 module spectrum_analyzer(
    input clk,
    input vauxp6,vauxn6,
    input vauxp7,vauxn7,
    input vauxp14,vauxn14,
    input vauxp15,vauxn15,
    input [11:0] sw,
    input [3:0] col,
    output wire[3:0] row,
    output wire[7:0] seg,
    output wire[5:0] an,
    output wire[11:0] led,
    output wire Hsync,
    output wire Vsync,
    output wire[3:0] vgaRed,
    output wire[3:0] vgaBlue,
    output wire[3:0] vgaGreen
    );

//    wire[23:0] seg_data;//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//    assign seg_data = {16'h0000,wea_choosed,3'b000,3'b000,stop};//�����@@@@@@@@@@@@@@@@@

//    ila_0 instance_ila(
//    .clk(clk),
//    .probe0(wave_ori_pos),
//    .probe1(key_value)
//    );
/**********************************ʱ�ӹ���ģ�飬���ɵ�Ƶʱ��*******************************************/

 
//wire clk_VGA;//25.175
wire clk25M;
wire clk20M;       
wire clk10M;         
wire clk5M;          
wire clk2M;          
wire clk1M;          
wire clk500k;        
wire clk200k;        
wire clk100k;        
wire clk50k;         
wire clk20k;         
wire clk10k;         
wire clk5k;          
wire clk2k;          
wire clk1k;          
wire clk500;         
wire clk100;         
wire clk10;          
wire clk1Hz;          


    wire[15:0] key_value;
    wire key_pressed;
    wire clk_choosed;
    wire[3:0] clk_state;

    wire[2:0] h_state1;
    wire signal_clk;

clk_manager instance_clk_manager(
    .clk_in(clk),
    .key_pressed_in(key_pressed),
    .keyval_in(key_value),
    .h_state1_in(h_state1),
    .clk_state_out(clk_state),
    .clk_choosed_out(clk_choosed),
//    .clk_VGA_out(clk_VGA),//25.175
    .clk25M_out(clk25M),
    .clk20M_out(clk20M),
    .clk10M_out(clk10M),
    .clk5M_out(clk5M),
    .clk2M_out(clk2M),
    .clk1M_out(clk1M),
    .clk500k_out(clk500k),
    .clk200k_out(clk200k),
    .clk100k_out(clk100k),
    .clk50k_out(clk50k),
    .clk20k_out(clk20k),
    .clk10k_out(clk10k),
    .clk5k_out(clk5k),
    .clk2k_out(clk2k),
    .clk1k_out(clk1k),
    .clk500_out(clk500),
    .clk100_out(clk100),
    .clk10_out(clk10),
    .clk1Hz_out(clk1Hz),
    .signal_clk_out(signal_clk)
    );
    

     


/********************************************������̲ɼ�************************************************/

    keyscan instance_keyscan(
        .clk_in(clk1k),   //ɨ��ʱ��800Hz��������50Hz
        .reset_in(0),
        .keycol_in(col),
        .keyrow_out(row),    //�����������λ             
        .keyval_out(key_value),          //���������ֵ
        .key_pressed_out(key_pressed)
    );
/********************************************������̲ɼ�����********************************************/

/**********************************ʱ�ӹ���ģ�飬���ɵ�Ƶʱ�ӽ���****************************************/

     disp_seg instance_disp_seg(
    .clk_in(clk1k),
    .clk_state_in(clk_state),
    .seg_out(seg),
    .an_out(an)
    );
/*****************************************XADC�źŲɼ�ģ��***********************************************/
//    wire [15:0] measured_temp;
//    wire [15:0] measured_vccint;
//    wire [15:0] measured_vccbram;
    wire [15:0] measured_aux6;
    wire [15:0] measured_aux7;
    wire [15:0] measured_aux14;
    wire [15:0] measured_aux15;
    wire [7:0] adc_state;
    xadc_seq instance_xadc_seq(
        .clk25M_in(clk25M),
        .clk20M_in(clk20M),
        .clk10M_in(clk10M),
        .clk5M_in(clk5M),
        .clk1M_in(clk1M),
        .DCLK(clk),           //ʱ������ 50MHz
        .RESET(0),
        .VAUXP6(vauxp6),
        .VAUXN6(vauxn6),
        .VAUXP7(vauxp7),
        .VAUXN7(vauxn7),  //ģ�⸨������ͨ��7��ͨ����17h
        .VAUXP14(vauxp14),
        .VAUXN14(vauxn14),//ģ�⸨������ͨ��14��ͨ����1eh
        .VAUXP15(vauxp15),
        .VAUXN15(vauxn15),//ģ�⸨������ͨ��14��ͨ����1eh
//        .MEASURED_TEMP(measured_temp),
//        .MEASURED_VCCINT(measured_vccint),
//        .MEASURED_VCCBRAM(measured_vccbram),
        .MEASURED_AUX6(measured_aux6),
        .MEASURED_AUX7(measured_aux7),
        .MEASURED_AUX14(measured_aux14),
        .MEASURED_AUX15(measured_aux15)
//        .state(adc_state)//������
    );
/*****************************************XADC�źŲɼ�ģ�����*******************************************/
    wire [7:0] test_square;
    wire [7:0] test_tangle;
    wire [7:0] test_sin;
    signal_generator instance_signal_generator(
        .clk_in(signal_clk),
        .test_square_out(test_square),
        .test_tangle_out(test_tangle),
        .test_sin_out(test_sin)
        );
/*******************************************ͬ��ģ��*********************************************/
    wire signed [11:0] trigger_level;
    wire[3:0] bit_choose;
    wire[7:0] wave_ori_pos;
    wire[7:0] trigger_level_raw;
    trigger_level instance_trigger_level(
        .key_pressed_in(key_pressed),
        .keyval_in(key_value),
        .bit_choose_in(bit_choose),//bit�Ŵ���
        .wave_ori_pos_in(wave_ori_pos),//x��λ��
        .trigger_level_raw_out(trigger_level_raw),
        .trigger_level_out(trigger_level)//signed
        );
/*********************************����ͬ��ģ��**********************************************/
    wire wave_wea;
    wire [8:0] wave_addra;
    wire signed [11:0] wave_dataa;
    wire signed [11:0] wave_data_cnt;
    wire[15:0] sync_count;
    wire sync_trigger;
    //////////test///////////////
//    wire[1:0] sync_state;
    wire[2:0] h_state0;
    wire[2:0] h_state2;
    wire[2:0] h_state3;
    sync_manager(
        .clk_in(clk),
        .divclk_in(clk_choosed),
        //    input [11:0] sw_in,
        .h_state0_in(h_state0),//ͨ������
        .h_state2_in(h_state2[1:0]),//��λ��3��ѡ�� ������ʽ���� 0:��ͳ��1:˲̬�� 2:���˲̬
        .h_state3_in(h_state3),//��ƽλ�ÿ���
        
        .level_in((trigger_level)),
        .freq_trigger_in(0),//Ƶ�ʴ���
        
        .measured_aux14_in(measured_aux14[15:4]),
        .measured_aux7_in(measured_aux7[15:4]),
        .measured_aux6_in(measured_aux6[15:4]),
        .measured_aux15_in(measured_aux15[15:4]),
        .test_square_in(test_square),
        .test_tangle_in(test_tangle),
        .test_sin_in(test_sin),
        
        .wave_wea_out(wave_wea),
        .wave_addr_out(wave_addra),
        .wave_data_out(wave_dataa),//������ǲ���
        
        .wave_data_cnt_out(wave_data_cnt),
        .trigger_out(sync_trigger),
        .count_out(sync_count)//������ʱ��Ҫ��2//һ����count1����������С1��һ���Ǵ���������ʼʱ�Ѿ��߹���һ��ʱ�ӣ�û�м���count,��waveinfo_calculator�м���
        );

/*******************************************�������ݴ洢ģ��*********************************************/
wire search_en;

wire wavegener_wea;
wire wavefft_wea;

wire wavefft_state;
stop_control(
    .wave_kc_in(key_value[9]),
    .spec_kc_in(key_value[11]),
    
    .wave_wea_in(wave_wea),
    
    .search_en_in(search_en),
    
    .wavegener_wea_out(wavegener_wea),
    .wavegener_state_out(),//0 ��ͣ
    
    .wavefft_wea_out(wavefft_wea),
    .wavefft_state_out(wavefft_state)//0 ��ͣ
    );

    wire[8:0] wave_addr_gener;
    wire[8:0] wave_addr_fft;
    wire[11:0] wave_data_gener;
    wire[11:0] wave_data_fft;
    wave_ram instance0_wave_ram(
        .clk_in(clk),
        .wea_in(wavegener_wea),//no problem
        .wave_addra_in(wave_addra),//[8��0]no problem
        .wave_data_in(wave_dataa),//[15:0]�������뵽ԭ�� problem
        .wave_addrb_in(wave_addr_gener),//
        .wave_data_out(wave_data_gener)//[15:0]
    );
    wave_ram instance1_wave_ram(
        .clk_in(clk),
        .wea_in(wavefft_wea),//no problem
        .wave_addra_in(wave_addra),//[8��0]no problem
        .wave_data_in(wave_dataa),//[15:0]�������뵽ԭ�� problem
        .wave_addrb_in(wave_addr_fft),//
        .wave_data_out(wave_data_fft)//[15:0]
    );

/*****************************************�������ݴ洢ģ�����*******************************************/
/************* ����fft�����ģ�� **************/


//    wire[3:0] state;
//    spec_control instance_spec_control(
//        .keyval_in(key_value[11]),
//        .wave_addr_gener_in(wave_addr_gener),//�����������ĵ�ַ���
//        .wave_addr_fft_in(wave_addr_fft),//fft����ģ��ĵ�ַ���
//        .wave_data_in(wave_datab),//����ram���������루����2ѡ1��ַ��
//        .wave_addr_out(wave_addrb),//2ѡ1�ĵ�ַ                      ��ram
//        .wave_data_gener_out(wave_data_gener),//���������������������
//        .wave_data_fft_out(wave_data_fft),//�����fftģ�������
//        .state_out(state)//ϵͳ״̬
//    );
    
    //////////////////////////////////

    wave_xorigin instance_wave_xorigin(
        .key_pressed_in(key_pressed),
        .keyval_in(key_value),
        .wave_ori_pos_out(wave_ori_pos)
        );
    ////////////////////////////////////
    /**********************************************��������ģ��**********************************************/
    wire[7:0] wave_data_8bit;
    wave_bit_choose instance_wave_bit_choose(
        .wave_data_in(wave_data_gener),//������и�ֵ�����ӿ�û�ж��壬��֪���᲻��ת��
        .wave_ori_pos_in(wave_ori_pos),
        .key_pressed_in(key_pressed),
        .keyval_in(key_value),
        .bit_choose_out(bit_choose),
        .wave_data_out(wave_data_8bit)//���8λֱ�ӻ������ݣ�Ӧ�����ӳ�
        );

        wire [16:0] generwave_addra;
        wire [1:0] generwave_color;
        wire wave_disp_wea;
        wire stop;//�Ƿ�ֹ��Ļ
    wave_generator instance_wave_g(
        .clk_in(clk),//DCLK 50MHz
        .reset_in(0),
        .col_val_out(wave_addr_gener),//�����������ĵ�ַ�������������ѡ���Ƿ��͵�����ram��//
        .wave_in(wave_data_8bit),//�������������������룬���Կ�����������ram
        .disp_wave_addr_out(generwave_addra),//����������Դ�A�ڵĵ�ַ
        .color_out(generwave_color),//Ҫд�������Դ�����ݣ���ɫ��15λ
        .wea_out(wave_disp_wea)//�Դ�A�ڵ�дʹ��
    );

    
    /*******************************************��������ģ�����*********************************************/

/************* fft����ģ�� ***************/
    wire fft_valid;
    wire[8:0] spec_addra;
    wire[48:0] amp;
    fft instance_fft(
    .clk_in(clk),
    .aresetn(1),
    .systemstate_in(wavefft_state),//[3:0]
    .wave_addr_out(wave_addr_fft),//[8:0]
    .wave_data_in(wave_data_fft[11:4]),//[7:0]
    .fft_valid_out(fft_valid),
    .spec_addr_out(spec_addra),//[8:0]
    .amp_out(amp)//[46:0]
    );
    


    wire[7:0] amp_data;
    spec_bit_choose instance_spec_bit_choose(
        .amp_in(amp),
        .key_pressed_in(key_pressed),
        .keyval_in(key_value),
        .amp_data_out(amp_data)//8λ
        );
        


    wire[8:0] spec_addrb;
    wire[7:0] spec_data;

    spec_ram instance_spec_ram(
    .clk_in(clk),
    .fft_valid_in(fft_valid),
    .search_en_in(search_en),
    .spec_addra_in(spec_addra),//fftģ��ĵ�ַ���
    .spec_data_in(amp_data),//fft��������������浽Ƶ��ram��
    .spec_addrb_in(spec_addrb),//[8:0]Ƶ���������ĵ�ַ���루������ȡƵ�����ݣ�
    .spec_data_out(spec_data)//[7:0]Ƶ������������͵�Ƶ����������
    );
    wire[16:0] generspec_addra;
    wire[1:0] generspec_color;
    wire gener_wea;
    
    
    wire spec_level_en;
    wire[7:0] amp_addr_ans;
    wire search_no_data;
    wire[7:0] spec_level;
    spec_generator instance_spec_g(
        .clk_in(clk),//DCLK 50MHz
        .reset_in(0),//RESET ��λ�źţ���ʱ����
        .key_pressed_in(key_pressed),
        .key_lr_in({key_value[13],key_value[15]}),
        .col_val_out(spec_addrb),//Ƶ���������ĵ�ַ�����������ȡƵ�����ݣ�
        .spec_in(spec_data),//Ƶ������������������
        
        .search_en_in(search_en),
        .spec_level_en_in(spec_level_en),
        
        .amp_addr_ans_out(amp_addr_ans),
        .search_no_data_out(search_no_data),
        .spec_level_out(spec_level),
        
        .disp_spec_addr_out(generspec_addra),//�����Ƶ���Դ�A�ڵĵ�ַ
        .color_out(generspec_color),//Ҫд��Ƶ���Դ�����ݣ���ɫ��
        .wea_out(gener_wea)//Ƶ���Դ�A�ڵ�дʹ��
        );


/*****************************************��ʾ�ڴ�ģ��***************************************************/
//û����
//wire wave_disp_wea_choosed;
//    wave_stop instance_wave_stop(//��ģ��ѡ���Ƿ�дʹ�ܣ��Ӷ�ѡ���Ƿ�ֹ��Ļ
//    .keyval_in(key_value[9]),
//    .wea_disp_ram(wave_disp_wea),//���Բ����������Դ�дʹ��
//    .state_in(state),//ϵͳ״̬����
//    .wea_disp_ram_choosed(wave_disp_wea_choosed),//��15��������дʹ���Ƿ���Ч
//    .no_stop(stop)//@@@@@@@@@@@@@@@@@@@@�����ã�����
//    );
//    reg[11:0] led_temp = 0; 
//    always@(stop)
//        led_temp[0] = stop;//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//    assign led = led_temp;


wire[15:0] edgeline_addra;
wire edgeline_dina;
wire edgeline_wea;
 edge_line_manager instance_edge_line_manager(
   .clk_in(clk),
   .clk1Hz_in(clk10),
   //.sw_in(sw),
   .key_pressed_in(key_pressed),
   .keyval_in(key_value),//16bit
   
   .clk_state_in(clk_state),
   .addr_ans_in(amp_addr_ans),
   .no_data_in(search_no_data),
   
   .h_state0(h_state0),//ͨ�������ź�
   .h_state1(h_state1),//�ڲ�Ƶ�ʿ����ź�
   .h_state2(h_state2),//������ʽ�����ź�
   .h_state3(h_state3),//����λ�ÿ����ź�
   .choosed4(search_en),
   .choosed5(spec_level_en),
   
   .edgeline_addr_out(edgeline_addra),//������Դ�A�ڵĵ�ַ
   .color_out(edgeline_dina),//Ҫд���Դ�����ݣ���ɫ��
   .wea_out(edgeline_wea)//�Դ�A�ڵ�дʹ��
   );
    wire dispwave_enb;
    wire dispspec_enb;
    wire[16:0] dispwave_addrb;
    wire[16:0] dispspec_addrb;
    wire[1:0] dispwave_color;
    wire[1:0] dispspec_color;
    wire edgeline_enb;
    wire [15:0] edgeline_addrb;
    wire edgeline_color;
    display_ram instance_disp_ram(//û����
        .clk_in(clk),
        .dispwave_wea_in(wave_disp_wea),//stopģ�������дʹ��
        .dispwave_addra_in(generwave_addra),//�����Դ�˿�a��ַ��17λ��ַ��16��0�������Բ���������
        .dispwave_dina_in(generwave_color),//�˿�a�������� 6λ��5��0�������Բ���������
        .dispwave_enb_in(dispwave_enb),//�˿�bʹ�ܣ�����vga����
        .dispwave_addrb_in(dispwave_addrb),//�˿�b��ȡ��ַ���� 17λ��16��0��������vga����
        .dispwave_doutb_out(dispwave_color),//�˿�b��� 6λ��5��0��������vga����
        .dispspec_wea_in(gener_wea),//Ƶ���Դ�a�ڵ�дʹ�ܣ�����Ƶ��������
        .dispspec_addra_in(generspec_addra),//�˿�a��ַ//17λ��ַ������Ƶ��������
        .dispspec_dina_in(generspec_color),//�˿�����6λ������Ƶ��������
        .dispspec_enb_in(dispspec_enb),//�˿�bʹ�ܣ�����vga����
        .dispspec_addrb_in(dispspec_addrb),//�˿�b��ַ//17λ��ַ������vga����
        .dispspec_doutb_out(dispspec_color),//�˿�b���6λ������vga����
        .edgeline_wea_in(edgeline_wea),                         
        .edgeline_addra_in(edgeline_addra),//�˿�a��ַ//15λ��ַ  
        .edgeline_dina_in(edgeline_dina),//�˿�����6λ                
        .edgeline_enb_in(edgeline_enb),//�˿�bʹ��                  
        .edgeline_addrb_in(edgeline_addrb),//�˿�b��ַ//17λ��ַ  
        .edgeline_doutb_out(edgeline_color)//�˿�b���6λ             
    );
    
//                       ila_0 instance_ila_0(
//                           .clk(clk),
//                            .probe0(edgeline_wea),
//                            .probe1(edgeline_addra),
//                            .probe2(edgeline_dina),
//                            .probe3(edgeline_enb),
//                            .probe4(edgeline_addrb),
//                            .probe5(edgeline_color)
    //                        .probe6(volt_sum_data),
    //                        .probe7(volt_sum_data_abs),
    //                        .probe8(sync_state)
    //                        .probe9(lenth),
    //                        .probe10(real_lenth)
//                                    );
/*****************************************��ʾ�ڴ�ģ�����***********************************************/
/*****************************************��ʾ�ڴ�ģ�����***********************************************/
/*****************************************��ʾ�ڴ�ģ�����***********************************************/
/*****************************************��ʾ�ڴ�ģ�����***********************************************/
wire[8:0] pixel_bit;
wire[3:0] char_height;
wire[5:0] char_bit;
wire[5:0] char_code;
wire pixel_color;
digit_write instance_digit_write(//�����
    .clk_in(clk),
//    input dwen,//��ǰ�������ڣ�������ǰʹ��
//�������Ҫ�Ҷ��룬��ô�Ͳ���Ҫ�����ܿ����    input [7:0] pixel_num_in,//���ؿ��
    .pixel_bit_in(pixel_bit),//��ǰ����λ,���512������ok
    .char_height_in(char_height),//��ǰ�߶ȣ�ok
//�������Ҫ�Ҷ��룬��ô�Ͳ���Ҫ���ַ�����    input [4:0] char_num_in,//���ַ��� 
    .char_bit_out(char_bit),//��ǰ�ַ�λ��ok���64���ַ�
    .char_code_in(char_code),//��ǰ�ַ�����,ok
    .pixel_color_out(pixel_color)//������ɫ,ok
    );
    wire[1:0] inf_state;
    wire inf_disp_ram_wea;
    wire[14:0] inf_disp_ram_addra;
    wire inf_colora;
    inf_calculate_display instance_inf_calculate_display(//���㣬ɨ��͸��Դ渳ֵ����
        .clk_in(clk),
        .state_in(inf_state),//0:����wave��д�Դ棻1:����spec��д�Դ棺2,3:��ȡ�Դ�
        .clk1Hz_in(clk1Hz),
        .divclk_in(clk_choosed),
        .sync_trigger_in(sync_trigger),
        .sync_count_in(sync_count),
        .signal_in(wave_data_cnt),
        .clk_state_in(clk_state),
        .bit_choose_in(bit_choose),
        ///////////д�ֲ���//////////
        .pixel_bit_out(pixel_bit),//��ǰ����λ
        .char_height_out(char_height),
        .char_bit_in(char_bit),
        .char_code_out(char_code),
        .pixel_color_in(pixel_color),
        //////////�Դ沿��////////////
        .inf_disp_ram_wea_out(inf_disp_ram_wea),
        .inf_disp_ram_addr_out(inf_disp_ram_addra),
        .color_out(inf_colora)
        );
    wire inf_disp_ram_enb;
    wire[14:0]inf_disp_ram_addrb;
    wire inf_colorb;
    waveinf_disp_ram instance_waveinf_disp_ram(//�Դ�
        .clk_in(clk),
        .ena_in(1),
        .wea_in(inf_disp_ram_wea),
        .addra_in(inf_disp_ram_addra),//15λ��ַ
        .dataa_in(inf_colora),
        .enb_in(inf_disp_ram_enb),
        .addrb_in(inf_disp_ram_addrb),
        .datab_out(inf_colorb)
        );


/*******************************************vga���ģ��**************************************************/
/*******************************************vga���ģ��**************************************************/
/*******************************************vga���ģ��**************************************************/
/*******************************************vga���ģ��**************************************************/
    display_vga instance_disp_vga(//û����
        .clk_in(clk),//640*480@60Hz
        
        .wave_color_in(dispwave_color),//6λ��ɫ����,
        .spec_color_in(dispspec_color),
        .info_color_in(inf_colorb),
        .edgeline_color_in(edgeline_color),
        
        .wave_ori_pos_in(wave_ori_pos),
        .trigger_level_in(trigger_level_raw),
        .spec_level_in(spec_level),
        
        .Hsync_out(Hsync),
        .Vsync_out(Vsync),
        .vgaRed_out(vgaRed),
        .vgaGreen_out(vgaGreen),
        .vgaBlue_out(vgaBlue),
        
        .state_out(inf_state),
        .wave_addr_out(dispwave_addrb),//�Դ��ַ�����
        .wave_enb_out(dispwave_enb),//enbB�˿�дʹ�ܣ�**********�Ƿ����Դ����ݵ�ʹ���źţ�
        .spec_addr_out(dispspec_addrb),
        .spec_enb_out(dispspec_enb),
        .info_addr_out(inf_disp_ram_addrb),
        .info_enb_out(inf_disp_ram_enb),
        .edgeline_addr_out(edgeline_addrb),//[15:0]
        .edgeline_enb_out(edgeline_enb)

    );
endmodule
