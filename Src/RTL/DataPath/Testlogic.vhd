-- Testlogic
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Ports in order: Adder output, sum equal to 7, sum equal to 7 or 11 and sum equal to 2 or 3 or 12
entity test_logic is
    port (
        current_sum : in  STD_LOGIC_VECTOR(3 downto 0);
        D7          : out STD_LOGIC;
        D711        : out STD_LOGIC;
        D2312       : out STD_LOGIC
    );
end test_logic;

architecture Behavioral of test_logic is
begin
    -- if sum is equal to (7 = 0111)
    D7 <= '1' when (current_sum = "0111") else '0';
    -- if sum is equal to (7 = 0111) or (11 = 1011)
    D711 <= '1' when (current_sum = "0111" or current_sum = "1011") else '0';
    -- if sum is equal to (2 = 0010) or (3 = 0011) or (12 = 1100)
    D2312 <= '1' when (current_sum = "0010" or current_sum = "0011" or current_sum = "1100") else '0';
    
end Behavioral;