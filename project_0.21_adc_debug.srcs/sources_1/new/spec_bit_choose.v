`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/08 21:53:56
// Design Name: 
// Module Name: spec_bit_choose
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


module spec_bit_choose(
    input [48:0] amp_in,
    input key_pressed_in,
    input [15:0] keyval_in,
    output reg[7:0] amp_data_out = 0
    );

    reg[5:0] state = 6'd10;
    
    always@(posedge key_pressed_in)
        casex(keyval_in)//根据拨码开关的位置向npv赋值
            16'b0000_0000_1000_0000://缩小
                if (state == 6'd41)
                    state <= state;
                else
                    state <= state + 1'b1;
            16'b0000_0000_0000_1000://放大
                if (state == 6'd0)
                    state <= state;
                else
                    state <= state - 1'b1;
            default:                      
                state <= state;
        endcase
    always@(*)
        case(state)
6'd0:
        begin
        if((|amp_in[48:8])||(amp_in[7:0] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[7:0];
        end
        6'd1:
        begin
        if((|amp_in[48:9])||(amp_in[8:1] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[8:1];
        end
        6'd2:
        begin
        if((|amp_in[48:10])||(amp_in[9:2] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[9:2];
        end
        6'd3:
        begin
        if((|amp_in[48:11])||(amp_in[10:3] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[10:3];
        end
        6'd4:
        begin
        if((|amp_in[48:12])||(amp_in[11:4] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[11:4];
        end
        6'd5:
        begin
        if((|amp_in[48:13])||(amp_in[12:5] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[12:5];
        end
        6'd6:
        begin
        if((|amp_in[48:14])||(amp_in[13:6] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[13:6];
        end
        6'd7:
        begin
        if((|amp_in[48:15])||(amp_in[14:7] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[14:7];
        end
        6'd8:
        begin
        if((|amp_in[48:16])||(amp_in[15:8] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[15:8];
        end
        6'd9:
        begin
        if((|amp_in[48:17])||(amp_in[16:9] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[16:9];
        end
        6'd10:
        begin
        if((|amp_in[48:18])||(amp_in[17:10] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[17:10];
        end
        6'd11:
        begin
        if((|amp_in[48:19])||(amp_in[18:11] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[18:11];
        end
        6'd12:
        begin
        if((|amp_in[48:20])||(amp_in[19:12] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[19:12];
        end
        6'd13:
        begin
        if((|amp_in[48:21])||(amp_in[20:13] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[20:13];
        end
        6'd14:
        begin
        if((|amp_in[48:22])||(amp_in[21:14] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[21:14];
        end
        6'd15:
        begin
        if((|amp_in[48:23])||(amp_in[22:15] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[22:15];
        end
        6'd16:
        begin
        if((|amp_in[48:24])||(amp_in[23:16] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[23:16];
        end
        6'd17:
        begin
        if((|amp_in[48:25])||(amp_in[24:17] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[24:17];
        end
        6'd18:
        begin
        if((|amp_in[48:26])||(amp_in[25:18] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[25:18];
        end
        6'd19:
        begin
        if((|amp_in[48:27])||(amp_in[26:19] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[26:19];
        end
        6'd20:
        begin
        if((|amp_in[48:28])||(amp_in[27:20] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[27:20];
        end
        6'd21:
        begin
        if((|amp_in[48:29])||(amp_in[28:21] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[28:21];
        end
        6'd22:
        begin
        if((|amp_in[48:30])||(amp_in[29:22] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[29:22];
        end
        6'd23:
        begin
        if((|amp_in[48:31])||(amp_in[30:23] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[30:23];
        end
        6'd24:
        begin
        if((|amp_in[48:32])||(amp_in[31:24] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[31:24];
        end
        6'd25:
        begin
        if((|amp_in[48:33])||(amp_in[32:25] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[32:25];
        end
        6'd26:
        begin
        if((|amp_in[48:34])||(amp_in[33:26] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[33:26];
        end
        6'd27:
        begin
        if((|amp_in[48:35])||(amp_in[34:27] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[34:27];
        end
        6'd28:
        begin
        if((|amp_in[48:36])||(amp_in[35:28] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[35:28];
        end
        6'd29:
        begin
        if((|amp_in[48:37])||(amp_in[36:29] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[36:29];
        end
        6'd30:
        begin
        if((|amp_in[48:38])||(amp_in[37:30] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[37:30];
        end
        6'd31:
        begin
        if((|amp_in[48:39])||(amp_in[38:31] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[38:31];
        end
        6'd32:
        begin
        if((|amp_in[48:40])||(amp_in[39:32] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[39:32];
        end
        6'd33:
        begin
        if((|amp_in[48:41])||(amp_in[40:33] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[40:33];
        end
        6'd34:
        begin
        if((|amp_in[48:42])||(amp_in[41:34] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[41:34];
        end
        6'd35:
        begin
        if((|amp_in[48:43])||(amp_in[42:35] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[42:35];
        end
        6'd36:
        begin
        if((|amp_in[48:44])||(amp_in[43:36] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[43:36];
        end
        6'd37:
        begin
        if((|amp_in[48:45])||(amp_in[44:37] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[44:37];
        end
        6'd38:
        begin
        if((|amp_in[48:46])||(amp_in[45:38] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[45:38];
        end
        6'd39:
        begin
        if((|amp_in[48:47])||(amp_in[46:39] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[46:39];
        end
        6'd40:
        begin
        if(amp_in[48]||(amp_in[47:40] > 8'd200))
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[47:40];
        end
        6'd41:
        begin
        if(amp_in[48:41] > 8'd200)
            amp_data_out <= 8'd200;
        else
            amp_data_out <= amp_in[48:41];
        end
        endcase
endmodule
