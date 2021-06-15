`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/14 15:38:39
// Design Name: 
// Module Name: sim_fft_specg_dispram_vga
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


module sim_fft_specg_dispram_vga;
    reg clk = 0;
    always #10
        clk = !clk;

    
    wire[11:0] sw;//����
    assign sw = 12'h001;
    
    reg[15:0] measured_temp;//////////�������������ó���ʱ100�ķ���
    reg wave_flag = 0;
    always #100
        wave_flag = !wave_flag;
    always@(wave_flag)
        if(wave_flag)
             measured_temp = 16'd32767;
        else
            measured_temp = 16'd0;
    
    wire[15:0] measured_vccint;
    assign measured_vccint = 0;
    wire[15:0] measured_aux7;
    assign measured_aux7 = 0;
    wire[15:0] measured_aux14;
    assign measured_aux14 = 0;
    
    wire[8:0] wave_addr;
    wire[7:0] wave_data;
    
    wave_ram uut_wave_ram(
        .divclk_in(clk),//������λ�Ĵ�����ʱ��
        .sw_in(sw),//���뿪��ѡ��ģ������ͨ��
        .MEASURED_TEMP_in(measured_temp),//�������¶�ֵ����
        .MEASURED_VCCINT_in(measured_vccint),//�������ں˵�ѹ����
        .MEASURED_AUX7_in(measured_aux7),//ͨ��7����ֵ����
        .MEASURED_AUX14_in(measured_aux14),//ͨ��7����ֵ����
        .wave_addr_in(wave_addr),//��ȡ���ݵĵ�ַ
        .wave_data(wave_data)//@@@@@@@@@@@@@@@@@@@@@@@@�������Ҫ��out
    );
    
        reg [15:0] key_value = 0;/////////
        initial
        begin
            #200000//#20�ɼ�һ�����ݣ�100000������֮���л���fft
            key_value[14] = 1'b1;
            #500
            key_value = 0;
        end
        
        wire wea;
        wire[3:0] state;
        wire wea_choosed;
    wave_stop uut_wave_stop(//��ģ��ѡ���Ƿ�дʹ�ܣ��Ӷ�ѡ���Ƿ�ֹ��Ļ
        .keyval_in(key_value[15]),
        .wea_disp_ram(wea),
        .state_in(state),
        .wea_disp_rem_choosed(wea_choosed),//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        .no_stop()//@@@@@@@@@@@@@@@@@@@@�����ã�����
        );

    wire[8:0] wave_addr_gener;
    wire[8:0] wave_addr_fft;
    wire[7:0] wave_data_gener;
    wire[7:0] wave_data_fft;
    
    spec_control uut_spec_control(
    .keyval_in(key_value[14]),
    .wave_addr_gener_in(wave_addr_gener),
    .wave_addr_fft_in(wave_addr_fft),
    .wave_data_in(wave_data),
    .wave_addr_out(wave_addr),
    .wave_data_gener_out(wave_data_gener),
    .wave_data_fft_out(wave_data_fft),
    .state_out(state)
    );
    
    wire fft_valid;
    wire[15:0] spec_addra;
    wire[46:0] amp;
        fft_test2 uut_fft(
        .clk_in(clk),
        .aresetn(1),
        .state_in(state),//[3:0]
        .wave_data_in(wave_data_fft),//[7:0]
        .wave_addr_out(wave_addr_fft),//[8:0]
        .fft_valid_out(fft_valid),
        .m_axis_data_tuser(spec_addra),//[15:0]
        .amp_out(amp)//[46:0]
        );
        
        wire[8:0] spec_addra_input;
        assign spec_addra_input = spec_addra[8:0];
        wire[8:0] spec_addrb;
        wire[11:0] spec_data;
        
            spec_ram uut_spec_ram(
        .clk_in(clk),
        .fft_valid_in(fft_valid),
        .spec_addra_in(spec_addra_input),//[8��0]���뵽specram�ĵ�ַ��9λ����fftģ�������ĵ�ַȴ��16λ
        .spec_data_in(amp),//[46:0]���ø���
        .spec_addrb_in(spec_addrb),//[8:0]
        .spec_data_out(spec_data)//[11:0]
        );
        
        wire[16:0] generspec_addra;
        wire[5:0] generspec_color;
        wire gener_wea;
            spec_generator uut_spec_g(
            .clk_in(clk),//DCLK 50MHz
            .reset_in(0),//RESET ��λ�źţ���ʱ����
            .col_val_out(spec_addrb),//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!������9λ������Ϊ��ַ�᲻�����
            .spec_in(spec_data),//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@12λ
            .disp_spec_addr_out(generspec_addra),//������Դ�A�ڵĵ�ַ
            .color_out(generspec_color),//Ҫд���Դ�����ݣ���ɫ��
            .wea_out(gener_wea)//�Դ�A�ڵ�дʹ��
            );
    
        wire[16:0] generwave_addra;
        wire[5:0] generwave_color;
        wave_generator uut_wave_g(
                .clk_in(clk),//DCLK 50MHz@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                .reset_in(0),
                .col_val_out(wave_addr_gener),
                .wave_in(wave_data_gener),
                .disp_wave_addr_out(generwave_addra),//������Դ�A�ڵĵ�ַ
                .color_out(generwave_color),//Ҫд���Դ�����ݣ���ɫ��15λ
                .wea_out(wea)//�Դ�A�ڵ�дʹ��
            );

            wire dispwave_enb;
            wire[16:0] dispwave_addrb;
            wire[5:0] dispwave_color;
            wire dispspec_enb;
            wire[16:0] dispspec_addrb;
            wire[5:0] dispspec_color;
                display_ram uut_disp_ram(
                .clk_in(clk),
                .dispwave_wea_in(wea_choosed),//дʹ��
                .dispwave_addra_in(generwave_addra),//�˿�a��ַ��17λ��ַ��16��0��
                .dispwave_dina_in(generwave_color),//�˿�a�������� 6λ��5��0��
                .dispwave_enb_in(dispwave_enb),//�˿�bʹ��
                .dispwave_addrb_in(dispwave_addrb),//�˿�b��ȡ��ַ���� 17λ��16��0��
                .dispwave_doutb_out(dispwave_color),//�˿�b��� 6λ��5��0��
                .dispspec_wea_in(gener_wea),//дʹ��
                .dispspec_addra_in(generspec_addra),//�˿�a��ַ//17λ��ַ
                .dispspec_dina_in(generspec_color),//�˿�����6λ
                .dispspec_enb_in(dispspec_enb),//�˿�bʹ��
                .dispspec_addrb_in(dispspec_addrb),//�˿�b��ַ//17λ��ַ
                .dispspec_doutb_out(dispspec_color)//�˿�b���6λ
            );
        /*****************************************��ʾ�ڴ�ģ�����***********************************************/
        /*******************************************vga���ģ��**************************************************/
        reg clk25M = 0;
        always@(posedge clk)
            clk25M = !clk25M;
        wire Hsync;
        wire Vsync;
        wire[3:0] vgaRed;
        wire[3:0] vgaGreen;
        wire[3:0] vgaBlue;
            display_vga uut_disp_vga(
                .clk_in(clk25M),//640*480@60Hz
                .wave_color_in(dispwave_color),//6λ��ɫ����,
                .spec_color_in(dispspec_color),
                .Hsync_out(Hsync),
                .Vsync_out(Vsync),
                .vgaRed_out(vgaRed),
                .vgaGreen_out(vgaGreen),
                .vgaBlue_out(vgaBlue),
                .wave_addr_out(dispwave_addrb),//�Դ��ַ�����
                .wave_enb_out(dispwave_enb),//enbB�˿�дʹ�ܣ�**********�Ƿ����Դ����ݵ�ʹ���źţ�
                .spec_addr_out(dispspec_addrb),
                .spec_enb_out(dispspec_enb)
            );
endmodule
