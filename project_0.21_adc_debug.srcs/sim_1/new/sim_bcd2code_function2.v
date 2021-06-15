`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 16:24:05
// Design Name: 
// Module Name: sim_bcd2code_function2
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


module sim_bcd2code_function2(

    );
        reg clk_in = 0;
    always#10
        clk_in = ~clk_in;
    reg[25:0] bin = 26'hfffff;
    always#1000
        bin = bin + 1;
    
    wire[31:0] bcd_out;
    wire bcd_valid_out;
    bin2bcd uut_bin2bcd(
            .clk_in(clk_in),
            .bin_in(bin),//最高26位输入
            .bcd_out(bcd_out),//最高32位输出
            .valid_out(bcd_valid_out)
            );
    reg[31:0] bcd_in;
    always@(posedge bcd_valid_out)
        bcd_in = bcd_out;
        
        
    parameter ca = 6'd0,     cb = 6'd1,     cc = 6'd2,     cd = 6'd3,     ce = 6'd4,     cf = 6'd5,     cg = 6'd6,     ch = 6'd7,     
                               ci = 6'd8,     cj = 6'd9,     ck = 6'd10,    cl = 6'd11,    cm = 6'd12,    cn = 6'd13,    cp = 6'd14,    cq = 6'd15,    
                               cr = 6'd16,    cs = 6'd17,    ct = 6'd18,    cu = 6'd19,    cv = 6'd20,    cw = 6'd21,    cx = 6'd22,    cy = 6'd23,    
                               cz = 6'd24,    a = 6'd25,     b = 6'd26,     c = 6'd27,     d = 6'd28,     e = 6'd29,     f = 6'd30,     g = 6'd31,     
                               h = 6'd32,     
                               //i = 6'd33,     j = 6'd34,     //i 和 j 已经用过了
                               k = 6'd35,     m = 6'd36,     n = 6'd37,     o = 6'd38,     p = 6'd39,     
                               q = 6'd40,     r = 6'd41,     s = 6'd42,     t = 6'd43,     u = 6'd44,     v = 6'd45,     w = 6'd46,     x = 6'd47,     
                               y = 6'd48,     z = 6'd49,     n0 = 6'd50,    n1 = 6'd51,    n2 = 6'd52,    n3 = 6'd53,    n4 = 6'd54,    n5 = 6'd55,    
                               n6 = 6'd56,    n7 = 6'd57,    n8 = 6'd58,    n9 = 6'd59,    div = 6'd60,   neg = 6'd61,  space = 6'd62,  point = 6'd63,
                               l = 6'd51,co = 6'd50;//字母l用数字1代替，数字0用大写字母O代替
    
    
            
            reg negative_in = 0;
            reg carried_in = 0;
            reg [2:0]carry_in = 0;//最多带了7个0
            reg loosed_in = 0;
            reg [2:0]loose_in = 0;//最多去了7个0
            
            reg [2:0] units_in = 4;//0:p，1:n, 2:u, 3:m, 4:无单位 5:k, 6:M，7:G
            reg [11:0] units_code_in = {ch,z};//最多两位符号输入//如果增加，要改units_code,code_out
            
            reg[47:0] code_out;//8个字符，小数点保留2位
            //output reg[2:0] units_out,//0:无单位，1:n,2:u,3:m,4:k,5:M，6:G，7:T
            ////////////test//////////////////
        //    output reg state,
        //    output reg[47:0] code_temp,
        //    output reg[3:0] lenth,
         //   output reg signed [4:0] real_lenth

            
            
            
        //                always@(posedge clk_in)
        //                    if(carried_in&loosed_in)
        //                        wrong_out = 1;
        //                    else
        //                        wrong_out = 0;
                        reg lenth_flag = 0;
                        reg[31:0] bcd_temp = 0;//用来操作的bcd码
                        reg state = 0;
                        always@(posedge clk_in)//状态转换
                            case(state)
                                1'b0:
                                     if(bcd_temp != bcd_in)
                                     begin
                                         bcd_temp <= bcd_in;
                                         state <= 1'b1;
                                     end
                                1'b1:
                                     if(lenth_flag)
                                         state <= 0;
                            endcase
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////            
                            
                            //////////////判断数据有效位长度
                        reg[5:0] i;
                        reg[5:0] j;
                        reg[3:0] lenth;//数据有效位长度
                        
                        always@(negedge clk_in)
                            if(state)
                            begin
                                for(i=32;i>=1;i=i-1)
                                begin
                                    j = i - 1;
                                    if(~lenth_flag)
                                    begin
                                        if(bcd_temp[j] != 0)
                                        begin
                                            lenth = (j/4) + 1;
                                            lenth_flag = 1;
                                        end
                                        else if(j == 0)
                                        begin
                                            lenth = 0;
                                            lenth_flag = 1;
                                        end
                                    end
                                end
                            end
                            else
                                lenth_flag = 0;
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                
                        /////////////////转换/////////////////////
                        wire[5:0] code0;
                        wire[5:0] code1;
                        wire[5:0] code2;
                        wire[5:0] code3;
                        wire[5:0] code4;
                        wire[5:0] code5;
                        wire[5:0] code6;
                        wire[5:0] code7;
                        
                        bcd2code_core bc0(
                            .bcd_4bit_in(bcd_temp[3:0]),
                            .code_4bit_out(code0)
                            );
                        bcd2code_core bc1(                  
                            .bcd_4bit_in(bcd_temp[7:4]),
                            .code_4bit_out(code1)       
                            );
                        bcd2code_core bc2(                  
                            .bcd_4bit_in(bcd_temp[11:8]),
                            .code_4bit_out(code2)       
                            );                          
                        bcd2code_core bc3(                  
                            .bcd_4bit_in(bcd_temp[15:12]),
                            .code_4bit_out(code3)       
                            );                        
                        bcd2code_core bc4(                  
                            .bcd_4bit_in(bcd_temp[19:16]),
                            .code_4bit_out(code4)       
                            );                          
                        bcd2code_core bc5(                  
                            .bcd_4bit_in(bcd_temp[23:20]),
                            .code_4bit_out(code5)       
                            );                          
                        bcd2code_core bc6(                  
                            .bcd_4bit_in(bcd_temp[27:24]),
                            .code_4bit_out(code6)       
                            );                          
                        bcd2code_core bc7(                  
                            .bcd_4bit_in(bcd_temp[31:28]),
                            .code_4bit_out(code7)       
                            );
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////下降沿
                        /////////////////////赋值/////////////////////
                        reg[47:0] code_temp;                          
                        always@(posedge lenth_flag)//时钟下降沿
                            code_temp <= {code7,code6,code5,code4,code3,code2,code1,code0};
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////上升沿
                        ////////////////////移位///////////////////
                        reg[17:0] code_temp_shift;
                        reg shift_flag = 0;
                        always@(posedge clk_in)
                            if(lenth_flag)
                                begin
                                    shift_flag = 1;
                                    case(lenth)
                                        4'd8: code_temp_shift <= code_temp[47:30];
                                        4'd7: code_temp_shift <= code_temp[41:24];
                                        4'd6: code_temp_shift <= code_temp[35:18];
                                        4'd5: code_temp_shift <= code_temp[29:12];
                                        4'd4: code_temp_shift <= code_temp[23:6];
                                        4'd3: code_temp_shift <= code_temp[17:0];
                                        4'd2: code_temp_shift <= {code_temp[11:0],n0};
                                        4'd1: code_temp_shift <= {code_temp[5:0],n0,n0};
                                        4'd0: code_temp_shift <= {n0,n0,n0};
                                    endcase
                                end
                            else
                                shift_flag = 0;
                            
                                
                        //////////////真实长度判断///////////////////
                        //长度最大8位
                        //因此范围是8+7 -- 0 - 7//////15~~~~-7
                        //
                        reg signed [4:0] real_lenth;
                        reg real_lenth_flag = 0;
                        always@(posedge clk_in)
                        if(lenth_flag)
                        begin
                            if(carried_in)
                                real_lenth <= lenth - carry_in;
                            else if(loosed_in)
                                real_lenth <= lenth + loose_in;
                            else
                                real_lenth <= lenth;
                            real_lenth_flag <= 1;
                        end
                        else
                            real_lenth_flag <= 0;
                    
                    wire[4:0] real_lenth_abs;
                    assign real_lenth_abs = real_lenth[4]? (~real_lenth) + 1 : real_lenth;
                    
                    wire[2:0] bit10_ans;//10进制，
                    assign bit10_ans = real_lenth_abs/3;
                    wire[1:0] bit10_remain;
                    assign bit10_remain = real_lenth_abs%3;
            
            
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////下降沿
            ///////////////加小数点///////////////
            reg[23:0] code_temp_point;//4位的带小数点的字符码
            reg point_flag = 0;
            always@(negedge clk_in)
                if(real_lenth_flag&&shift_flag)
                begin
                    point_flag <= 1;
                    if(~real_lenth[4])
                        case(bit10_remain)
                            2'd0: code_temp_point <= {code_temp_shift[17:0],point};
                            2'd1: code_temp_point <= {code_temp_shift[17:12],point,code_temp_shift[11:0]};
                            2'd2: code_temp_point <= {code_temp_shift[17:6],point,code_temp_shift[5:0]};
                        endcase
                    else
                        case(bit10_remain)                                                                
                            2'd0: code_temp_point <= {code_temp_shift[17:0],point};                       
                            2'd1: code_temp_point <= {code_temp_shift[17:6],point,code_temp_shift[5:0]};
                            2'd2: code_temp_point <= {code_temp_shift[17:12],point,code_temp_shift[11:0]};  
                        endcase
                end
                else
                    point_flag <= 0;
            
            
            /////////////判断单位//////////////
            reg units_flag = 0;
            reg [3:0] units_real;//0:y, 1:z, 2:a, 3:f, 4:p, 5:n, 6:u, 7:m, 8:无单位 9:k, 10:M, 11:G, 12:T, 13:P, 14:E, 15:Z
            always@(negedge clk_in)
                if(real_lenth_flag&&shift_flag)
                begin
                    units_flag <= 1;
                    if(~real_lenth[4])//如果真实长度是正数
                        case(bit10_ans)
                            3'd5: units_real <= units_in + 3'd4 + 3'd4;//加4位
                            3'd4: begin
                                      if(bit10_remain == 0)
                                          units_real <= units_in + 3'd4 + 2'd3;
                                      else
                                          units_real <= units_in + 3'd4 + 3'd4;
                                  end
                            3'd3: begin                                        
                                      if(bit10_remain == 0)                    
                                          units_real <= units_in + 3'd4 + 2'd2;
                                      else                                     
                                          units_real <= units_in + 3'd4 + 2'd3;
                                  end   
                            3'd2: begin                                        
                                      if(bit10_remain == 0)                    
                                          units_real <= units_in + 3'd4 + 1'd1;
                                      else                                     
                                          units_real <= units_in + 3'd4 + 2'd2;
                                  end
                            3'd1: begin                                        
                                      if(bit10_remain == 0)                    
                                          units_real <= units_in + 3'd4;
                                      else                                                                                     
                                          units_real <= units_in + 3'd4 + 1'd1;                                                                                 
                                  end
                            3'd0: begin                                        
                                      if(bit10_remain == 0)                    
                                          units_real <= units_in + 2'd3;       
                                      else                                     
                                          units_real <= units_in + 3'd4;
                                  end
                         endcase
                     else
                         case(bit10_ans)
                             3'd0: units_real <= units_in + 2'd3;//减一单位
                             3'd1: units_real <= units_in + 2'd2;//减二单位
                             3'd2: units_real <= units_in + 1'd1;//减三单位
                         endcase
                 end
                 else
                     units_flag <= 0;
            
        ////////////////////////////////////////////////////////////////////////////////////////////////////上升沿
        ////////////////转换单位字符/////////// 
        //0:y, 1:z, 2:a, 3:f, 4:p, 5:n, 6:u, 7:m, 8:无单位 9:k, 10:M, 11:G, 12:T, 13:P, 14:E, 15:Z
            reg[17:0] units_code;//单位字符
            always@(posedge clk_in)
                if(units_flag&&point_flag)
                    case(units_real)
                        4'h0:units_code <= {y,units_code_in};
                        4'h1:units_code <= {z,units_code_in};
                        4'h2:units_code <= {a,units_code_in};
                        4'h3:units_code <= {f,units_code_in};
                        4'h4:units_code <= {p,units_code_in};
                        4'h5:units_code <= {n,units_code_in};
                        4'h6:units_code <= {u,units_code_in};
                        4'h7:units_code <= {m,units_code_in};
                        4'h8:units_code <= {units_code_in,space};
                        4'h9:units_code <= {k,units_code_in};
                        4'ha:units_code <= {cm,units_code_in};
                        4'hb:units_code <= {cg,units_code_in};
                        4'hc:units_code <= {ct,units_code_in};
                        4'hd:units_code <= {cp,units_code_in};
                        4'he:units_code <= {ce,units_code_in};
                        4'hf:units_code <= {cz,units_code_in};
                    endcase
                    
                ///////////判断低位无效字符的个数//////////
                reg[1:0] state_low = 0;
                reg[23:0] code_temp_point_judge = 0;
                reg[1:0] lenth_low;//低位有几个无效位
                reg code_temp_low_flag = 0;
                always@(posedge clk_in)
                    case(state_low)
                        2'd0: if(code_temp_point_judge != code_temp_point)
                              begin
                                  state_low <= 2'd1;
                                  code_temp_point_judge <= code_temp_point;
                                  code_temp_low_flag <= 0;
                              end
                              else
                                  code_temp_low_flag <= 1;
                        2'd1:
                              if(code_temp_point_judge[5:0] == point)//第一位是小数点
                              begin
                                  lenth_low <= 2'd1;
                                  state_low <= 2'd0;
                                  code_temp_low_flag <= 1;
                              end
                              else if(code_temp_point_judge[5:0] == n0)
                              begin
                                  lenth_low <= 2'd1;      
                                  state_low <= 2'd2;//判断第二位
                              end
                              else
                              begin
                                  lenth_low <= 2'd0;
                                  state_low <= 2'd0;
                                  code_temp_low_flag <= 1;
                              end
                        2'd2: if(code_temp_point_judge[11:6] == point)//第二位是小数点       
                              begin                                                  
                                  lenth_low <= 2'd2; //无效长度2                           
                                  state_low <= 2'd0;                              
                                  code_temp_low_flag <= 1;  //已完成                         
                              end                                                    
                              else if(code_temp_point_judge[11:6] == n0)              
                              begin                                                  
                                  lenth_low <= 2'd3;//如果前两位没有小数点，且都是零，无效位为3                           
                                  state_low <= 2'd0;//判断第三位  
                                  code_temp_low_flag <= 1;                        
                              end                                                    
                              else                                                   
                              begin                                                  
                                  lenth_low <= lenth_low;                                 
                                  state_low <= 2'd0;       //返回初始态                          
                                  code_temp_low_flag <= 1;                           
                              end
                  endcase                                             
                                                                    
        ///////////////////////////////////////////////////////////////////////////////////////////////////////拼接
            always@(negedge clk_in)
                if(code_temp_low_flag)
                    case(lenth_low)
                        2'd0: if(negative_in)
                                  code_out <= {neg,code_temp_point,units_code};
                              else
                                  code_out <= {code_temp_point,units_code,space};
                        2'd1: if(negative_in)
                                  code_out <= {neg,code_temp_point[23:6],units_code,space};
                              else
                                  code_out <= {code_temp_point[23:6],units_code,space,space};
                        2'd2: if(negative_in)                                                
                                  code_out <= {neg,code_temp_point[23:12],units_code,space,space};  
                              else                                                           
                                  code_out <= {code_temp_point[23:12],units_code,space,space,space};
                        2'd3: if(negative_in)                                                
                                      code_out <= {neg,code_temp_point[23:18],units_code,space,space,space};  
                                  else                                                           
                                      code_out <= {code_temp_point[23:18],units_code,space,space,space,space};
                    endcase
endmodule
