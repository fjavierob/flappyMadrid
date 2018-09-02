----------------------------------------------------------------------------------
-- Company: ESCUELA TECNICA SUPERIOR DE INGENIERIA - MASTER INGENIERIA DE TELECOMUNICACIONES
-- Engineer: FRANCISCO JOSE DIAZ, FRANCISCO JAVIER ORTIZ, ALBERTO FUENTES
-- 
-- Create Date:    12/01/2018
-- Project Name: FLAPPY BIRD
 
-- Module Name:    div_frec - Behavioral 
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

entity div_frec is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  rand : out STD_LOGIC_VECTOR (3 downto 0);
			  sat : out STD_LOGIC);
end div_frec;

architecture Behavioral of div_frec is
signal count, p_count: unsigned(13 downto 0);

begin

rand <= std_logic_vector(p_count(3 downto 0));

sinc: process(clk, reset)
begin
	if (reset = '1') then
		count <= (others => '0');
	elsif (rising_edge(clk)) then
		count <= p_count;
	end if;
end process;

comb: process(count)
begin
	-- 2^13 - 1 = 16383
	if (count = 16383) then
		p_count <= (others => '0');
		sat <= '1';
	else
		p_count <= count + 1;
		-- Mantener a 0 para no latch !!
		sat <= '0';
	end if;

end process;

end Behavioral;

