`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/05/28 16:01:24
// Design Name: 
// Module Name: AD_CLK_GENERATE
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


module AD_CLK_GENERATE
(
    input       dco        ,
    input       dly_clk    ,
    input       re_sync_in ,
    output      dly_rdy    ,
    output[4:0] tap_out    ,
    output      clk_out    ,
    output      clk_div_out
);
      
    // 输入差分时钟经过IBUFDS模块得到单端时钟
    (* keep="true" *)reg [4:0] delay_tap_dly=0;
    (* keep="true" *)reg load_en_dly=0;
    //1. 单端时钟经过IDELAY模块
//    (* IODELAY_GROUP = IODELAY_GROUP *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL
    
       IDELAYCTRL IDELAYCTRL_inst (
          .RDY(dly_rdy),       // 1-bit output: Ready output
          .REFCLK(dly_clk), // 1-bit input: Reference clock input
          .RST(rst_in)        // 1-bit input: Active high reset input
       );
//    (* IODELAY_GROUP = IODELAY_GROUP *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL
       
       wire dco_dly;
       wire clk_out_serdes;
       IDELAYE2 #(
          .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
          .DELAY_SRC("IDATAIN"),           // Delay input (IDATAIN, DATAIN)
          .HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
          .IDELAY_TYPE("VAR_LOAD"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
          .IDELAY_VALUE(0),                // Input delay tap setting (0-31)
          .PIPE_SEL("FALSE"),              // Select pipelined mode, FALSE, TRUE
          .REFCLK_FREQUENCY(200.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
          .SIGNAL_PATTERN("CLOCK")          // DATA, CLOCK input signal
       )
       IDELAYE2_inst (
          .CNTVALUEOUT(tap_out), // 5-bit output: Counter value output
          .DATAOUT(dco_dly),         // 1-bit output: Delayed data output
          .C(dly_clk),                     // 1-bit input: Clock input
          .CE(0),                   // 1-bit input: Active high enable increment/decrement input
          .CINVCTRL(0),       // 1-bit input: Dynamic clock inversion input
          .CNTVALUEIN(delay_tap_dly),   // 5-bit input: Counter value input
          .DATAIN(0),           // 1-bit input: Internal delay data input
          .IDATAIN(dco),         // 1-bit input: Data input from the I/O
          .INC(0),                 // 1-bit input: Increment / Decrement tap delay input
          .LD(load_en_dly),                   // 1-bit input: Load IDELAY_VALUE input
          .LDPIPEEN(0),       // 1-bit input: Enable PIPELINE register to load data input
          .REGRST(0)            // 1-bit input: Active-high reset tap-delay input
       );
    //2. IDELAY模块的输出经过BUFIO和BUFR产生延时的时钟和分频时钟，延时时钟与分频时钟认为是相位对其的
         /*(* keep="true" *)*/ wire clk_out_bufr;
         /*(* keep="true" *)*/ wire clk_out_bufio;
      BUFR #(
          .BUFR_DIVIDE("4"),   // Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8" 
          .SIM_DEVICE("7SERIES")  // Must be set to "7SERIES" 
       )
       BUFR_inst (
          .O(clk_out_bufr),     // 1-bit output: Clock output port
          .CE(1),   // 1-bit input: Active high, clock enable (Divided modes only)
          .CLR(0), // 1-bit input: Active high, asynchronous clear (Divided modes only)
          .I(dco_dly)      // 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
       );
       BUFIO BUFIO_inst (
             .O(clk_out_bufio), // 1-bit output: Clock output (connect to I/O clock loads).
             .I(dco_dly)  // 1-bit input: Clock input (connect to an IBUF or BUFMR).
          );

   //对齐计数器控制  
   //当发现未对齐时，清零对齐计数器
   //当正在运行时，对齐计数器增加 
   reg re_sync_in_d1;
   reg re_sync_in_d2;
   wire re_sync;
   assign re_sync = !re_sync_in_d2 & re_sync_in_d1;
   always @(posedge dly_clk) begin
//      delay_tap_dly <= delay_tap;
//      load_en_dly   <= load_en;   
       re_sync_in_d1    <= re_sync_in;
       re_sync_in_d2    <= re_sync_in_d1;
      if(re_sync == 1) begin
          delay_tap_dly <= 10;
          load_en_dly   <= 1;
      end
      else begin
          load_en_dly   <= 0;
      end 
   end     
   
   assign clk_out       = clk_out_bufio;
   assign clk_div_out   = clk_out_bufr;
endmodule
