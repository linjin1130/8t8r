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

module interpolation
(
   input              clk   ,
   input              rst   ,
   input              valid ,
   input      [15:0]  din0  ,
   input      [15:0]  din1  ,
   input      [15:0]  din2  ,
   input      [15:0]  din3  , 
   input      [15:0]  din4  ,
   input      [15:0]  din5  ,
   input      [15:0]  din6  ,
   input      [15:0]  din7  , 
   output reg [15:0]  dout0 ,
   output reg [15:0]  dout1 ,   
   output reg [15:0]  dout2 ,   
   output reg [15:0]  dout3 ,   
   output reg [15:0]  dout4 ,   
   output reg [15:0]  dout5 ,   
   output reg [15:0]  dout6 ,   
   output reg [15:0]  dout7                            
 );
///*********************************************************************
///internal reg singals
///*********************************************************************
  reg [15:0]  datain0;
  reg [15:0]  datain1;
  reg [15:0]  datain2;
  reg [15:0]  datain3;
  reg [15:0]  datain4;
  reg [15:0]  datain5;
  reg [15:0]  datain6;
  reg [15:0]  datain7;        


///*********************************************************************
///internal wire singals
///*********************************************************************
  wire [23:0]  dataout0;
  wire [23:0]  dataout1;
  wire [23:0]  dataout2;
  wire [23:0]  dataout3;
  wire [23:0]  dataout4;
  wire [23:0]  dataout5;
  wire [23:0]  dataout6;
  wire [23:0]  dataout7; 
  
///*********************************************************************
///ADC clock domain to 250M clock domain
///*********************************************************************
always @(posedge clk)
  if(rst) begin
      datain0 <= 16'b0;
      datain1 <= 16'b0;
      datain2 <= 16'b0;
      datain3 <= 16'b0;
      datain4 <= 16'b0;
      datain5 <= 16'b0;
      datain6 <= 16'b0;
      datain7 <= 16'b0;      	
  end
  else begin
      datain0 <= din0;
      datain1 <= din1;
      datain2 <= din2;
      datain3 <= din3;
      datain4 <= din4;
      datain5 <= din5;
      datain6 <= din6;
      datain7 <= din7;      	
  end   
  
filter u_filter_d0
(
  .aclk               ( clk      ),
  .s_axis_data_tvalid ( valid    ),
  .s_axis_data_tready (          ),
  .s_axis_data_tdata  ( datain0  ),
  .m_axis_data_tvalid (          ),
  .m_axis_data_tdata  ( dataout0 )
);

filter u_filter_d1
(
  .aclk               ( clk      ),
  .s_axis_data_tvalid ( valid    ),
  .s_axis_data_tready (          ),
  .s_axis_data_tdata  ( datain1  ),
  .m_axis_data_tvalid (          ),
  .m_axis_data_tdata  ( dataout1 )
);

filter u_filter_d2
(
  .aclk               ( clk      ),
  .s_axis_data_tvalid ( valid    ),
  .s_axis_data_tready (          ),
  .s_axis_data_tdata  ( datain2  ),
  .m_axis_data_tvalid (          ),
  .m_axis_data_tdata  ( dataout2 )
);

filter u_filter_d3
(
  .aclk               ( clk      ),
  .s_axis_data_tvalid ( valid    ),
  .s_axis_data_tready (          ),
  .s_axis_data_tdata  ( datain3  ),
  .m_axis_data_tvalid (          ),
  .m_axis_data_tdata  ( dataout3 )
);

filter u_filter_d4
(
  .aclk               ( clk      ),
  .s_axis_data_tvalid ( valid    ),
  .s_axis_data_tready (          ),
  .s_axis_data_tdata  ( datain4  ),
  .m_axis_data_tvalid (          ),
  .m_axis_data_tdata  ( dataout4 )
);

filter u_filter_d5
(
  .aclk               ( clk      ),
  .s_axis_data_tvalid ( valid    ),
  .s_axis_data_tready (          ),
  .s_axis_data_tdata  ( datain5  ),
  .m_axis_data_tvalid (          ),
  .m_axis_data_tdata  ( dataout5 )
);

filter u_filter_d6
(
  .aclk               ( clk      ),
  .s_axis_data_tvalid ( valid    ),
  .s_axis_data_tready (          ),
  .s_axis_data_tdata  ( datain6  ),
  .m_axis_data_tvalid (          ),
  .m_axis_data_tdata  ( dataout6 )
);

filter u_filter_d7
(
  .aclk               ( clk      ),
  .s_axis_data_tvalid ( valid    ),
  .s_axis_data_tready (          ),
  .s_axis_data_tdata  ( datain7  ),
  .m_axis_data_tvalid (          ),
  .m_axis_data_tdata  ( dataout7 )
);

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
      dout0 <= dataout0[15:0];
      dout1 <= dataout1[15:0];
      dout2 <= dataout2[15:0];
      dout3 <= dataout3[15:0];
      dout4 <= dataout4[15:0];
      dout5 <= dataout5[15:0];
      dout6 <= dataout6[15:0];
      dout7 <= dataout7[15:0];      	
  end   

endmodule