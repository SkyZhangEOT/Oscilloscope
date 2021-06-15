`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/19 14:21:51
// Design Name: 
// Module Name: bcd2code_core
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


module bcd2code_core(
    input [3:0] bcd_4bit_in,
    output reg[5:0] code_4bit_out
    );
        parameter n0 = 6'd50,    n1 = 6'd51,    n2 = 6'd52,    n3 = 6'd53,    n4 = 6'd54,
                   n5 = 6'd55,    n6 = 6'd56,    n7 = 6'd57,    n8 = 6'd58,    n9 = 6'd59,
                   cx = 6'd22;
    
    always@(*)
        case(bcd_4bit_in)
            4'd0: code_4bit_out = n0;
            4'd1: code_4bit_out = n1;
            4'd2: code_4bit_out = n2;
            4'd3: code_4bit_out = n3;
            4'd4: code_4bit_out = n4;
            4'd5: code_4bit_out = n5;
            4'd6: code_4bit_out = n6;
            4'd7: code_4bit_out = n7;
            4'd8: code_4bit_out = n8;
            4'd9: code_4bit_out = n9;
            default:code_4bit_out = cx;
        endcase

endmodule
