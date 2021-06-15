`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/27 11:57:25
// Design Name: 
// Module Name: sim_stop
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


module sim_stop;
    reg wea = 0;
    reg key = 0;
    always #10 wea = ~wea;
    always #100 key = ~key;
    wire [11:0] led;
    wire wea_out;
    wire stop;
    wave_stop uut_stop(
    .keyval_in(key),
    .wea_disp_ram(wea),
    .state_in(4'b0000),
    .wea_disp_rem_choosed(wea_out),
    .no_stop(stop)
    );
    
        reg[11:0] led_temp = 0; 
    always@(*)
        led_temp[0] = stop;//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    assign led = led_temp;
    



endmodule
