----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:14:14 01/26/2018 
-- Design Name: 
-- Module Name:    contador_auxiliar - Behavioral 
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

entity contador_auxiliar is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           pantalla : out  STD_LOGIC);
end contador_auxiliar;

architecture Behavioral of contador_auxiliar is
signal count, p_count: unsigned(2 downto 0);
begin


sinc:process(clk, reset)
begin
	if (reset = '1') then
		count <= (others => '0');
	elsif(rising_edge(clk)) then
		count <= p_count;
	end if;
end process;


comb:process(count, enable)
begin
	if (enable = '1') then
		if (count = 4) then
		p_count <= (others => '0');
		pantalla <= '1';
		else 
		p_count <= count + 1;
		pantalla <= '0';	
		end if;
	else
		p_count <= count;
		pantalla <= '0';
	end if;
end process;

end Behavioral;
