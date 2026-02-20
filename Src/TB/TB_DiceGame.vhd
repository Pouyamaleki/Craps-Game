-- TB_DiceGame
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dice_game_top_tb is
end dice_game_top_tb;

architecture Behavioral of dice_game_top_tb is
    signal clk : STD_LOGIC := '0';
    signal reset_btn : STD_LOGIC := '0';
    signal roll_btn : STD_LOGIC := '0';
    signal seg_dice1 : STD_LOGIC_VECTOR(6 downto 0);
    signal seg_dice2 : STD_LOGIC_VECTOR(6 downto 0);
    signal win_led : STD_LOGIC;
    signal lose_led : STD_LOGIC;
    
    constant CLK_PERIOD : time := 10 ns;
begin
    uut: entity work.dice_game_top
        port map (
            clk => clk,
            reset_btn => reset_btn,
            roll_btn => roll_btn,
            seg_dice1 => seg_dice1,
            seg_dice2 => seg_dice2,
            win_led => win_led,
            lose_led => lose_led
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
        reset_btn <= '1';
        wait for 30 ns;
        reset_btn <= '0';
        wait for 50 ns;
        
        -- play a few rolls (actual values depend on counter randomness)
        roll_btn <= '1';  -- press
        wait for 100 ns;  -- hold for several clock cycles
        roll_btn <= '0';  -- release
        wait for 100 ns;
        
        roll_btn <= '1';
        wait for 100 ns;
        roll_btn <= '0';
        wait for 100 ns;
        
        roll_btn <= '1';
        wait for 100 ns;
        roll_btn <= '0';
        wait for 100 ns;
        
        -- reset and play again
        reset_btn <= '1';
        wait for 30 ns;
        reset_btn <= '0';
        wait for 50 ns;
        
        roll_btn <= '1';
        wait for 100 ns;
        roll_btn <= '0';
        wait for 100 ns;
        
        wait;
    end process;
end Behavioral;