library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.interface.all;

entity rs232c_receiver is
  generic ( wtime: std_logic_vector(15 downto 0) := x"1ADB");
  Port ( clk   : in  std_logic;
         rx    : in  std_logic;
         rrin  : in rs232c_receiver_in;
         rrout : out rs232c_receiver_out);
end rs232c_receiver;

architecture rtl of rs232c_receiver is
    type reg_t is record
        count: std_logic_vector(15 downto 0);
        recvbuf: std_logic_vector(7 downto 0);
        state: integer range 0 to 15;
        next_rrout : rs232c_receiver_out;
    end record;

    signal r : reg_t := (count => (others => '0'), recvbuf => (others => '1'), state => 0, next_rrout => default_rs232c_receiver_out);
begin

  process(clk)
      variable v : reg_t;
  begin
    if rising_edge(clk) then
        v := r;
        case v.state is
            when 0 => -- WAIT
                if rx = '0' then
                    v.count := std_logic_vector(unsigned(wtime) + (unsigned(wtime) / 2));
                    v.state := 1;
                    v.next_rrout.done := '0';
                end if;
            when 9 => -- STOP bit
                if unsigned(v.count) = 0 then
                    v.next_rrout.data := v.recvbuf;
                    v.state := 0;
                    v.next_rrout.done := '1';
                else
                    v.count := std_logic_vector(unsigned(v.count) - 1);
                end if;
            when others => -- 8 to 1 bit
                if unsigned(v.count) = 0 then
                    v.recvbuf(v.state - 1) := rx;
                    v.state := v.state + 1;
                    v.count := wtime;
                else
                    v.count := std_logic_vector(unsigned(v.count) - 1);
                end if;
        end case;

        if rrin.buf_clear = '1' then
            v.next_rrout.data := "00000000";
            v.next_rrout.done := '0';
        end if;

        r <= v;
        rrout <= v.next_rrout;
    end if;
end process;
end rtl;

