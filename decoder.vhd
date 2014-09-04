library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
use work.interface.all;

entity decoder is
    Port ( instruction : in std_logic_vector (inst_width - 1 downto 0);
           dout : out decoder_out
         );
end decoder;

architecture core of decoder is
begin
    process (instruction)
    begin
        case instruction is
            when "00111110" => -- '>'
                dout.cpu_op_code <= P_INC;
            when "00111100" => -- '<'
                dout.cpu_op_code <= P_DEC;
            when "00101011" => -- '+'
                dout.cpu_op_code <= VAL_INC;
            when "00101101" => -- '-'
                dout.cpu_op_code <= VAL_DEC;
            when "00101110" => -- '.'
                dout.cpu_op_code <= WRITE;
            when "00101100" => -- ','
                dout.cpu_op_code <= READ;
            when "01011011" => -- '['
                dout.cpu_op_code <= LBRACE;
            when "01011101" => -- ']'
                dout.cpu_op_code <= RBRACE;
            when "00000000" => -- FINISH
                dout.cpu_op_code <= FINISH;
            when others =>
                dout.cpu_op_code <= UNDEFINED;
        end case;
    end process;
end core;

