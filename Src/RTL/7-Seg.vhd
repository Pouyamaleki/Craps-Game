-- 7-seg
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_segment is
    port (
        dice_value : in  STD_LOGIC_VECTOR(2 downto 0);  -- counter output
        seg_out    : out STD_LOGIC_VECTOR(6 downto 0)   -- 7-segment output
    );
end seven_segment;

architecture Behavioral of seven_segment is
begin
    process(dice_value)
    begin
        case dice_value is
            -- Display the output of the dice
            when "001" =>  -- 1
                seg_out <= "1111001";  -- turn on b and c
                
            when "010" =>  -- 2
                seg_out <= "0100100";  -- turn on a, b, g, e and d
                
            when "011" =>  -- 3
                seg_out <= "0110000";  -- turn on a, b, c, d and g
                
            when "100" =>  -- 4
                seg_out <= "0011001";  -- turn on b. c. f and g
                
            when "101" =>  -- 5
                seg_out <= "0010010";  -- turn on a, f, g, c and d
                
            when "110" =>  -- 6
                seg_out <= "0000010";  -- turn on a, f, e, d, c and g
                
            when others => -- 0 for Default value
                seg_out <= "1000000";  -- turn on a, b, c, d, e and f
                
        end case;
    end process;
end Behavioral;