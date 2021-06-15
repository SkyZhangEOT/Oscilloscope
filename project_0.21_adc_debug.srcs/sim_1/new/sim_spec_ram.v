`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/13 21:40:37
// Design Name: 
// Module Name: sim_spec_ram
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


module sim_spec_ram;
    reg clk = 0;
    reg fft_valid = 0;
    reg[8:0] addra = 0;
    reg[8:0] addrb = 0;
    wire[7:0] data_in;
    wire[7:0] data_out;
    initial
    begin
        fft_valid = 1;
        #5120;
        fft_valid = 0;
    end
    always #10
        clk = !clk;
        
    always #20
        addra = addra+1;
    assign data_in = addra[8:1];
    always#20
        addrb = addrb+1;
       
    spec_ram uut_spec_ram(
                .clk_in(clk),
                .fft_valid_in(fft_valid),
                .spec_addra_in(addra),//[8£º0]
                .spec_data_in(data_in),//[7:0]
                .spec_addrb_in(addrb),
                .spec_data_out(data_out)//[7:0]
                );
endmodule
