`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: zhangwenxiang
// 
// Create Date: 2019/05/15 22:06:21
// Design Name: 
// Module Name: digit_char_rom
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
// A(0) B(1) C(2) D(3) E(4) F(5) G(6) H(7) I(8) J(9) K(10) L(11) M(12) N(13) O(14) P(15) Q(16) R(17) S(18) T(19) U(20) V(21) W(22) X(23)
    //Y(24) Z(25) a(26) b(27) c(28) d(29) e(30) f(31) g(32) h(33) i(34) j(35) k(36) m(37) n(38) o(39) p(40) q(41) r(42) s(43) t(44) u(45) v(46) w(47)
    //x(48) y(49) z(50) 0(51) 1(52) 2(53) 3(54) 4(55) 5(56) 6(57) 7(58) 8(59) 9(60) /(61) :(62) .(63)

module digit_char_rom(
    input clk_in,
//    input space_in,//空格
    input [5:0] digit_char_code_in,//哪个字符
    input [2:0] digit_char_bit_in,//字符的第几个像素
    output wire[15:0] digit_char_matrix_data_out//输出字符的列数据
    );
wire[8:0]addra;
wire[15:0] digit_char_matrix_data_t;
assign addra = (digit_char_code_in * 8) + digit_char_bit_in;
  blk_mem_gen_5 char_rom(
      .clka(clk_in),
      .ena(1),
      .addra(addra),
      .douta(digit_char_matrix_data_t)
    );
    assign digit_char_matrix_data_out = digit_char_matrix_data_t;
endmodule
