library ieee;
use ieee.std_logic_1164.all;

package constants is
    type cpu_op is (
        NOP,
       P_INC, P_DEC, VAL_INC, VAL_DEC, WRITE, LBRACE, RBRACE,
        FINISH, UNDEFINED 
    );
    type cpu_state is (
        EXEC_OP, START_IO, WAIT_IO, JMP_TO_RIGHT, JMP_TO_LEFT
    );
    constant inst_width : integer := 8;
    constant opcode_width : integer := 3;
    constant operand_width : integer := inst_width - opcode_width;

    constant max_inst_length : integer := 256;
    constant max_inst_len_width : integer := 8;

    constant array_len_width : integer := 8;
    constant max_array_length : integer := 256;
end constants;
