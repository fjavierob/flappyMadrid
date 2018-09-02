----------------------------------------------------------------------------------
-- Company: ESCUELA TECNICA SUPERIOR DE INGENIERIA - MASTER INGENIERIA DE TELECOMUNICACIONES
-- Engineer: FRANCISCO JOSE DIAZ, FRANCISCO JAVIER ORTIZ, ALBERTO FUENTES
-- 
-- Create Date:    12/01/2018
-- Project Name: FLAPPY BIRD

-- Module Name:    contador - Behavioral  
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

-- Uncomment the following library declaration if usin
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity contador is
	Generic (Nbit: INTEGER := 8);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  resets : in  STD_LOGIC;
			  enable: in STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (Nbit-1 downto 0));
end contador;

architecture Behavioral of contador is
signal count, p_count: unsigned(Nbit-1 downto 0); --se crea count porque la necesitaremos leer, posteriormente se asignara a cuenta como salida
begin

Q <= std_logic_vector(count);

sinc:process(clk, reset)
begin
	if (reset = '1') then
		count <= (others => '0');
	elsif(rising_edge(clk)) then
		count <= p_count;
	end if;
end process;


comb:process(count, resets, enable)
begin
	p_count <= count;
	if (resets = '1') then
		p_count <= (others => '0');
	elsif (enable = '1') then
		p_count <= count +1;
		end if;
end process;

end Behavioral;