-- Testbench for fsm_controller: every transition table row, outputs of each state, enable = 0 holds.
library ieee;
use ieee.std_logic_1164.all;

entity tb_fsm_controller is
end tb_fsm_controller;

architecture sim of tb_fsm_controller is
    signal clk : std_logic := '0';
    signal rst, en, ce, sscs, mst, sst : std_logic := '0';
    signal mstl, sstl : std_logic_vector(2 downto 0);
    signal mrun, srun, sel, trun : std_logic;
    signal state : std_logic_vector(1 downto 0);

    constant MG : std_logic_vector(1 downto 0) := "00";
    constant MY : std_logic_vector(1 downto 0) := "01";
    constant SG : std_logic_vector(1 downto 0) := "11";
    constant SY : std_logic_vector(1 downto 0) := "10";
begin
    clk <= not clk after 5 ns;

    uut : entity work.fsm_controller
        port map (i_clock => clk, i_reset => rst, i_enable => en, i_ce => ce, i_sscs => sscs,
                  i_mst => mst, i_sst => sst, o_mstl => mstl, o_sstl => sstl,
                  o_mrun => mrun, o_srun => srun, o_sel => sel, o_trun => trun, o_state => state);

    process
        procedure step (c, s, m, t : std_logic; nxt : std_logic_vector(1 downto 0); msg : string) is
        begin
            ce <= c; sscs <= s; mst <= m; sst <= t;
            wait until rising_edge(clk); wait for 1 ns;
            assert state = nxt report msg severity error;
        end procedure;
    begin
        rst <= '1'; en <= '1'; wait for 20 ns; rst <= '0'; wait for 1 ns;
        assert state = MG and mstl = "001" and sstl = "100" and mrun = '1' and srun = '0'
               and sel = '0' and trun = '0' report "MG outputs" severity error;
        step('0', '1', '0', '0', MG, "MG CE=0 must stay");
        step('1', '0', '0', '0', MG, "MG CE=1 SSCS=0 must stay");
        en <= '0';
        step('1', '1', '0', '0', MG, "enable=0 must hold");
        en <= '1';
        step('1', '1', '0', '0', MY, "MG CE.SSCS -> MY");
        assert mstl = "010" and sstl = "100" and trun = '1' and mrun = '0' and sel = '0'
               report "MY outputs" severity error;
        step('0', '0', '0', '0', MY, "MY MST=0 must stay");
        step('1', '1', '1', '0', SG, "MY MST -> SG");
        assert mstl = "100" and sstl = "001" and srun = '1' and sel = '1' and trun = '0'
               report "SG outputs" severity error;
        step('0', '1', '1', '1', SG, "SG CE=0 must stay");
        step('1', '0', '0', '0', SY, "SG CE -> SY");
        assert mstl = "100" and sstl = "010" and trun = '1' and srun = '0' and sel = '1'
               report "SY outputs" severity error;
        step('1', '1', '1', '0', SY, "SY SST=0 must stay");
        step('0', '0', '0', '1', MG, "SY SST -> MG");
        step('1', '1', '0', '0', MY, "MG -> MY again");
        rst <= '1'; wait for 1 ns;
        assert state = MG report "async reset to MG" severity error;
        rst <= '0';
        report "tb_fsm_controller done" severity note;
        wait;
    end process;
end sim;
