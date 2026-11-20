-- Testbench for diagram_final_lab3: one full cycle MG -> MY -> SG -> SY -> MG.
-- 1 s scaled to 1000 ns (G_TICK = 100), MSC = 3, SSC = 2. Run with: run all
library ieee;
use ieee.std_logic_1164.all;

entity tb_diagram_final_lab3 is
end tb_diagram_final_lab3;

architecture sim of tb_diagram_final_lab3 is
    constant TP : time := 1000 ns;                        -- 1 s

    signal CLOCK    : std_logic := '0';
    signal RESETBAR : std_logic := '0';
    signal LOAD_FSM : std_logic := '1';
    signal CAPTEUR  : std_logic := '0';
    signal MSC_MAX  : std_logic_vector(3 downto 0) := "0011";
    signal SSC_MAX  : std_logic_vector(3 downto 0) := "0010";
    signal MSTL, SSTL : std_logic_vector(2 downto 0);
    signal AN : std_logic_vector(7 downto 0);
    signal done : boolean := false;

    type phase_t is (MG, MY, SG, SY, ERR);
    signal phase     : phase_t;
    signal seconds   : integer := 0;                      -- seconds since reset
    signal phase_sec : integer := 1;                      -- second of the current light

    constant GREEN  : std_logic_vector(2 downto 0) := "001";
    constant YELLOW : std_logic_vector(2 downto 0) := "010";
    constant RED    : std_logic_vector(2 downto 0) := "100";
begin
    CLOCK <= not CLOCK after 5 ns when not done else '0';

    uut : entity work.diagram_final_lab3
        generic map (G_TICK => 100, G_DEB => 3)
        port map (CLOCK => CLOCK, RESETBAR => RESETBAR, LOAD_FSM => LOAD_FSM,
                  MSC_MAX => MSC_MAX, SSC_MAX => SSC_MAX, CAPTEUR => CAPTEUR,
                  MSTL => MSTL, SSTL => SSTL, AN => AN);

    phase <= MG when MSTL = GREEN  and SSTL = RED    else
             MY when MSTL = YELLOW and SSTL = RED    else
             SG when MSTL = RED    and SSTL = GREEN  else
             SY when MSTL = RED    and SSTL = YELLOW else
             ERR;

    sec_count : process
    begin
        wait until RESETBAR = '1';
        wait for 5 ns;                                    -- align with the 1 s ticks
        while not done loop
            wait for TP;
            seconds <= seconds + 1;
        end loop;
        wait;
    end process;

    phase_count : process
    begin
        wait until RESETBAR = '1';
        wait for 5 ns;
        while not done loop
            wait on phase for TP;
            if phase'event then
                phase_sec <= 1;
            else
                phase_sec <= phase_sec + 1;
            end if;
        end loop;
        wait;
    end process;

    stim : process
        variable t0 : time;
    begin
        RESETBAR <= '0'; wait for 50 ns; RESETBAR <= '1';     -- MG
        assert phase = MG report "reset state is not MG" severity error;

        wait for 5 * TP;                                      -- no car: MG holds
        assert phase = MG report "MG should hold with no car" severity error;

        CAPTEUR <= '1';                                       -- car arrives
        wait until phase = MY for TP + 100 ns;
        assert phase = MY report "car did not start MY" severity error;
        report "MG -> MY" severity note;

        t0 := now;
        wait until phase = SG for 4 * TP;                     -- MY = 3 s
        assert now - t0 = 3 * TP report "MY should last 3 s" severity error;
        report "MY -> SG (MY = 3 s)" severity note;
        CAPTEUR <= '0';

        t0 := now;
        wait until phase = SY for 4 * TP;                     -- SG = SSC + 1 = 3 s
        assert now - t0 = 3 * TP report "SG should last 3 s" severity error;
        report "SG -> SY (SG = 3 s)" severity note;

        t0 := now;
        wait until phase = MG for 3 * TP;                     -- SY = 2 s
        assert now - t0 = 2 * TP report "SY should last 2 s" severity error;
        report "SY -> MG (SY = 2 s)" severity note;

        wait for 4 * TP;                                      -- no car: MG holds
        assert phase = MG report "MG should hold after the cycle" severity error;

        report "tb_diagram_final_lab3 done" severity note;
        done <= true;
        wait;
    end process;
end sim;
