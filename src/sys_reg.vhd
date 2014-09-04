library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
use work.interface.all;

entity sys_reg is
    Port ( clk : in std_logic;
           sin : in sys_reg_t;
           sout : out sys_reg_t
         );
end sys_reg;

architecture rtl of sys_reg is
begin

    process (clk)
    begin
        if rising_edge(clk) then
            sout <= sin;
        end if;
    end process;

end rtl;
