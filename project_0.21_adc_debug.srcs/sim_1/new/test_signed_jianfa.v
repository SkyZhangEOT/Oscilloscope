`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/19 16:53:26
// Design Name: 
// Module Name: test_signed_jianfa
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


module test_signed_jianfa;

reg[2:0] carry = 0;
reg[3:0] lenth = 0;
reg signed [4:0] real_lenth_add;
reg signed [4:0] real_lenth_minus;
always#10
begin
    carry = carry + 1;
    if(carry == 0)
        if(lenth == 8)
            lenth = 0;
        else
            lenth = lenth + 1;
        
end
always#10
begin
    real_lenth_add = lenth + carry;
    real_lenth_minus = lenth - carry;
end
endmodule
