`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 21:44:14
// Design Name: 
// Module Name: sim_divider
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


module sim_divider;
    reg clk = 0;
    always#10 
        clk = ~clk;
    reg [15:0]clkinfo = 16'd50000;
    reg [15:0]count = 16'd52;
    wire[1:0] carry;
    wire clk_in;
    assign clk_in = clk;
    always#1000
    begin
    clkinfo = clkinfo+1;
    end
        
    wire valid;
    wire[41:0] ans;
    divider uut_div(
        .clk_in(clk),
        .dividend_in({16'd0,clkinfo}), 
        .divisor_in({16'd0,count}),
    
        .valid_out(valid),
        .ans_out(ans),
        .carry_out(carry)
    );

        
    
endmodule
