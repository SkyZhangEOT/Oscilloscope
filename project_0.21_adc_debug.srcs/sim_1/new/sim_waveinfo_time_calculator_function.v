`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/20 11:47:39
// Design Name: 
// Module Name: sim_waveinfo_time_calculator_function
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


module sim_waveinfo_time_calculator_function(

    );
        reg clk_in = 0;
    always#10
        clk_in = ~clk_in;
    reg[15:0] sync_count_in = 0;
    reg[3:0] clk_state_in = 0;
   always#1000
   begin
       clk_state_in = clk_state_in + 1;
       if(clk_state_in == 0)
           sync_count_in = sync_count_in + 50;
   end



       wire[25:0] freq_out;//26位二进制数
       wire[2:0] freq_carry_out;//频谱后面带的零
       wire freq_wrong_out;//频率出错

   
       reg[25:0] clk_info;//clk基础时钟
       reg[2:0] carry = 0;//缩放，代表后面有多少个0
       assign freq_carry_out = carry;
       reg[1:0] unit = 2'd0;//时间单位，0:ns, 1:us, 2:ms, 3:s
       always@(posedge clk_in)
           case(clk_state_in)
               4'h0: begin
                         clk_info = 26'd15260000;//*10000
                         carry = 3'd4;
                        //time_info = 655360;
                         unit = 2'd0;
                     end
               4'h1: begin
                         clk_info = 26'd30520000;
                         carry = 3'd4;
                        //time_info = 327680;
                         unit = 2'd0;
                     end
               4'h2: begin
                         clk_info = 26'd6104000;//*1000
                         carry = 3'd3;
                        //time_info = 163840;
                         unit = 2'd0;
                     end
               4'h3:begin
                        clk_info = 26'd12207000;
                        carry = 3'd3;
                        //time_info = 81920;
                        unit = 2'd0;
                    end
               4'h4:begin
                        clk_info = 26'd24414000;
                        carry = 3'd3;
                        //time_info = 40960;
                        unit = 2'd0;
                    end
               4'h5:begin
                        clk_info = 26'd48828000;
                        carry = 3'd3;
                        //time_info = 20480;
                        unit = 2'd0;
                    end
               4'h6:begin
                        clk_info = 26'd9765600;//*100
                        carry = 3'd2;
                       //time_info = 10240;
                        unit = 2'd0;
                    end
               4'h7:begin
                        clk_info = 26'd19531300;
                        carry = 3'd2;
                        //time_info = 5120;
                        unit = 2'd0;
                    end
               4'h8:begin
                        clk_info = 26'd39062500;
                        carry = 3'd2;
                        //time_info = 2560;
                        unit = 2'd0;
                    end
               4'h9:begin
                        clk_info = 26'd7812500;//*10
                        carry = 3'd1;
                        //time_info = 1280;
                        unit = 2'd0;
                    end
               4'ha:begin
                        clk_info = 26'd15625000;
                        carry = 3'd1;
                        //time_info = 640;
                        unit = 2'd0;
                    end
               4'hb:begin
                        clk_info = 26'd31250000;
                        carry = 3'd1;
                        //time_info = 320;
                        unit = 2'd0;
                    end
               4'hc:begin
                        clk_info = 26'd6250000;//*1
                        carry = 3'd0;
                        //time_info = 160;
                        unit = 2'd0;
                    end
               4'hd:begin
                        clk_info = 26'd12500000;
                        carry = 3'd0;
                        //time_info = 80;
                        unit = 2'd0;
                    end
               4'he:begin
                        clk_info = 26'd25000000;
                        carry = 3'd0;
                        //time_info = 40;
                        unit = 2'd0;
                    end
               4'hf:begin
                        clk_info = 26'd50000000;
                        carry = 3'd0;
                        //time_info = 20;
                        unit = 2'd0;
                    end
           endcase
       ///////////计数寄存器结果//////////
       reg [15:0] count;
       always@(posedge clk_in)
           case(sync_count_in)
               16'h0000:count = 16'd0;
               16'h0001:count = 16'd0;
               16'hffff:count = 16'd0;
               default:count = sync_count_in + 1'd1;
           endcase
           
      ///////////频率计算结果////////////
       
       
       reg[25:0] signal_freq;
       assign freq_out = signal_freq;
       reg freq_wrong;
       assign freq_wrong_out = freq_wrong;
       wire[25:0] freq_ans;//除法器出来的结果
       ///////////判断结果是否错误///////
       always@(posedge clk_in)
           if(count == 0)
           begin
               signal_freq = 26'd0;
               freq_wrong = 1;
           end
           else
           begin
               signal_freq = freq_ans;
               freq_wrong = 0;
           end
       ////////除法器调用////////////////
       wire[25:0] freq_remain_ans;//余数
       wire divider_valid;
       divider ins1_divider(//除数为零时，结果全一
               .clk_in(clk_in),
               .dividend_in({6'd0,clk_info}), 
               .divisor_in({16'd0,count}),
           
               .valid_out(divider_valid),
               .ans_out(freq_ans),
               .remain_out(freq_remain_ans)
           );
endmodule
