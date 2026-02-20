--FSM
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Ports in order Clock, Reset, Roll button, equall to 7 , equall to 7 or 11 ->
-- equal to 2 or 3 or 12, boolean variable for equality, Activator, Save points, win and lose
entity fsm_controller is
    port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        roll_btn : in  STD_LOGIC;
        D7       : in  STD_LOGIC;
        D711     : in  STD_LOGIC;
        D2312    : in  STD_LOGIC;
        eq       : in  STD_LOGIC;
        roll_en  : out STD_LOGIC;
        store_p : out STD_LOGIC;
        win      : out STD_LOGIC;
        lose     : out STD_LOGIC
    );
end fsm_controller;

architecture Behavioral of fsm_controller is

    -- Decraling every state
    -- every type in order: wating for the game to start, first roll, next rolls, win and lose states
    type state_type is (
        WAITING,
        FIRST_ROLL,
        OTHERROLLS,
        WIN_STATE,
        LOSE_STATE
    );
    
    signal current_state, next_state : state_type;
    signal roll_btn_prev : STD_LOGIC := '0';  -- the dice values are captured and displayed upon its release
    
begin
    -- memory state
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= WAITING;
            roll_btn_prev <= '0';
        elsif rising_edge(clk) then
            current_state <= next_state;
            roll_btn_prev <= roll_btn;
        end if;
    end process;
    
    -- next state
    process(current_state, roll_btn, roll_btn_prev, D7, D711, D2312, eq)
    begin
        -- Default values for the variables
        next_state <= current_state;
        roll_en <= '0';
        store_p <= '0';
        win <= '0';
        lose <= '0';
        
        case current_state is
            when WAITING =>
                -- wating for the Player to press the key
                if roll_btn = '1' then
                    next_state <= FIRST_ROLL;
                end if;
                
            when FIRST_ROLL =>
                -- start the counters
                if roll_btn = '1' then
                    roll_en <= '1';
                end if;
                
                -- Player leave the button
                if roll_btn_prev = '1' and roll_btn = '0' then
                    -- check the first result
                    if D711 = '1' then
                        next_state <= WIN_STATE;
                        win <= '1';
                    elsif D2312 = '1' then
                        next_state <= LOSE_STATE;
                        lose <= '1';
                    -- save the points
                    else 
                        store_p <= '1';
                        next_state <= OTHERROLLS;
                    end if;
                end if;
                
            when OTHERROLLS =>
                -- start the counters
                if roll_btn = '1' then
                    roll_en <= '1';
                end if;
                
                -- Player leave the button
                if roll_btn_prev = '1' and roll_btn = '0' then
                    -- check the next results
                    if eq = '1' then
                        next_state <= WIN_STATE;
                        win <= '1';
                    elsif D7 = '1' then
                        next_state <= LOSE_STATE;
                        lose <= '1';
                    -- continue the Game
                    else 
                        next_state <= OTHERROLLS;
                    end if;
                end if;
            
                when WIN_STATE =>
                    win <= '1';
                    roll_en <= '0';
                    store_p <= '0';
                    lose <= '0';
    
                when LOSE_STATE =>
                    lose <= '1';
                    roll_en <= '0';
                    store_p <= '0';
                    win <= '0';
    
                when others =>
                     next_state <= WAITING;
                     store_p <= '0';
                     lose <= '0';
                     win <= '0';

        end case;
    end process;
    
end Behavioral;