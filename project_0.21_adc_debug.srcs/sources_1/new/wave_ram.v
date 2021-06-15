`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/12 00:48:30
// Design Name: 
// Module Name: wave_ram
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


    module wave_ram(
        input clk_in,
        input wea_in,
        input [8:0] wave_addra_in,//[8£º0]
        input [11:0] wave_data_in,//[15:0]
        input [8:0] wave_addrb_in,
        output wire[11:0] wave_data_out//[7:0]
        );
    blk_mem_gen_4 wave_ram(
      .clka(clk_in),
      .ena(1),
      .wea(wea_in),
      .addra(wave_addra_in),
      .dina(wave_data_in),
      .clkb(clk_in),
      .enb(1),
      .addrb(wave_addrb_in),
      .doutb(wave_data_out)
    );
endmodule
