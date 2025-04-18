-----------------------------------------------------------------
-- Title: Half Adder with simulated propagation delays
-----------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity half_adder is
  port (
    x : in    std_logic;
    y : in    std_logic;
    g : out   std_logic;
    p : out   std_logic
  );
end entity half_adder;

architecture behavioral of half_adder is

begin

  g <= x and y after 1 ns;
  p <= x xor y after 1 ns;

end architecture behavioral;
