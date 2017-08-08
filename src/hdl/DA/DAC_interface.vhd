----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2017/05/12 00:35:38
-- Design Name: 
-- Module Name: DATAout_IOB - Behavioral
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
use IEEE.std_logic_1164.all;
use IEEE.std_logic_UNSIGNED.all;
use IEEE.std_logic_arith.all;
library UNISIM;
use UNISIM.VCOMPONENTS.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DAC_interface is
  generic
    (
      dac_resolution :integer := 16
      );
  port (
    rst : in std_logic;
    CLK       : in  std_logic; -- clk 500MHz 0degree
    CLK_div   : in std_logic;    --clk 250MHz
    CLK_dly   : in std_logic;    --clk 200MHz
    Q_p       : out std_logic_vector(dac_resolution-1 downto 0);
    Q_n       : out std_logic_vector(dac_resolution-1 downto 0);
    frame_p   : out std_logic;
    frame_n   : out std_logic;
    parity_p  : out std_logic;
    parity_n  : out std_logic;
    SYNC_p    : out std_logic;
    SYNC_n    : out std_logic;
    DataCLk_p : out std_logic;
    DataCLk_n : out std_logic;
    Data_A    : in  std_logic_vector(dac_resolution-1 downto 0);
    Data_B    : in  std_logic_vector(dac_resolution-1 downto 0);
    Data_C    : in  std_logic_vector(dac_resolution-1 downto 0);
    Data_D    : in  std_logic_vector(dac_resolution-1 downto 0);
    DataCLk   : in  std_logic           -- clk 500MHz 90degree shift
    );
end DAC_interface;

architecture Behavioral of DAC_interface is
    signal parity_A         : std_logic;
    signal parity_B         : std_logic;
    signal parity_C         : std_logic;
    signal parity_D         : std_logic;
    signal delay_locked     : std_logic;
    signal sync             : std_logic;
    signal Frame            : std_logic;
    signal parity           : std_logic;
    signal single_out       : std_logic_vector(1 downto 0);
    signal single_delay_out : std_logic_vector(1 downto 0);
    signal data_out         : std_logic_vector(dac_resolution downto 0);
    signal data_A_d2        : std_logic_vector(dac_resolution downto 0);
    signal data_B_d2        : std_logic_vector(dac_resolution downto 0);
    signal data_C_d2        : std_logic_vector(dac_resolution downto 0);
    signal data_D_d2        : std_logic_vector(dac_resolution downto 0);
    signal data_A_d         : std_logic_vector(dac_resolution-1 downto 0);
    signal data_B_d         : std_logic_vector(dac_resolution-1 downto 0);
    signal data_C_d         : std_logic_vector(dac_resolution-1 downto 0);
    signal data_D_d         : std_logic_vector(dac_resolution-1 downto 0);
--    signal data_combine     : std_logic_vector(dac_resolution*4-1 downto 0);
--    signal out_delay_tap_in : std_logic_vector(dac_resolution*5-1 downto 0);
--    signal out_delay_tap_out: std_logic_vector(dac_resolution*5-1 downto 0);
    
    signal Q : std_logic_vector(dac_resolution-1 downto 0);
  component serdes_out
    port(
      rst      : in  std_logic;
      clk      : in  std_logic;
      div_clk  : in  std_logic;
      clk_dly : in std_logic;
      Frame    : out std_logic;
      sync     : out std_logic;
      data_s0  : in  std_logic_vector(dac_resolution downto 0);
      data_s1  : in  std_logic_vector(dac_resolution downto 0);
      data_s2  : in  std_logic_vector(dac_resolution downto 0);
      data_s3  : in  std_logic_vector(dac_resolution downto 0);
--      Q_delay_tap : in std_logic_vector(dac_resolution*5-1 downto 0);
      data_out : out std_logic_vector(dac_resolution downto 0)
      );
  end component;      
  component OBUFDS_module is
    port (
      Q_p       : out std_logic_vector(dac_resolution-1 downto 0);
      Q_n       : out std_logic_vector(dac_resolution-1 downto 0);
      Q         : in  std_logic_vector(dac_resolution-1 downto 0);
      frame_p   : out std_logic;
      frame_n   : out std_logic;
      frame     : in  std_logic;
      SYNC_p    : out std_logic;
      SYNC_n    : out std_logic;
      sync      : in  std_logic;
      parity_p  : out std_logic;
      parity_n  : out std_logic;
      parity    : in  std_logic;
      DataCLk_p : out std_logic;
      DataCLk_n : out std_logic;
      DataCLk   : in  std_logic);
  end component OBUFDS_module;
  -----------------------------------------------------------------------------
  signal rom_addr_cnt : std_logic_vector(9 downto 0) := "0000000000";
  signal rom_dout     : std_logic_vector(15 downto 0);
  signal data_en     : std_logic;

    signal Data_A_inter : std_logic_vector(15 downto 0) := x"0000";
    signal Data_B_inter : std_logic_vector(15 downto 0) := x"1111";
    signal Data_C_inter : std_logic_vector(15 downto 0) := x"2222";
    signal data_D_inter : std_logic_vector(15 downto 0) := x"3333";
    
  component rom
    port (
      clka  : in  std_logic;
      rsta  : in  std_logic;
      ena   : in  std_logic;
      addra : in  std_logic_vector(9 downto 0);
      douta : out std_logic_vector(15 downto 0)
      );
  end component;
begin
  Data_en <= '1';

Inst_rom : rom
           port map (
             clka  => clk_div,
             rsta  => rst,
             ena   => Data_en,
             addra => rom_addr_cnt,
             douta => rom_dout
             );
  main_counter_ps : process (clk_div) is
 begin  -- process main_counter_ps
   if clk_div'event and clk_div = '1' then  -- rising clock edge
     rom_addr_cnt <= rom_addr_cnt + 1;
   end if;
 end process;


 Data_A_cnt_ps : process (clk_div, rst) is
 begin  -- process Data_A_cnt_ps
   if rst = '1' then                 -- asynchronous reset (active low)
     Data_A_inter <= x"0000";
   elsif clk_div'event and clk_div = '1' then  -- rising clock edge
     if data_en = '1' then
       Data_A_inter <= rom_dout;
     --   Data_A<=x"ffff";
     end if;
   end if;
 end process Data_A_cnt_ps;

 Data_B_cnt_ps : process (clk_div, rst) is
 begin  -- process Data_B_cnt_ps
   if rst = '1' then                 -- asynchronous reset (active low)
     Data_B_inter <= (others => '0');
     Data_C_inter <= (others => '0');
     Data_D_inter <= (others => '0');
   elsif clk_div'event and clk_div = '1' then  -- rising clock edge
     if data_en = '1' then
        Data_B_inter <= rom_dout;--Data_B_inter+7;
        Data_C_inter <= rom_dout;--Data_C_inter+11;
        Data_D_inter <= rom_dout;--Data_D_inter+17;
       
--        Data_B_inter <=(others => '0');
--        Data_C_inter <=(others => '0');
--        Data_D_inter <=(others => '0');
     -- Data_B <= ram_dout;
     end if;
   end if;
 end process Data_B_cnt_ps;
----------------------------------------------------------
 data_s_d_ps: process (clk_div) is
 begin  -- process data_A_d
   if clk_div'event and clk_div = '1' then   -- rising clock edge
     data_A_d  <= Data_A_inter;
     data_B_d  <= Data_B_inter;
     data_C_d  <= Data_C_inter;
     data_D_d  <= Data_D_inter;
     parity_A  <= data_A_d(0)  xor data_A_d(1)  xor data_A_d(2)  xor data_A_d(3)  xor 
                  data_A_d(4)  xor data_A_d(5)  xor data_A_d(6)  xor data_A_d(7)  xor 
                  data_A_d(8)  xor data_A_d(9)  xor data_A_d(10) xor data_A_d(11) xor 
                  data_A_d(12) xor data_A_d(13) xor data_A_d(14) xor data_A_d(15); 
     parity_B  <= data_B_d(0)  xor data_B_d(1)  xor data_B_d(2)  xor data_B_d(3)  xor 
                  data_B_d(4)  xor data_B_d(5)  xor data_B_d(6)  xor data_B_d(7)  xor 
                  data_B_d(8)  xor data_B_d(9)  xor data_B_d(10) xor data_B_d(11) xor 
                  data_B_d(12) xor data_B_d(13) xor data_B_d(14) xor data_B_d(15); 
     parity_C  <= data_C_d(0)  xor data_C_d(1)  xor data_C_d(2)  xor data_C_d(3)  xor 
                  data_C_d(4)  xor data_C_d(5)  xor data_C_d(6)  xor data_C_d(7)  xor 
                  data_C_d(8)  xor data_C_d(9)  xor data_C_d(10) xor data_C_d(11) xor 
                  data_C_d(12) xor data_C_d(13) xor data_C_d(14) xor data_C_d(15); 
     parity_D  <= data_D_d(0)  xor data_D_d(1)  xor data_D_d(2)  xor data_D_d(3)  xor 
                  data_D_d(4)  xor data_D_d(5)  xor data_D_d(6)  xor data_D_d(7)  xor 
                  data_D_d(8)  xor data_D_d(9)  xor data_D_d(10) xor data_D_d(11) xor 
                  data_D_d(12) xor data_D_d(13) xor data_D_d(14) xor data_D_d(15); 
     data_A_d2 <= parity_A & data_A_d;
     data_B_d2 <= parity_B & data_B_d;
     data_C_d2 <= parity_C & data_C_d;
     data_D_d2 <= parity_D & data_D_d;
   end if;
 end process data_s_d_ps;
-- data_combine <= data_A_d & data_B_d & data_C_d & data_D_d;
--   delay_gen1:
--   for l_inst in 0 to 2 generate
--   begin
--       out_delay_tap_in((l_inst+1)*5-1 downto l_inst*5) <= "01000";
--   end generate;
--   delay_gen2:
--   for l_inst in 8 to 13 generate
--   begin
--       out_delay_tap_in((l_inst+1)*5-1 downto l_inst*5) <= "01000";
--   end generate; 
--   delay_gen3:
--   for l_inst in 3 to 7 generate
--   begin
--       out_delay_tap_in((l_inst+1)*5-1 downto l_inst*5) <= "00000";
--   end generate;
--   delay_gen4:
--   for l_inst in 14 to 15 generate
--   begin
--       out_delay_tap_in((l_inst+1)*5-1 downto l_inst*5) <= "00000";
--   end generate;
   
  serdes_out_core : serdes_out
    port map(
      rst      => rst,
      clk      => clk,
      div_clk  => clk_div,
      clk_dly  => clk_dly,
      data_s0  => data_A_d2,
      data_s1  => data_B_d2,
      data_s2  => data_C_d2,
      data_s3  => data_D_d2,
      Frame    => Frame,
      sync     => sync,
--      Q_delay_tap => out_delay_tap_in,
      data_out => data_out
      );
  Q         <=   data_out(dac_resolution-1 downto 0);
  parity    <=   data_out(dac_resolution);  
  OBUFDS_signals_inst : OBUFDS_module
    port map (
      Q_p       => Q_p,
      Q_n       => Q_n,
      Q         => Q,
      parity    => parity,
      parity_p  => parity_p,
      parity_n  => parity_n,
      frame_p   => frame_p,
      frame_n   => frame_n,
      frame     => frame,
      SYNC_p    => SYNC_p,
      SYNC_n    => SYNC_n,
      sync      => sync,
      DataCLk_p => DataCLk_p,
      DataCLk_n => DataCLk_n,
      DataCLk   => DataCLk);

end Behavioral;
