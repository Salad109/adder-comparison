--------------------------------------------------------------------------------
-- Title: Test Bench for Comparing Kogge-Stone PPA and Ripple Carry Adder
-- Description: Verifies the functionality of both 64-bit adders simultaneously
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adders_comparison_tb is
end entity adders_comparison_tb;

architecture Behavioral of adders_comparison_tb is
    constant BIT_WIDTH : integer := 64;
    
    component koggestone_ppa is
        port (
            a     : in  STD_LOGIC_VECTOR(63 downto 0);
            b     : in  STD_LOGIC_VECTOR(63 downto 0);
            c_in  : in  STD_LOGIC;
            sum   : out STD_LOGIC_VECTOR(63 downto 0);
            c_out : out STD_LOGIC
        );
    end component koggestone_ppa;
    
    component rca is
        port (
            a     : in  STD_LOGIC_VECTOR(63 downto 0);
            b     : in  STD_LOGIC_VECTOR(63 downto 0);
            c_in  : in  STD_LOGIC;
            sum   : out STD_LOGIC_VECTOR(63 downto 0);
            c_out : out STD_LOGIC
        );
    end component rca;
    
    -- Shared Inputs
    signal a_tb     : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal b_tb     : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal c_in_tb  : STD_LOGIC := '0';
    
    -- Outputs for Kogge-Stone PPA
    signal sum_ks_tb   : STD_LOGIC_VECTOR(63 downto 0);
    signal c_out_ks_tb : STD_LOGIC;
    
    -- Outputs for RCA
    signal sum_rca_tb   : STD_LOGIC_VECTOR(63 downto 0);
    signal c_out_rca_tb : STD_LOGIC;
    
    -- Clear procedure to reset and stabilize inputs
    procedure clear_inputs(
        signal a     : out std_logic_vector(63 downto 0);
        signal b     : out std_logic_vector(63 downto 0);
        signal c_in  : out std_logic
    ) is
    begin
        a     <= (others => '0');
        b     <= (others => '0');
        c_in  <= '0';
        
        -- Wait for signals to die down
        wait for 20 ns;
    end procedure;
    
    -- Test procedures
    procedure check_both_adders(
        constant a_val    : in unsigned(63 downto 0);
        constant b_val    : in unsigned(63 downto 0);
        constant c_in_val : in std_logic;
        signal a          : out std_logic_vector(63 downto 0);
        signal b          : out std_logic_vector(63 downto 0);
        signal c_in       : out std_logic;
        signal sum_ks     : in std_logic_vector(63 downto 0);
        signal c_out_ks   : in std_logic;
        signal sum_rca    : in std_logic_vector(63 downto 0);
        signal c_out_rca  : in std_logic
    ) is
        variable expected_sum   : unsigned(63 downto 0);
        variable expected_cout  : std_logic;
        variable result_val     : unsigned(64 downto 0);
    begin
        clear_inputs(a, b, c_in);
        -- Set inputs
        a <= std_logic_vector(a_val);
        b <= std_logic_vector(b_val);
        c_in <= c_in_val;
        
        -- Wait for signals to propagate through both adders
        wait for 150 ns;
        
        -- Calculate expected result
        if c_in_val = '1' then
            result_val := ('0' & a_val) + ('0' & b_val) + 1;
        else
            result_val := ('0' & a_val) + ('0' & b_val);
        end if;
        
        expected_cout := result_val(64);
        expected_sum := result_val(63 downto 0);
        
        assert sum_ks = std_logic_vector(expected_sum)
            severity error;
            
        assert c_out_ks = expected_cout
            severity error;
        
        assert sum_rca = std_logic_vector(expected_sum)
            severity error;
            
        assert c_out_rca = expected_cout
            severity error;
            
        assert sum_ks = sum_rca
            severity error;
            
        assert c_out_ks = c_out_rca
            severity error;
               
    end procedure;

begin
    -- Instantiate the Kogge-Stone PPA
    KS_PPA: koggestone_ppa
        port map (
            a     => a_tb,
            b     => b_tb,
            c_in  => c_in_tb,
            sum   => sum_ks_tb,
            c_out => c_out_ks_tb
        );
        
    
    -- Instantiate the Ripple Carry Adder
    RCA_INST: rca
        port map (
            a     => a_tb,
            b     => b_tb,
            c_in  => c_in_tb,
            sum   => sum_rca_tb,
            c_out => c_out_rca_tb
        );
    
    -- Stimulus process tests both adders with identical inputs
    stimulus: process
    begin
        -- 0 + 0 + 1
        --check_both_adders(to_unsigned(0, BIT_WIDTH), to_unsigned(0, BIT_WIDTH), '1',  a_tb, b_tb, c_in_tb, sum_ks_tb, c_out_ks_tb, sum_rca_tb, c_out_rca_tb);
                        
        -- 0xF + 0xF = 0x10 (4-bit carry chain)
        --check_both_adders(to_unsigned(15, BIT_WIDTH), to_unsigned(15, BIT_WIDTH), '0', a_tb, b_tb, c_in_tb, sum_ks_tb, c_out_ks_tb, sum_rca_tb, c_out_rca_tb);
                        
        -- 8 + 7 + 1 = 0x10 (4-bit carry chain with carry-in)
        --check_both_adders(to_unsigned(8, BIT_WIDTH), to_unsigned(7, BIT_WIDTH), '1',  a_tb, b_tb, c_in_tb, sum_ks_tb, c_out_ks_tb, sum_rca_tb, c_out_rca_tb);
        
        -- 0xFF + 0x01 = 0x100 (8-bit carry chain)
        check_both_adders(to_unsigned(255, BIT_WIDTH), to_unsigned(1, BIT_WIDTH), '0', a_tb, b_tb, c_in_tb, sum_ks_tb, c_out_ks_tb, sum_rca_tb, c_out_rca_tb);
                        
        -- 0xFFFF + 0x01 = 0x10000 (16-bit carry chain)
        check_both_adders(to_unsigned(65535, BIT_WIDTH), to_unsigned(0, BIT_WIDTH), '1', a_tb, b_tb, c_in_tb, sum_ks_tb, c_out_ks_tb, sum_rca_tb, c_out_rca_tb);
                        
        -- 32-bit carry chain
        check_both_adders(x"00000000FFFFFFFF", to_unsigned(1, BIT_WIDTH), '0',a_tb, b_tb, c_in_tb, sum_ks_tb, c_out_ks_tb, sum_rca_tb, c_out_rca_tb);
                        
        -- 48-bit carry chain
        --check_both_adders(x"0000FFFFFFFFFFFF", x"0000000000000001", '0', a_tb, b_tb, c_in_tb, sum_ks_tb, c_out_ks_tb, sum_rca_tb, c_out_rca_tb);
                        
        -- 64-bit carry chain
        check_both_adders(x"FFFFFFFFFFFFFFFF", to_unsigned(0, BIT_WIDTH), '1', a_tb, b_tb, c_in_tb, sum_ks_tb, c_out_ks_tb, sum_rca_tb, c_out_rca_tb);

        wait;
    end process;

end architecture Behavioral;