--TB_Adder
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_tb is
end adder_tb;

architecture Behavioral of adder_tb is
    signal dice1 : STD_LOGIC_VECTOR(2 downto 0);
    signal dice2 : STD_LOGIC_VECTOR(2 downto 0);
    signal sum_out : STD_LOGIC_VECTOR(3 downto 0);
begin
    uut: entity work.adder
        port map (
            dice1 => dice1,
            dice2 => dice2,
            sum_out => sum_out
        );
    
    stimulus: process
    begin
        -- test various combinations
        dice1 <= "001"; dice2 <= "001";  -- 1 + 1 = 2
        wait for 10 ns;
        
        dice1 <= "001"; dice2 <= "110";  -- 1 + 6 = 7
        wait for 10 ns;
        
        dice1 <= "011"; dice2 <= "100";  -- 3 + 4 = 7
        wait for 10 ns;
        
        dice1 <= "101"; dice2 <= "110";  -- 5 + 6 = 11
        wait for 10 ns;
        
        dice1 <= "110"; dice2 <= "110";  -- 6 + 6 = 12
        wait for 10 ns;
        
        dice1 <= "010"; dice2 <= "001";  -- 2 + 1 = 3
        wait for 10 ns;
        
        wait;
    end process;
end Behavioral;