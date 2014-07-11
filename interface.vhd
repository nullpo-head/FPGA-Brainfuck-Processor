library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

package interface is

    type decoder_out is record
        cpu_op_code : cpu_op;
    end record decoder_out;
    constant default_decoder_out : decoder_out := (cpu_op_code => NOP);

    type sys_reg_t is record
        pc : integer range 0 to (max_inst_length - 1);
        array_pointer : integer range 0 to (max_array_length - 1);
        brace_counter : integer range 0 to (max_inst_length / 2 - 1);
        exec_mode : cpu_state;
    end record sys_reg_t;
    constant default_sys_reg_t : sys_reg_t := (pc => 0, array_pointer => 0, brace_counter => 0, exec_mode => EXEC_OP);
    -- default values should be located here not to forget to declare for each interface, though they are constants.

    type rs232c_sender_in is record
         data : STD_LOGIC_VECTOR (7 downto 0);
         go   : STD_LOGIC;
    end record rs232c_sender_in;
    constant default_rs232c_sender_in : rs232c_sender_in := (data => (others => '0'), go => '0');

    type rs232c_sender_out is record
         busy : STD_LOGIC;
    end record rs232c_sender_out;
    constant default_rs232c_sender_out : rs232c_sender_out := (busy => '0');

    type inst_mem is array(0 to max_inst_length - 1) of std_logic_vector(7 downto 0);

    type bf_array_in is record
        pointer : integer range 0 to (max_array_length - 1);
        write : std_logic;
        data : std_logic_vector(7 downto 0);
    end record bf_array_in;
    constant default_bf_array_in : bf_array_in := (pointer => 0, write => '0', data => (others => '0'));

    type bf_array_out is record
        data : std_logic_vector(7 downto 0);
    end record bf_array_out;
    constant default_bf_array_out : bf_array_out := (data => (others => '0'));

    type controller_out is record
        bf_array_control : bf_array_in;
        sys_reg_control : sys_reg_t;
        write_control : rs232c_sender_in;
    end record controller_out;
    constant default_controller_out : controller_out := (bf_array_control => default_bf_array_in, sys_reg_control => default_sys_reg_t, write_control => default_rs232c_sender_in);

    type controller_in is record
        decoder_res : decoder_out;
        bf_array_res : bf_array_out;
        sys_reg_res : sys_reg_t;
        write_stat : rs232c_sender_out;
    end record controller_in;
    constant default_controller_in : controller_in := (decoder_res => default_decoder_out, bf_array_res => default_bf_array_out, sys_reg_res => default_sys_reg_t, write_stat => default_rs232c_sender_out);

end interface;
