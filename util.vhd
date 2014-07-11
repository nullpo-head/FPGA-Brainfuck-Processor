library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.interface.all;
use work.constants.all;

package util is
    function str_to_inst_mem(src : string) return inst_mem;
end util;

package body util is
    function str_to_inst_mem(src : string) return inst_mem is
    variable result : inst_mem := (others => (others => '0'));
    begin
        for i in src'range loop
            result(i - 1) := std_logic_vector(to_unsigned(natural(character'pos(src(i))), 8));
        end loop;
        return result;
    end str_to_inst_mem;
end util;
