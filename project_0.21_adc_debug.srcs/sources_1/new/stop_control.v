`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/06/03 16:50:16
// Design Name: 
// Module Name: stop_control
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


module stop_control(
    input wave_kc_in,
    input spec_kc_in,
    
    input wave_wea_in,
    
    input search_en_in,
    
    output wire wavegener_wea_out,
    output reg wavegener_state_out = 1'b1,//0 暂停
    
    output wire wavefft_wea_out,
    output reg wavefft_state_out = 1'b1//0 暂停
    );
    
    always@(posedge wave_kc_in)
        wavegener_state_out = ~wavegener_state_out;
    assign wavegener_wea_out = wavegener_state_out & wave_wea_in;
    
    always@(posedge spec_kc_in)
        if(search_en_in)//////////////en的优先级更高
            wavefft_state_out = 1'b0;
        else
            wavefft_state_out = ~wavefft_state_out;
            
    assign wavefft_wea_out = wavefft_state_out & wave_wea_in & (~search_en_in);
endmodule
