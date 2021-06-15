`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/12 16:30:13
// Design Name: 
// Module Name: sim_wave_control
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


module sim_wave_control;
reg key = 0;
always#1000
    key = ~key;
reg[8:0] wave_addr_gener = 0;
reg[8:0] wave_addr_fft = 0;
always#10
begin
wave_addr_gener = wave_addr_gener +1;
wave_addr_fft = wave_addr_fft-1;      
end
reg [11:0]wave_data = 12'hfff;
wire[8:0]wave_addr_out;
wire[11:0] wave_data_gener_out;
wire[11:0] wave_data_fft_out;

spec_control uut_spec_control(
    .keyval_in(key),
    .wave_addr_gener_in(wave_addr_gener),//协调fft模块和波形生成模块，两个地址输入，一个地址输出，一个数据输入，两个数据输出
    .wave_addr_fft_in(wave_addr_fft),
    .wave_data_in(wave_data),
    .wave_addr_out(wave_addr_out),
    .wave_data_gener_out(wave_data_gener_out),
    .wave_data_fft_out(wave_data_fft_out),
    .state_out(state)
    );
endmodule
