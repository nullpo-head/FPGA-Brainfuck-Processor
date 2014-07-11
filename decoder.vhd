library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
use work.interface.all;

entity decoder is
    Port ( instruction : in std_logic_vector (inst_width - 1 downto 0);
           output : out decoder_out
         );
end decoder;

architecture core of decoder is
begin
    process (instruction)
    begin
        case instruction is
            when "00111110" => -- '>'
                output.cpu_op_code <= P_INC;
            when "00111100" => -- '<'
                output.cpu_op_code <= P_DEC;
            when "00101011" => -- '+'
                output.cpu_op_code <= VAL_INC;
            when "00101101" => -- '-'
                output.cpu_op_code <= VAL_DEC;
            when "00101110" => -- '.'
                output.cpu_op_code <= WRITE;
            when "00101100" => -- ','
                output.cpu_op_code <= NOP;
            when "01011011" => -- '['
                output.cpu_op_code <= LBRACE;
            when "01011101" => -- ']'
                output.cpu_op_code <= RBRACE;
            when "00000000" => -- FINISH
                output.cpu_op_code <= FINISH;
            when others =>
                output.cpu_op_code <= UNDEFINED;
        end case;
    end process;
end core;

