`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 17:18:36
// Design Name: 
// Module Name: sim_wave_g
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


module sim_wave_g;
reg clk=0;
always#10
    clk = ~clk;
    wire[8:0] wave_addr;
    reg[7:0] wave_data = 8'h7f;
    wire[16:0] disp_addr;
    wire[5:0] color;
    wire wea;
    wave_generator uut_wave_g(
        .clk_in(clk),//DCLK 50MHz
        .reset_in(0),//RESET 复位信号，暂时不用
        .col_val_out(wave_addr),//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!待测用9位长度作为地址会不会溢出
        .wave_in(wave_data),
        .disp_wave_addr_out(disp_addr),//输出给显存A口的地址
        .color_out(color),//要写到显存的数据（颜色）
        .wea_out(wea)//显存A口的写使能
        
        );
            wire[8:0] spec_addr;
        reg[7:0] spec_data = 8'h7f;
        wire[16:0] disp_spec_addr;
        wire[5:0] spec_color;
        wire spec_wea;
spec_generator uut_spec_g(
    .clk_in(clk),//DCLK 50MHz
    .reset_in(0),//RESET 复位信号，暂时不用
    .col_val_out(spec_addr),//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!待测用9位长度作为地址会不会溢出
    .spec_in(spec_data),
    .disp_spec_addr_out(disp_spec_addr),//输出给显存A口的地址
    .color_out(spec_color),//要写到显存的数据（颜色）
    .wea_out(spec_wea)//显存A口的写使能
    
    );
    
endmodule
