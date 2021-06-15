`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/27 00:04:29
// Design Name: 
// Module Name: edgeline_char_state
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


module edgeline_char_state(
    input [2:0] char_state_in,
    
    output reg[3:0] char_height_out,//当前像素高度
//    input [3:0] char_bit_in,//最多写13.5个字/////////////////注意，接口不对应
    output reg[5:0] char_code_out,//当前字符代码
//    input pixel_color_in,
    ////////////////////////六个接口//////////////////////////////
    input [3:0] char_height0_in,
//    output reg[3:0] char_bit0_out,
    input [5:0] char_code0_in,
//    output reg pixel_color0_out,
    
    input [3:0] char_height1_in,  
//    output reg[3:0] char_bit1_out,
    input [5:0] char_code1_in,    
//    output reg pixel_color1_out,  
    
    input [3:0] char_height2_in,  
//    output reg[3:0] char_bit2_out,
    input [5:0] char_code2_in,    
//    output reg pixel_color2_out,  
    
    input [3:0] char_height3_in,  
//    output reg[3:0] char_bit3_out,
    input [5:0] char_code3_in,    
//    output reg pixel_color3_out,  
    
    input [3:0] char_height4_in,  
//    output reg[3:0] char_bit4_out,
    input [5:0] char_code4_in,    
//    output reg pixel_color4_out,  
    
    input [3:0] char_height5_in,  
//    output reg[3:0] char_bit5_out,
    input [5:0] char_code5_in   
//    output reg pixel_color5_out 
    );
    always@(*)
        case(char_state_in)
            3'd0: begin
                      char_height_out <= char_height0_in;
//                      char_bit0_out <= char_bit_in;
                      char_code_out <= char_code0_in;
//                      pixel_color0_out <= pixel_color_in;
                  end
            3'd1:begin                                  
                      char_height_out <= char_height1_in;
//                      char_bit1_out <= char_bit_in;      
                      char_code_out <= char_code1_in;    
//                      pixel_color1_out <= pixel_color_in;
                  end                                    
            3'd2:begin                                  
                      char_height_out <= char_height2_in;
//                      char_bit2_out <= char_bit_in;      
                      char_code_out <= char_code2_in;    
//                      pixel_color2_out <= pixel_color_in;
                  end                                    
            3'd3:begin                                  
                      char_height_out <= char_height3_in;
//                      char_bit3_out <= char_bit_in;      
                      char_code_out <= char_code3_in;    
//                      pixel_color3_out <= pixel_color_in;
                  end                                    
            3'd4:begin                                  
                      char_height_out <= char_height4_in;
//                      char_bit4_out <= char_bit_in;      
                      char_code_out <= char_code4_in;    
//                      pixel_color4_out <= pixel_color_in;
                  end                                    
            3'd5:begin                                  
                      char_height_out <= char_height5_in;
//                      char_bit5_out <= char_bit_in;      
                      char_code_out <= char_code5_in;    
//                      pixel_color5_out <= pixel_color_in;
                  end
        endcase
endmodule
