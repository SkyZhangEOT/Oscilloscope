`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/06 00:38:32
// Design Name: 
// Module Name: signal_generator
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


module signal_generator(
    input clk_in,
    output reg[7:0] test_square_out = 0,
    output reg[7:0] test_tangle_out = 0,
    output wire[7:0] test_sin_out
    );
    wire clk;
    assign clk = ~clk_in;
    reg wave_flag = 0;
    reg[4:0] wave_flag_cnt = 0;//flag计数器  5M时钟输入，一个信号周期含有64个时钟周期
    always@(posedge clk)
        begin
            wave_flag_cnt = wave_flag_cnt + 1;
            if(wave_flag_cnt == 0)
                wave_flag = !wave_flag;
        end
    always@(posedge clk)
        if(wave_flag)
        begin
             test_square_out = 8'b0011_1111;
             test_tangle_out = test_tangle_out - 1'b1;
        end
        else
        begin
            test_square_out = 8'd0;
            test_tangle_out = test_tangle_out + 1'b1;
        end
        /////////////////正弦波/////////////////////
    reg[5:0] sin_addra = 0;
      blk_mem_gen_2 sin_rom(
          .clka(clk),
          .ena(1),
          .addra(sin_addra),
          .douta(test_sin_out)
        );
        always@(posedge clk_in)
            sin_addra = sin_addra + 1;
endmodule
