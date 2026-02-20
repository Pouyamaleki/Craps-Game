-- DiceGame
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- portts in order: Clock, Reset, Roll, first 7-segment, second 7-segment, win and lose
entity dice_game_top is
    port (
        clk          : in  STD_LOGIC;
        reset_btn    : in  STD_LOGIC;
        roll_btn     : in  STD_LOGIC;
        seg_dice1    : out STD_LOGIC_VECTOR(6 downto 0);
        seg_dice2    : out STD_LOGIC_VECTOR(6 downto 0);
        win_led      : out STD_LOGIC;
        lose_led     : out STD_LOGIC
    );
end dice_game_top;

architecture Structural of dice_game_top is

    -- siganls to connect the componenets
    signal dice1_value : STD_LOGIC_VECTOR(2 downto 0);
    signal dice2_value : STD_LOGIC_VECTOR(2 downto 0);
    signal sum_value   : STD_LOGIC_VECTOR(3 downto 0);
    signal point_value : STD_LOGIC_VECTOR(3 downto 0);

    signal roll_en     : STD_LOGIC;
    signal store_p    : STD_LOGIC;
    signal D7_sig      : STD_LOGIC;
    signal D711_sig    : STD_LOGIC;
    signal D2312_sig   : STD_LOGIC;
    signal eq_sig      : STD_LOGIC;
    
    -- reset signal
    signal reset_inv   : STD_LOGIC;

begin
    -- reverse the reset
    reset_inv <= not reset_btn;
    
    -- first Dice
    counter1: entity work.counter
        port map (
            clk      => clk,
            reset    => reset_inv,
            enable   => roll_en,
            dice_out => dice1_value
        );
    
    -- second Dice
    counter2: entity work.counter
        port map (
            clk      => clk,
            reset    => reset_inv,
            enable   => roll_en,
            dice_out => dice2_value
        );
    
    -- Adder
    adder_inst: entity work.adder
        port map (
            dice1   => dice1_value,
            dice2   => dice2_value,
            sum_out => sum_value
        );
    
    -- pointReg
    point_reg: entity work.point_register
        port map (
            clk         => clk,
            reset       => reset_inv,
            store_point => store_p,
            point_in    => sum_value,
            point_out   => point_value
        );
    
    -- Comparator
    comparator_inst: entity work.comparator
        port map (
            current_sum => sum_value,
            point_value => point_value,
            eq          => eq_sig
        );
    
    -- TestLogic
    test_logic_inst: entity work.test_logic
        port map (
            current_sum => sum_value,
            D7          => D7_sig,
            D711        => D711_sig,
            D2312       => D2312_sig
        );
    
    -- 7-segment for the first Dice
    seg1: entity work.seven_segment
        port map (
            dice_value => dice1_value,
            seg_out    => seg_dice1
        );
    
    -- 7-segment for the second Dice
    seg2: entity work.seven_segment
        port map (
            dice_value => dice2_value,
            seg_out    => seg_dice2
        );

    -- Finite State Machine (FSM)
    controller: entity work.fsm_controller
        port map (
            clk      => clk,
            reset    => reset_inv,
            roll_btn => roll_btn,
            D7       => D7_sig,
            D711     => D711_sig,
            D2312    => D2312_sig,
            eq       => eq_sig,
            roll_en  => roll_en,
            store_p => store_p,
            win      => win_led,
            lose     => lose_led
        );

end Structural;