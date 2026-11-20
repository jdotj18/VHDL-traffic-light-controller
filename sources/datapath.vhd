-- datapath : green counters, SEL muxes, green comparator (CE) and yellow timer.
library ieee;
use ieee.std_logic_1164.all;

entity datapath is
    port (
        i_clock, i_reset   : in  std_logic;
        i_enable           : in  std_logic;
        i_mrun, i_srun     : in  std_logic;
        i_sel, i_trun      : in  std_logic;
        i_msc_max          : in  std_logic_vector(3 downto 0);
        i_ssc_max          : in  std_logic_vector(3 downto 0);
        o_ce, o_mst, o_sst : out std_logic;
        o_ms_cnt, o_ss_cnt : out std_logic_vector(3 downto 0)
    );
end datapath;

architecture structural of datapath is
    component counter4
        port ( i_clock, i_reset, i_enable, i_run, i_hold : in std_logic;
               o_q : out std_logic_vector(3 downto 0) );
    end component;
    component mux2N
        generic ( N : integer );
        port ( i_a, i_b : in std_logic_vector(N-1 downto 0); i_sel : in std_logic;
               o_y : out std_logic_vector(N-1 downto 0) );
    end component;
    component comparator4
        port ( i_a, i_b : in std_logic_vector(3 downto 0); o_eq : out std_logic );
    end component;
    component yellow_timer
        port ( i_clock, i_reset, i_enable, i_run : in std_logic;
               o_mst, o_sst : out std_logic; o_t : out std_logic_vector(3 downto 0) );
    end component;

    signal ms_cnt, ss_cnt, cnt_sel, max_sel, t : std_logic_vector(3 downto 0);
    signal ce : std_logic;
begin
    -- green counters hold once count = max (CE = 1)
    cnt_ms : counter4 port map (i_clock, i_reset, i_enable, i_mrun, ce, ms_cnt);
    cnt_ss : counter4 port map (i_clock, i_reset, i_enable, i_srun, ce, ss_cnt);

    -- SEL = 0 : main street, SEL = 1 : side street
    mx_cnt : mux2N generic map (4) port map (ms_cnt, ss_cnt, i_sel, cnt_sel);
    mx_max : mux2N generic map (4) port map (i_msc_max, i_ssc_max, i_sel, max_sel);
    cmp_ce : comparator4 port map (cnt_sel, max_sel, ce);

    tmr_y : yellow_timer port map (i_clock, i_reset, i_enable, i_trun, o_mst, o_sst, t);

    o_ce     <= ce;
    o_ms_cnt <= ms_cnt;
    o_ss_cnt <= ss_cnt;
end structural;
