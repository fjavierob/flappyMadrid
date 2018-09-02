----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:32:26 11/16/2017 
-- Design Name: 
-- Module Name:    contador2 - Behavioral 
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

entity contador2 is
	 Generic (Nbit: INTEGER := 8);
    Port ( enable : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  resets : in  STD_LOGIC;
			  color : out STD_LOGIC;
			  data : out  STD_LOGIC_VECTOR (Nbit-1 downto 0));
end contador2;

architecture Behavioral of contador2 is

signal count, p_count: unsigned(Nbit-1 downto 0);
signal p_color, c_color : STD_LOGIC;
--signal p_pantallas, pantallas : unsigned(2 downto 0);

begin

data <= std_logic_vector(count);
color <= c_color;

sinc:process(clk, reset)
begin
	if (reset = '1') then
		count <= (others => '0');
		c_color <= '0';
		--pantallas <= (others=>'0');
	elsif(rising_edge(clk)) then
		count <= p_count;
		c_color <= p_color;
		--pantallas <= p_pantallas;
	end if;
end process;

--comb:process(count, resets, enable, c_color, pantallas)
comb:process(count, resets, enable, c_color)
begin

	--if (enable = '1') then
	--p_pantallas <= pantallas + 1;
	--else
	--p_pantallas <= pantallas;
	--end if;
	
	if (resets = '1') then
		p_count <= (others => '0');
		p_color <= not c_color;
		--p_pantallas <= (others => '0');
	--elsif (pantallas = 3) then
	elsif (enable = '1') then
		p_count <= count + 1;
		p_color <= c_color;
		--p_pantallas <= (others => '0');
	else
	   p_count <= count;
		p_color <= c_color;
		--p_pantallas <= pantallas;
		end if;
end process;


end Behavioral;

