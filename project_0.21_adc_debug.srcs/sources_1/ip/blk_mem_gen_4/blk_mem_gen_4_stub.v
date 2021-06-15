// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Sun May 12 16:04:01 2019
// Host        : DESKTOP-846A3QC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               F:/xilinx/project_0.11_wave_sync/project_0.11_wave_sync.srcs/sources_1/ip/blk_mem_gen_4/blk_mem_gen_4_stub.v
// Design      : blk_mem_gen_4
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *)
module blk_mem_gen_4(clka, ena, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[8:0],dina[11:0],clkb,enb,addrb[8:0],doutb[11:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [8:0]addra;
  input [11:0]dina;
  input clkb;
  input enb;
  input [8:0]addrb;
  output [11:0]doutb;
endmodule
