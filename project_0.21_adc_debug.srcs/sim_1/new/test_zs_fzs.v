`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/16 23:58:40
// Design Name: 
// Module Name: test_zs_fzs
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


module test_zs_fzs;
    reg[4:0] count = 0;
    reg[4:0] count_reg = 0;
    reg[4:0] fzs;
    reg[4:0] zs;
        reg[4:0] fzs1;
    reg[4:0] zs1;
        reg[4:0] fzs2;
    reg[4:0] zs2;
    always#10
    begin
        count <= count + 1;
        count_reg <= count;
    end
    wire flag;
    assign flag = |count;
    always@(negedge flag)
        fzs <= count_reg;
    always@(negedge flag)
        zs = count-1;
    always@(negedge flag)
    begin
            fzs1 = count-1;
            zs1 = fzs1;
    end
        always@(negedge flag)
    begin
            fzs2 <= count-1;
            zs2 <= fzs2;


    end
    
endmodule
