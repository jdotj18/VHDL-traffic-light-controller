-- yellow_timer : fixed yellow timer, MST at T = 2 (3 s), SST at T = 1 (2 s).
library ieee;
use ieee.std_logic_1164.all;

entity yellow_timer is
    port (
        i_clock  : in  std_logic;
        i_reset  : in  std_logic;
        i_enable : in  std_logic;
        i_run    : in  std_logic;
        o_mst    : out std_logic;
        o_sst    : out std_logic;
        o_t      : out std_logic_vector(3 downto 0)
    );
end yellow_timer;

architecture structural of yellow_timer is
    component counter4
        port ( i_clock, i_reset, i_enable, i_run, i_hold : in std_logic;
               o_q : out std_logic_vector(3 downto 0) );
    end component;
    component comparator4
        port ( i_a, i_b : in std_logic_vector(3 downto 0); o_eq : out std_logic );
    end component;

    constant MT_LAST : std_logic_vector(3 downto 0) := "0010";
    constant ST_LAST : std_logic_vector(3 downto 0) := "0001";
    signal t : std_logic_vector(3 downto 0);
begin
    cnt_t  : counter4    port map (i_clock, i_reset, i_enable, i_run, '0', t);
    cmp_mt : comparator4 port map (t, MT_LAST, o_mst);
    cmp_st : comparator4 port map (t, ST_LAST, o_sst);
    o_t <= t;
end structural;
