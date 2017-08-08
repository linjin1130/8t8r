//*****************************************************************************
// File    : 
// Project :        
// Tool    : Xilinx ISE 11.1, ModelSim 6.5a
//
// Modify history
// Version :
// Date    :
// Author  :
// E-mail  :
// Note    :
//*****************************************************************************

module  clk_rst
(
    input        clk_a7_refa_p  ,
    input        clk_a7_refa_n  ,
//    input        clk_a7_refb_p  ,
//    input        clk_a7_refb_n  ,
    input        rst_sw_n       ,
    input        clk_adc0       ,
    input        clk_adc1       ,    
    output       clk_250m       , 
    output       clk_200m       ,   
    output       clk_500m       ,
    output       clk500m_90     ,
    output       clk_5m         ,
    output       pll_locked     ,                     
//    output       rst_adc0       ,
//    output       rst_adc1       ,
    output       rst_250m               
 );

///*********************************************************************
///internal wire singals defination
///*********************************************************************

///*********************************************************************
///PLL for sys clock
///*********************************************************************
tx_pll u_tx_pll
 (
     .clk_in1_p ( clk_a7_refa_p ),
     .clk_in1_n ( clk_a7_refa_n ),
     .clk_out1  ( clk_250m      ),
     .clk_out2  ( clk_200m      ),
     .clk_out3  ( clk_500m      ),
     .clk_out4  ( clk_5m        ),
     .clk_out5  ( clk500m_90    ),
     .reset     ( 1'b0          ),
     .locked    ( pll_locked    )
 );

///*********************************************************************
///reset
///*********************************************************************
assign rst_sys_async = !(pll_locked && !rst_sw_n); 

//rst_sync u_rst_adc0 
//(
//    .i_in_clk        ( clk_200m      ), 
//    .i_rst_async     ( rst_sys_async ), 
//    .o_rst_sync      ( rst_adc0      )  
//);      
//
//rst_sync u_rst_adc1 
//(
//    .i_in_clk        ( clk_200m      ), 
//    .i_rst_async     ( rst_sys_async ), 
//    .o_rst_sync      ( rst_adc1      )  
//);      

rst_sync u_rst_250m 
(
    .i_in_clk        ( clk_250m      ), 
    .i_rst_async     ( rst_sys_async ), 
    .o_rst_sync      ( rst_250m      )  
);    

endmodule