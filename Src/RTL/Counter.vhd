-- 3 bit counter
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Ports in order: Clock , reset to restart the game , enable to start the game , output
entity counter is
    port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        enable  : in  STD_LOGIC;
        dice_out: out STD_LOGIC_VECTOR(2 downto 0)
    );
end counter;


architecture Behavioral of counter is
    
    -- count_reg value become 001 
    signal count_reg : unsigned(2 downto 0) := "001"; 

begin
    process(clk, reset)
    begin
        if reset = '1' then
            count_reg <= "001"; -- reset the value of count_reg when reset = 1
        elsif rising_edge(clk) then
            if enable = '1' then
                -- count from 1 to 6 then reset the count_reg
                if count_reg = "110" then
                    count_reg <= "001";
                else
                    count_reg <= count_reg + 1;
                end if;
            end if;
        end if;
    end process;
    
    dice_out <= STD_LOGIC_VECTOR(count_reg); -- show the value of count_reg and output of the counter
    
end Behavioral;