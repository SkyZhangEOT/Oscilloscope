`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/17 23:07:02
// Design Name: 
// Module Name: simulation_main_1
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


module simulation_main_1(

    );
    reg clk = 0;
    always #10 
        clk = ~clk;
    reg[11:0] sw = 0;    
    reg[3:0] col;
    wire[3:0] row;
    reg add = 0;
    always #1000
        add = ~add;
    
     always@(*)
       if (row == 4'b1000)
           if (add)
                col = 4'b0001;
           else
               col = 4'b0010;
       else
        col = 4'b0000;

    wire[7:0] seg;
    wire[5:0] an;
    wire[11:0] led;
    wire Hsync;
    wire Vsync;
    wire vgaRed;
    wire vgaBlue;
    wire vgaGreen;
    spectrum_analyzer uut1(
        .clk(clk),
        .vauxp7(1),
        .vauxn7(0),
        .vauxp8(0),
        .vauxn8(0),
        .vauxp12(0),
        .vauxn12(0),
        .vauxp14(0),
        .vauxn14(0),
        .sw(sw),//[11:0]
        .col(col),//[3:0]
        //*********************output
        .row(row),//[3:0]
        .seg(seg),//7:0
        .an(an),//5:0
        .led(led),//[12:0]///////////////////////B型实验板是12位led
        .Hsync(Hsync),
        .Vsync(Vsync),
        .vgaRed(vgaRed),//[3:0]
        .vgaBlue(vgaBlue),//[3:0]
        .vgaGreen(vgaGreen)//[3:0]
        );
endmodule
