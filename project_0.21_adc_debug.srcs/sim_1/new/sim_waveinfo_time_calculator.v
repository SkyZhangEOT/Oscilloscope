`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/20 11:38:29
// Design Name: 
// Module Name: sim_waveinfo_time_calculator
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


module sim_waveinfo_time_calculator(

    );
    reg clk = 0;
    always#10
        clk = ~clk;
    reg[15:0] count = 0;
    reg[3:0] state = 0;
   always#1000
   begin
       state = state + 1;
       if(state == 0)
           count = count + 50;
   end
   wire[25:0] freq_out;
   wire[2:0] freq_carry_out;
   wire freq_wrong_out;
    waveinfo_time_calculator uut_waveinfo_time_calculator(//计算周期和频率，管理32个字符
           .clk_in(clk),
           .sync_count_in(count),
           .clk_state_in(state),//时钟频率状态
           .freq_out(freq_out),//26位二进制数
           .freq_carry_out(freq_carry_out),//频谱后面带的零
           .freq_wrong_out(freq_wrong_out)//频率出错
           );
endmodule
