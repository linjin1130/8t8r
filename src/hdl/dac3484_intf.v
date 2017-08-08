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

module dac3484_intf
(  
   input          clk250m        ,  // dac module input clk,
   input          clk500m        ,  // dac module input clk,ȱ500M
   input          clk500m_90     ,  // dac module input clk,ȱ500M
   input          rst            ,
   input  [15:0]  din0           ,  // input data, 250M SPS
   input  [15:0]  din1           ,
   input  [15:0]  din2           ,
   input  [15:0]  din3           ,
   output         clk_data_dac_p ,  // DAC pin
   output         clk_data_dac_n ,
   output         parity_dac_p   ,  //no
   output         parity_dac_n   ,
   output         frame_dac_p    ,
   output         frame_dac_n    ,
   output         sync_dac_p     ,
   output         sync_dac_n     ,
   output         ostr_p         ,
   output         ostr_n         ,
   output [15:0]  data_dac_db_p  ,
   output [15:0]  data_dac_db_n           
 );

///*********************************************************************
///internal reg singals
///*********************************************************************

///*********************************************************************
///internal wire singals
///*********************************************************************
//wire clk_90;
wire ostr  ;
//wire parity;

///*********************************************************************
///
///*********************************************************************
assign ostr = 1'b0;
assign parity = 1'b0;

OBUFDS #(
   .IOSTANDARD  ("DEFAULT"),  
   .SLEW        ("SLOW"   )  
) OBUFDS_ostr (
   .I ( ostr   ),  // Buffer output
   .O ( ostr_p ),  // Diff_p buffer input (connect directly to top-level port)
   .OB( ostr_n )   // Diff_n buffer input (connect directly to top-level port)
);

//OBUFDS #(
//   .IOSTANDARD  ("DEFAULT"),  
//   .SLEW        ("SLOW"   )  
//) OBUFDS_parity (
//   .I ( parity       ),  // Buffer output
//   .O ( parity_dac_p ),  // Diff_p buffer input (connect directly to top-level port)
//   .OB( parity_dac_n )   // Diff_n buffer input (connect directly to top-level port)
//);

DAC_interface DAC_interface_inst
(
    .rst      ( rst            ),
    .CLK      ( clk500m        ),
    .CLK_div  ( clk250m        ),
    .CLK_dly  ( CLK_dly        ),
    .Q_p      ( data_dac_db_p  ),
    .Q_n      ( data_dac_db_n  ),
    .frame_p  ( frame_dac_p    ),
    .frame_n  ( frame_dac_n    ),
    .SYNC_p   ( sync_dac_p     ),
    .SYNC_n   ( sync_dac_n     ),
    .parity_p ( parity_dac_p   ),
    .parity_n ( parity_dac_n   ),
    .DataCLk_p( clk_data_dac_p ),
    .DataCLk_n( clk_data_dac_n ),
    .Data_A   ( din0           ),
    .Data_B   ( din1           ),
    .Data_C   ( din2           ),
    .Data_D   ( din3           ),
    .DataCLk  ( clk500m_90     )
    );
    
//    assign clk_90 = !clk250m;
    
endmodule