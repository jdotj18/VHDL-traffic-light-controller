-- Testbench for counter4: count, hold, enable = 0, clear (RUN = 0), wrap 15 -> 0.
library ieee;
use ieee.std_logic_1164.all;

entity tb_counter4 is
end tb_counter4;

architecture sim of tb_counter4 is
    signal clk : std_logic := '0';
    signal rst, en, run, hold : std_logic := '0';
    signal q : std_logic_vector(3 downto 0);
begin
    clk <= not clk after 5 ns;

    uut : entity work.counter4
        port map (i_clock => clk, i_reset => rst, i_enable => en, i_run => run, i_hold => hold, o_q => q);

    process
    begin
        rst <= '1'; run <= '1'; en <= '1'; wait for 20 ns;    -- q = 0000 (reset)
        assert q = "0000" report "reset failed" severity error;
        rst <= '0'; wait for 30 ns;                           -- 3 clocks: q = 0011
        assert q = "0011" report "count failed" severity error;
        hold <= '1'; wait for 30 ns;                          -- hold: q = 0011
        assert q = "0011" report "hold failed" severity error;
        hold <= '0'; en <= '0'; wait for 30 ns;               -- enable off: q = 0011
        assert q = "0011" report "enable failed" severity error;
        en <= '1'; wait for 10 ns;                            -- q = 0100
        assert q = "0100" report "count after enable failed" severity error;
        run <= '0'; wait for 10 ns;                           -- RUN = 0: q = 0000
        assert q = "0000" report "clear failed" severity error;
        run <= '1'; wait for 150 ns;                          -- 15 clocks: q = 1111
        assert q = "1111" report "count to 15 failed" severity error;
        wait for 10 ns;                                       -- wraps to 0000
        assert q = "0000" report "wrap failed" severity error;
        report "tb_counter4 done" severity note;
        wait;
    end process;
end sim;
