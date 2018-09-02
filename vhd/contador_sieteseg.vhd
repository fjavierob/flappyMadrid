----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:14:19 11/07/2017 
-- Design Name: 
-- Module Name:    contador_sieteseg - Behavioral 
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

entity contador_sieteseg is
    Port ( enable : in  STD_LOGIC;
			  clk : in  STD_LOGIC;
			  reset : in  STD_LOGIC;
           cuenta : out  STD_LOGIC_VECTOR (3 downto 0);
			  sat : out STD_LOGIC);
end contador_sieteseg;

architecture Behavioral of contador_sieteseg is

signal count, p_count : unsigned (3 downto 0);

begin

cuenta <= std_logic_vector(count);

sinc : process (clk, reset)
begin

if (reset = '1') then

count <= (others => '0');

elsif (rising_edge(clk)) then

count <= p_count;

end if;
end process;

comb : process (count, enable)
begin

if (enable = '1' AND count = 9) then

	p_count <= (others => '0');
	sat <= '1';
	
elsif (enable = '1') then

p_count <= count + 1;
sat <= '0';
	
else

	p_count <= count;
	sat <= '0';

end if;
end process;
end Behavioral;

