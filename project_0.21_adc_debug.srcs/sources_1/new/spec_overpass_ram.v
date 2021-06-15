`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/31 22:35:05
// Design Name: 
// Module Name: spec_overpass_ram
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


module spec_overpass_ram(//从test posedge的结果来看，判断和赋值都是上升沿之后的值
    input clk_in,
    input en_in,//搜索使能
    
    input [7:0] spec_addra_in,//0到255
    input data_in,
    
    input key_pressed_in,
    input [1:0] key_lr_in,//10：左搜， 01：右搜
    
    output reg[8:0] spec_addr_out,//512位的地址
    output reg got_out,
    output reg no_data_out = 1
    );
    reg spec_ram[0:255];
    reg[8:0] write_count = 0;
    always@(posedge clk_in)
        if(en_in)
          begin
            if(write_count < 9'd511)
            begin
                spec_ram[spec_addra_in] = data_in;
                write_count = write_count + 1;
            end
            else
                write_count = write_count;
          end
        else
            write_count = 9'd0;
    
    
    reg find_left = 0;
    reg got_left = 0;
    reg find_right = 0;
    reg got_right = 0;
    reg no_data = 1;
    always@(posedge key_pressed_in)
        if(en_in)
        begin
                if(key_lr_in == 2'b10)
                    begin
                        find_left = ~find_left;
                        find_right = find_right;
                    end
                else if(key_lr_in == 2'b01)
                    begin
                        find_left = find_left;
                        find_right = ~find_right;
                    end
                else
                    begin
                        find_left = find_left;
                        find_right = find_right;
                    end

        end                
    
    reg[1:0] state;//0:初始状态 1：向左搜 2:向右搜
    reg[7:0] spec_addr = 0;
    reg[8:0] step_count;
    
    

    
    
    always@(posedge clk_in)
        case(state)
            2'd0: begin
                      spec_addr = spec_addr;
                      step_count = 9'd0;
                      no_data = no_data;
                      
                      if(find_left != got_left)
                          state = 2'd1;
                      else if(find_right != got_right)
                          state = 2'd2;
                      else
                          state = state;
                  end
            2'd1: begin
                      spec_addr = spec_addr - 1;
                      step_count = step_count + 1;
                      if(spec_ram[spec_addr] == 1)
                          begin
                              state = 2'd0;
                              got_left = ~got_left;
                              no_data = 0;
                          end
                      else if(step_count == 9'd511)
                          begin
                              state = 2'd0;
                              got_left = ~got_left;
                              no_data = 1;
                          end
                      else
                          begin            
                          state = state;
                          got_left = got_left;     
                          no_data = 0; 
                      end              
                  end
            2'd2: begin                            
                            spec_addr = spec_addr + 1;   
                            step_count = step_count + 1; 
                            if(spec_ram[spec_addr] == 1) 
                                begin                    
                                    state = 2'd0;        
                                    got_right = ~got_right;             
                                    no_data = 0;         
                                end                      
                            else if(step_count == 9'd511)
                                begin                    
                                    state = 2'd0;        
                                    got_right = ~got_right;             
                                    no_data = 1;         
                                end                      
                            else                         
                                begin                    
                                state = state;           
                                got_right = got_right;                 
                                no_data = 0;             
                            end                          
                        end
            default: state = 2'd0;
        endcase
    
    always@(got_left or got_right or no_data)
        if(no_data)
            begin                                
                spec_addr_out = {1'b1,spec_addr};
                got_out = 0;                   
                no_data_out = 1;                 
            end
        else
            begin                                
                spec_addr_out = {1'b1,spec_addr};
                got_out = 1;                     
                no_data_out = 0;                 
            end                                  
endmodule
