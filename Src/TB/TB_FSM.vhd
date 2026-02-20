--TB_FSM
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsm_controller_tb is
end fsm_controller_tb;

architecture Behavioral of fsm_controller_tb is
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal roll_btn : STD_LOGIC := '0';
    signal D7 : STD_LOGIC := '0';
    signal D711 : STD_LOGIC := '0';
    signal D2312 : STD_LOGIC := '0';
    signal eq : STD_LOGIC := '0';
    signal roll_en : STD_LOGIC;
    signal store_p : STD_LOGIC;
    signal win : STD_LOGIC;
    signal lose : STD_LOGIC;
    
    constant CLK_PERIOD : time := 10 ns;
begin
    uut: entity work.fsm_controller
        port map (
            clk => clk,
            reset => reset,
            roll_btn => roll_btn,
            D7 => D7,
            D711 => D711,
            D2312 => D2312,
            eq => eq,
            roll_en => roll_en,
            store_p => store_p,
            win => win,
            lose => lose
        );
    
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    stimulus: process
    begin
        -- reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
        
        -- test case 1: win on first roll (7)
        roll_btn <= '1';  -- press button
        wait for 30 ns;
        D711 <= '1';      -- sum is 7 or 11
        wait for 10 ns;
        roll_btn <= '0';  -- release button
        wait for 30 ns;
        D711 <= '0';
        wait for 30 ns;
        
        -- reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 30 ns;
        
        -- test case 2: lose on first roll (2)
        roll_btn <= '1';
        wait for 30 ns;
        D2312 <= '1';     -- sum is 2,3,12
        wait for 10 ns;
        roll_btn <= '0';
        wait for 30 ns;
        D2312 <= '0';
        wait for 30 ns;
        
        -- reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 30 ns;

        --test case 3: set point 5 and then win
        -- first roll: 5
        roll_btn <= '1';
        wait for 30 ns;   -- sum = 5 not any of ( D7, D711, D2312)
        roll_btn <= '0';
        wait for 30 ns;   -- should store point
        wait for 30 ns;
        
        -- second roll: 5 (win)
        roll_btn <= '1';
        wait for 30 ns;
        eq <= '1';
        wait for 10 ns;
        roll_btn <= '0';
        wait for 30 ns;
        eq <= '0';
        
        wait;
    end process;
end Behavioral;