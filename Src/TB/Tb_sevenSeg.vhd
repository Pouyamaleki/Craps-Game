-- TB_sevenseg
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_segment_tb is
end seven_segment_tb;

architecture Behavioral of seven_segment_tb is
    signal dice_value : STD_LOGIC_VECTOR(2 downto 0);
    signal seg_out : STD_LOGIC_VECTOR(6 downto 0);
begin
    uut: entity work.seven_segment
        port map (
            dice_value => dice_value,
            seg_out => seg_out
        );
    
    stimulus: process
    begin
        -- test all dice values 1 to 6
        dice_value <= "001";  -- 1
        wait for 10 ns;
        
        dice_value <= "010";  -- 2
        wait for 10 ns;
        
        dice_value <= "011";  -- 3
        wait for 10 ns;
        
        dice_value <= "100";  -- 4
        wait for 10 ns;
        
        dice_value <= "101";  -- 5
        wait for 10 ns;
        
        dice_value <= "110";  -- 6
        wait for 10 ns;
        
        -- test invalid value
        dice_value <= "000";  -- 0
        wait for 10 ns;
        
        dice_value <= "111";  -- 7, this one should show 0
        wait for 10 ns;
        
        wait;
    end process;
end Behavioral;