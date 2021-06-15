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
    output wire event_frame_started,//ÿһ�µĴ�
    output wire event_tlast_unexpected,//��s
    output wire event_tlast_missing,//��IP����
    output wire event_status_channel_halt,
    output wire event_data_in_channel_halt
    
    );
    
    parameter waitstart = 2'b00,//�ȴ�������������fft
               configin = 2'b01,//����������Ϣ
               datain = 2'b10,//��������
               dataout = 2'b11;//�������
                     
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
    

    
    initial//��ʼ��״̬������
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
        .s_axis_config_tready(),//���
        .s_axis_data_tdata(s_axis_data_tdata),
        .s_axis_data_tvalid(s_axis_data_tvalid),/////////////////////
        .s_axis_data_tready(),//���
        .s_axis_data_tlast(s_axis_data_tlast),
        .m_axis_data_tdata(m_axis_data_tdata),
        .m_axis_data_tuser(m_axis_data_tuser),//�����������ǰ���ڴ��ݵ��ź��ǵڼ������ݡ���15��0��
        .m_axis_data_tvalid(m_axis_data_tvalid),//��ʾ������Ч�����
        .m_axis_data_tready(1'b1),//���룬����Чʱ�������
        .m_axis_data_tlast(m_axis_data_tlast),//��������һλʱ�����Ч
        .event_frame_started(),//ÿһ�µĴ�fft��ʼʱ����һ��
        .event_tlast_unexpected(),//��s_axis_data_tlast��������IP����Ϊ�Ⲣ�������һ������ʱ����һ��
        .event_tlast_missing(),//��IP����Ϊ�������һ�����ݣ���s_axis_data_tlast���ǵ͵�ʱ�򣬸��ź�������
        .event_status_channel_halt(),//�� IP�˳���������ݵ�״̬ͨ�����޷����ʱ���ߡ�ֻ��Non-Realtime ģʽ����Ч��
        .event_data_in_channel_halt(),//��IP����Ҫ�µ��������ݵ�����ڲ�û���ṩ�㹻������ʱ����
        .event_data_out_channel_halt()//�� IP�˳���������ݵ��޷����ʱ������ʱ�������û�и�IP���������ʹ���źţ����ߡ�ֻ��Non-Realtime ģʽ����Ч
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
                    ////////////��ʼ��////////////   
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
//    always@(posedge clk_in)//�ӳ�һ��ʱ��
//    begin
//        fft_real <= m_axis_data_tdata[23:0];//�����Ƿ�����һ��ʱ�ӵ�ֵ��
//    end
    comp2ture_24 copm2ture_1(
//        .clk_in(clk_in),
        .complement_in(m_axis_data_tdata[23:0]),
        .ture_out(fft_real)
        );
    
//    always@(posedge clk_in)
//    begin
//        fft_imag <= m_axis_data_tdata[47:24];//�����Ƿ�����һ��ʱ�ӵ�ֵ��
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

        /********** ����Ƶ�׵ķ�ֵ�ź� **********/
    
        wire signed [47:0] xkre_square, xkim_square;
        assign xkre_square = fft_real * fft_real;
        assign xkim_square = fft_imag * fft_imag;
    
//    always @(posedge clk_in)
//        amp_out <= xkre_square + xkim_square;
    assign amp_out = xkre_square + xkim_square;
endmodule
