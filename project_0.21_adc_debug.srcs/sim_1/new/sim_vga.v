`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/25 12:35:33
// Design Name: 
// Module Name: sim_vga
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


module sim_vga;
////************************************vga·ÂÕæ
reg clk = 0;
wire[5:0] wave_color_in;
wire[16:0] wave_addrb;
assign wave_color_in = wave_addrb[5:0];
wire[5:0] spec_color_in;
wire[16:0] spec_addrb;
assign spec_color_in = spec_addrb[5:0];
wire Hsync,Vsync;
wire[3:0] vgaRed;
wire[3:0] vgaGreen;
wire[3:0] vgaBlue;
wire wave_enb;
wire spec_enb;
reg [7:0] wave_ori_pos_in = 200;
display_vga uut_vga(
    .clk_in(clk),
    .wave_color_in(wave_color_in),
    .spec_color_in(spec_color_in),
    .wave_ori_pos_in(wave_ori_pos_in),
    .Hsync_out(Hsync),
    .Vsync_out(Vsync),
    .vgaRed_out(vgaRed),
    .vgaGreen_out(vgaGreen),
    .vgaBlue_out(vgaBlue),
    .wave_addr_out(wave_addrb),
    .wave_enb_out(wave_enb),
    .spec_addr_out(spec_addrb),
    .spec_enb_out(spec_enb)
);


always #10
    clk = ~clk;
endmodule
