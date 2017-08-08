
`timescale 1ns/100ps

module rst_sync
(
    input           i_in_clk     ,
    input           i_rst_async  ,  
    output reg      o_rst_sync = 1'b0           
);


/// -------------------------------------------------------------------------
/// Register declarations
/// -------------------------------------------------------------------------
reg  rst_1d; 
reg  rst_2d; 
reg  rst_3d;
reg  rst_4d;
reg  rst_5d;
reg  rst_6d;

/// -------------------------------------------------------------------------
/// Main body of code
/// -------------------------------------------------------------------------
///release latency =7clk
always @(posedge i_in_clk or posedge i_rst_async)
  begin
    if(i_rst_async)
       begin
         rst_1d     <= 1'b1;
         rst_2d     <= 1'b1;  
         rst_3d     <= 1'b1;
         rst_4d     <= 1'b1;
         rst_5d     <= 1'b1;
         rst_6d     <= 1'b1;
         o_rst_sync <= 1'b1;
       end
    else
       begin
         rst_1d     <= 1'b0;
         rst_2d     <= rst_1d;
         rst_3d     <= rst_2d;
         rst_4d     <= rst_3d;
         rst_5d     <= rst_4d;
         rst_6d     <= rst_5d;
         o_rst_sync <= rst_6d;
       end
  end

endmodule