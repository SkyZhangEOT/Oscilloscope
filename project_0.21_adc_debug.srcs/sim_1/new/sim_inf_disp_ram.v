`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/16 13:56:45
// Design Name: 
// Module Name: sim_inf_disp_ram
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


module sim_inf_disp_ram;
    reg clk = 0;
    always#10
        clk = ~clk;
        
    reg[14:0] waveinf_addr_in=0;
    reg[14:0] specinf_addr_in=0;
    
    always#20
    begin
        waveinf_addr_in = waveinf_addr_in + 1;
        specinf_addr_in = specinf_addr_in + 1;
    end
    reg waveinf_wea_in = 0;
    reg specinf_wea_in = 0;
    always@(*)
    if(waveinf_addr_in == 0)
    begin
        waveinf_wea_in = ~waveinf_wea_in;
        specinf_wea_in = ~specinf_wea_in;
    end
    wire waveinf_data_out;
    wire specinf_data_out;
    wire dina1;
    assign dina1 = waveinf_addr_in[2];
    wire dina2;
    assign dina2 = waveinf_addr_in[3];
    
          blk_mem_gen_6 waveinf_disp_ram(
            .clka(clk),
            .wea(waveinf_wea_in),
            .addra(waveinf_addr_in),
            .dina(dina1),
            .douta(waveinf_data_out)
          );
            blk_mem_gen_6 specinf_disp_ram(
                .clka(clk),
                .wea(specinf_wea_in),
                .addra(specinf_addr_in),
                .dina(dina2),
                .douta(specinf_data_out)
              );
     
endmodule
