`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/04/16 20:30:57
// Design Name: 
// Module Name: fft
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


module fft(
    input clk_in,
    input aresetn,
    input systemstate_in,
    output reg[8:0] wave_addr_out,
    input [7:0] wave_data_in,
    output reg fft_valid_out,
    output reg[8:0] spec_addr_out,
    output wire[48:0] amp_out,
//    output reg[23:0] fft_real,
//    output reg[23:0] fft_imag,
    output wire event_frame_started,//每一新的次
    output wire event_tlast_unexpected,//当s
    output wire event_tlast_missing,//当IP核认
    output wire event_status_channel_halt,
    output wire event_data_in_channel_halt
    
    );
    
    parameter waitstart = 2'b00,//等待按键控制启动fft
               configin = 2'b01,//输入配置信息
               datain = 2'b10,//输入数据
               dataout = 2'b11;//输出数据
                     
    reg[1:0] state;
    reg aclken;
    
    reg[7:0] cfg_cnt;
    reg[7:0] s_axis_config_tdata;
    reg s_axis_config_tvalid;

    reg s_axis_data_tvalid;
    reg[15:0] s_axis_data_tdata = 0;
    reg s_axis_data_tlast;
    
    wire[47:0] m_axis_data_tdata;
    wire[15:0] m_axis_data_tuser;
    wire m_axis_data_tvalid;
    wire m_axis_data_tlast;
    
    reg fft_ed;
    

    
    initial//初始化状态与数据
    begin
        state <= waitstart;
        aclken <= 0;
        
        cfg_cnt <= 0;
        s_axis_config_tdata <= 0;
        s_axis_config_tvalid <= 0;
        
        wave_addr_out <= 0;
        s_axis_data_tvalid <= 0;
        s_axis_data_tlast <= 0;
        fft_ed <= 0;
    end
    
    
    xfft_0 instance_fft(
        .aclk(clk_in),
        .aclken(aclken),////////////////
        .aresetn(aresetn),
        .s_axis_config_tdata(s_axis_config_tdata),
        .s_axis_config_tvalid(s_axis_config_tvalid),/////////////////
        .s_axis_config_tready(),//输出
        .s_axis_data_tdata(s_axis_data_tdata),
        .s_axis_data_tvalid(s_axis_data_tvalid),/////////////////////
        .s_axis_data_tready(),//输出
        .s_axis_data_tlast(s_axis_data_tlast),
        .m_axis_data_tdata(m_axis_data_tdata),
        .m_axis_data_tuser(m_axis_data_tuser),//输出，表明当前周期传递的信号是第几个数据。【15：0】
        .m_axis_data_tvalid(m_axis_data_tvalid),//表示数据有效的输出
        .m_axis_data_tready(1'b1),//输入，当有效时输出数据
        .m_axis_data_tlast(m_axis_data_tlast),//输出，最后一位时输出有效
        .event_frame_started(),//每一新的次fft开始时上跳一次
        .event_tlast_unexpected(),//当s_axis_data_tlast上跳，但IP核认为这并不是最后一个数据时上跳一次
        .event_tlast_missing(),//当IP核认为这是最后一个数据，但s_axis_data_tlast还是低的时候，该信号上跳。
        .event_status_channel_halt(),//当 IP核尝试输出数据到状态通道但无法输出时拉高。只在Non-Realtime 模式下有效。
        .event_data_in_channel_halt(),//当IP核需要新的输入数据但输入口并没有提供足够的数据时拉高
        .event_data_out_channel_halt()//当 IP核尝试输出数据但无法输出时（可能时输出对象没有给IP核输出接收使能信号）拉高。只在Non-Realtime 模式下有效
      );
    

        
    always@(posedge clk_in)
        if(!aresetn)
        begin
            state = waitstart;
        end
        else
            case(state)
                waitstart:////////////////////////////////////////////////////
                begin
                    aclken <= 1'b0;
                    s_axis_config_tvalid <= 1'b0;
                    s_axis_data_tvalid <= 1'b0;
                    ////////////初始化////////////   
                    cfg_cnt <= 0;
                    s_axis_config_tdata <= 0;
                    wave_addr_out <= 0;
                    s_axis_data_tdata <= 0;
                    s_axis_data_tlast <= 0;
                    //////////////////////////////
                    if(systemstate_in)
                    begin
//                        if(!fft_ed)
//                        begin
                            state <= configin;
//                            fft_ed <= 1;
//                        end
                    end
//                    else
//                        fft_ed <= 0;
                end
                configin:////////////////////////////////////////////////////////////
                begin
                    aclken <= 1'b1;
                    s_axis_config_tdata <= 8'b00000001;
                    s_axis_config_tvalid <= 1'b1;
                    s_axis_data_tvalid <= 1'b0;
                    if(cfg_cnt == 200)
                    begin
                        state <= datain;
                        cfg_cnt <= 0;
                    end
                    else
                        cfg_cnt = cfg_cnt + 1;
                end
                datain:////////////////////////////////////////////////////////////////////
                begin
                    aclken <= 1'b1;
                    s_axis_config_tvalid <= 1'b1;//////////////////////testtestesttesttesttestetse
                    s_axis_data_tvalid <= 1'b1;
                    s_axis_data_tdata <= {8'd0,wave_data_in};
                    if(wave_addr_out == 511)
                    begin
                        s_axis_data_tlast <= 1'b1;
                        wave_addr_out <= 0;
                        state <= dataout;
                    end
                    else
                    begin
                        s_axis_data_tlast <= 1'b0;
                        wave_addr_out = wave_addr_out + 1;
                    end
                end
                dataout:////////////////////////////////////////////////////////////////////
                begin
                    aclken <= 1'b1;              
                    s_axis_config_tvalid <= 1'b0;
                    s_axis_data_tvalid <= 1'b0;  
                    if(m_axis_data_tlast)
                        state <= waitstart;
                end
            endcase
        /////////////////////////////fft sink_in ctl/////////////////////////
    wire[23:0] fft_real,fft_imag;
//    always@(posedge clk_in)//延迟一个时钟
//    begin
//        fft_real <= m_axis_data_tdata[23:0];//这里是否是上一个时钟的值？
//    end
    comp2ture_24 copm2ture_1(
//        .clk_in(clk_in),
        .complement_in(m_axis_data_tdata[23:0]),
        .ture_out(fft_real)
        );
    
//    always@(posedge clk_in)
//    begin
//        fft_imag <= m_axis_data_tdata[47:24];//这里是否是上一个时钟的值？
//    end
    comp2ture_24 copm2ture_2(
//        .clk_in(clk_in),
        .complement_in(m_axis_data_tdata[47:24]),
        .ture_out(fft_imag)
        );
    wire[8:0] spec_addr;
    assign spec_addr = m_axis_data_tuser[8:0];
    always@(*)
    begin
        fft_valid_out <= m_axis_data_tvalid;
        if(spec_addr > 9'd255)
            spec_addr_out <= spec_addr - 9'd256;
        else
            spec_addr_out <= spec_addr + 9'd256;
    end

        /********** 计算频谱的幅值信号 **********/
    
        wire signed [47:0] xkre_square, xkim_square;
        assign xkre_square = fft_real * fft_real;
        assign xkim_square = fft_imag * fft_imag;
    
//    always @(posedge clk_in)
//        amp_out <= xkre_square + xkim_square;
    assign amp_out = xkre_square + xkim_square;
endmodule
