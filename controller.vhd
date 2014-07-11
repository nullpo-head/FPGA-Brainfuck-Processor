library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.interface.all;
use work.constants.all;

use std.textio.all;
use work.txt_util.all;

entity controller is
    Port (
           clk : in std_logic;
           cin : in controller_in;
           cout : out controller_out
         );
end controller;
    
architecture rtl of controller is
    signal r : controller_out := default_controller_out;
    signal rin : controller_out := default_controller_out;
begin
    cout <= r;

    process (cin)

        variable next_cout : controller_out := default_controller_out;

--        variable debug_line: line;
    begin
        next_cout.sys_reg_control := cin.sys_reg_res;
        next_cout.bf_array_control := (write => '0', pointer => cin.sys_reg_res.array_pointer, data => "00000000");
        next_cout.write_control := default_rs232c_sender_in;

        case cin.sys_reg_res.exec_mode is
            when EXEC_OP =>
                next_cout.sys_reg_control.pc := cin.sys_reg_res.pc + 1;

                case cin.decoder_res.cpu_op_code is
                    when P_INC =>
                        next_cout.sys_reg_control.array_pointer := cin.sys_reg_res.array_pointer + 1;
                        next_cout.bf_array_control.pointer := next_cout.sys_reg_control.array_pointer;
                    when P_DEC =>
                        if cin.sys_reg_res.array_pointer = 0 then
--                            write(debug_line, String'("zero."));
--                            writeline(output, debug_line);
                        else 
                            next_cout.sys_reg_control.array_pointer := cin.sys_reg_res.array_pointer - 1;
                            next_cout.bf_array_control.pointer := next_cout.sys_reg_control.array_pointer;
                        end if;
                    when VAL_INC =>
                        next_cout.bf_array_control.write := '1';
                        next_cout.bf_array_control.data := std_logic_vector(to_signed(to_integer(signed(cin.bf_array_res.data) + 1), 8));
                    when VAL_DEC =>
                        next_cout.bf_array_control.write := '1';
                        next_cout.bf_array_control.data := std_logic_vector(to_signed(to_integer(signed(cin.bf_array_res.data) - 1), 8));
                    when WRITE =>
                        next_cout.sys_reg_control.pc := cin.sys_reg_res.pc;
                        next_cout.sys_reg_control.exec_mode := START_IO;
                    when LBRACE =>
                        if cin.bf_array_res.data = "00000000" then
                            next_cout.sys_reg_control.exec_mode := JMP_TO_RIGHT;
                            next_cout.sys_reg_control.brace_counter := 1;
                        end if;
                    when RBRACE =>
                        if cin.bf_array_res.data /= "00000000" then
                            next_cout.sys_reg_control.exec_mode := JMP_TO_LEFT;
                            next_cout.sys_reg_control.brace_counter := 1;
                            next_cout.sys_reg_control.pc := cin.sys_reg_res.pc - 1;
                        end if;
                    when FINISH =>
                        next_cout.sys_reg_control.pc := cin.sys_reg_res.pc;
                    when others =>
                end case;

            when START_IO =>
                if cin.write_stat.busy = '0' then
                    next_cout.write_control.data := cin.bf_array_res.data;
                    next_cout.write_control.go := '1';
                else
                    next_cout.sys_reg_control.exec_mode := WAIT_IO;
                    next_cout.write_control.go := '0';
                end if;

            when WAIT_IO =>
                if cin.write_stat.busy = '0' then
                    next_cout.sys_reg_control.exec_mode := EXEC_OP;
                    next_cout.sys_reg_control.pc := cin.sys_reg_res.pc + 1;
                end if;

            when JMP_TO_RIGHT =>
                next_cout.sys_reg_control.pc := cin.sys_reg_res.pc + 1;

                case cin.decoder_res.cpu_op_code is
                    when LBRACE =>
                        next_cout.sys_reg_control.brace_counter := cin.sys_reg_res.brace_counter + 1;
                    when RBRACE =>
                        next_cout.sys_reg_control.brace_counter := cin.sys_reg_res.brace_counter - 1;
                        if next_cout.sys_reg_control.brace_counter = 0 then
                            next_cout.sys_reg_control.exec_mode := EXEC_OP;
                        end if;
                    when others =>
                end case;

            when JMP_TO_LEFT =>
                next_cout.sys_reg_control.pc := cin.sys_reg_res.pc - 1;

                case cin.decoder_res.cpu_op_code is
                    when LBRACE =>
                        next_cout.sys_reg_control.brace_counter := cin.sys_reg_res.brace_counter - 1;
                        if next_cout.sys_reg_control.brace_counter = 0 then
                            next_cout.sys_reg_control.exec_mode := EXEC_OP;
                            next_cout.sys_reg_control.pc := cin.sys_reg_res.pc + 1;
                        end if;
                    when RBRACE =>
                        next_cout.sys_reg_control.brace_counter := cin.sys_reg_res.brace_counter + 1;
                    when others =>
                end case;
        end case;

        rin <= next_cout;

--        write(debug_line, String'("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>-.+++++++..+++.>>.<-.<.+++...>>+.>++."));
--        writeline(output, debug_line);
--        for i in 1 to cin.sys_reg_res.pc loop
--            write(debug_line, String'(" "));
--        end loop;
--        write(debug_line, String'("^"));
--        writeline(output, debug_line);
--        write(debug_line, String'("ap: "));
--        write(debug_line, cin.sys_reg_res.array_pointer);
--        write(debug_line, String'(", data: "));
--        write(debug_line, str(cin.bf_array_res.data));
--        write(debug_line, String'(", bc: "));
--        write(debug_line, str(cin.sys_reg_res.brace_counter));
--        writeline(output, debug_line);
    end process;

    process (clk)
    begin
        if falling_edge(clk) then
            r <= rin;
        end if;
    end process;

end rtl;
