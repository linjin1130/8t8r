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

module pk_proc
(
   input              clk      ,
   input              rst      ,
   input      [15:0]  din0     ,
   input      [15:0]  din1     ,
   input      [15:0]  din2     ,
   input      [15:0]  din3     , 
   input      [15:0]  din4     ,
   input      [15:0]  din5     ,
   input      [15:0]  din6     ,
   input      [15:0]  din7     , 
   output reg [15:0]  dout0    ,
   output reg [15:0]  dout1    ,   
   output reg [15:0]  dout2    ,   
   output reg [15:0]  dout3    ,   
   output reg [15:0]  dout4    ,   
   output reg [15:0]  dout5    ,   
   output reg [15:0]  dout6    ,   
   output reg [15:0]  dout7    ,
//   input              zyt1     , 
//   input              zyt2     , 
//   input              zyt3     ,                  
   output     [7:0]   io_db_cb , 
//   input              kn       , 
//   input              kw       , 
   output             n4_sum   , 
   output             n4_pk    , 
   output             w4_sum   , 
   output             w4_pk                                  
 );
///*********************************************************************
///internal reg singals
///*********************************************************************
//  reg [15:0] datain0;
      
///*********************************************************************
///internal wire singals
///*********************************************************************
//  wire [16:0] datain0;
 
///*********************************************************************
///ADC clock domain to 250M clock domain
///*********************************************************************
assign io_db_cb = 8'b0;
assign n4_sum   = 1'b0;
assign n4_pk    = 1'b0;
assign w4_sum   = 1'b0;
assign w4_pk    = 1'b0;

always @(posedge clk)
  if(rst) begin
      dout0 <= 16'b0;
      dout1 <= 16'b0;
      dout2 <= 16'b0;
      dout3 <= 16'b0;
      dout4 <= 16'b0;
      dout5 <= 16'b0;
      dout6 <= 16'b0;
      dout7 <= 16'b0;      	
  end
  else begin
      dout0 <= din0;
      dout1 <= din1;
      dout2 <= din2;
      dout3 <= din3;
      dout4 <= din4;
      dout5 <= din5;
      dout6 <= din6;
      dout7 <= din7;      	
  end   

endmodule