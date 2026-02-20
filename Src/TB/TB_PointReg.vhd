--TB_PointReg
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity point_register_tb is
end point_register_tb;

architecture Behavioral of point_register_tb is
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal store_point : STD_LOGIC := '0';
    signal point_in : STD_LOGIC_VECTOR(3 downto 0);
    signal point_out : STD_LOGIC_VECTOR(3 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
begin
    uut: entity work.point_register
        port map (
            clk         => clk,
            reset       => reset,
            store_point => store_point,
            point_in    => point_in,
            point_out   => point_out
        );
    
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    stimulus: process
    begin
        -- initial reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 10 ns;
        
        -- store first point
        point_in <= "0111";  -- 7
        store_point <= '1';
        wait for 20 ns;
        store_point <= '0';
        wait for 20 ns;
        
        -- try to store another point (should not change)
        point_in <= "0101";  -- 5
        store_point <= '1';
        wait for 20 ns;
        store_point <= '0';
        wait for 20 ns;
        
        -- reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        -- store new point
        point_in <= "1010";  -- 10
        store_point <= '1';
        wait for 20 ns;
        store_point <= '0';
        
        wait;
    end process;
end Behavioral;