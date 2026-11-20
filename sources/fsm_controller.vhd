-- fsm_controller : Moore FSM, Gray code MG = 00, MY = 01, SG = 11, SY = 10.
library ieee;
use ieee.std_logic_1164.all;

entity fsm_controller is
    port (
        i_clock  : in  std_logic;
        i_reset  : in  std_logic;
        i_enable : in  std_logic;
        i_ce     : in  std_logic;
        i_sscs   : in  std_logic;
        i_mst    : in  std_logic;
        i_sst    : in  std_logic;
        o_mstl   : out std_logic_vector(2 downto 0);     -- 2 red, 1 yellow, 0 green
        o_sstl   : out std_logic_vector(2 downto 0);
        o_mrun   : out std_logic;
        o_srun   : out std_logic;
        o_sel    : out std_logic;
        o_trun   : out std_logic;
        o_state  : out std_logic_vector(1 downto 0)
    );
end fsm_controller;

architecture structural of fsm_controller is
    component dFF
        generic ( G_INIT : std_logic );
        port ( i_clock, i_reset, i_enable, i_d : in std_logic; o_q : out std_logic );
    end component;

    signal y1, y0 : std_logic;   -- current state
    signal d1, d0 : std_logic;   -- next state
begin
    -- next-state logic
    d1 <= (y1 and y0) or (y0 and i_mst) or (y1 and (not i_sst));
    d0 <= ((not y1) and y0) or ((not y1) and i_ce and i_sscs) or (y0 and (not i_ce));

    -- state flip-flops (reset to MG = 00)
    ff_y1 : dFF generic map (G_INIT => '0')
                port map (i_clock => i_clock, i_reset => i_reset, i_enable => i_enable, i_d => d1, o_q => y1);
    ff_y0 : dFF generic map (G_INIT => '0')
                port map (i_clock => i_clock, i_reset => i_reset, i_enable => i_enable, i_d => d0, o_q => y0);

    -- Moore outputs
    o_mstl(0) <= (not y1) and (not y0);
    o_mstl(1) <= (not y1) and y0;
    o_mstl(2) <= y1;
    o_sstl(0) <= y1 and y0;
    o_sstl(1) <= y1 and (not y0);
    o_sstl(2) <= not y1;
    o_mrun    <= (not y1) and (not y0);
    o_srun    <= y1 and y0;
    o_sel     <= y1;
    o_trun    <= y1 xor y0;
    o_state   <= y1 & y0;
end structural;
