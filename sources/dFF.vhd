-- dFF : D flip-flop with enable and asynchronous reset (reset value G_INIT).
library ieee;
use ieee.std_logic_1164.all;

entity dFF is
    generic ( G_INIT : std_logic := '0' );
    port (
        i_clock  : in  std_logic;
        i_reset  : in  std_logic;
        i_enable : in  std_logic;
        i_d      : in  std_logic;
        o_q      : out std_logic
    );
end dFF;

architecture rtl of dFF is
begin
    process (i_clock, i_reset)
    begin
        if i_reset = '1' then
            o_q <= G_INIT;
        elsif rising_edge(i_clock) then
            if i_enable = '1' then
                o_q <= i_d;
            end if;
        end if;
    end process;
end rtl;
