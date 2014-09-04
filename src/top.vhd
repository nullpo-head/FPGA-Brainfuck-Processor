library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library UNISIM;
use UNISIM.VComponents.all;

entity top is
  Port ( MCLK1 : in  std_logic;
         RS_TX : out  std_logic;
         RS_RX : in  std_logic
         );
end top;

architecture structure of top is
    signal clk,iclk: std_logic;

    component main
        Port ( clk  : in  STD_LOGIC; tx : out STD_LOGIC; rx : in STD_LOGIC);
    end component;
    component myclk
        Port(
                clkin_in : in std_logic;
                rst_in : in std_logic;          
                clk0_out : out std_logic;
                clk0_div : out std_logic;
                locked_out : out std_logic
            );
    end component;

    signal clk_pll : std_logic;
begin
  ib: IBUFG port map (
    i=>MCLK1,
    o=>iclk);
  bg: BUFG port map (
    i=>iclk,
    o=>clk);
  Inst_myclk: myclk PORT MAP(
                                CLKIN_IN => clk,
                                RST_IN => '0',
                                CLK0_OUT => open,
                                CLK0_DIV => clk_pll,
                                LOCKED_OUT => open
                                );


  m: main port map (clk=> clk_pll, tx => RS_TX, rx => RS_RX);

end structure;

