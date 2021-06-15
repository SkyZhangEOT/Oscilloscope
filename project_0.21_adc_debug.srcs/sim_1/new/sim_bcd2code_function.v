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


module sim_bcd2code_function;
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




    reg carried_in = 1;
    reg[2:0]carry_in = 7;//最多带了7个0
    reg loosed_in = 0;
    reg [2:0]loose_in = 0;//最多去了7个0       


//////////////output
   reg wrong_out;
   reg valid_out;
   reg[35:0] code_out;//6个字符，小数点保留2位
   reg[2:0] units_out;//0:无单位，1:n,2:u,3:m,4:k,5:M，6:G，7:T
                parameter  zero = 3'd0, sn = 3'd1, su = 3'd2, sm = 3'd3, 
                           lk = 3'd4, lm = 3'd5, lg = 3'd6, lt = 3'd7, space = 6'd62,
                           n0 = 6'd50,point = 6'd63;
                always@(posedge clk_in)
                    if(carried_in&&loosed_in)
                        wrong_out = 1;
                    else
                        wrong_out = 0;
                        
                reg[31:0] bcd_temp = 0;//用来操作的bcd码
                reg[31:0] bcd_check = 0;//用来比较的bcd码
                reg state = 0;
                reg[2:0] cnt;
                always@(posedge clk_in)//状态转换
                    case(state)
                        1'b0:
                             if(bcd_check != bcd_in)
                             begin
                                 bcd_check = bcd_in;
                                 bcd_temp = bcd_in;
                                 state = 1'b1;
                             end
                        1'b1:
                             if(cnt == 7)
                                 state = 0;
                    endcase
                    
                    
                    //////////////判断数据有效位长度
                reg[5:0] i;
                reg[5:0] j;
                reg[3:0] lenth;//数据有效位长度
                reg lenth_flag = 0;
                always@(posedge clk_in)
                    if(~state)
                    begin
                        for(i=32;i>=1;i=i-1)
                        begin
                            j = i - 1;
                            if(~lenth_flag)
                            begin
                                if(bcd_in[j] != 0)
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
                            
                            
                always@(posedge clk_in)//计数
                    if(state)
                        cnt = cnt + 1;
                    else
                        cnt = 3'd7;
                
                
                ////////////////////赋值
                reg[3:0] bcd;//传给bcd2core核的数据
                
                reg finished;//移位完成标志
                always@(cnt)
                begin
                    if(cnt != 7)
                    begin
                        bcd = bcd_temp[31:28];
                        bcd_temp = bcd_temp << 4;
                        finished = 0;
                    end
                    else
                    begin
                        bcd = bcd_temp[31:28];
                        finished = 1;
                    end
                end
                
                
                /////////////////转换
                wire[5:0] code;
                bcd2code_core bcd2code_core(
                    .bcd_in(bcd),
                    .code_out(code)
                    );  
                 
                 reg[2:0] cnt1;//延迟的cnt1，用于传出数据的判断  
                always@(negedge clk_in)//计数
                        if(state)
                            cnt1 = cnt1 + 1;
                        else
                            cnt1 = 3'd7; 
                /////////////赋值
                reg[47:0] code_temp;
                reg code_out_finished = 0;
                always@(cnt1)
                    if(~finished)
                    begin
                        code_temp[5:0] = code;
                        code_temp = code_temp << 6;
                        code_out_finished = 0;
                    end
                    else
                    begin
                        code_temp[5:0] = code;
                        code_out_finished = 1;
                    end
                //////////////真实长度判断
                //长度最大8位
                //因此范围是8+7 -- 0 - 7
                reg signed [4:0] real_lenth;
                reg real_lenth_flag = 0;
                always@(posedge clk_in)
                if(lenth_flag)
                begin
                    if(wrong_out)
                        real_lenth = 0;
                    else if(carried_in)
                        real_lenth = lenth - carry_in;
                    else if(loosed_in)
                        real_lenth = lenth + loose_in;
                    else
                        real_lenth = lenth;
                    real_lenth_flag = 1;
                end
                else
                    real_lenth_flag = 0;
            
            
            reg code_change_finished = 0;
            always@(posedge clk_in)//给出6位code，单位，k,m,g
                if(real_lenth_flag&&code_out_finished)
                begin
                    case(real_lenth)//从15位到-7位
                        5'b01111://15位，原长度为8位，加7位零,
                        begin
                            code_out = code_temp[47:12];
                            units_out = lg;
                        end
                        5'b01110://14位，两种可能前5位
                        begin
                            case(lenth)
                                4'd8:begin code_out = {space,code_temp[47:18]}; units_out = lg;end
                                4'd7:begin code_out = {space,code_temp[41:12]}; units_out = lg;end
                            endcase
                        end
                        5'b01101://13前4位
                        begin
                            case(lenth)//两个空格，4个有效数,小数点前4位
                                4'd8:begin code_out = {code_temp[47:24],point,code_temp[23:18]}; units_out = lg;end
                                4'd7:begin code_out = {code_temp[41:18],point,code_temp[17:12]}; units_out = lg;end
                                4'd6:begin code_out = {code_temp[35:12],point,code_temp[11:6]}; units_out = lg;end
                            endcase
                        end
                        5'b01100://12前3位
                        begin
                            case(lenth)//3个空格，3个有效位
                                4'd8:begin code_out = {code_temp[47:30],point,code_temp[29:18]}; units_out = lg;end
                                4'd7:begin code_out = {code_temp[41:24],point,code_temp[23:12]}; units_out = lg;end
                                4'd6:begin code_out = {code_temp[35:18],point,code_temp[17:6]}; units_out = lg;end
                                4'd5:begin code_out = {code_temp[29:12],point,code_temp[11:0]}; units_out = lg;end
                            endcase
                        end
                        5'b01011://11前2位
                        begin
                            case(lenth)//3个空格，3个有效位                                                           
                                4'd8:begin code_out = {code_temp[47:36],point,code_temp[35:18]}; units_out = lg;end
                                4'd7:begin code_out = {code_temp[41:30],point,code_temp[29:12]}; units_out = lg;end
                                4'd6:begin code_out = {code_temp[35:24],point,code_temp[23:6]}; units_out = lg;end
                                4'd5:begin code_out = {code_temp[29:18],point,code_temp[17:0]}; units_out = lg;end
                                4'd4:begin code_out = {space,code_temp[23:12],point,code_temp[11:0]}; units_out = lg;end
                            endcase                                                                           
                        end
                        5'b01010://10,小数点前一位,G
                        begin
                            case(lenth)
                                4'd8:begin code_out = {code_temp[47:42],point,code_temp[41:18]}; units_out = lg;end     
                                4'd7:begin code_out = {code_temp[41:36],point,code_temp[35:12]}; units_out = lg;end     
                                4'd6:begin code_out = {code_temp[35:30],point,code_temp[29:6]}; units_out = lg;end      
                                4'd5:begin code_out = {code_temp[29:24],point,code_temp[23:0]}; units_out = lg;end      
                                4'd4:begin code_out = {space,code_temp[23:18],point,code_temp[17:0]}; units_out = lg;end
                                4'd3:begin code_out = {space,space,code_temp[17:12],point,code_temp[11:0]}; units_out = lg;end
                            endcase                                                                                     
                        end
                        5'b01001://9,小数点前3位,后两位，M
                        begin
                            case(lenth)                                                                                       
                                4'd8:begin code_out = {code_temp[47:30],point,code_temp[29:18]}; units_out = lm;end           
                                4'd7:begin code_out = {code_temp[41:24],point,code_temp[23:12]}; units_out = lm;end           
                                4'd6:begin code_out = {code_temp[35:18],point,code_temp[17:6]}; units_out = lm;end            
                                4'd5:begin code_out = {code_temp[29:12],point,code_temp[11:0]}; units_out = lm;end            
                                4'd4:begin code_out = {space,code_temp[23:6],point,code_temp[5:0]}; units_out = lm;end      
                                4'd3:begin code_out = {space,space,space,code_temp[17:0]}; units_out = lm;end
                                4'd2:begin code_out = {space,space,space,code_temp[11:0],n0}; units_out = lm;end
                            endcase                                                                                           
                        end
                        5'b01000://8位,小数点前两位，后三位
                        begin
                            case(lenth)                                                                               
                                4'd8:begin code_out = {code_temp[47:36],point,code_temp[35:18]}; units_out = lm;end   
                                4'd7:begin code_out = {code_temp[41:30],point,code_temp[29:12]}; units_out = lm;end   
                                4'd6:begin code_out = {code_temp[35:24],point,code_temp[23:6]}; units_out = lm;end    
                                4'd5:begin code_out = {code_temp[29:18],point,code_temp[17:0]}; units_out = lm;end    
                                4'd4:begin code_out = {space,code_temp[23:12],point,code_temp[11:0]}; units_out = lm;end
                                4'd3:begin code_out = {space,space,code_temp[17:6],point,code_temp[5:0]}; units_out = lm;end         
                                4'd2:begin code_out = {space,space,space,space,code_temp[11:0]}; units_out = lm;end
                                4'd1:begin code_out = {space,space,space,space,code_temp[5:0],n0}; units_out = lm;end
                            endcase                                                                                   
                        end
                        5'b00111://7位，小数点前1位
                        begin
                            case(lenth)                                                                                     
                                4'd8:begin code_out = {code_temp[47:42],point,code_temp[41:18]}; units_out = lm;end         
                                4'd7:begin code_out = {code_temp[41:36],point,code_temp[35:12]}; units_out = lm;end         
                                4'd6:begin code_out = {code_temp[35:30],point,code_temp[29:6]}; units_out = lm;end          
                                4'd5:begin code_out = {code_temp[29:24],point,code_temp[23:0]}; units_out = lm;end          
                                4'd4:begin code_out = {space,code_temp[23:18],point,code_temp[17:0]}; units_out = lm;end    
                                4'd3:begin code_out = {space,space,code_temp[17:12],point,code_temp[11:0]}; units_out = lm;end
                                4'd2:begin code_out = {space,space,space,code_temp[11:6],point,code_temp[5:0]}; units_out = lm;end         
                                4'd1:begin code_out = {space,space,space,space,space,code_temp[5:0]}; units_out = lm;end    
                            endcase                                                                                         
                        end
                        5'b00110://6位，小数点前3位，单位k
                        begin
                            case(lenth)                                                                                           
                                4'd8:begin code_out = {code_temp[47:30],point,code_temp[29:18]}; units_out = lk;end               
                                4'd7:begin code_out = {code_temp[41:24],point,code_temp[23:12]}; units_out = lk;end               
                                4'd6:begin code_out = {code_temp[35:18],point,code_temp[17:6]}; units_out = lk;end                
                                4'd5:begin code_out = {code_temp[29:12],point,code_temp[11:0]}; units_out = lk;end                
                                4'd4:begin code_out = {space,code_temp[23:6],point,code_temp[5:0]}; units_out = lk;end          
                                4'd3:begin code_out = {space,space,space,code_temp[17:0]}; units_out = lk;end    
                                4'd2:begin code_out = {space,space,space,code_temp[11:0],n0}; units_out = lk;end
                                4'd1:begin code_out = {space,space,space,code_temp[5:0],n0,n0}; units_out = lk;end             
                            endcase                                                                                               
                        end
                        5'b00101://5位，小数点前2位，
                        begin
                            case(lenth)                                                                               
                                4'd8:begin code_out = {code_temp[47:36],point,code_temp[35:18]}; units_out = lk;end   
                                4'd7:begin code_out = {code_temp[41:30],point,code_temp[29:12]}; units_out = lk;end   
                                4'd6:begin code_out = {code_temp[35:24],point,code_temp[23:6]}; units_out = lk;end    
                                4'd5:begin code_out = {code_temp[29:18],point,code_temp[17:0]}; units_out = lk;end    
                                4'd4:begin code_out = {space,code_temp[23:12],point,code_temp[11:0]}; units_out = lk;end
                                4'd3:begin code_out = {space,space,code_temp[17:6],point,code_temp[17:6]}; units_out = lk;end         
                                4'd2:begin code_out = {space,space,space,space,code_temp[11:0]}; units_out = lk;end      
                                4'd1:begin code_out = {space,space,space,space,code_temp[5:0],n0}; units_out = lk;end    
                            endcase                                                                                   
                        end
                        5'b00100://4位，小数点前1位
                        begin
                            case(lenth)                                                                                      
                                4'd8:begin code_out = {code_temp[47:42],point,code_temp[41:18]}; units_out = lk;end          
                                4'd7:begin code_out = {code_temp[41:36],point,code_temp[35:12]}; units_out = lk;end          
                                4'd6:begin code_out = {code_temp[35:30],point,code_temp[29:6]}; units_out = lk;end           
                                4'd5:begin code_out = {code_temp[29:24],point,code_temp[23:0]}; units_out = lk;end           
                                4'd4:begin code_out = {space,code_temp[23:18],point,code_temp[17:0]}; units_out = lk;end     
                                4'd3:begin code_out = {space,space,code_temp[17:12],point,code_temp[11:6]}; units_out = lk;end
                                4'd2:begin code_out = {space,space,space,code_temp[11:6],point,code_temp[5:0]}; units_out = lk;end          
                                4'd1:begin code_out = {space,space,space,space,space,code_temp[5:0]}; units_out = lk;end        
                            endcase                                                                                          
                        end
                        5'b00011://3位，单位为0,小数点前3位
                        begin
                            case(lenth)                                                                               
                                4'd8:begin code_out = {code_temp[47:30],point,code_temp[29:18]}; units_out = zero;end   
                                4'd7:begin code_out = {code_temp[41:24],point,code_temp[23:12]}; units_out = zero;end   
                                4'd6:begin code_out = {code_temp[35:18],point,code_temp[17:6]}; units_out = zero;end    
                                4'd5:begin code_out = {code_temp[29:12],point,code_temp[11:0]}; units_out = zero;end    
                                4'd4:begin code_out = {space,code_temp[23:6],point,code_temp[5:0]}; units_out = zero;end
                                4'd3:begin code_out = {space,space,space,code_temp[17:0]}; units_out = zero;end         
                                4'd2:begin code_out = {space,space,space,code_temp[11:0],n0}; units_out = zero;end      
                                4'd1:begin code_out = {space,space,space,code_temp[5:0],n0,n0}; units_out = zero;end    
                            endcase                                                                                   
                        end
                        5'b00010://2位，单位为0，小数点前两位
                        begin
                            case(lenth)                                                                                       
                                4'd8:begin code_out = {code_temp[47:36],point,code_temp[35:18]}; units_out = zero;end           
                                4'd7:begin code_out = {code_temp[41:30],point,code_temp[29:12]}; units_out = zero;end           
                                4'd6:begin code_out = {code_temp[35:24],point,code_temp[23:6]}; units_out = zero;end            
                                4'd5:begin code_out = {code_temp[29:18],point,code_temp[17:0]}; units_out = zero;end            
                                4'd4:begin code_out = {space,code_temp[23:12],point,code_temp[11:0]}; units_out = zero;end      
                                4'd3:begin code_out = {space,space,code_temp[17:6],point,code_temp[17:6]}; units_out = zero;end 
                                4'd2:begin code_out = {space,space,space,space,code_temp[11:0]}; units_out = zero;end           
                                4'd1:begin code_out = {space,space,space,space,code_temp[5:0],n0}; units_out = zero;end         
                            endcase                                                                                           
                        end
                        5'b00001://小数点前一位
                        begin
                            case(lenth)                                                                                           
                                4'd8:begin code_out = {code_temp[47:42],point,code_temp[41:18]}; units_out = zero;end               
                                4'd7:begin code_out = {code_temp[41:36],point,code_temp[35:12]}; units_out = zero;end               
                                4'd6:begin code_out = {code_temp[35:30],point,code_temp[29:6]}; units_out = zero;end                
                                4'd5:begin code_out = {code_temp[29:24],point,code_temp[23:0]}; units_out = zero;end                
                                4'd4:begin code_out = {space,code_temp[23:18],point,code_temp[17:0]}; units_out = zero;end          
                                4'd3:begin code_out = {space,space,code_temp[17:12],point,code_temp[11:6]}; units_out = zero;end    
                                4'd2:begin code_out = {space,space,space,code_temp[11:6],point,code_temp[5:0]}; units_out = zero;end
                                4'd1:begin code_out = {space,space,space,space,space,code_temp[5:0]}; units_out = zero;end          
                            endcase                                                                                               
                        end
                        5'b00000://小数点前三位，单位sm
                        begin
                            case(lenth)
                                4'd7:begin code_out = {code_temp[41:24],point,code_temp[23:12]}; units_out = sm;end   
                                4'd6:begin code_out = {code_temp[35:18],point,code_temp[17:6]}; units_out = sm;end    
                                4'd5:begin code_out = {code_temp[29:12],point,code_temp[11:0]}; units_out = sm;end    
                                4'd4:begin code_out = {space,code_temp[23:6],point,code_temp[5:0]}; units_out = sm;end
                                4'd3:begin code_out = {space,space,space,code_temp[17:0]}; units_out = sm;end         
                                4'd2:begin code_out = {space,space,space,code_temp[11:0],n0}; units_out = sm;end      
                                4'd1:begin code_out = {space,space,space,code_temp[5:0],n0,n0}; units_out = sm;end  
                            endcase    
                        end
                        5'b11111://-1,小数点前2位，
                        begin
                            case(lenth)                                                                                                
                                4'd6:begin code_out = {code_temp[35:24],point,code_temp[23:6]}; units_out = sm;end           
                                4'd5:begin code_out = {code_temp[29:18],point,code_temp[17:0]}; units_out = sm;end           
                                4'd4:begin code_out = {space,code_temp[23:12],point,code_temp[11:0]}; units_out = sm;end     
                                4'd3:begin code_out = {space,space,code_temp[17:6],point,code_temp[17:6]}; units_out = sm;end
                                4'd2:begin code_out = {space,space,space,space,code_temp[11:0]}; units_out = sm;end          
                                4'd1:begin code_out = {space,space,space,space,code_temp[5:0],n0}; units_out = sm;end        
                            endcase                                                                                            
                        end
                        5'b11110://-2,小数点前一位
                        begin
                            case(lenth)           
                                4'd5:begin code_out = {code_temp[29:24],point,code_temp[23:0]}; units_out = sm;end                
                                4'd4:begin code_out = {space,code_temp[23:18],point,code_temp[17:0]}; units_out = sm;end          
                                4'd3:begin code_out = {space,space,code_temp[17:12],point,code_temp[11:6]}; units_out = sm;end    
                                4'd2:begin code_out = {space,space,space,code_temp[11:6],point,code_temp[5:0]}; units_out = sm;end
                                4'd1:begin code_out = {space,space,space,space,space,code_temp[5:0]}; units_out = sm;end          
                            endcase                                                                                                 
                        end
                        5'b11101://-3,小数点前3位，单位su
                        begin
                            case(lenth)                                                                                  
                                4'd4:begin code_out = {space,code_temp[23:6],point,code_temp[5:0]}; units_out = su;end
                                4'd3:begin code_out = {space,space,space,code_temp[17:0]}; units_out = su;end         
                                4'd2:begin code_out = {space,space,space,code_temp[11:0],n0}; units_out = su;end      
                                4'd1:begin code_out = {space,space,space,code_temp[5:0],n0,n0}; units_out = su;end    
                            endcase                                                                                   
                        end
                        5'b11100://-4,小数点前2位
                        begin
                            case(lenth)                                                                                        
                                4'd3:begin code_out = {space,space,code_temp[17:6],point,code_temp[17:6]}; units_out = su;end
                                4'd2:begin code_out = {space,space,space,space,code_temp[11:0]}; units_out = su;end          
                                4'd1:begin code_out = {space,space,space,space,code_temp[5:0],n0}; units_out = su;end        
                            endcase                                                                                          
                        end
                        5'b11011://-5,小数点前1位
                        begin
                            case(lenth)                                                                                           
                                4'd2:begin code_out = {space,space,space,code_temp[11:6],point,code_temp[5:0]}; units_out = su;end
                                4'd1:begin code_out = {space,space,space,space,space,code_temp[5:0]}; units_out = su;end          
                            endcase                                                                                               
                        end
                        5'b11010://-6     前三位 单位sn
                        begin
                            code_out = {space,space,space,code_temp[5:0],n0,n0}; units_out = sn;
                        end
                    endcase
                    code_change_finished = 1;
                end
                else
                    code_change_finished = 0;
        always@(negedge clk_in)
            if(code_change_finished)
                valid_out = 1;
            else
                valid_out = 0;
endmodule
