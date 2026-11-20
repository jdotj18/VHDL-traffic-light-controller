-- Testbench for yellow_timer: SST at T = 1, MST at T = 2, TRUN = 0 clears.
library ieee;
use ieee.std_logic_1164.all;

entity tb_yellow_timer is
end tb_yellow_timer;

architecture sim of tb_yellow_timer is
    signal clk : std_logic := '0';
    signal rst, run : std_logic := '0';
    signal en : std_logic := '1';
    signal mst, sst : std_logic;
    signal t : std_logic_vector(3 downto 0);
begin
    clk <= not clk after 5 ns;

    uut : entity work.yellow_timer
        port map (i_clock => clk, i_reset => rst, i_enable => en, i_run => run,
                  o_mst => mst, o_sst => sst, o_t => t);

    process
    begin
        rst <= '1'; wait for 20 ns; rst <= '0';
        wait for 1 ns;
        assert t = "0000" and mst = '0' and sst = '0' report "idle failed" severity error;
        run <= '1';
        wait until rising_edge(clk); wait for 1 ns;           -- T = 1 : SST
        assert t = "0001" and sst = '1' and mst = '0' report "SST at T=1 failed" severity error;
        wait until rising_edge(clk); wait for 1 ns;           -- T = 2 : MST
        assert t = "0010" and mst = '1' and sst = '0' report "MST at T=2 failed" severity error;
        wait until rising_edge(clk); wait for 1 ns;           -- T = 3 : none
        assert mst = '0' and sst = '0' report "T=3 failed" severity error;
        run <= '0';
        wait until rising_edge(clk); wait for 1 ns;           -- TRUN = 0 : cleared
        assert t = "0000" report "clear failed" severity error;
        report "tb_yellow_timer done" severity note;
        wait;
    end process;
end sim;
