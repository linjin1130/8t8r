//*****************************************************************************
// File    : 
// Project :        
// Tool    : Xilinx Vivado 2015.2
//
// Modify history
// Version : 
// Date    : 
// Note    : 
//*****************************************************************************

module adc9653_intf
(  
   output          adc_pdwn   , //From ADC pin 
   output          adc_sync   ,
   input           rst        ,
   input           adc_fco_p  ,
   input           adc_fco_n  ,
   input           adc_dco_p  ,
   input           adc_dco_n  ,
   input           adc_d0_a_p ,
   input           adc_d0_a_n ,
   input           adc_d1_a_p ,
   input           adc_d1_a_n ,
   input           adc_d0_b_p ,
   input           adc_d0_b_n ,  
   input           adc_d1_b_p ,
   input           adc_d1_b_n , 
   input           adc_d0_c_p ,
   input           adc_d0_c_n ,
   input           adc_d1_c_p ,
   input           adc_d1_c_n , 
   input           adc_d0_d_p ,
   input           adc_d0_d_n ,
   input           adc_d1_d_p ,
   input           adc_d1_d_n , 
   output          clk_adc    , // adc clock output, 125M 
   input           dly_clk    , // delay clock 200Mhz
   output  [15:0]  dout0      , // adc output data        
   output  [15:0]  dout1      ,
   output  [15:0]  dout2      ,
//   output fco,
   output  [15:0]  dout3             
 );

///*********************************************************************
///internal reg singals
///*********************************************************************
reg [63:0] data1;
reg [63:0] data2;

///*********************************************************************
///internal wire singals
///*********************************************************************
wire        fco     ;
wire        dco     ;
wire [3:0]  ch_d0_p ;
wire [3:0]  ch_d0_n ;
wire [3:0]  ch_d1_p ;
wire [3:0]  ch_d1_n ;
wire        adc_clk ;
wire [63:0] data_out;

///*********************************************************************
///
///*********************************************************************
assign adc_sync = 1'b0;
assign adc_pdwn = 1'b0; //ADC normal work

IBUFDS #(
   .DIFF_TERM   ("TRUE"  ),    // Differential Termination
   .IBUF_LOW_PWR("FALSE"   ),    // Low power="TRUE", Highest performance="FALSE" 
   .IOSTANDARD  ("DEFAULT")     // Specify the input I/O standard
) IBUFDS_dco_inst (
   .O ( dco       ),  // Buffer output
   .I ( adc_dco_p ),  // Diff_p buffer input (connect directly to top-level port)
   .IB( adc_dco_n )  // Diff_n buffer input (connect directly to top-level port)
);

IBUFDS #(
   .DIFF_TERM   ("TRUE"  ),    // Differential Termination
   .IBUF_LOW_PWR("FALSE"   ),    // Low power="TRUE", Highest performance="FALSE" 
   .IOSTANDARD  ("DEFAULT")     // Specify the input I/O standard
) IBUFDS_fco_inst (
   .O ( fco       ),  // Buffer output
   .I ( adc_fco_p ),  // Diff_p buffer input (connect directly to top-level port)
   .IB( adc_fco_n )  // Diff_n buffer input (connect directly to top-level port)
);
reg rst_sys_async;
reg rst_sys_sync;
reg rst_adc;
always @(posedge adc_clk) begin
    rst_sys_async <= rst;
    rst_sys_sync <= rst_sys_async;
    rst_adc <= rst_sys_sync & (!rst_sys_async);
end
assign ch_d0_p = {adc_d0_a_p,adc_d0_b_p, adc_d0_c_p, adc_d0_d_p};
assign ch_d0_n = {adc_d0_a_n,adc_d0_b_n, adc_d0_c_n, adc_d0_d_n};
assign ch_d1_p = {adc_d1_a_p,adc_d1_b_p, adc_d1_c_p, adc_d1_d_p};
assign ch_d1_n = {adc_d1_a_n,adc_d1_b_n, adc_d1_c_n, adc_d1_d_n};

wire [4:0] tap_out;
ADC_interface ADC_interface_inst
(
   .rst      ( rst_adc  ),
   .ch_d0_p  ( ch_d0_p  ),
   .ch_d0_n  ( ch_d0_n  ),
   .ch_d1_p  ( ch_d1_p  ),
   .ch_d1_n  ( ch_d1_n  ),
   .dco      ( dco      ),
   .fco      ( fco      ),
   .clk_adc  ( adc_clk  ),
   .dly_clk  ( dly_clk  ),
   .tap_out  ( tap_out  ),
   .data_out ( data_out )
);
wire [7:0] debug_tap = {3'b000,tap_out};
ila_4k_8bit u_adc0
(
  .clk    ( clk_adc  ),
  .probe0 (  debug_tap  )
);
BUFG u_clkadc
(
   .I ( adc_clk ),
   .O ( clk_adc )
);

    
always @(posedge clk_adc)
  if(rst_adc) begin
  	data1 <= 64'b0;
  	data2 <= 64'b0;
  end
  else begin
  	data1 <= data_out;
  	data2 <= data1;
  end

assign dout0 =  data2[15:0];   
assign dout1 =  data2[31:16];   
assign dout2 =  data2[47:32];   
assign dout3 =  data2[63:48];   

endmodule