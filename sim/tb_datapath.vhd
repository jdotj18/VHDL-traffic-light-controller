-- Testbench for datapath: CE at MSC / SSC, counter hold and clear, SEL mux, MST / SST.
library ieee;
use ieee.std_logic_1164.all;

entity tb_datapath is
end tb_datapath;

architecture sim of tb_datapath is
    signal clk : std_logic := '0';
    signal rst, mrun, srun, sel, trun : std_logic := '0';
    signal en : std_logic := '1';
    signal msc, ssc : std_logic_vector(3 downto 0);
    signal ce, mst, sst : std_logic;
    signal ms_cnt, ss_cnt : std_logic_vector(3 downto 0);

    procedure tick (signal c : in std_logic) is
    begin
        wait until rising_edge(c); wait for 1 ns;
    end procedure;
begin
    clk <= not clk after 5 ns;

    uut : entity work.datapath
        port map (i_clock => clk, i_reset => rst, i_enable => en, i_mrun => mrun, i_srun => srun,
                  i_sel => sel, i_trun => trun, i_msc_max => msc, i_ssc_max => ssc,
                  o_ce => ce, o_mst => mst, o_sst => sst, o_ms_cnt => ms_cnt, o_ss_cnt => ss_cnt);

    process
    begin
        msc <= "0011"; ssc <= "0010";
        rst <= '1'; wait for 20 ns; rst <= '0';
        -- MG
        mrun <= '1'; sel <= '0'; wait for 1 ns;
        assert ce = '0' report "CE should be 0 at count 0" severity error;
        tick(clk); tick(clk); tick(clk);                       -- MS_CNT = 3 = MSC
        assert ms_cnt = "0011" and ce = '1' report "CE at MSC failed" severity error;
        tick(clk); tick(clk);                                  -- holds at 3
        assert ms_cnt = "0011" and ce = '1' report "MS hold at max failed" severity error;
        -- MY
        mrun <= '0'; trun <= '1';
        tick(clk);                                             -- MS cleared, T = 1
        assert ms_cnt = "0000" and sst = '1' report "MS clear / T=1 failed" severity error;
        tick(clk);                                             -- T = 2
        assert mst = '1' report "MST failed" severity error;
        -- SG
        trun <= '0'; srun <= '1'; sel <= '1';
        tick(clk);                                             -- T cleared, SS_CNT = 0 -> 1
        assert mst = '0' and sst = '0' report "timer clear failed" severity error;
        tick(clk);                                             -- SS_CNT = 2 = SSC
        assert ss_cnt = "0010" and ce = '1' report "CE at SSC failed" severity error;
        sel <= '0'; wait for 1 ns;
        assert ce = '0' report "SEL mux failed" severity error;
        report "tb_datapath done" severity note;
        wait;
    end process;
end sim;
