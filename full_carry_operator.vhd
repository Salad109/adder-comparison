-----------------------------------------------------------------
-- Title: Full Carry Operator with simulated propagation delays
-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_carry_operator is
	Port(
		gh : in std_logic;
		ph : in std_logic;
		gl : in std_logic;
		pl : in std_logic;
		go : out std_logic;
		po : out std_logic
	);
end full_carry_operator;

architecture Behavioral of full_carry_operator is
begin
	go <= gh or (gl and ph) after 2 ns;
	po <= pl and ph after 1 ns;
end architecture Behavioral;	
