--TB_testLogic
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_logic_tb is
end test_logic_tb;

architecture Behavioral of test_logic_tb is
    signal current_sum : STD_LOGIC_VECTOR(3 downto 0);
    signal D7 : STD_LOGIC;
    signal D711 : STD_LOGIC;
    signal D2312 : STD_LOGIC;
begin
    uut: entity work.test_logic
        port map (
            current_sum => current_sum,
            D7 => D7,
            D711 => D711,
            D2312 => D2312
        );
    
    stimulus: process
    begin
        current_sum <= "0010";  -- 2
        wait for 10 ns;
        
        current_sum <= "0011";  -- 3
        wait for 10 ns;

        current_sum <= "0111";  -- 7
        wait for 10 ns;
   
        current_sum <= "1011";  -- 11
        wait for 10 ns;
 
        current_sum <= "1100";  -- 12
        wait for 10 ns;
   
        current_sum <= "0100";  -- 4
        wait for 10 ns;
        
        current_sum <= "0101";  -- 5
        wait for 10 ns;
        
        current_sum <= "0110";  -- 6
        wait for 10 ns;
        
        current_sum <= "1000";  -- 8
        wait for 10 ns;
        
        current_sum <= "1001";  -- 9
        wait for 10 ns;
        
        current_sum <= "1010";  -- 10
        wait for 10 ns;
        
        wait;
    end process;
end Behavioral;