`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/18 16:45:12
// Design Name: 
// Module Name: sim_bin2bcd_function
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


module sim_bin2bcd_function(

    );
    reg clk_in = 0;
    always#1
        clk_in = ~clk_in;
    reg [25:0] bin_in = 26'h0ffffff;
    always#200
        bin_in = bin_in+1;

   reg [31:0] bcd_out = 0;//最高32位输出
   reg valid_out;

       reg state = 0;
    reg [25:0] bin = 0;//输入的二进制码寄存器
    reg [4:0] cnt = 0;
    always@(posedge clk_in)
        case(state)
            1'b0:
                if(bin != bin_in)
                begin
                    bin <= bin_in;
                    state <= 1'b1;
                end
            1'b1:
                if(cnt == 26)
                    state = 1'b0;
        endcase
        
        always@(negedge clk_in)
            if(state)
                cnt = cnt + 1;
            else
                cnt = 0;
                
        
        reg[31:0] bcd = 0;
        wire[3:0] c0;
        wire[3:0] c1;
        wire[3:0] c2;
        wire[3:0] c3;
        wire[3:0] c4;
        wire[3:0] c5;
        wire[3:0] c6;
        wire[3:0] c7;
        bcd_comparator comp0(
            .code_in(bcd[3:0]),
            .code_out(c0)
            );
        bcd_comparator comp1(
            .code_in(bcd[7:4]),
            .code_out(c1)
            );
        bcd_comparator comp2(
            .code_in(bcd[11:8]),
            .code_out(c2)
            );
        bcd_comparator comp3(
            .code_in(bcd[15:12]),
            .code_out(c3)
            );
        bcd_comparator comp4(
            .code_in(bcd[19:16]),
            .code_out(c4)
            );
        bcd_comparator comp5(
            .code_in(bcd[23:20]),
            .code_out(c5)
            );

        bcd_comparator comp6(
            .code_in(bcd[27:24]),
            .code_out(c6)
            );
        bcd_comparator comp7(
            .code_in(bcd[31:28]),
            .code_out(c7)
            );

        always @(negedge clk_in)
            if(state) begin
                bcd[0] <= bin[25-cnt];
                bcd[4:1] <= c0;
                bcd[8:5] <= c1;
                bcd[12:9] <= c2;
                bcd[16:13] <= c3;
                bcd[20:17] <= c4;
                bcd[24:21] <= c5;
                bcd[28:25] <= c6;
                bcd[31:29] <= c7;
              end
            else
                bcd <= 0;
        
        always@(posedge clk_in)
            if(cnt == 26)
            begin
                bcd_out <= bcd;
                valid_out <= 0;
            end
            else
                valid_out <= 1;
    endmodule

