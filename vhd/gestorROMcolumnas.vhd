----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:22:16 01/29/2018 
-- Design Name: 
-- Module Name:    gestorROMcolumnas - Behavioral 
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

entity gestorROMcolumnas is
    Port ( 
			  clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  rand: in STD_LOGIC_VECTOR (3 downto 0);
			  data_posy : in  STD_LOGIC_VECTOR (9 downto 0);
           data_hueco : in  STD_LOGIC_VECTOR (9 downto 0);
           dir_posy : out  STD_LOGIC_VECTOR (3 downto 0);
           dir_hueco : out  STD_LOGIC_VECTOR (3 downto 0);
           pide: in  STD_LOGIC;
           da_hueco : out  STD_LOGIC_VECTOR (9 downto 0);
           da_posy : out  STD_LOGIC_VECTOR (9 downto 0));
end gestorROMcolumnas;

architecture Behavioral of gestorROMcolumnas is

type estado is (reposo, espera, dar_datos);

signal estado_actual, nuevo_estado : estado;
signal dir, p_dir : unsigned (3 downto 0);
signal aux_da_posy, aux_da_hueco, p_da_posy, p_da_hueco : STD_LOGIC_VECTOR (9 downto 0);

begin

dir_posy <= std_logic_vector(dir); 
dir_hueco <= std_logic_vector(dir);
da_hueco <= std_logic_vector(aux_da_hueco);
da_posy <= std_logic_vector(aux_da_posy);

sinc : process (reset, clk, rand) 
begin
	if (reset = '1') then
		estado_actual <= reposo;
		dir <= unsigned(rand);
	elsif (rising_edge(clk)) then
		estado_actual <= nuevo_estado;
		dir <= p_dir;
		aux_da_hueco <= p_da_hueco;
		aux_da_posy <= p_da_posy;
	end if;
end process;

comb : process (pide, estado_actual, dir, aux_da_hueco, aux_da_posy, data_hueco, data_posy)
begin

p_dir <= dir;
p_da_hueco <= aux_da_hueco;
p_da_posy <= aux_da_posy;


case estado_actual is

	when reposo =>
		if (pide = '1') then
			nuevo_estado <= dar_datos;
		else
			nuevo_estado <= estado_actual;
		end if;
		
	when dar_datos =>
		p_da_hueco <= data_hueco;
		p_da_posy <= data_posy;
		
		if (dir = 15) then
			p_dir <= (others => '0');
		else
			p_dir <= dir + 1;
		end if;
		
		nuevo_estado <= espera;
	
	when espera =>
		if (pide = '0') then
			nuevo_estado <= reposo;
		else
			nuevo_estado <= espera;
		end if;
		
end case;

end process;

end Behavioral;

