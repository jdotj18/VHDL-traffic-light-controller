-- diagram_final_lab3 : traffic light controller top level (Nexys A7-100T).
library ieee;
use ieee.std_logic_1164.all;

entity diagram_final_lab3 is
    generic (
        G_TICK : integer := 100000000;                  -- 1 s
        G_DEB  : integer := 1000000                     -- 10 ms
    );
    port (
        CLOCK    : in  std_logic;
        RESETBAR : in  std_logic;
        LOAD_FSM : in  std_logic;
        MSC_MAX  : in  std_logic_vector(3 downto 0);
        SSC_MAX  : in  std_logic_vector(3 downto 0);
        CAPTEUR  : in  std_logic;
        MSTL     : out std_logic_vector(2 downto 0);
        SSTL     : out std_logic_vector(2 downto 0);
        AN       : out std_logic_vector(7 downto 0)
    );
end diagram_final_lab3;

architecture structural of diagram_final_lab3 is
    component clk_divider
        generic ( G_N : integer );
        port ( i_clock, i_reset : in std_logic; o_tick : out std_logic );
    end component;
    component debouncer
        generic ( G_N : integer );
        port ( i_clk, i_reset, i_button : in std_logic; o_clean : out std_logic );
    end component;
    component fsm_controller
        port ( i_clock, i_reset, i_enable, i_ce, i_sscs, i_mst, i_sst : in std_logic;
               o_mstl, o_sstl : out std_logic_vector(2 downto 0);
               o_mrun, o_srun, o_sel, o_trun : out std_logic;
               o_state : out std_logic_vector(1 downto 0) );
    end component;
    component datapath
        port ( i_clock, i_reset, i_enable, i_mrun, i_srun, i_sel, i_trun : in std_logic;
               i_msc_max, i_ssc_max : in std_logic_vector(3 downto 0);
               o_ce, o_mst, o_sst : out std_logic;
               o_ms_cnt, o_ss_cnt : out std_logic_vector(3 downto 0) );
    end component;

    signal reset, tick, en1, sscs : std_logic;
    signal ce, mst, sst, mrun, srun, sel, trun : std_logic;
    signal state : std_logic_vector(1 downto 0);
    signal ms_cnt, ss_cnt : std_logic_vector(3 downto 0);
begin
    reset <= not RESETBAR;
    en1   <= tick and LOAD_FSM;

    u_div : clk_divider    generic map (G_N => G_TICK) port map (CLOCK, reset, tick);
    u_deb : debouncer      generic map (G_N => G_DEB)  port map (CLOCK, reset, CAPTEUR, sscs);

    u_fsm : fsm_controller port map (CLOCK, reset, en1, ce, sscs, mst, sst,
                                     MSTL, SSTL, mrun, srun, sel, trun, state);

    u_dp  : datapath       port map (CLOCK, reset, en1, mrun, srun, sel, trun,
                                     MSC_MAX, SSC_MAX, ce, mst, sst, ms_cnt, ss_cnt);

    AN <= (others => '1');                               -- seven-segment display off
end structural;
