`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/26 20:47:48
// Design Name: 
// Module Name: sim_mux
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


module sim_mux;
    reg clk = 0;
    wire clk25M,clk12M,clk6M,clk3M,clk1M,clk781k,clk390k,clk195k,clk97k,clk48k,clk24k,clk12k,clk6k,clk3k,clk1k,clk762;
    wire clk_out;
    reg key = 0;
    reg add = 0;
    reg[15:0] key_value = 0;
    
    always@(*)
        if (add)
            key_value = {11'b0000_0000_000,key,4'b0000};
        else
            key_value = {10'b0000_0000_00,key,5'b0_0000};
    always #1
        clk = ~clk;

    always #10000
        key = ~key;
    always #200000
        add = ~add;
    
    
        clk_div uut_clk_div(
            .clk_in(clk),
            .clk25M_out(clk25M),
            .clk12M_out(clk12M),
            .clk6M_out(clk6M), 
            .clk3M_out(clk3M), 
            .clk1M_out(clk1M), 
            .clk781k_out(clk781k),
            .clk390k_out(clk390k),
            .clk195k_out(clk195k),
            .clk97k_out(clk97k),
            .clk48k_out(clk48k),
            .clk24k_out(clk24k),
            .clk12k_out(clk12k),
            .clk6k_out(clk6k), 
            .clk3k_out(clk3k), 
            .clk1k_out(clk1k),
            .clk762_out(clk762)
        );
        
    clk_mux instance_clk_mux(
                .clk50M_in(clk),
                .clk25M_in(clk25M),
                .clk12M_in(clk12M),
                .clk6M_in(clk6M),
                .clk3M_in(clk3M),
                .clk1M_in(clk1M),
                .clk781k_in(clk781k),
                .clk390k_in(clk390k),
                .clk195k_in(clk195k),
                .clk97k_in(clk97k),
                .clk48k_in(clk48k),
                .clk24k_in(clk24k),
                .clk12k_in(clk12k),
                .clk6k_in(clk6k),
                .clk3k_in(clk3k),
                .clk1k_in(clk1k),
                .keyval_in(key_value),
                .clk_out(clk_out)
             //    output reg clkK_out
                 );
endmodule
