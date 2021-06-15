`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/27 11:42:23
// Design Name: 
// Module Name: sim_fft
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


module sim_fft;
    reg clk = 0;
reg aresetn = 0;
reg[3:0] state = 0;
wire[8:0] wave_addr;
reg[7:0] wave_data_reg[0:511];
wire[7:0] wave_data;
reg[9:0] i = 0;

wire fft_valid;
wire[8:0] m_axis_data_tuser;
wire[46:0] amp;
initial//初始化数据，前二十
begin

    for(i=0;i<512;i=i+1)
        if((i > 127)&&(i <= 384))
            wave_data_reg[i]= 255;
        else
            wave_data_reg[i]= 0;
            
    #100 aresetn = 1;
    #200 state = 4'b1111;
end
assign wave_data = wave_data_reg[wave_addr];
wire[5:0] sin_addra;
wire[7:0] test_sin_out;
assign sin_addra = wave_addr[5:0];
    blk_mem_gen_2 sin_rom_test(
          .clka(clk),
          .ena(1),
          .addra(sin_addra),
          .douta(test_sin_out)
        );
always #10
    clk = !clk;
    
reg[15:0] count = 0;
always@(m_axis_data_tuser)
    count = count + 1;
    
wire[23:0]fft_real;
wire[23:0]fft_imag;  
wire event_frame_started;//每一新的次
wire event_tlast_unexpected;//当s
wire event_tlast_missing;//当IP核认
wire event_status_channel_halt;
wire event_data_in_channel_halt;
fft uut_fft(
.clk_in(clk),
.aresetn(aresetn),
.systemstate_in(state),//[3:0]
.wave_addr_out(wave_addr),//[8:0]
.wave_data_in(wave_data),//[7:0]
.fft_valid_out(fft_valid),
.spec_addr_out(m_axis_data_tuser),//[15:0]
.amp_out(amp),//[46:0]
//.fft_real(fft_real),
//.fft_imag(fft_imag),
.event_frame_started(event_frame_started),//每一新的次
.event_tlast_unexpected(event_tlast_unexpected),//当s
.event_tlast_missing(event_tlast_missing),//当IP核认
.event_status_channel_halt(event_status_channel_halt),
.event_data_in_channel_halt(event_data_in_channel_halt)
);
reg[11:0] amp_ans [0:511];
reg[23:0] real_ans [0:511];
reg[23:0] imag_ans [0:511];

always@(posedge clk)
begin
    amp_ans[m_axis_data_tuser] = amp[11:0];
    real_ans[m_axis_data_tuser] = fft_real;
    imag_ans[m_axis_data_tuser] = fft_imag;
end
endmodule
