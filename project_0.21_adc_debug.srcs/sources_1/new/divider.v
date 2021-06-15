`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/17 21:30:06
// Design Name: 
// Module Name: divider
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

 
module divider(//除数为零时，结果全一
    input clk_in,
    input[31:0] dividend_in, 
    input[31:0] divisor_in,

    output reg valid_out,
    output reg [41:0] ans_out,//最大42位,最大乘以1000
    output reg [1:0] carry_out,//最大带3位
    output reg [35:0] ans10_out,//乘以10,最大36位
    output reg carry10_out,
    output wire[31:0] ans_nf_out
);
    wire [63:0] dout_tdata;
    wire[31:0] remain;
    wire valid;
    assign ans_nf_out = valid? dout_tdata[63:32]:32'd0;
    assign remain = valid? dout_tdata[31:0]:32'd0;

  div_gen_0 divider(
      .aclk(clk_in),
      .s_axis_divisor_tvalid(1),
      .s_axis_divisor_tdata(divisor_in),
      .s_axis_dividend_tvalid(1),
      .s_axis_dividend_tdata(dividend_in),
      .m_axis_dout_tvalid(valid),
      .m_axis_dout_tdata(dout_tdata)
);
    wire[31:0] d12;
    assign d12 = {1'b0,divisor_in[31:1]};
    wire[31:0] d14;
    assign d14 = {2'd0,divisor_in[31:2]};
    wire[31:0] d18;
    assign d18 = {3'd0,divisor_in[31:3]};
    wire[35:0] ans10;
    assign ans10 = {ans_nf_out[31:0],3'd0} + {ans_nf_out[31:0],1'd0};
    wire[38:0] ans100;
    assign ans100 = {ans10[35:0],3'd0} + {ans10[35:0],1'd0};
    wire[41:0] ans1000;
    assign ans1000 = {ans100[38:0],3'd0} + {ans100[38:0],1'd0};
               
    reg finished = 0;
    always@(posedge clk_in)
        if(valid)
        begin
            if(remain < d18)//  1/8
                begin
                    ans_out = {10'd0,ans_nf_out};
                    carry_out = 0;
                    ans10_out = ans10 + 1'd1;
                    carry10_out = 1;
                    finished = 1;
                end
            else if(remain < d14)// 2/8
                begin
                    ans_out = ans1000 + 7'd125;
                    carry_out = 3;
                    ans10_out = ans10 + 2'd2;
                    carry10_out = 1;              
                    finished = 1;
                end
            else if(remain < (d14 + d18))// 3/8
                begin                          
                    ans_out = {3'd0,ans100} + 5'd25;
                    carry_out = 2;
                    ans10_out = ans10 + 2'd3;
                    carry10_out = 1;              
                    finished = 1;           
                end
            else if(remain < d12)// 4/8                            
                begin                          
                    ans_out = ans1000 + 9'd375;
                    carry_out = 3;
                    ans10_out = ans10 + 3'd4;
                    carry10_out = 1;         
                    finished = 1;           
                end
            else if(remain < (d12 + d18))// 5/8        
                begin                          
                    ans_out = {6'd0,ans10} + 3'd5;
                    carry_out = 1;
                    ans10_out = ans10 + 3'd6;
                    carry10_out = 1;         
                    finished = 1;           
                end                            
            else if(remain < (d12 + d14))// 6/8   
                begin                             
                    ans_out = ans1000 + 10'd625;                            
                    carry_out = 3;
                    ans10_out = ans10 + 3'd7;
                    carry10_out = 1;         
                    finished = 1;            
                end
            else if(remain < (d12 + d14 + d18))// 7/8     
                begin                               
                    ans_out = {3'd0,ans100} + 10'd75;    
                    carry_out = 2;
                    ans10_out = ans10 + 4'd8;
                    carry10_out = 1;         
                    finished = 1;                
                end                                 
            else// 6/8     
                begin                               
                    ans_out = ans1000 + 10'd875;    
                    carry_out = 3;
                    ans10_out = ans10 + 4'd9;
                    carry10_out = 1;         
                    finished = 1;             
                end                                    
        end
        else
            finished = 0;
    
    always@(negedge clk_in)
        if(finished)
            valid_out = 1;
        else
            valid_out = 0;
endmodule
