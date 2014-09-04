library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.interface.all;

entity rs232c_sender is
  generic (wtime: std_logic_vector(15 downto 0) := x"02b6");
  Port ( clk  : in  std_logic;
         tx : out std_logic;
         rsin : in rs232c_sender_in;
         rsout : out rs232c_sender_out);
end rs232c_sender;

architecture rtl of rs232c_sender is
  signal countdown: std_logic_vector(15 downto 0) := (others=>'0');
  signal sendbuf: std_logic_vector(8 downto 0) := (others=> '1');
  signal state: integer range 0 to 15 := 10;
  signal sending: std_logic_vector(7 downto 0);
begin
  statemachine: process(clk)
  begin
    if rising_edge(clk) then
      case state is
        when 10 =>
          if rsin.go = '1' then
            sending <= rsin.data;
            sendbuf <= rsin.data & "0";
            state <= state - 1;
            countdown<=wtime;
          end if;
        when others=>
          if unsigned(countdown) = 0 then
            sendbuf <= "1" & sendbuf(8 downto 1);
            countdown <= wtime;
            if state = 0 then
                state <= 10;
            else
                state <= state - 1;
            end if;
          else
            countdown <= std_logic_vector(unsigned(countdown) - 1);
          end if;
      end case;
    end if;
  end process;
  tx <= sendbuf(0);
  rsout.busy <= '0' when state = 10 else '1';
end rtl;

