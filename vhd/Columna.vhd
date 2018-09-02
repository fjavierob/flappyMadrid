----------------------------------------------------------------------------------
-- Company: ESCUELA TECNICA SUPERIOR DE INGENIERIA - MASTER INGENIERIA DE TELECOMUNICACIONES
-- Engineer: FRANCISCO JOSE DIAZ, FRANCISCO JAVIER ORTIZ, ALBERTO FUENTES
-- 
-- Create Date:    12/01/2018
-- Project Name: FLAPPY BIRD

-- Module Name:    Columna - Behavioral  
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

entity Columna is

	 Generic (coordenada_pajaro : unsigned(9 downto 0) := to_unsigned(100,10);
				retardo : integer := 642;
				retardoinicio : integer := 642);
					
    Port ( 
			  clk : in   STD_LOGIC;
			  reset : in   STD_LOGIC;
			  eje_x : in STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in STD_LOGIC_VECTOR (9 downto 0);
			  newpantalla : in STD_LOGIC;
			  enable : in STD_LOGIC;
			  data_posy : in  STD_LOGIC_VECTOR (9 downto 0);
			  data_hueco : in  STD_LOGIC_VECTOR (9 downto 0);
           pide_datos : out  STD_LOGIC;
           RED : out  STD_LOGIC_VECTOR (2 downto 0);
           GRN : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE : out  STD_LOGIC_VECTOR (1 downto 0);
			  pasandocolumna : out STD_LOGIC);
end Columna;

architecture Behavioral of Columna is

type estado is (reposo,pintacolMovPrimera,pintacolmov,pintacolfija);
signal estado_actual: estado;
signal estado_nuevo: estado;


--signal posx, p_posx : unsigned (9 downto 0);
--Signal velx, p_velx : unsigned (7 downto 0);


signal gap : unsigned(9 downto 0) := to_unsigned(640,10);
signal p_gap : unsigned(9 downto 0) := to_unsigned(640,10);

signal posy, hueco, p_posy, p_hueco : std_logic_vector(9 downto 0);

begin


sinc: process(clk, reset)
begin

if(reset = '1') then
	gap <= to_unsigned(retardoinicio,10);
	estado_actual <= reposo;
	posy <= std_logic_vector(to_unsigned(100,10));
	hueco <= std_logic_vector(to_unsigned(200,10));

elsif(rising_edge(clk)) then 
	posy <= p_posy;
	hueco <= p_hueco;
	gap <= p_gap;
	estado_actual <= estado_nuevo;
end if;
end process;


dibuja: process(estado_actual, gap, newpantalla, enable, data_posy, data_hueco, posy, hueco)
begin

pide_datos <= '0';
pasandocolumna <= '0';
p_gap <= gap;

if (newpantalla = '1') then
	if (gap = 641) then
		pide_datos <= '1';
	end if;
end if;

if (gap = 640) then
	p_posy <= data_posy;
	p_hueco <= data_hueco;
else
	p_posy <= posy;
	p_hueco <= hueco;
end if;

case estado_actual is

	when reposo =>
		p_gap <= to_unsigned(retardoinicio,10);
		pasandocolumna <= '0';
			if (enable = '1') then
				estado_nuevo <= pintacolMovPrimera;
			else
				estado_nuevo <= reposo;
			end if;
		
		when pintacolMovPrimera =>
	
		if((gap <= 100) and (gap + 63 >= 131)) then
			pasandocolumna <= '1';
		else
			pasandocolumna <= '0';
		end if;
		
		if (enable = '1') then
			estado_nuevo <= pintacolMovPrimera;
			if (newpantalla = '1') then
				if (gap = 0) then
					p_gap <= to_unsigned(retardo,10);
					estado_nuevo <= pintacolmov;
				else
					p_gap <= gap - 1;
				end if;
			else
				p_gap <= gap;
			end if;
		else
			estado_nuevo <= pintacolfija;
		end if;	
		
	when pintacolmov =>
	
		--if((gap <= 100) and (gap + 63 >= 131)) then
		if ((gap <= 131) and (gap + 63 >= 100)) then
			pasandocolumna <= '1';
		else
			pasandocolumna <= '0';
		end if;
		
		if (enable = '1') then
			estado_nuevo <= pintacolmov;
			if (newpantalla = '1') then
				if (gap = 0) then
					p_gap <= to_unsigned(retardo,10);
				else
					p_gap <= gap - 1;
				end if;
			else
				p_gap <= gap;
			end if;
		else
			estado_nuevo <= pintacolfija;
		end if;
		
	when pintacolfija =>
		p_gap <= gap;
		estado_nuevo <= pintacolfija;

	end case;
	
end process;


dib : process (eje_x, eje_y, gap, posy, hueco)


begin
	-- linea blanca sobre suelo: 1111 1111
	if (unsigned(eje_y) >= 420 and unsigned(eje_y) < 424) then
		RED <= "111"; 
		GRN <= "111";
		BLUE <= "11";		
	-- suelo verde: 0011 0100
	elsif (unsigned(eje_y) >= 424) then
		RED <= "001"; 
		GRN <= "101";
		BLUE <= "00";
	-- borde horizontal (arriba)
		elsif (((unsigned(eje_x) >= gap) and (unsigned(eje_x) < gap+64)) and ((unsigned(eje_y) >= (unsigned(posy)-1)) and (unsigned(eje_y) <= unsigned(posy)))) then
		RED <= "000"; 
		GRN <= "000";
		BLUE <= "00"; 
	-- borde horizontal (abajo)
		elsif (((unsigned(eje_x) >= gap) and (unsigned(eje_x) < gap+64)) and ((unsigned(eje_y) >= (unsigned(posy)+unsigned(hueco))) and (unsigned(eje_y) <= unsigned(posy)+unsigned(hueco)+1))) then
		RED <= "000"; 
		GRN <= "000";
		BLUE <= "00"; 		
	-- borde vertical negro (izq)
	elsif (((unsigned(eje_x) >= gap) and (unsigned(eje_x) < gap+2)) and ((unsigned(eje_y) >= (unsigned(posy)+unsigned(hueco))) or (unsigned(eje_y) < unsigned(posy)))) then
		RED <= "000"; 
		GRN <= "000";
		BLUE <= "00"; 
	-- color burdeos (izq)
	elsif (((unsigned(eje_x) >= gap+2) and (unsigned(eje_x) < gap+20+2)) and ((unsigned(eje_y) >= (unsigned(posy)+unsigned(hueco))) or (unsigned(eje_y) < unsigned(posy)))) then
		RED <= "100"; 
		GRN <= "001";
		BLUE <= "00"; 
	-- color azul (centro)
	elsif (((unsigned(eje_x) >= gap+20+2) and (unsigned(eje_x) < gap+20+20+2)) and ((unsigned(eje_y) >= (unsigned(posy)+unsigned(hueco))) or (unsigned(eje_y) < unsigned(posy)))) then
		RED <= "000"; 
		GRN <= "001";
		BLUE <= "10";	
	-- color burdeos (dch)
	elsif (((unsigned(eje_x) >= gap+20+20+2) and (unsigned(eje_x) < gap+20+20+20+2)) and ((unsigned(eje_y) >= (unsigned(posy)+unsigned(hueco))) or (unsigned(eje_y) < unsigned(posy)))) then
		RED <= "100"; 
		GRN <= "001";
		BLUE <= "00";
	-- borde vertical negro (dch)
	elsif (((unsigned(eje_x) >= gap+20+20+20+2) and (unsigned(eje_x) < gap+20+20+20+2+2)) and ((unsigned(eje_y) >= (unsigned(posy)+unsigned(hueco))) or (unsigned(eje_y) < unsigned(posy)))) then
		RED <= "000"; 
		GRN <= "000";
		BLUE <= "00"; 
	else
	-- Fondo (azul): 0111 0111
		RED <= "011"; 
		GRN <= "101";
		BLUE <= "11"; 
	end if;
end process;

end Behavioral;
