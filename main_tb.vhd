LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
-- USE ieee.numeric_std.ALL;

ENTITY main_tb IS
END main_tb;

ARCHITECTURE behavioral OF main_tb IS 
  
  -- Component Declaration for the Unit Under Test (UUT)
  
  COMPONENT main
    PORT(
      clk : IN  std_logic;
      tx : OUT  std_logic;
      rx : IN std_logic
      );
  END COMPONENT;

  --Inputs
  signal clk : std_logic := '0';
  signal RS_RX : std_logic := '1';

  --Outputs
  signal RS_TX : std_logic := '1';
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: main PORT MAP (
    clk => clk,
    tx => rs_tx,
    rx => rs_rx
    );

  clkgen: process
  begin
    clk <= '0';
    wait for 7 ns;
    clk <= '1';
    wait for 7 ns;
  end process;

END;
