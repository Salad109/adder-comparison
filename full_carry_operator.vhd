-----------------------------------------------------------------
-- Title: Full Carry Operator with simulated propagation delays
-----------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity full_carry_operator is
  port (
    gh : in    std_logic;
    ph : in    std_logic;
    gl : in    std_logic;
    pl : in    std_logic;
    go : out   std_logic;
    po : out   std_logic
  );
end entity full_carry_operator;

architecture behavioral of full_carry_operator is

begin

  go <= gh or (gl and ph) after 2 ns;
  po <= pl and ph after 1 ns;

end architecture behavioral;
