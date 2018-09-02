----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:46:47 11/14/2017 
-- Design Name: 
-- Module Name:    dibuja - Behavioral 
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

entity dibuja is
	Generic (Nbit: INTEGER := 8);
    Port ( eje_x : in  STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (9 downto 0);
			  data : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
			  color : in STD_LOGIC;
			  fin : out STD_LOGIC;
           RED : out  STD_LOGIC_VECTOR (2 downto 0);
           GRN : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE : out  STD_LOGIC_VECTOR (1 downto 0));
end dibuja;

architecture Behavioral of dibuja is

signal RED_in, GRN_in : UNSIGNED (2 downto 0);
signal BLUE_in : UNSIGNED (1 downto 0);

begin

RED <=  std_logic_vector(RED_in);
GRN <=  std_logic_vector(GRN_in);
BLUE <=  std_logic_vector(BLUE_in);

dibuja: process(eje_x, eje_y, data, color)
begin

if (color = '0') then
RED_in <="111"; GRN_in <="000"; BLUE_in <="00";
else
RED_in <= "000"; GRN_in <="000"; BLUE_in <= "11";
end if;


if ((unsigned(eje_y)>(120+unsigned(data)) and unsigned (eje_y)<(360-unsigned(data)))and (unsigned(eje_x)>0)) then

if (color = '1') then
RED_in <= "111"; GRN_in <="111"; BLUE_in <= "00";
else
RED_in <= "111"; GRN_in <="111"; BLUE_in <= "11";
end if;

end if;

if ((unsigned(data)+120)>(360-unsigned(data))) then
	fin <= '1';
else
	fin <= '0';
end if;


end process;
end Behavioral;

