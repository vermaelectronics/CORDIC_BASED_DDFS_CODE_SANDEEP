//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
//Date        : Sat Jul 22 16:45:26 2023
//Host        : LAPTOP-VUEJVMSK running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=1,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (clk_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, CLK_DOMAIN design_1_clk_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk_0;

  wire [15:0]DDFS_BASED_ON_CORDIC_0_COSINE_WAVE;
  wire [15:0]DDFS_BASED_ON_CORDIC_0_SINE_WAVE;
  wire [0:0]Net;
  wire [9:0]Net1;
  wire clk_0_1;

  assign clk_0_1 = clk_0;
  design_1_DDFS_BASED_ON_CORDIC_0_0 DDFS_BASED_ON_CORDIC_0
       (.COSINE_WAVE(DDFS_BASED_ON_CORDIC_0_COSINE_WAVE),
        .FCW(Net1),
        .SINE_WAVE(DDFS_BASED_ON_CORDIC_0_SINE_WAVE),
        .clear_DDFS(Net),
        .clock_100_MHz(clk_0_1));
  design_1_ila_0_0 ila_0
       (.clk(clk_0_1),
        .probe0(Net),
        .probe1(Net1),
        .probe2(DDFS_BASED_ON_CORDIC_0_COSINE_WAVE),
        .probe3(DDFS_BASED_ON_CORDIC_0_SINE_WAVE));
  design_1_vio_0_0 vio_0
       (.clk(clk_0_1),
        .probe_in0(DDFS_BASED_ON_CORDIC_0_COSINE_WAVE),
        .probe_in1(DDFS_BASED_ON_CORDIC_0_SINE_WAVE),
        .probe_out0(Net),
        .probe_out1(Net1));
endmodule
