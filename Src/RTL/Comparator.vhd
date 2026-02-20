-- Comparator
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparator is
    port (
        current_sum : in  STD_LOGIC_VECTOR(3 downto 0); -- Adder output
        point_value : in  STD_LOGIC_VECTOR(3 downto 0); -- Saved vlaue for point
        eq : out STD_LOGIC  -- boolean variable for equality
    );
end comparator;

architecture Behavioral of comparator is
begin
    eq <= '1' when (current_sum = point_value) else '0';
    
end Behavioral;