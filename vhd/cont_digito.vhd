----------------------------------------------------------------------------------
-- Company: ESCUELA TECNICA SUPERIOR DE INGENIERIA - MASTER INGENIERIA DE TELECOMUNICACIONES
-- Engineer: FRANCISCO JOSE DIAZ, FRANCISCO JAVIER ORTIZ, ALBERTO FUENTES
-- 
-- Create Date:    12/01/2018
-- Project Name: FLAPPY BIRD

-- Module Name:    cont_digito - Behavioral  
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

entity cont_digito is
    Port ( clk : in STD_LOGIC;
			  enable : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           cuenta : out  STD_LOGIC_VECTOR (3 downto 0);
			  sat: out STD_LOGIC);
end cont_digito;

architecture Behavioral of cont_digito is
signal count, p_count: unsigned (3 downto 0) := to_unsigned(0,4);
--signal sat_aux, p_sat: STD_LOGIC;

begin
cuenta <= std_logic_vector(count);
--sat <= sat_aux;

sinc: process (clk, reset)
begin
	if (reset = '1') then
		count <= (others => '0');
--		sat_aux <= '0';
	elsif (rising_edge(clk)) then
		count <= p_count;
--		sat_aux <= p_sat;
	end if;
end process;

comb: process (count, reset, enable)
begin
	p_count <= count;
	sat <= '0';
--	p_sat <= sat_aux;
	if (enable = '1') then
		if (count = 9) then
			p_count <= (others => '0');
			sat <= '1';
		--	p_sat <= '1';
		else
			p_count <= count + 1;
		--	p_sat <= '0';
		end if;
	end if;
end process;

end Behavioral;

