`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/22 18:19:47
// Design Name: 
// Module Name: clk_manager
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


module clk_manager(
    input clk_in,
    input key_pressed_in,
    input [15:0] keyval_in,
    input [2:0] h_state1_in,
    output wire[3:0] clk_state_out,
    output reg clk_choosed_out,
//    output wire clk_VGA_out,//25.175
    output reg clk25M_out = 0,
    output wire clk20M_out,
    output wire clk10M_out,
    output wire clk5M_out,
    output wire clk2M_out,
    output wire clk1M_out,
    output wire clk500k_out,
    output wire clk200k_out,
    output wire clk100k_out,
    output wire clk50k_out,
    output wire clk20k_out,
    output wire clk10k_out,
    output wire clk5k_out,
    output wire clk2k_out,
    output wire clk1k_out,
    output wire clk500_out,
    output wire clk100_out,
    output wire clk10_out,
    output wire clk1Hz_out,
    output wire signal_clk_out
    );
    signal_clk_manager(
        .state_in(h_state1_in),
        .clk50M_in(clk_in),
        .clk20M_in(clk20M_out),
        .clk10M_in(clk10M_out),
        .clk5M_in(clk5M_out),
        .clk2M_in(clk2M_out),
        .clk1M_in(clk1M_out),
        .clk500k_in(clk500k_out),
        .clk200k_in(clk200k_out),
        .signal_clk_out(signal_clk_out)
        );
    reg[3:0] state;
    assign clk_state_out = state;
    always@(posedge key_pressed_in)                  
        case(keyval_in)//根据拨码开关的位置向npv赋值            
            16'b0000_0001_0000_0000://增加频率           
                if (state == 4'd15)                 
                    state <= state;                  
                else                                 
                    state <= state + 1'b1;           
            16'b0001_0000_0000_0000://减小频率           
                if (state == 4'd0)                  
                    state <= state;                  
                else                                 
                    state <= state - 1'b1;           
            default:                                 
                state <= state;                      
        endcase
                                      
    always@(*)
        case(state)
            4'h0: clk_choosed_out = clk500_out;
            4'h1: clk_choosed_out = clk1k_out;
            4'h2: clk_choosed_out = clk2k_out;
            4'h3: clk_choosed_out = clk5k_out;
            4'h4: clk_choosed_out = clk10k_out;
            4'h5: clk_choosed_out = clk20k_out;
            4'h6: clk_choosed_out = clk50k_out;
            4'h7: clk_choosed_out = clk100k_out;
            4'h8: clk_choosed_out = clk200k_out;
            4'h9: clk_choosed_out = clk500k_out;
            4'ha: clk_choosed_out = clk1M_out;
            4'hb: clk_choosed_out = clk2M_out;
            4'hc: clk_choosed_out = clk5M_out;
            4'hd: clk_choosed_out = clk10M_out;
            4'he: clk_choosed_out = clk20M_out;
            4'hf: clk_choosed_out = clk_in;
        endcase


    clk_wiz_0
     (
      // Clock out ports
      .clk_out1(clk20M_out),
      .clk_out2(clk10M_out),
//      .clk_out3(clk_VGA_out),
     // Clock in ports
      .clk_in1(clk_in)
     );
     
     always@(posedge clk_in)
         clk25M_out = ~clk25M_out;
     
    freq_frac(//十分频
        .clk_in(clk_in),
        .clk_out(clk5M_out)
        );
    freq_frac(//十分频
        .clk_in(clk20M_out),
        .clk_out(clk2M_out)
        );
    freq_frac(//十分频
        .clk_in(clk10M_out),
        .clk_out(clk1M_out)
        );


    freq_frac(//十分频         
        .clk_in(clk5M_out),    
        .clk_out(clk500k_out) 
        );                  
    freq_frac(//十分频         
        .clk_in(clk2M_out),
        .clk_out(clk200k_out) 
        );                  
    freq_frac(//十分频         
        .clk_in(clk1M_out),
        .clk_out(clk100k_out) 
        );                  


    freq_frac(//十分频          
        .clk_in(clk500k_out),  
        .clk_out(clk50k_out)
        );                   
    freq_frac(//十分频          
        .clk_in(clk200k_out),  
        .clk_out(clk20k_out)
        );                   
    freq_frac(//十分频          
        .clk_in(clk100k_out),  
        .clk_out(clk10k_out)
        );                   


    freq_frac(//十分频          
        .clk_in(clk50k_out),
        .clk_out(clk5k_out) 
        );                   
    freq_frac(//十分频          
        .clk_in(clk20k_out),
        .clk_out(clk2k_out) 
        );                   
    freq_frac(//十分频          
        .clk_in(clk10k_out),
        .clk_out(clk1k_out) 
        );                   
    
    
    freq_frac(//十分频          
        .clk_in(clk5k_out),  
        .clk_out(clk500_out)
        );                   
    freq_frac(//十分频          
        .clk_in(clk1k_out),  
        .clk_out(clk100_out)
        );                   
    freq_frac(//十分频          
        .clk_in(clk100_out),  
        .clk_out(clk10_out)
        );                   
    freq_frac(//十分频         
        .clk_in(clk10_out),
        .clk_out(clk1Hz_out) 
        );                  


    
endmodule
