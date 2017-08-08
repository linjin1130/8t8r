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

module data_proc
(  
   input          clk_adc0   , 
   input          clk_adc1   ,
   input          clk_250m   ,
   input          rst_adc0   ,
   input          rst_adc1   ,
   input          rst_250m   ,
   input  [15:0]  adc_data0  ,
   input  [15:0]  adc_data1  ,
   input  [15:0]  adc_data2  ,
   input  [15:0]  adc_data3  , 
   input  [15:0]  adc_data4  ,
   input  [15:0]  adc_data5  ,
   input  [15:0]  adc_data6  ,
   input  [15:0]  adc_data7  , 
   output [15:0]  dac_data0  ,
   output [15:0]  dac_data1  ,   
   output [15:0]  dac_data2  ,   
   output [15:0]  dac_data3  ,   
   output [15:0]  dac_data4  ,   
   output [15:0]  dac_data5  ,   
   output [15:0]  dac_data6  ,   
   output [15:0]  dac_data7  ,                 
//   input          zyt1       , 
//   input          zyt2       , 
//   input          zyt3       ,                  
   output [7:0]   io_db_cb   , 
//   input          kn         , 
//   input          kw         , 
   output         n4_sum     , 
   output         n4_pk      , 
   output         w4_sum     , 
   output         w4_pk      
 );

///*********************************************************************
///internal reg singals
///*********************************************************************

///*********************************************************************
///internal wire singals
///*********************************************************************
  wire         vaid    ;
  wire [15:0]  din0    ;
  wire [15:0]  din1    ;
  wire [15:0]  din2    ;
  wire [15:0]  din3    ;
  wire [15:0]  din4    ;
  wire [15:0]  din5    ;
  wire [15:0]  din6    ;
  wire [15:0]  din7    ;
  wire [15:0]  data0   ;
  wire [15:0]  data1   ;
  wire [15:0]  data2   ;
  wire [15:0]  data3   ;
  wire [15:0]  data4   ;
  wire [15:0]  data5   ;
  wire [15:0]  data6   ;
  wire [15:0]  data7   ;
  wire [15:0]  proc_d0 ;
  wire [15:0]  proc_d1 ;
  wire [15:0]  proc_d2 ;
  wire [15:0]  proc_d3 ;
  wire [15:0]  proc_d4 ;
  wire [15:0]  proc_d5 ;
  wire [15:0]  proc_d6 ;
  wire [15:0]  proc_d7 ;
  wire [15:0]  dout0   ;
  wire [15:0]  dout1   ;   
  wire [15:0]  dout2   ;   
  wire [15:0]  dout3   ;   
  wire [15:0]  dout4   ;   
  wire [15:0]  dout5   ;   
  wire [15:0]  dout6   ;   
  wire [15:0]  dout7   ; 

///*********************************************************************
/// ADC domain to 250M domain
///*********************************************************************
adc2dac u_adc2dac
(
   .clk_adc0 ( clk_adc0  ), 
   .clk_adc1 ( clk_adc1  ),
   .clk_250m ( clk_250m  ),
   .rst_adc0 ( rst_adc0  ),
   .rst_adc1 ( rst_adc1  ),
   .rst_250m ( rst_250m  ),
   .din0     ( adc_data0 ),
   .din1     ( adc_data1 ),
   .din2     ( adc_data2 ),
   .din3     ( adc_data3 ), 
   .din4     ( adc_data4 ),
   .din5     ( adc_data5 ),
   .din6     ( adc_data6 ),
   .din7     ( adc_data7 ), 
   .valid    ( valid     ),
   .dout0    ( data0     ),
   .dout1    ( data1     ),   
   .dout2    ( data2     ),   
   .dout3    ( data3     ),   
   .dout4    ( data4     ),   
   .dout5    ( data5     ),   
   .dout6    ( data6     ),   
   .dout7    ( data7     )                           
 );

///*********************************************************************
/// 2x interpolation
///*********************************************************************
interpolation u_interpolation
(
  .clk    (  clk_250m ),
  .rst    (  rst_250m ),
  .valid  (  valid    ),
  .din0   (  data0    ),
  .din1   (  data1    ),
  .din2   (  data2    ),
  .din3   (  data3    ), 
  .din4   (  data4    ),
  .din5   (  data5    ),
  .din6   (  data6    ),
  .din7   (  data7    ), 
  .dout0  (  proc_d0  ),
  .dout1  (  proc_d1  ),   
  .dout2  (  proc_d2  ),   
  .dout3  (  proc_d3  ),   
  .dout4  (  proc_d4  ),   
  .dout5  (  proc_d5  ),   
  .dout6  (  proc_d6  ),   
  .dout7  (  proc_d7  )                           
 );

///*********************************************************************
/// pk_proc
///*********************************************************************
pk_proc u_pk_proc
(
   .clk      ( clk_250m ),
   .rst      ( rst_250m ),
   .din0     ( proc_d0  ),
   .din1     ( proc_d1  ),
   .din2     ( proc_d2  ),
   .din3     ( proc_d3  ), 
   .din4     ( proc_d4  ),
   .din5     ( proc_d5  ),
   .din6     ( proc_d6  ),
   .din7     ( proc_d7  ), 
   .dout0    ( dout0    ),
   .dout1    ( dout1    ),   
   .dout2    ( dout2    ),   
   .dout3    ( dout3    ),   
   .dout4    ( dout4    ),   
   .dout5    ( dout5    ),   
   .dout6    ( dout6    ),   
   .dout7    ( dout7    ),
//   .zyt1     ( zyt1     ), 
//   .zyt2     ( zyt2     ), 
//   .zyt3     ( zyt3     ),                  
   .io_db_cb ( io_db_cb ), 
//   .kn       ( kn       ), 
//   .kw       ( kw       ), 
   .n4_sum   ( n4_sum   ), 
   .n4_pk    ( n4_pk    ), 
   .w4_sum   ( w4_sum   ), 
   .w4_pk    ( w4_pk    )                              
 );                        


assign dac_data0 = dout0;
assign dac_data1 = dout1;   
assign dac_data2 = dout2;   
assign dac_data3 = dout3;   
assign dac_data4 = dout4;   
assign dac_data5 = dout5;   
assign dac_data6 = dout6;   
assign dac_data7 = dout7;   

endmodule