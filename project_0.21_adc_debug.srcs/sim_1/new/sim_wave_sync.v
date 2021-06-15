`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/11 23:29:01
// Design Name: 
// Module Name: sim_wave_sync
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


module sim_wave_sync;
    reg clk = 0;
    always #10
        clk = ~clk;
    
    reg clk7 = 0;
   always #7
        clk7 = ~clk7;
        
    reg[11:0] level = 12'd50;
        
        

        wire [7:0] test_sin;
        signal_generator instance_signal_generator(
            .clk_in(clk7),
            .test_square_out(),
            .test_tangle_out(),
            .test_sin_out(test_sin)
            );
            
    wire wave_wea;
    wire[8:0] wave_addr;
    wire[11:0] wave_data;
    wire[15:0] count;
    wire counting;
    wire[17:0] count_flag;
    wire[17:0] count_judge_trigger;
    wave_sync uut_wave_sync(
            .divclk_in(clk),
            .sw_in(12'b0000_0100_0000),
            .level_in(level),
            .measured_temp_in(12'h000),
            .measured_vccint_in(12'h000),
            .measured_aux7_in(12'h000),
            .measured_aux14_in(12'h000),
            .test_square_in(8'h00),
            .test_tangle_in(8'h00),
            .test_sin_in(test_sin),
            .wave_wea_out(wave_wea),
            .wave_addr_out(wave_addr),
            .wave_data_out(wave_data),//±£´æµÄÊÇ²¹Âë
            .count(count),
            .counting(counting),
            .count_flag(count_flag),
            .count_judge_trigger(count_judge_trigger)
            );
     reg[8:0] wave_addra = 0;
     wire[11:0] wave_dataa;
     assign wave_dataa[11:4] = wave_addra;
     assign wave_dataa[3:0] = 0;
     reg[8:0] wave_addrb = 0;
     wire [11:0] wave_datab;

    always#20
     begin
         wave_addra = wave_addra + 1;
     end
     always #20
     begin
         if(wave_addrb == 511)
             wave_addrb = 0;
         else
             wave_addrb = wave_addrb + 1;
    end
             
    wave_ram uut_wave_ram(
        .clk_in(clk),
        .wea_in(1),
        .wave_addra_in(wave_addra),//[8£º0]
        .wave_data_in(wave_dataa),//[15:0]
        .wave_addrb_in(wave_addrb),
        .wave_data_out(wave_datab)//[7:0]
        );
endmodule
