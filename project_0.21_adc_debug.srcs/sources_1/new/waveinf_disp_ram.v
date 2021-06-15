`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/16 13:45:39
// Design Name: 
// Module Name: waveinf_disp_ram
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


module waveinf_disp_ram(//œ‘¥Ê
    input clk_in,
    input ena_in,
    input wea_in,
    input [14:0] addra_in,//15Œªµÿ÷∑
    input dataa_in,
    input enb_in,
    input [14:0] addrb_in,
    output wire datab_out
    );
      blk_mem_gen_6 waveinf_disp_ram(
          .clka(clk_in),
          .ena(ena_in),
          .wea(wea_in),
          .addra(addra_in),
          .dina(dataa_in),
          .clkb(clk_in),
          .enb(enb_in),
          .addrb(addrb_in),
          .doutb(datab_out)
        );
endmodule
