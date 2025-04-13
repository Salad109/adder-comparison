-----------------------------------------------------------------
-- Title: 64-bit Ripple Carry Adder with simulated propagation delays
-----------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity rca is
    Port (
        a      : in  std_logic_vector(63 downto 0);  -- First input vector
        b      : in  std_logic_vector(63 downto 0);  -- Second input vector
        c_in   : in  std_logic;                      -- Carry input
        sum    : out std_logic_vector(63 downto 0);  -- Sum output vector
        c_out  : out std_logic                       -- Carry output
    );
end entity rca;
architecture behavioral of rca is
    signal carries : std_logic_vector(64 downto 0); -- Internal carry
    signal a_xor_b : std_logic_vector(63 downto 0); -- Internal a XOR b
    
begin
    carries(0) <= c_in; -- Initial carry from input
    
    -- Carry chain
    gen_adders: for i in 0 to 63 generate
        a_xor_b(i) <= a(i) xor b(i) after 1 ns;
        sum(i) <= a_xor_b(i) xor carries(i) after 2 ns;
        carries(i+1) <= (a(i) and b(i)) or (a_xor_b(i) and carries(i)) after 2 ns;
    end generate;
    
    c_out <= carries(64); -- Final carry is the output
    
end architecture behavioral;