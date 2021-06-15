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

    
    wire[11:0] sw;//开关
    assign sw = 12'h001;
    
    reg[15:0] measured_temp;//////////将输入数据设置成延时100的方波
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
        .divclk_in(clk),//控制移位寄存器的时钟
        .sw_in(sw),//拨码开关选择模拟输入通道
        .MEASURED_TEMP_in(measured_temp),//测量的温度值输入
        .MEASURED_VCCINT_in(measured_vccint),//测量的内核电压输入
        .MEASURED_AUX7_in(measured_aux7),//通道7测量值输入
        .MEASURED_AUX14_in(measured_aux14),//通道7测量值输入
        .wave_addr_in(wave_addr),//提取数据的地址
        .wave_data(wave_data)//@@@@@@@@@@@@@@@@@@@@@@@@输出，需要加out
    );
    
        reg [15:0] key_value = 0;/////////
        initial
        begin
            #200000//#20采集一个数据，100000个周期之后，切换到fft
            key_value[14] = 1'b1;
            #500
            key_value = 0;
        end
        
        wire wea;
        wire[3:0] state;
        wire wea_choosed;
    wave_stop uut_wave_stop(//该模块选择是否写使能，从而选择是否静止屏幕
        .keyval_in(key_value[15]),
        .wea_disp_ram(wea),
        .state_in(state),
        .wea_disp_rem_choosed(wea_choosed),//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        .no_stop()//@@@@@@@@@@@@@@@@@@@@测试用，多余
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
        .spec_addra_in(spec_addra_input),//[8：0]输入到specram的地址是9位，从fft模块的输出的地址却是16位
        .spec_data_in(amp),//[46:0]不用根据
        .spec_addrb_in(spec_addrb),//[8:0]
        .spec_data_out(spec_data)//[11:0]
        );
        
        wire[16:0] generspec_addra;
        wire[5:0] generspec_color;
        wire gener_wea;
            spec_generator uut_spec_g(
            .clk_in(clk),//DCLK 50MHz
            .reset_in(0),//RESET 复位信号，暂时不用
            .col_val_out(spec_addrb),//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!待测用9位长度作为地址会不会溢出
            .spec_in(spec_data),//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@12位
            .disp_spec_addr_out(generspec_addra),//输出给显存A口的地址
            .color_out(generspec_color),//要写到显存的数据（颜色）
            .wea_out(gener_wea)//显存A口的写使能
            );
    
        wire[16:0] generwave_addra;
        wire[5:0] generwave_color;
        wave_generator uut_wave_g(
                .clk_in(clk),//DCLK 50MHz@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                .reset_in(0),
                .col_val_out(wave_addr_gener),
                .wave_in(wave_data_gener),
                .disp_wave_addr_out(generwave_addra),//输出给显存A口的地址
                .color_out(generwave_color),//要写到显存的数据（颜色）15位
                .wea_out(wea)//显存A口的写使能
            );

            wire dispwave_enb;
            wire[16:0] dispwave_addrb;
            wire[5:0] dispwave_color;
            wire dispspec_enb;
            wire[16:0] dispspec_addrb;
            wire[5:0] dispspec_color;
                display_ram uut_disp_ram(
                .clk_in(clk),
                .dispwave_wea_in(wea_choosed),//写使能
                .dispwave_addra_in(generwave_addra),//端口a地址，17位地址【16：0】
                .dispwave_dina_in(generwave_color),//端口a数据输入 6位【5：0】
                .dispwave_enb_in(dispwave_enb),//端口b使能
                .dispwave_addrb_in(dispwave_addrb),//端口b读取地址输入 17位【16：0】
                .dispwave_doutb_out(dispwave_color),//端口b输出 6位【5：0】
                .dispspec_wea_in(gener_wea),//写使能
                .dispspec_addra_in(generspec_addra),//端口a地址//17位地址
                .dispspec_dina_in(generspec_color),//端口输入6位
                .dispspec_enb_in(dispspec_enb),//端口b使能
                .dispspec_addrb_in(dispspec_addrb),//端口b地址//17位地址
                .dispspec_doutb_out(dispspec_color)//端口b输出6位
            );
        /*****************************************显示内存模块结束***********************************************/
        /*******************************************vga输出模块**************************************************/
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
                .wave_color_in(dispwave_color),//6位颜色输入,
                .spec_color_in(dispspec_color),
                .Hsync_out(Hsync),
                .Vsync_out(Vsync),
                .vgaRed_out(vgaRed),
                .vgaGreen_out(vgaGreen),
                .vgaBlue_out(vgaBlue),
                .wave_addr_out(dispwave_addrb),//显存地址输出？
                .wave_enb_out(dispwave_enb),//enbB端口写使能？**********是访问显存数据的使能信号？
                .spec_addr_out(dispspec_addrb),
                .spec_enb_out(dispspec_enb)
            );
endmodule
