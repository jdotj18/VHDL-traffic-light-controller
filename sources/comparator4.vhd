-- comparator4 : 4-bit equality comparator (XNOR per bit, then AND).
library ieee;
use ieee.std_logic_1164.all;

entity comparator4 is
    port (
        i_a, i_b : in  std_logic_vector(3 downto 0);
        o_eq     : out std_logic
    );
end comparator4;

architecture structural of comparator4 is
    signal eq : std_logic_vector(3 downto 0);
begin
    gen_bits : for i in 0 to 3 generate
        eq(i) <= i_a(i) xnor i_b(i);
    end generate;
    o_eq <= eq(3) and eq(2) and eq(1) and eq(0);
end structural;
