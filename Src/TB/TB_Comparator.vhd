-- TB_Comparator
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparator_tb is
end comparator_tb;

architecture Behavioral of comparator_tb is
    signal current_sum : STD_LOGIC_VECTOR(3 downto 0);
    signal point_value : STD_LOGIC_VECTOR(3 downto 0);
    signal eq : STD_LOGIC;
begin
    uut: entity work.comparator
        port map (
            current_sum => current_sum,
            point_value => point_value,
            eq => eq
        );
    
    stimulus: process
    begin
        -- equal case
        current_sum <= "0111"; point_value <= "0111";  -- 7 == 7
        wait for 10 ns;
        
        -- not equal case
        current_sum <= "0101"; point_value <= "0111";  -- 5 != 7
        wait for 10 ns;
        
        -- point is 0 (first roll)
        current_sum <= "0111"; point_value <= "0000";  -- 7 != 0
        wait for 10 ns;
        
        -- other equal cases
        current_sum <= "1011"; point_value <= "1011";  -- 11 == 11
        wait for 10 ns;
        
        current_sum <= "0010"; point_value <= "1100";  -- 2 != 12
        wait for 10 ns;
        
        wait;
    end process;
end Behavioral;