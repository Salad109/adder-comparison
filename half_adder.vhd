-----------------------------------------------------------------
-- Title: Half Adder with simulated propagation delays
-----------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
	Port(
		x : in std_logic;
		y : in std_logic;
		g : out std_logic;
		p : out std_logic
	);
end half_adder;

architecture Behavioral of half_adder is
begin
	g <= x AND y after 1 ns;
	p <= x XOR y after 1 ns;
end Behavioral;
