`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/04/13 21:06:57
// Design Name: 
// Module Name: spec_ram
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


module spec_ram(
    input clk_in,
    input fft_valid_in,
    input search_en_in,
    input[8:0] spec_addra_in,//[8£º0]
    input[7:0] spec_data_in,//[7:0]
    input[8:0] spec_addrb_in,
    output wire[7:0] spec_data_out//[7:0]
    );
    
    wire fft_valid;
    assign fft_valid = (~search_en_in) & fft_valid_in;
    blk_mem_gen_3 spec_ram(
      .clka(clk_in),
      .ena(1),
      .wea(fft_valid),
      .addra(spec_addra_in),
      .dina(spec_data_in),
      .clkb(clk_in),
      .enb(1),
      .addrb(spec_addrb_in),
      .doutb(spec_data_out)
    );

endmodule
