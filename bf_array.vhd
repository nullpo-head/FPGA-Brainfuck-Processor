library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
use work.interface.all;

entity bf_array is
    Port ( clk : in  std_logic;
           input : in bf_array_in;
           output : out bf_array_out
       );
end bf_array;

architecture rtl of bf_array is
    type array_mem is array(0 to max_array_length - 1) of std_logic_vector(7 downto 0);
    signal arrays : array_mem := (others => (others => '0'));
    signal addr : integer range 0 to max_array_length - 1;
begin
    output.data <= arrays(addr);

    process (clk)
    begin
        if rising_edge (clk) then
            if input.write = '1' then
                arrays(input.pointer) <= input.data;
            end if;
        end if;
        addr <= input.pointer;
    end process;
end rtl;
