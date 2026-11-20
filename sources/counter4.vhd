-- counter4 : 4-bit counter, q+ = RUN . (q + HOLD') on each enable.
library ieee;
use ieee.std_logic_1164.all;

entity counter4 is
    port (
        i_clock  : in  std_logic;
        i_reset  : in  std_logic;
        i_enable : in  std_logic;
        i_run    : in  std_logic;
        i_hold   : in  std_logic;
        o_q      : out std_logic_vector(3 downto 0)
    );
end counter4;

architecture structural of counter4 is
    component regN
        generic ( N : integer );
        port ( i_clock, i_reset, i_load : in std_logic;
               i_d : in std_logic_vector(N-1 downto 0); o_q : out std_logic_vector(N-1 downto 0) );
    end component;
    component addSubN
        generic ( N : integer );
        port ( i_a, i_b : in std_logic_vector(N-1 downto 0); i_sub : in std_logic;
               o_s : out std_logic_vector(N-1 downto 0); o_cout, o_ovf : out std_logic );
    end component;

    signal q, inc_v, sum, d : std_logic_vector(3 downto 0);
    signal inc, nc1, nc2    : std_logic;
begin
    inc   <= not i_hold;
    inc_v <= "000" & inc;                                -- +1, or +0 when holding

    add_q : addSubN generic map (4) port map (q, inc_v, '0', sum, nc1, nc2);

    gen_clr : for i in 0 to 3 generate
        d(i) <= sum(i) and i_run;                        -- RUN = 0 clears
    end generate;

    reg_q : regN generic map (4) port map (i_clock, i_reset, i_enable, d, q);

    o_q <= q;
end structural;
