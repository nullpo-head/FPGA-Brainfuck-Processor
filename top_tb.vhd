LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
-- USE ieee.numeric_std.ALL;

ENTITY top_tb IS
END top_tb;

ARCHITECTURE behavior OF top_tb IS 
  
  -- Component Declaration for the Unit Under Test (UUT)
  
  COMPONENT top
    PORT(
      MCLK1 : IN  std_logic;
      RS_TX : OUT  std_logic
      );
  END COMPONENT;

  --Inputs
  signal MCLK1 : std_logic := '0';

  --Outputs
  signal RS_TX : std_logic;
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: top PORT MAP (
    MCLK1 => MCLK1,
    RS_TX => RS_TX
    );

  clkgen: process
  begin
    mclk1 <= '0';
    wait for 7 ns;
    mclk1 <= '1';
    wait for 7 ns;
  end process;

END;
