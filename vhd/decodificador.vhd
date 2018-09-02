----------------------------------------------------------------------------------
-- Company: ESCUELA TECNICA SUPERIOR DE INGENIERIA - MASTER INGENIERIA DE TELECOMUNICACIONES
-- Engineer: FRANCISCO JOSE DIAZ, FRANCISCO JAVIER ORTIZ, ALBERTO FUENTES
-- 
-- Create Date:    12/01/2018
-- Project Name: FLAPPY BIRD

-- Module Name:    decodificador - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decodificador is
    Port ( siete_seg : out STD_LOGIC_VECTOR (6 downto 0);
           binario : in  STD_LOGIC_VECTOR (3 downto 0));
end decodificador;

architecture Behavioral of decodificador is

begin

decod : process (binario)
begin
	case binario is
		when "0000" => 
			siete_seg <= "0000001";
		when "0001" => 
			siete_seg <= "1001111";
		when "0010" => 
			siete_seg <= "0010010";
		when "0011" => 
			siete_seg <= "0000110";
		when "0100" => 
			siete_seg <= "1001100";
		when "0101" => 
			siete_seg <= "0100100";
		when "0110" => 
			siete_seg <= "0100000";
		when "0111" => 
			siete_seg <= "0001111";
		when "1000" => 
			siete_seg <= "0000000";
		when "1001" => 
			siete_seg <= "0000100";
		when others =>
			siete_seg <= "1111111";
	end case;
end process;

end Behavioral;

