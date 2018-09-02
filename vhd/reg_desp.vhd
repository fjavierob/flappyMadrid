----------------------------------------------------------------------------------
-- Company: ESCUELA TECNICA SUPERIOR DE INGENIERIA - MASTER INGENIERIA DE TELECOMUNICACIONES
-- Engineer: FRANCISCO JOSE DIAZ, FRANCISCO JAVIER ORTIZ, ALBERTO FUENTES
-- 
-- Create Date:    12/01/2018
-- Project Name: FLAPPY BIRD

-- Module Name:    reg_desp - Behavioral 
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

entity reg_desp is
Port ( clk : in STD_LOGIC;
		 reset : in STD_LOGIC;
		 enable : in STD_LOGIC;
		 display_enable : out STD_LOGIC_VECTOR (3 downto 0));
end reg_desp;

architecture Behavioral of reg_desp is

signal display_enable_aux, p_display_enable_aux: STD_LOGIC_VECTOR (3 downto 0) := "1110";

begin

display_enable <= display_enable_aux;

comb: process (enable, display_enable_aux)
begin
	p_display_enable_aux <= display_enable_aux;
	if (enable = '1') then
		p_display_enable_aux(3 downto 1) <= display_enable_aux(2 downto 0);
		p_display_enable_aux(0) <= display_enable_aux(3);
	end if;
end process;

sinc: process (reset, clk)
begin
	if (reset = '1') then
		display_enable_aux <= "1110";
	elsif (rising_edge(clk)) then
		display_enable_aux <= p_display_enable_aux;
	end if;
end process;
	
end Behavioral;

