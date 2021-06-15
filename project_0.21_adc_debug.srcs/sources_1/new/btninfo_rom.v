`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/28 13:11:04
// Design Name: 
// Module Name: btninfo_rom
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


module btninfo_rom(
    input clk_in,
    input ena_in,
    input [13:0] btninfo_addra,
    input [15:0] keyval_in,
    input [6:0] x_axis_in,
    input [6:0] y_axis_in,
    output btninfo_douta
    );

    blk_mem_gen_8 btninfo_rom(
              .clka(clk_in),
              .ena(ena_in),
              .addra(btninfo_addra),
              .douta(btninfo_douta)
            );
endmodule
