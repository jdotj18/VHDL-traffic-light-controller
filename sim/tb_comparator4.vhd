-- Testbench for comparator4: all 256 (a, b) pairs, eq = 1 only when a = b.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_comparator4 is
end tb_comparator4;

architecture sim of tb_comparator4 is
    signal a, b : std_logic_vector(3 downto 0) := "0000";
    signal eq   : std_logic;
begin
    uut : entity work.comparator4 port map (i_a => a, i_b => b, o_eq => eq);

    process
        variable errors : integer := 0;
    begin
        for i in 0 to 15 loop
            for j in 0 to 15 loop
                a <= std_logic_vector(to_unsigned(i, 4));
                b <= std_logic_vector(to_unsigned(j, 4));
                wait for 10 ns;
                if (i = j and eq /= '1') or (i /= j and eq /= '0') then
                    errors := errors + 1;
                    report "comparator4 wrong output" severity error;
                end if;
            end loop;
        end loop;
        assert errors = 0 report "tb_comparator4 FAILED" severity error;
        report "tb_comparator4 done" severity note;
        wait;
    end process;
end sim;
