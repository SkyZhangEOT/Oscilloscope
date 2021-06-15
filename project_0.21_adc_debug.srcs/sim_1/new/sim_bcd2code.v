`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/19 23:16:33
// Design Name: 
// Module Name: sim_bcd2code
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


module sim_bcd2code(

    );
    reg clk = 0;
    always#1
        clk = ~clk;
    reg[25:0] bin = 0;
    always#500
        bin = bin + 1;
    
    wire[31:0] bcd_out;
    wire bcd_valid_out;
    bin2bcd uut_bin2bcd(
            .clk_in(clk),
            .bin_in(bin),//���26λ����
            .bcd_out(bcd_out),//���32λ���
            .valid_out(bcd_valid_out)
            );
    reg[31:0] bcd;
    always@(posedge bcd_valid_out)
        bcd = bcd_out;

    wire wrong_out;
    wire valid_out;
    wire[35:0] code;
    wire[2:0]units;
    bcd2code uut_bcd2code(
            .clk_in(clk),
            .bcd_in(bcd),
            .carried_in(0),
            .carry_in(0),//������7��0
            .loosed_in(0),
            .loose_in(0),//���ȥ��7��0
            .wrong_out(wrong_out),
            .valid_out(valid_out),
            .code_out(code),//6���ַ���С���㱣��2λ
            .units_out(units)//0:�޵�λ��1:n,2:u,3:m,4:k,5:M��6:G��7:T
            );
endmodule
