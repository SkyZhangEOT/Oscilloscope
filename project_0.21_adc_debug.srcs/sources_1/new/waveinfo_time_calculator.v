`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/17 19:53:15
// Design Name: 
// Module Name: waveinfo_time_calculator
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


 module waveinfo_time_calculator(//计算周期,频率
    input clk_in,
    input clk1Hz_in,      
    input sync_trigger_in,
    input [15:0]sync_count_in,
    input [3:0] clk_state_in,//时钟频率状态
    output wire[31:0] freq_bcd_out,
    output reg[18:0] period_bit_out,
    output wire[2:0] period_loosed_out
    );
    
    reg[3:0] bcd0 = 0;
    reg[3:0] bcd1 = 0;
    reg[3:0] bcd2 = 0;
    reg[3:0] bcd3 = 0;
    reg[3:0] bcd4 = 0;
    reg[3:0] bcd5 = 0;
    reg[3:0] bcd6 = 0;
    reg[3:0] bcd7 = 0;
    
    wire[3:0] bcd1_wire;
    assign bcd1_wire = bcd1;
    
    reg cnt_state = 0;
    reg[31:0] freq_bcd = 0;
    assign freq_bcd_out = freq_bcd;
    reg save = 0;
    always@(posedge clk1Hz_in)
        cnt_state = ~cnt_state;
    always@(posedge sync_trigger_in)
        if(cnt_state) begin save <= 0;
            if(bcd0 == 9) begin bcd0 <= 0;
                if(bcd1 == 9) begin bcd1 <= 0;
                    if(bcd2 == 9) begin bcd2 <= 0;
                        if(bcd3 == 9) begin bcd3 <= 0;
                            if(bcd4 == 9) begin bcd4 <= 0;
                                if(bcd5 == 9) begin bcd5 <= 0;
                                    if(bcd6 == 9) begin bcd6 <= 0;
                                        if(bcd7 == 9) bcd7 <= 0;
                                        else bcd7 <= bcd7 + 1; end
                                    else bcd6 <= bcd6 + 1; end
                                else bcd5 <= bcd5 + 1; end
                            else bcd4 <= bcd4 + 1; end
                        else bcd3 <= bcd3 + 1; end
                    else bcd2 <= bcd2 + 1; end
                else bcd1 <= bcd1 + 1; end
            else bcd0 <= bcd0 + 1; end
        else begin
            if(save == 0)
            begin
                freq_bcd <= {bcd7,bcd6,bcd5,bcd4,bcd3,bcd2,bcd1,bcd0};
                save <= 1;
            end
            else
            begin
                bcd0 <= 0;
                bcd1 <= 0;
                bcd2 <= 0;
                bcd3 <= 0;
                bcd4 <= 0;
                bcd5 <= 0;
                bcd6 <= 0;
                bcd7 <= 0;
            end
        end
            


       reg[2:0] period_info;
       reg[2:0] period_loosed;
       assign period_loosed_out = period_loosed;
       reg[1:0] unit = 2'd0;//时间单位，0:ns, 1:us, 2:ms, 3:s
       always@(posedge clk_in)
           case(clk_state_in)
               4'hf: begin
                         period_info = 2;//20ns
                         period_loosed = 1;
                     end
               4'he: begin
                         period_info = 5;//50ns
                         period_loosed = 1;      
                     end
               4'hd: begin
                         period_info = 1;//100ns
                         period_loosed = 2;      
                     end
               4'hc:begin
                         period_info = 2;//200ns
                         period_loosed = 2;      
                    end
               4'hb:begin
                         period_info = 5;//500ns
                         period_loosed = 2;      
                    end
               4'ha:begin
                         period_info = 1;//1,000ns
                         period_loosed = 3;      
                    end
               4'h9:begin
                         period_info = 2;//2,000ns
                         period_loosed = 3;      
                    end
               4'h8:begin
                         period_info = 5;//5,000ns
                         period_loosed = 3;      
                    end
               4'h7:begin
                         period_info = 1;//10,000ns
                         period_loosed = 4;      
                    end
               4'h6:begin
                         period_info = 2;//20,000ns
                         period_loosed = 4;
                    end
               4'h5:begin
                         period_info = 5;//50,000ns
                         period_loosed = 4;
                    end
               4'h4:begin
                         period_info = 1;//100,000ns
                         period_loosed = 5;
                    end
               4'h3:begin
                         period_info = 2;//200,000ns
                         period_loosed = 5;
                    end
               4'h2:begin
                         period_info = 5;//500,000ns
                         period_loosed = 5;
                    end
               4'h1:begin
                         period_info = 1;//1,000,000ns
                         period_loosed = 6;
                    end
               4'h0:begin
                         period_info = 1;//2,000,000ns
                         period_loosed = 6;
                    end
           endcase
       ///////////计数寄存器结果//////////
       reg [15:0] count;
       always@(posedge clk_in)
           case(sync_count_in)
               16'h0000:count = 16'd0;
               16'h0001:count = 16'd0;
               16'hffff:count = 16'd0;
               default:count = sync_count_in;
           endcase
           
      ///////////周期计算结果////////////
       always@(posedge clk1Hz_in)
           case(period_info)
               3'd1: period_bit_out <= count;//乘以1
               3'd2: period_bit_out <= count<<1;//乘以2
               3'd5: period_bit_out <= {count,2'b00} + {2'b00,count};//乘以5
               default: period_bit_out = period_bit_out;
           endcase
endmodule

