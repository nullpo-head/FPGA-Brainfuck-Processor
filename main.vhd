library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
use work.interface.all;
use work.util.all;

entity main is
  Port ( clk : in  std_logic;
         tx : out std_logic
       );
end main;

architecture structural of main is
    component decoder
        Port ( instruction : in std_logic_vector (inst_width - 1 downto 0);
               output : out decoder_out
           );
    end component;
    component bf_array
        Port ( clk : in  std_logic;
               input : in bf_array_in;
               output : out bf_array_out
           );
    end component;
    component controller
        Port ( clk : in std_logic;
               cin : in controller_in;
               cout : out controller_out
           );
    end component;
    component sys_reg
        Port ( clk : in std_logic;
               sin : in sys_reg_t;
               sout : out sys_reg_t
           );
    end component;
    component rs232c_sender
        generic (wtime: std_logic_vector(15 downto 0) := x"02b6");
        Port (
                 clk  : in  STD_LOGIC;
                 tx : out STD_LOGIC;
                 input : in rs232c_sender_in;
                 output : out rs232c_sender_out
             );
    end component;

    signal sys_reg_out : sys_reg_t := default_sys_reg_t;

    --hello world
--    constant instructions : inst_mem := str_to_inst_mem("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.");
    --fibonatch
    constant instructions : inst_mem := str_to_inst_mem(">++++++++++>+>+[[+++++[>++++++++<-]>.<++++++[>--------<-]+<<<]>.>>[[-]<[>+<-]>>[<<+>+>-]<[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>[-]>+>+<<<-[>+<-]]]]]]]]]]]+>>>]<<<]");

    signal controller_in : controller_in := default_controller_in;
    signal controller_out : controller_out := default_controller_out;

    signal bf_array_out : bf_array_out := default_bf_array_out;

    signal rs232c_sender_out : rs232c_sender_out := default_rs232c_sender_out;

    signal inst : std_logic_vector(7 downto 0);
    signal decoder_out : decoder_out := (cpu_op_code => NOP);

begin

    sys_reg0 : sys_reg port map (
        clk => clk,
        sin => controller_out.sys_reg_control,
        sout => sys_reg_out
    );

    inst <= instructions(sys_reg_out.pc);
    decoder0 : decoder port map (
        instruction => inst,
        output => decoder_out
    );

    controller_in <= (
                     write_stat => rs232c_sender_out,
                     decoder_res => decoder_out, 
                     bf_array_res => bf_array_out,
                     sys_reg_res => sys_reg_out
                 );
    controller0 : controller port map (
        clk => clk,
        cin => controller_in,
        cout => controller_out
    );

    bf_array0 : bf_array port map (
        clk => clk,
        input => controller_out.bf_array_control,
        output => bf_array_out
    );

    rs232c_sender0 : rs232c_sender port map (
        clk => clk,
        input => controller_out.write_control,
        output => rs232c_sender_out,
        tx => tx
    );
    
end;
