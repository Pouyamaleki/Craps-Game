-- TB_counter
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_tb is
end counter_tb;

architecture Behavioral of counter_tb is
    signal clk      : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '0';
    signal enable   : STD_LOGIC := '0';
    signal dice_out : STD_LOGIC_VECTOR(2 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
begin
    -- unit under test
    uut: entity work.counter
        port map (
            clk      => clk,
            reset    => reset,
            enable   => enable,
            dice_out => dice_out
        );
    
    -- clock process
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    -- reset_button process
    reset_button: process
    begin
        -- initial reset_button
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 10 ns;
        
        -- test counting from 1 to 6
        enable <= '1';
        wait for 100 ns;  -- the result is 1,2,3,4,5,6,1,2,...
        
        -- turn off the counters
        enable <= '0';
        wait for 30 ns;
        
        -- enable again
        enable <= '1';
        wait for 70 ns;
        
        -- test reset while enabled
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        wait;
    end process;
end Behavioral;