-- Comparator
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--Ports in order: Adder output, Saved value for point, boolean variable for equality
entity comparator is
    port (
        current_sum : in  STD_LOGIC_VECTOR(3 downto 0);
        point_value : in  STD_LOGIC_VECTOR(3 downto 0);
        eq : out STD_LOGIC
    );
end comparator;

architecture Behavioral of comparator is
begin
    eq <= '1' when (current_sum = point_value) else '0';
    
end Behavioral;