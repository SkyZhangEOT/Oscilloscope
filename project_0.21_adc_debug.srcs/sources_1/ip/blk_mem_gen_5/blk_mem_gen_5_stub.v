// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Thu May 16 18:09:22 2019
// Host        : DESKTOP-846A3QC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               F:/xilinx/project_0.12_char_disp/project_0.12_char_disp.srcs/sources_1/ip/blk_mem_gen_5/blk_mem_gen_5_stub.v
// Design      : blk_mem_gen_5
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *)
module blk_mem_gen_5(clka, ena, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[8:0],douta[15:0]" */;
  input clka;
  input ena;
  input [8:0]addra;
  output [15:0]douta;
endmodule
