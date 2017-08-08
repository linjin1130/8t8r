//*****************************************************************************
// File    : top_8t8r.v
// Project : 8T8R
// Tool    : Xilinx Vivado 2015.2
//
// Modify history
// Version :
// Date    :
// Note    :
//*****************************************************************************

module top_8t8r
(
//ADC0 Config
   output        ADC0_SYNC       , //Y17 //1v8
   output        ADC0_PDWN       , //AA16
   output        ADC0_CSB        , //AB16
   inout         ADC0_SDIO       , //AB17
   output        ADC0_SCLK       , //AA13
//ADC1 Config                    
   output        ADC1_SYNC       , //AB13
   output        ADC1_PDWN       , //AB15
   output        ADC1_CSB        , //Y13
   inout         ADC1_SDIO       , //AA14
   output        ADC1_SCLK       , //W14
//ADCCLK846 Buffer               
   output        BUFFER_CTRLA    , //Y14,1.8V
   output        BUFFER_CTRLB    , //AB11
//   input         CLK_A7_C_REFB_P , //W11
//   input         CLK_A7_C_REFB_N , //W12
   input         CLK_A7_C_REFA_P , //C18
   input         CLK_A7_C_REFA_N , //C19
//LM75C                          
//   output        TEMP_SCL        , //C2,LM75C
//   output        TEMP_SDA        , //B2
//DAC0 Config                    
//   input         CFG_DAC0_SDO    , //D1, 3V3
   inout         CFG_DAC0_SDIO   , //E2
   output        CFG_DAC0_SCLK   , //D2
   output        CFG_DAC0_SDENB_N, //P6
//   input         ALARM_DAC0      , //G1
   output        TXENABLE_DAC0   , //F1
   output        RESET_DAC0_N    , //F3
   output        SLEEP_DAC0      , //E3
//DAC1 Config                         
//   input         CFG_DAC1_SDO    , //K1, 3.3v
   inout         CFG_DAC1_SDIO   , //J1
   output        CFG_DAC1_SCLK   , //H2
   output        CFG_DAC1_SDENB_N, //N5   
//   input         ALARM_DAC1      , //G2
   output        TXENABLE_DAC1   , //K2
   output        RESET_DAC1_N    , //J2
   output        SLEEP_DAC1      , //J5
//Board communication signals        
//   input         ZYT1_2V5        , //G21, 2V5
//   input         ZYT2_2V5        , //G22
//   input         ZYT3_2V5        , //F21                         
   output        IO0_DB_CB       , //H5, 3V3
   output        IO1_DB_CB       , //H3
   output        IO2_DB_CB       , //G3
   output        IO3_DB_CB       , //H4
   output        IO4_DB_CB       , //G4
   output        IO5_DB_CB       , //K4
   output        IO6_DB_CB       , //J4
   output        IO7_DB_CB       , //L3
//   input         KN_DB_CB        , //K3
//   input         KW_DB_CB        , //M1
   output        N4_SUM_CB_DB    , //L1
   output        N4_PK_CB_DB     , //M3
   output        W4_SUM_CB_DB    , //M2
   output        W4_PK_CB_DB     , //K6
//ARM interface
   input         SPI_ARM_A7_CLK  , //J6, 3V3
   input         SPI_ARM_A7_C0   , //L5
   output        SPI_ARM_A7_MISO , //L4
   input         SPI_ARM_A7_MOSI , //N4
   input         GPIO0_ARM_A7    , //N3 
   input         GPIO1_ARM_A7    , //R1
   input         GPIO2_ARM_A7    , //P1
   input         GPIO3_ARM_A7    , //P5
   input         GPIO4_ARM_A7    , //P4
   input         GPIO5_ARM_A7    , //P2
   input         GPIO6_ARM_A7    , //N2 
   input         GPIO7_ARM_A7    , //M6 
   input         RST_ARM_FPGA_N  , //L6
//DAC0   
   output [15:0] DATA_DAC0_DB_P  , //2V5
   output [15:0] DATA_DAC0_DB_N  ,
   output        PARITY_DAC0_P   , //U20
   output        PARITY_DAC0_N   , //V20
   output        CLK_DATA_DAC0_P , //W19
   output        CLK_DATA_DAC0_N , //W20
   output        FRAME_DAC0_P    , //Y18
   output        FRAME_DAC0_N    , //Y19
   output        SYNC_DAC0_P     , //V18
   output        SYNC_DAC0_N     , //V19
   output        OSTR_DAC0_P     , //N17
   output        OSTR_DAC0_N     , //P17
//DAC1   
   output [15:0] DATA_DAC1_DB_P  ,
   output [15:0] DATA_DAC1_DB_N  ,
   output        PARITY_DAC1_P   , //Y4
   output        PARITY_DAC1_N   , //AA4
   output        CLK_DATA_DAC1_P , //V4
   output        CLK_DATA_DAC1_N , //W4
   output        FRAME_DAC1_P    , //R4
   output        FRAME_DAC1_N    , //T4
   output        SYNC_DAC1_P     , //T5
   output        SYNC_DAC1_N     , //U5   
   output        OSTR_DAC1_P     , //V9
   output        OSTR_DAC1_N     , //V8
//ADC0                               
   input         ADC0_FCO_P      , //B17
   input         ADC0_FCO_N      , //B18
   input         ADC0_DCO_P      , //D17
   input         ADC0_DCO_N      , //C17
   input         ADC0_D0_A_P     , //F13
   input         ADC0_D0_A_N     , //F14
   input         ADC0_D1_A_P     , //F16   
   input         ADC0_D1_A_N     , //E17       
   input         ADC0_D0_B_P     , //C13
   input         ADC0_D0_B_N     , //B13
   input         ADC0_D1_B_P     , //B15
   input         ADC0_D1_B_N     , //B16   
   input         ADC0_D0_C_P     , //D14
   input         ADC0_D0_C_N     , //D15
   input         ADC0_D1_C_P     , //E16
   input         ADC0_D1_C_N     , //D16   
   input         ADC0_D0_D_P     , //E13
   input         ADC0_D0_D_N     , //E14             
   input         ADC0_D1_D_P     , //C14
   input         ADC0_D1_D_N     , //C15
//ADC1                               
   input         ADC1_FCO_P      , //J20
   input         ADC1_FCO_N      , //J21
   input         ADC1_DCO_P      , //J19
   input         ADC1_DCO_N      , //H19
   input         ADC1_D0_A_P     , //H13
   input         ADC1_D0_A_N     , //G13
   input         ADC1_D1_A_P     , //G15   
   input         ADC1_D1_A_N     , //G16      
   input         ADC1_D0_B_P     , //H20
   input         ADC1_D0_B_N     , //G20
   input         ADC1_D1_B_P     , //J22
   input         ADC1_D1_B_N     , //H22   
   input         ADC1_D0_C_P     , //H17
   input         ADC1_D0_C_N     , //H18
   input         ADC1_D1_C_P     , //J15
   input         ADC1_D1_C_N     , //H15   
   input         ADC1_D0_D_P     , //G17
   input         ADC1_D0_D_N     , //G18                    
   input         ADC1_D1_D_P     , //J14
   input         ADC1_D1_D_N     , //H14
//Test point
   output        FPGA_LED        , //E22, light when L
   output        F_TP1_2V5       , //M18
   output        F_TP2_2V5       , //N19
   output        F_TP3_2V5       , //K13
   output        F_TP4_2V5         //L13
 );

///********************************************************************* 
///internal reg singals                                                  
///********************************************************************* 



///*********************************************************************
///internal wire singals
///*********************************************************************
wire         clk_250m  ;
wire         clk_200m  ;
wire         clk_500m  ;
wire         clk500m_90;
wire         clk_5m    ;
//wire         fpga_ready;
wire [15:0]  tx_data0  ;
wire [15:0]  tx_data1  ;
wire [15:0]  tx_data2  ;
wire [15:0]  tx_data3  ;
wire [15:0]  tx_data4  ;
wire [15:0]  tx_data5  ;
wire [15:0]  tx_data6  ;
wire [15:0]  tx_data7  ;
wire         clk_adc0  ;
wire         clk_adc1  ;
wire         rst_adc0  ;
wire         rst_adc1  ;   
wire         rst_dac0  ;
wire         rst_dac1  ;
wire         rst_250m  ;
wire [7:0]   io_db_cb  ;
wire [15:0]  adc_dout0 ;
wire [15:0]  adc_dout1 ;
wire [15:0]  adc_dout2 ;
wire [15:0]  adc_dout3 ;
wire [15:0]  adc_dout4 ;
wire [15:0]  adc_dout5 ;
wire [15:0]  adc_dout6 ;
wire [15:0]  adc_dout7 ;

///*********************************************************************
/// CLK and reset module                                                          
///*********************************************************************
clk_rst u_clk_rst
(
    .clk_a7_refa_p ( CLK_A7_C_REFA_P ),
    .clk_a7_refa_n ( CLK_A7_C_REFA_N ),
//    .clk_a7_refb_p ( CLK_A7_C_REFB_P ),
//    .clk_a7_refb_n ( CLK_A7_C_REFB_N ),
    .rst_sw_n      ( RST_ARM_FPGA_N  ),
    .clk_adc0      ( clk_adc0        ),
    .clk_adc1      ( clk_adc1        ),    
    .clk_250m      ( clk_250m        ),
    .clk_200m      ( clk_200m        ),
    .clk_500m      ( clk_500m        ),
    .clk500m_90    ( clk500m_90      ),
    .clk_5m        ( clk_5m          ),
//    .pll_locked    ( fpga_ready      ),                         
//    .rst_adc0      ( rst_adc0        ),
//    .rst_adc1      ( rst_adc1        ),
    .rst_250m      ( rst_250m        )        
 );
 
///*********************************************************************
/// CLK and reset module                                                          
///*********************************************************************
spi_intf u_spi_intf
(
   .clk             ( clk_5m           ),
   .rst_adc0        ( rst_adc0         ),
   .rst_adc1        ( rst_adc1         ),
   .rst_dac0        ( rst_dac0         ),
   .rst_dac1        ( rst_dac1         ),
   .adc0_csb        ( ADC0_CSB         ),
   .adc0_sdio       ( ADC0_SDIO        ),
   .adc0_sclk       ( ADC0_SCLK        ),
   .adc1_csb        ( ADC1_CSB         ),
   .adc1_sdio       ( ADC1_SDIO        ),
   .adc1_sclk       ( ADC1_SCLK        ),
//   .dac0_sdo        ( CFG_DAC0_SDO     ),
   .dac0_sdio       ( CFG_DAC0_SDIO    ),
   .dac0_sclk       ( CFG_DAC0_SCLK    ),
   .dac0_sdenb_n    ( CFG_DAC0_SDENB_N ),   
//   .dac1_sdo        ( CFG_DAC1_SDO     ),
   .dac1_sdio       ( CFG_DAC1_SDIO    ),
   .dac1_sclk       ( CFG_DAC1_SCLK    ),
   .dac1_sdenb_n    ( CFG_DAC1_SDENB_N ),   
//   .alarm_dac0      ( ALARM_DAC0      ),
   .txenable_dac0   ( TXENABLE_DAC0    ),
   .reset_dac0_n    ( RESET_DAC0_N     ),
   .sleep_dac0      ( SLEEP_DAC0       ),
//   .alarm_dac1      ( ALARM_DAC1      ),
   .txenable_dac1   ( TXENABLE_DAC1    ),   
   .reset_dac1_n    ( RESET_DAC1_N     ),
   .sleep_dac1      ( SLEEP_DAC1       ),
   .spi_arm_a7_clk  ( SPI_ARM_A7_CLK   ),  
   .spi_arm_a7_c0   ( SPI_ARM_A7_C0    ),  
   .spi_arm_a7_miso ( SPI_ARM_A7_MISO  ),  
   .spi_arm_a7_mosi ( SPI_ARM_A7_MOSI  ),  
   .gpio0_arm_a7    ( GPIO0_ARM_A7     ), 
   .gpio1_arm_a7    ( GPIO1_ARM_A7     ), 
   .gpio2_arm_a7    ( GPIO2_ARM_A7     ), 
   .gpio3_arm_a7    ( GPIO3_ARM_A7     ), 
   .gpio4_arm_a7    ( GPIO4_ARM_A7     ), 
   .gpio5_arm_a7    ( GPIO5_ARM_A7     ), 
   .gpio6_arm_a7    ( GPIO6_ARM_A7     ),
   .gpio7_arm_a7    ( GPIO7_ARM_A7     )
 );

//assign GPIO7_ARM_A7 = fpga_ready;

///*********************************************************************
/// main process                                                          
///*********************************************************************
assign  IO0_DB_CB = io_db_cb[0];
assign  IO1_DB_CB = io_db_cb[1];
assign  IO2_DB_CB = io_db_cb[2];
assign  IO3_DB_CB = io_db_cb[3];
assign  IO4_DB_CB = io_db_cb[4];
assign  IO5_DB_CB = io_db_cb[5];
assign  IO6_DB_CB = io_db_cb[6];
assign  IO7_DB_CB = io_db_cb[7];

data_proc u_data_proc
(  
   .clk_adc0  ( clk_adc0     ), 
   .clk_adc1  ( clk_adc1     ),
   .clk_250m  ( clk_250m     ),
   .rst_adc0  ( rst_adc0     ),
   .rst_adc1  ( rst_adc1     ),
   .rst_250m  ( rst_250m     ),
   .adc_data0 ( adc_dout0    ),
   .adc_data1 ( adc_dout1    ),
   .adc_data2 ( adc_dout2    ),
   .adc_data3 ( adc_dout3    ), 
   .adc_data4 ( adc_dout4    ),
   .adc_data5 ( adc_dout5    ),
   .adc_data6 ( adc_dout6    ),
   .adc_data7 ( adc_dout7    ), 
   .dac_data0 ( tx_data0     ),
   .dac_data1 ( tx_data1     ),   
   .dac_data2 ( tx_data2     ),   
   .dac_data3 ( tx_data3     ),   
   .dac_data4 ( tx_data4     ),   
   .dac_data5 ( tx_data5     ),   
   .dac_data6 ( tx_data6     ),   
   .dac_data7 ( tx_data7     ),                 
//   .zyt1      ( ZYT1_2V5     ), 
//   .zyt2      ( ZYT2_2V5     ), 
//   .zyt3      ( ZYT3_2V5     ),                  
   .io_db_cb  ( io_db_cb     ), 
//   .kn        ( KN_DB_CB     ), 
//   .kw        ( KW_DB_CB     ), 
   .n4_sum    ( N4_SUM_CB_DB ), 
   .n4_pk     ( N4_PK_CB_DB  ), 
   .w4_sum    ( W4_SUM_CB_DB ), 
   .w4_pk     ( W4_PK_CB_DB  )
 );

///*********************************************************************
/// ADC intf                                                            
///*********************************************************************
adc9653_intf u_adc0_intf
(  
   .adc_sync   (  ADC0_SYNC    ),
   .rst        (  rst_adc0     ),
   .adc_fco_p  (  ADC0_FCO_P   ),
   .adc_fco_n  (  ADC0_FCO_N  ),
   .adc_dco_p  (  ADC0_DCO_P   ),
   .adc_dco_n  (  ADC0_DCO_N   ),
   .adc_d0_a_p (  ADC0_D0_A_P  ),
   .adc_d0_a_n (  ADC0_D0_A_N  ),
   .adc_d1_a_p (  ADC0_D1_A_P  ),
   .adc_d1_a_n (  ADC0_D1_A_N  ),
   .adc_d0_b_p (  ADC0_D0_B_P  ),
   .adc_d0_b_n (  ADC0_D0_B_N  ),
   .adc_d1_b_p (  ADC0_D1_B_P  ),
   .adc_d1_b_n (  ADC0_D1_B_N  ),
   .adc_d0_c_p (  ADC0_D0_C_P  ),
   .adc_d0_c_n (  ADC0_D0_C_N  ),
   .adc_d1_c_p (  ADC0_D1_C_P  ),
   .adc_d1_c_n (  ADC0_D1_C_N  ),
   .adc_d0_d_p (  ADC0_D0_D_P  ),
   .adc_d0_d_n (  ADC0_D0_D_N  ),
   .adc_d1_d_p (  ADC0_D1_D_P  ),
   .adc_d1_d_n (  ADC0_D1_D_N  ),
   .adc_pdwn   (  ADC0_PDWN    ),
   .clk_adc    (  clk_adc0     ),
   .dly_clk    (  clk_200m     ),
   .dout0      (  adc_dout0    ),
   .dout1      (  adc_dout1    ),
   .dout2      (  adc_dout2    ),
//   .fco (fco),
   .dout3      (  adc_dout3    )     
 );

adc9653_intf u_adc1_intf
(
   .adc_sync   (  ADC1_SYNC    ),  
   .rst        (  rst_adc0     ),
   .adc_fco_p  (  ADC1_FCO_P   ),
   .adc_fco_n  (  ADC1_FCO_N   ),
   .adc_dco_p  (  ADC1_DCO_P   ),
   .adc_dco_n  (  ADC1_DCO_N   ),
   .adc_d0_a_p (  ADC1_D0_A_P  ),
   .adc_d0_a_n (  ADC1_D0_A_N  ),
   .adc_d1_a_p (  ADC1_D1_A_P  ),
   .adc_d1_a_n (  ADC1_D1_A_N  ),
   .adc_d0_b_p (  ADC1_D0_B_P  ),
   .adc_d0_b_n (  ADC1_D0_B_N  ),  
   .adc_d1_b_p (  ADC1_D1_B_P  ),
   .adc_d1_b_n (  ADC1_D1_B_N  ), 
   .adc_d0_c_p (  ADC1_D0_C_P  ),
   .adc_d0_c_n (  ADC1_D0_C_N  ),
   .adc_d1_c_p (  ADC1_D1_C_P  ),
   .adc_d1_c_n (  ADC1_D1_C_N  ), 
   .adc_d0_d_p (  ADC1_D0_D_P  ),
   .adc_d0_d_n (  ADC1_D0_D_N  ),
   .adc_d1_d_p (  ADC1_D1_D_P  ),
   .adc_d1_d_n (  ADC1_D1_D_N  ), 
   .adc_pdwn   (  ADC1_PDWN    ),
   .clk_adc    (  clk_adc1     ), 
   .dly_clk    (  clk_200m     ),
   .dout0      (  adc_dout4    ),
   .dout1      (  adc_dout5    ),
   .dout2      (  adc_dout6    ),
   .dout3      (  adc_dout7    )        
 );

///*********************************************************************
/// DAC intf
///*********************************************************************
dac3484_intf u_dac0_intf
(  
   .clk250m        ( clk_250m        ), 
   .clk500m        ( clk_500m        ),
   .clk500m_90     ( clk500m_90      ),
   .rst            ( rst_250m        ),
   .din0           ( tx_data0        ),
   .din1           ( tx_data1        ),
   .din2           ( tx_data2        ),
   .din3           ( tx_data3        ),
   .clk_data_dac_p ( CLK_DATA_DAC0_P ),
   .clk_data_dac_n ( CLK_DATA_DAC0_N ),
   .parity_dac_p   ( PARITY_DAC0_P   ),
   .parity_dac_n   ( PARITY_DAC0_N   ),
   .frame_dac_p    ( FRAME_DAC0_P    ),
   .frame_dac_n    ( FRAME_DAC0_N    ),
   .sync_dac_p     ( SYNC_DAC0_P     ),
   .sync_dac_n     ( SYNC_DAC0_N     ),
   .ostr_p         ( OSTR_DAC0_P     ),
   .ostr_n         ( OSTR_DAC0_N     ),
   .data_dac_db_p  ( DATA_DAC0_DB_P  ),
   .data_dac_db_n  ( DATA_DAC0_DB_N  ) 
 );

dac3484_intf u_dac1_intf
(  
   .clk250m        ( clk_250m        ), 
   .clk500m        ( clk_500m        ),
   .clk500m_90     ( clk500m_90      ),
   .rst            ( rst_250m        ),
   .din0           ( tx_data4        ),
   .din1           ( tx_data5        ),
   .din2           ( tx_data6        ),
   .din3           ( tx_data7        ),
   .clk_data_dac_p ( CLK_DATA_DAC1_P ),
   .clk_data_dac_n ( CLK_DATA_DAC1_N ),
   .parity_dac_p   ( PARITY_DAC1_P   ),
   .parity_dac_n   ( PARITY_DAC1_N   ),
   .frame_dac_p    ( FRAME_DAC1_P    ),
   .frame_dac_n    ( FRAME_DAC1_N    ),
   .sync_dac_p     ( SYNC_DAC1_P     ),
   .sync_dac_n     ( SYNC_DAC1_N     ),
   .ostr_p         ( OSTR_DAC1_P     ),
   .ostr_n         ( OSTR_DAC1_N     ),
   .data_dac_db_p  ( DATA_DAC1_DB_P  ),
   .data_dac_db_n  ( DATA_DAC1_DB_N  )        
 );

assign  BUFFER_CTRLA = 1'b0;  //0--LVDS, 1--CMOS
assign  BUFFER_CTRLB = 1'b0;  //0--LVDS, 1--CMOS
assign  F_TP1_2V5    = 1'b0;  //M18
assign  F_TP2_2V5    = 1'b0;  //N19
assign  F_TP3_2V5    = 1'b0;  //K13
assign  F_TP4_2V5    = 1'b0;  //L13


(* keep="true" *) reg [26:0] cnt;
always @(posedge clk_200m)
    cnt <= cnt + 1;
    
assign  FPGA_LED = cnt[26] ;

endmodule