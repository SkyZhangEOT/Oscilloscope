`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/26 23:01:01
// Design Name: 
// Module Name: edgeline_state
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


module edgeline_state(
    input key_pressed_in,
    input [3:0] keyval_in,//四位，上下左右
    output reg[2:0] state = 0,//0是最下面的
    output reg[2:0] state0 = 0,
    output reg[2:0] state1 = 0,
    output reg[2:0] state2 = 0,
    output reg[2:0] state3 = 1,
    output reg[2:0] state4 = 0,
    output reg[2:0] state5 = 0
    );

    reg[2:0] state0_top = 3'd7;

    reg[2:0] state1_top = 3'd7;

    reg[2:0] state2_top = 3'd3;

    reg[2:0] state3_top = 3'd2;

    reg[2:0] state4_top = 3'd7;

    reg[2:0] state5_top = 3'd7;
    always@(posedge key_pressed_in)                  
        case(keyval_in)//根据拨码开关的位置向npv赋值            
            4'b0100://下移
                if (state >= 3'd5)                 
                    state <= 3'd5;                  
                else                                 
                    state <= state + 1'b1;           
            4'b1000://上移   
                if (state == 3'd0)                  
                    state <= state;                  
                else                                 
                    state <= state - 1'b1;           
            default:                                 
                state <= state;                      
        endcase
        
    always@(posedge key_pressed_in)                  
        case(state)//根据拨码开关的位置向npv赋值            
            3'd0:
                  case(keyval_in)
                      4'b0010://左
                          if (state0 == 3'd0)        
                              state0 <= state0;        
                          else                      
                              state0 <= state0 - 1'b1;
                      4'b0001://右  
                          if (state0 >= state0_top)         
                              state0 <= state0_top;       
                          else                        
                              state0 <= state0 + 1'b1;
                      default:state0 <= state0;
                  endcase
            3'd1:                                     
                        case(keyval_in)                     
                            4'b0010://左     
                                if (state1 == 3'd0)         
                                    state1 <= state1;       
                                else                        
                                    state1 <= state1 - 1'b1;
                            4'b0001://右     
                                if (state1 >= state1_top)   
                                    state1 <= state1_top;   
                                else                        
                                    state1 <= state1 + 1'b1;
                            default:state1 <= state1;       
                        endcase 
            3'd2:                                     
                              case(keyval_in)                     
                                  4'b0010://左     
                                      if (state2 == 3'd0)         
                                          state2 <= state2;       
                                      else                        
                                          state2 <= state2 - 1'b1;
                                  4'b0001://右     
                                      if (state2 >= state2_top)   
                                          state2 <= state2_top;   
                                      else                        
                                          state2 <= state2 + 1'b1;
                                  default:state2 <= state2;       
                              endcase 
            3'd3:                                     
                                    case(keyval_in)                     
                                        4'b0010://左     
                                            if (state3 == 3'd0)         
                                                state3 <= state3;       
                                            else                        
                                                state3 <= state3 - 1'b1;
                                        4'b0001://右     
                                            if (state3 >= state3_top)   
                                                state3 <= state3_top;   
                                            else                        
                                                state3 <= state3 + 1'b1;
                                        default:state3 <= state3;       
                                    endcase                             
            3'd4:                                     
                                          case(keyval_in)                     
                                              4'b0010://左     
                                                  if (state4 == 3'd0)         
                                                      state4 <= state4;       
                                                  else                        
                                                      state4 <= state4 - 1'b1;
                                              4'b0001://右     
                                                  if (state4 >= state4_top)   
                                                      state4 <= state4_top;   
                                                  else                        
                                                      state4 <= state4 + 1'b1;
                                              default:state4 <= state4;       
                                          endcase                             
            3'd5:                                     
                                                case(keyval_in)                     
                                                    4'b0010://左     
                                                        if (state5 == 3'd0)         
                                                            state5 <= state5;       
                                                        else                        
                                                            state5 <= state5 - 1'b1;
                                                    4'b0001://右     
                                                        if (state5 >= state5_top)   
                                                            state5 <= state5_top;   
                                                        else                        
                                                            state5 <= state5 + 1'b1;
                                                    default:state5 <= state5;       
                                                endcase                                                                                                      
        endcase
endmodule
