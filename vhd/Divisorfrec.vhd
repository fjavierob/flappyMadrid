----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:58:18 11/07/2017 
-- Design Name: 
-- Module Name:    Divisorfrec - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Divisorfrec is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           saturado2 : out  STD_LOGIC);
end Divisorfrec;

architecture Behavioral of Divisorfrec is


signal count2, p_count2 : unsigned(13 downto 0);

begin

sinc : process (clk,reset) --Diseño de doble proceso
begin
if (reset = '1') then


count2 <= (others => '0');

elsif (rising_edge(clk)) then


count2 <= p_count2;

end if;
end process;


comb : process(count2)
begin

if (count2 = 16383) then
--if (count2 = 16) then

p_count2 <= (others => '0');
saturado2 <= '1';

else 

p_count2 <= count2 + 1;
saturado2 <= '0';

end if;
end process;
end Behavioral;

