--PointReg
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ports in order: Clock, Reset, Save signal, new value for point, Saved value for point
entity point_register is
    port (
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        store_point: in  STD_LOGIC;
        point_in   : in  STD_LOGIC_VECTOR(3 downto 0);
        point_out  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end point_register;

architecture Behavioral of point_register is
    --point_reg value beecome 0
    signal point_reg : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process(clk, reset)
    begin
        if reset = '1' then
            point_reg <= (others => '0'); -- reset the value to 0
        elsif rising_edge(clk) then
            if store_point = '1' then
                point_reg <= point_in; -- Save the new value for point_reg
            end if;
        end if;
    end process;
    
    point_out <= point_reg;  -- save the value for output
    
end Behavioral;