----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2017/05/06 14:21:52
-- Design Name: 
-- Module Name: ADC_interface - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity ADC_interface is
  port (
    rst          : in  std_logic;
    re_sync_in   : in  std_logic;
    ch_d0_p      : in  std_logic_vector(3 downto 0);
    ch_d0_n      : in  std_logic_vector(3 downto 0);
    ch_d1_p      : in  std_logic_vector(3 downto 0);
    ch_d1_n      : in  std_logic_vector(3 downto 0);
    dco          : in  std_logic;
    clk_adc      : out  std_logic;
    fco          : in  std_logic;
    dly_clk      : in  std_logic;
    tap_out      : out std_logic_vector(4 downto 0);
    data_out : out std_logic_vector(63 downto 0)
    );
end ADC_interface;

architecture Behavioral of ADC_interface is
  signal bitslip_out  : std_logic;
  signal clk_out      : std_logic;
  signal clk_div_out  : std_logic;
  
  --for test monitor
  
  signal dly_rdy      : std_logic;
  
  component AD_CLK_GENERATE is
    port (
      dco         : in  std_logic;
      -- clkB     : in  std_logic;
      dly_clk     : in  std_logic;
      re_sync_in  : in  std_logic;
      dly_rdy     : out std_logic;
      clk_out     : out std_logic;
      clk_div_out : out std_logic;
      tap_out     : out std_logic_vector(4 downto 0)
      );
  end component AD_CLK_GENERATE;

  component Frame_Check is
    port (
      rst_in      : in  std_logic;
      clk         : in  std_logic;
      clk_div     : in  std_logic;
      bitslip_out : out std_logic;
      Frame       : in  std_logic
      );
  end component Frame_Check;

  component iserdes is
    port (
      rst          : in  std_logic;
      clk          : in  std_logic;
      div_clk      : in  std_logic;
      data_in0_p   : in  std_logic;
      data_in0_n   : in  std_logic;
      data_in1_p   : in  std_logic;
      data_in1_n   : in  std_logic;
      BITSLIP_low  : in  std_logic;
      BITSLIP_high : in  std_logic;
      cascade_out  : out std_logic_vector(1 downto 0);
      data_combine : out std_logic_vector(15 downto 0));
  end component iserdes;

-------------------------------------------------------------------------------
begin
  clk_adc <= clk_div_out;
  Frame_Check_inst : Frame_Check
    port map (
      rst_in      => rst,
      clk         => clk_out,
      clk_div     => clk_div_out,
      bitslip_out => bitslip_out,
      Frame       => fco
      );

  AD_CLK_GENERATE_inst : AD_CLK_GENERATE
    port map (
      dco         => dco,
      dly_clk     => dly_clk,
      re_sync_in  => rst,
      dly_rdy     => dly_rdy,
      clk_out     => clk_out,
      clk_div_out => clk_div_out,
      tap_out     => tap_out
      );

  DATA_iserdes_inst : for i in 0 to 3 generate
  begin
    iserdes_inst : iserdes
      port map (
        rst          => rst,
        clk          => clk_out,
        div_clk      => clk_div_out,
        data_in0_p  => ch_d0_p(i),
        data_in0_n  => ch_d0_n(i),
        data_in1_p  => ch_d1_p(i),
        data_in1_n  => ch_d1_n(i),
        BITSLIP_low  => bitslip_out,
        BITSLIP_high => bitslip_out,
        cascade_out  => open,
        data_combine => data_out(i*16+15 downto i*16)
        );
  end generate;
  -----------------------------------------------------------------------------

end Behavioral;
