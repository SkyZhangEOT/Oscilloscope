`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/03/09 23:59:40
// Design Name: 
// Module Name: display_ram
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


module display_ram(
    input clk_in,
    input dispwave_wea_in,//写使能
    input [16:0] dispwave_addra_in,//端口a地址//17位地址
    input [1:0] dispwave_dina_in,//端口a地址
    input dispwave_enb_in,//端口b使能
    input [16:0] dispwave_addrb_in,//端口b地址//17位地址
//    output [5:0] douta_out,//端口a数据输出
    output [1:0] dispwave_doutb_out,//端口b输出 
    
    input dispspec_wea_in,//写使能
    input [16:0] dispspec_addra_in,//端口a地址//17位地址
    input [1:0] dispspec_dina_in,//端口输入6位
    input dispspec_enb_in,//端口b使能
    input [16:0] dispspec_addrb_in,//端口b地址//17位地址
    output [1:0] dispspec_doutb_out,//端口b输出6位
    
    input edgeline_wea_in,
    input [15:0] edgeline_addra_in,//端口a地址//17位地址  
    input edgeline_dina_in,//端口输入6位          
    input edgeline_enb_in,//端口b使能                  
    input [15:0] edgeline_addrb_in,//端口b地址//17位地址  
    output edgeline_doutb_out//端口b输出6位      
    );

      
    blk_mem_gen_0 instance_waveram(
          .clka(clk_in),
          .ena(1),//一直使用a端口做为写入
          .wea(dispwave_wea_in),
          .addra(dispwave_addra_in),//a端口地址
          .dina(dispwave_dina_in),//a端口数据写入
          .clkb(clk_in),
          .enb(dispwave_enb_in),
          .addrb(dispwave_addrb_in),
          .doutb(dispwave_doutb_out)
        );
        
    blk_mem_gen_1 instance_specram(
              .clka(clk_in),
              .ena(1),//一直使用a端口做为写入
              .wea(dispspec_wea_in),
              .addra(dispspec_addra_in),//a端口地址
              .dina(dispspec_dina_in),//a端口数据写入
              .clkb(clk_in),
              .enb(dispspec_enb_in),
              .addrb(dispspec_addrb_in),
              .doutb(dispspec_doutb_out)
            );
     blk_mem_gen_7 instance_edgeline(
              .clka(clk_in),
              .ena(1),//一直使用a端口做为写入
              .wea(edgeline_wea_in),
              .addra(edgeline_addra_in),//a端口地址
              .dina(edgeline_dina_in),//a端口数据写入
              .clkb(clk_in),
              .enb(edgeline_enb_in),
              .addrb(edgeline_addrb_in),
              .doutb(edgeline_doutb_out)
            );
endmodule
