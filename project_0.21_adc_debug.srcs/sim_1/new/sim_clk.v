`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 16:50:19
// Design Name: 
// Module Name: sim_clk
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


module sim_clk;

    reg clk = 0;
    reg key = 0;
    reg add = 0;
    reg [15:0] key_value;
    
    always #10 
        clk = ~clk;
        
   always #200
            key = ~key;
    always #2000
            add = ~add;
        
       always@(*)
            if (add)
                key_value = {11'b0000_0000_000,key,4'b0000};
            else
                key_value = {10'b0000_0000_00,key,5'b0_0000};
    
    wire clk1k;
    wire keyclk;
    wire clk500k;
    wire clk_25MHz;//25
    wire clk_12_5MHz;//12.5
    wire clk_6_25MHz;//6.25MHz
    wire clk_choosed;


    clock_low uut_clk_low(
    .clk_in(clk),
    .segclk_out(clk1k),  //输出1000Hz,数码管的扫描频率是1000Hz
    .keyclk_out(keyclk),   //输出800Hz，按键消抖频率设为50Hz，按键扫描频率是消抖频率的16倍，因此是800Hz
    .clk500k_out(clk500k)
);

    clk_wiz_0 uut_clk_wiz(
        .clk_out1(clk_25MHz),//25
        .clk_out2(clk_12_5MHz),//12.5
        .clk_out3(clk_6_25MHz),//6.25MHz
        .clk_in1(clk)
     );
     
      clk_mux uut_clk_mux(
         .clk50_in(clk),
         .clk25_in(clk_25MHz),
         .clk125_in(clk1k),
         .clk625_in(keyclk),
         .keyval_in(key_value),
         .clkM_out(clk_choosed)
     //    output reg clkK_out
         );


endmodule
