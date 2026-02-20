-- adder
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
    port (
        dice1    : in  STD_LOGIC_VECTOR(2 downto 0);  -- First dice
        dice2    : in  STD_LOGIC_VECTOR(2 downto 0);  -- Second Dice
        sum_out  : out STD_LOGIC_VECTOR(3 downto 0)   -- Sum of the Values os pther Dices
    );
end adder;

architecture Behavioral of adder is
    signal dice1_vector : unsigned(2 downto 0);
    signal dice2_vector : unsigned(2 downto 0);
    signal sum_vector   : unsigned(3 downto 0);
begin
    -- cast unsigned to Vector
    dice1_vector <= unsigned(dice1);
    dice2_vector <= unsigned(dice2);
    
    -- resize to cast 3 bit variables to 4 bit variables to prevent overflow
    sum_vector <= resize(dice1_vector, 4) + resize(dice2_vector, 4);

    sum_out <= STD_LOGIC_VECTOR(sum_vector); -- Save the value of sum_vector
    
end Behavioral;