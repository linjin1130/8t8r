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

module adc2dac
(
   input               clk_adc0 , 
   input               clk_adc1 ,
   input               clk_250m ,
   input               rst_adc0 ,
   input               rst_adc1 ,
   input               rst_250m ,
   input      [15:0]   din0     ,
   input      [15:0]   din1     ,
   input      [15:0]   din2     ,
   input      [15:0]   din3     , 
   input      [15:0]   din4     ,
   input      [15:0]   din5     ,
   input      [15:0]   din6     ,
   input      [15:0]   din7     , 
   output reg          valid    ,
   output reg [15:0]   dout0    ,
   output reg [15:0]   dout1    ,   
   output reg [15:0]   dout2    ,   
   output reg [15:0]   dout3    ,   
   output reg [15:0]   dout4    ,   
   output reg [15:0]   dout5    ,   
   output reg [15:0]   dout6    ,   
   output reg [15:0]   dout7                               
 );
///*********************************************************************
///internal reg singals
///*********************************************************************
reg  [15:0]   din0_r1    ;
reg  [15:0]   din1_r1    ;
reg  [15:0]   din2_r1    ;
reg  [15:0]   din3_r1    ; 
reg  [15:0]   din4_r1    ;
reg  [15:0]   din5_r1    ;
reg  [15:0]   din6_r1    ;
reg  [15:0]   din7_r1    ; 
reg  [15:0]   din0_r2    ;
reg  [15:0]   din1_r2    ;
reg  [15:0]   din2_r2    ;
reg  [15:0]   din3_r2    ; 
reg  [15:0]   din4_r2    ;
reg  [15:0]   din5_r2    ;
reg  [15:0]   din6_r2    ;
reg  [15:0]   din7_r2    ; 
reg  [15:0]   din0_r3    ;
reg  [15:0]   din1_r3    ;
reg  [15:0]   din2_r3    ;
reg  [15:0]   din3_r3    ; 
reg  [15:0]   din4_r3    ;
reg  [15:0]   din5_r3    ;
reg  [15:0]   din6_r3    ;
reg  [15:0]   din7_r3    ; 
reg           wea_adc0   ;
reg           wea_adc1   ;
reg  [2:0]    addr_adc0  ;
reg  [2:0]    addr_adc1  ;
reg  [63:0]   din_adc0   ;
reg  [63:0]   din_adc1   ;
reg  [2:0]    addr_250m  ;
reg           valid_250m ;

///*********************************************************************
///internal wire singals
///*********************************************************************
wire [63:0] douta_250m;
wire [63:0] doutb_250m;

///*********************************************************************
///ADC clock domain to 250M clock domain
///*********************************************************************
ila_4k u_adc0
(
  .clk    ( clk_adc0  ),
  .probe0 ( din0_r2   ),
  .probe1 ( din1_r2   ),
  .probe2 ( din2_r2   ),
  .probe3 ( din3_r2   )
);

ila_4k u_adc1
(
  .clk    ( clk_adc1  ),
  .probe0 ( din4_r2   ),
  .probe1 ( din5_r2   ),
  .probe2 ( din6_r2   ),
  .probe3 ( din7_r2   )
);

always @(posedge clk_adc0)
  if(rst_adc0) begin
      din0_r1 <= 16'b0;
      din1_r1 <= 16'b0;
      din2_r1 <= 16'b0;
      din3_r1 <= 16'b0;  
      din0_r2 <= 16'b0;
      din1_r2 <= 16'b0;
      din2_r2 <= 16'b0;
      din3_r2 <= 16'b0;        
      din0_r3 <= 16'b0;
      din1_r3 <= 16'b0;
      din2_r3 <= 16'b0;
      din3_r3 <= 16'b0;               	
  end
  else begin
      din0_r1 <= din0;
      din1_r1 <= din1;
      din2_r1 <= din2;
      din3_r1 <= din3;  
      din0_r2 <= din0_r1;
      din1_r2 <= din1_r1;
      din2_r2 <= din2_r1;
      din3_r2 <= din3_r1;        
      din0_r3 <= din0_r2;
      din1_r3 <= din1_r2;
      din2_r3 <= din2_r2;
      din3_r3 <= din3_r2;   	
  end

always @(posedge clk_adc1)
  if(rst_adc1) begin
      din4_r1 <= 16'b0;
      din5_r1 <= 16'b0;
      din6_r1 <= 16'b0;
      din7_r1 <= 16'b0;  
      din4_r2 <= 16'b0;
      din5_r2 <= 16'b0;
      din6_r2 <= 16'b0;
      din7_r2 <= 16'b0;        
      din4_r3 <= 16'b0;
      din5_r3 <= 16'b0;
      din6_r3 <= 16'b0;
      din7_r3 <= 16'b0;    	
  end
  else begin
      din4_r1 <= din4;
      din5_r1 <= din5;
      din6_r1 <= din6;
      din7_r1 <= din7;  
      din4_r2 <= din4_r1;
      din5_r2 <= din5_r1;
      din6_r2 <= din6_r1;
      din7_r2 <= din7_r1;        
      din4_r3 <= din4_r2;
      din5_r3 <= din5_r2;
      din6_r3 <= din6_r2;
      din7_r3 <= din7_r2;   	
  end

always @(posedge clk_adc0)
  if(rst_adc0) begin
      wea_adc0  <= 1'b0;
      addr_adc0 <= 3'b0;
      din_adc0  <= 64'b0;
  end
  else begin
      wea_adc0  <= 1'b1;
      addr_adc0 <= addr_adc0 + 1;
      din_adc0  <= {din0_r3,din1_r3,din2_r3,din3_r3};
  end

always @(posedge clk_adc1)
  if(rst_adc1) begin
      wea_adc1  <= 1'b0;
      addr_adc1 <= 3'b0;
      din_adc1  <= 64'b0;
  end
  else begin
      wea_adc1  <= 1'b1;
      addr_adc1 <= addr_adc1 + 1;
      din_adc1  <= {din4_r3,din5_r3,din6_r3,din7_r3};
  end

always @(posedge clk_250m)
  if(rst_250m) begin
      valid_250m <= 1'b0;
  end
  else begin
  	  valid_250m <= ~valid_250m;
  end
    	
always @(posedge clk_250m)
  if(rst_250m) begin
  	  addr_250m <= 3'd4;
  end
  else begin
  	  if(valid_250m)
  	      addr_250m <= addr_250m + 1;
  	  else
  	      addr_250m <= addr_250m;
  end    
    
dpram_64bx8 u_dpram_adc0
(
   .clka ( clk_adc0   ),
   .ena  ( 1'b1       ),
   .wea  ( wea_adc0   ),
   .addra( addr_adc0  ),
   .dina ( din_adc0   ),
   .douta(            ),
   .clkb ( clk_250m   ),
   .enb  ( 1'b1       ),
   .web  ( 1'b0       ),
   .addrb( addr_250m  ),
   .dinb ( 64'b0      ),
   .doutb( douta_250m )
);

dpram_64bx8 u_dpram_adc1
(
   .clka ( clk_adc1   ),
   .ena  ( 1'b1       ),
   .wea  ( wea_adc1   ),
   .addra( addr_adc1  ),
   .dina ( din_adc1   ),
   .douta(            ),
   .clkb ( clk_250m   ),
   .enb  ( 1'b1       ),
   .web  ( 1'b0       ),
   .addrb( addr_250m  ),
   .dinb ( 64'b0      ),
   .doutb( doutb_250m )
);

always @(posedge clk_250m)
  if(rst_250m) begin
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
      dout0 <= douta_250m[63:48];
      dout1 <= douta_250m[47:32];
      dout2 <= douta_250m[31:16];
      dout3 <= douta_250m[15:0] ;
      dout4 <= doutb_250m[63:48];
      dout5 <= doutb_250m[47:32];
      dout6 <= doutb_250m[31:16];
      dout7 <= doutb_250m[15:0] ;   	
  end

always @(posedge clk_250m)
  if(rst_250m) begin
  	valid <= 1'b0;
  end
  else begin
  	valid <= valid_250m;
  end
  
endmodule