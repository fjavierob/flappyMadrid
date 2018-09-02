----------------------------------------------------------------------------------
-- Company: ESCUELA TECNICA SUPERIOR DE INGENIERIA - MASTER INGENIERIA DE TELECOMUNICACIONES
-- Engineer: FRANCISCO JOSE DIAZ, FRANCISCO JAVIER ORTIZ, ALBERTO FUENTES
-- 
-- Create Date:    12/01/2018
-- Project Name: FLAPPY BIRD

-- Module Name:    bird - Behavioral 
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

entity bird is
		Generic (gravedad: integer := 1;
					posx: integer := 100);
    Port ( eje_x : in  STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (9 downto 0);
			  O3 : in STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           boton : in  STD_LOGIC;
			  enable : in STD_LOGIC;
			  pajaroMuerto : out STD_LOGIC;
			  data : in  STD_LOGIC_VECTOR (2 downto 0);
			  enable_memo : in STD_LOGIC;
           direcc : out  STD_LOGIC_VECTOR (9 downto 0);
           red : out  STD_LOGIC_VECTOR (2 downto 0);
           green : out  STD_LOGIC_VECTOR (2 downto 0);
           blue : out  STD_LOGIC_VECTOR (1 downto 0));
end bird;

architecture Behavioral of bird is

-- --------------------------- --
-- SEÑALES INTERNAS AUXILIARES --
-- --------------------------- --

type estado is (reposo_abs, reposo, actualizar_arriba, esperar_boton, actualizar_posy, actualizar_posy_go, actualizar_vely, actualizar_vely_go, pajarosuelo, gameover);
signal estado_actual: estado;
signal estado_nuevo : estado;

type estado_b is (reposo_b, pulsado_b, espera_b);
signal estado_actual_b : estado_b;
signal estado_nuevo_b : estado_b;

signal posy, p_posy : unsigned (9 downto 0);
Signal vely, p_vely : unsigned (7 downto 0);
signal arriba, p_arriba : STD_LOGIC;
signal botonpulsado : STD_LOGIC;

signal dir, p_dir : unsigned (9 downto 0);

-- FIN SEÑALES INTERNAS --

begin


direcc <= std_logic_vector(dir); 
	
-- -------- --
-- PROCESOS --
-- -------- --

sinc : process (clk, reset)
begin
if (reset = '1') then
		estado_actual <= reposo_abs;
		estado_actual_b <= reposo_b;
		posy <= "0011001000";
		vely <= (others => '0');
		arriba <= '0';
		dir <= (others => '0');
		
	elsif(rising_edge(clk)) then
		estado_actual <= estado_nuevo;
		estado_actual_b <= estado_nuevo_b;
		posy <= p_posy;
		vely <= p_vely;
		arriba <= p_arriba;
		dir <= p_dir;
	end if;
end process;

auxil : process (estado_actual_b, boton)
begin

case estado_actual_b is

	when reposo_b =>
		botonpulsado <= '0';
		if (boton = '1') then
			estado_nuevo_b <= pulsado_b;
		else
			estado_nuevo_b <= reposo_b;
		end if;
		
	when pulsado_b =>
		botonpulsado <= '1';
		estado_nuevo_b <= espera_b;
		
	when espera_b =>
		botonpulsado <= '0';
		if (boton = '0') then
			estado_nuevo_b <= reposo_b;
		else
			estado_nuevo_b <= espera_b;
		end if;
	
end case;
end process;

comb : process (estado_actual, O3, botonpulsado, posy, vely, arriba, enable)
begin

case estado_actual is

	when reposo_abs =>
		p_posy <= posy;
		p_vely <= vely;
		p_arriba <= arriba;
		pajaroMuerto <= '0';
			if (enable = '1') then
				estado_nuevo <= actualizar_arriba;
			else
				estado_nuevo <= reposo_abs;
			end if;

	when reposo =>
		p_posy <= posy;
		p_vely <= vely;
		p_arriba <= arriba;
		pajaroMuerto <= '0';
			if (O3 = '1') then
				if (posy = "0110111111") then
				estado_nuevo <= pajarosuelo;
				else
				estado_nuevo <= actualizar_posy;
				end if;
			elsif (botonpulsado = '1') then
				estado_nuevo <= actualizar_arriba;
			else
				estado_nuevo <= reposo;
			end if;
			
	when gameover =>
		p_posy <= posy;
		p_vely <= vely;
		p_arriba <= arriba;
		pajaroMuerto <= '1';
			if (O3 = '1') then
				if (posy = "0110001110") then -- POSICION 394 -- 420-32+11
				estado_nuevo <= pajarosuelo;
				else
				estado_nuevo <= actualizar_posy_go;
				end if;
			else
				estado_nuevo <= gameover;
			end if;
			
	when actualizar_arriba =>
		pajaroMuerto <= '0';
		p_arriba <= '1';
		p_vely <= "00001111"; --Velocidad 20
		p_posy <= posy;
		estado_nuevo <= esperar_boton;
		
		
	when esperar_boton =>
		pajaroMuerto <= '0';
		p_posy <= posy;
		p_vely <= vely;
		p_arriba <= arriba;
		estado_nuevo <= reposo;
			
	when actualizar_posy =>
		pajaroMuerto <= '0';
		p_vely <= vely;
		p_arriba <= arriba;
      estado_nuevo <= actualizar_vely;
			if (arriba = '1' and posy > vely) then
				p_posy <= posy - vely;
			elsif (arriba = '1' and posy < vely) then
				p_posy <= "0000000000"; --0
				estado_nuevo <= actualizar_vely;
			elsif (arriba = '0' and posy+32 >= 479) then  --creo que nunca entrara aqui, else cambiarlo.
			p_posy <= "0110111111"; --479-32
			else
				p_posy <= posy + vely;
			end if;
			
		when actualizar_posy_go =>
		pajaroMuerto <= '1';
		p_vely <= vely;
		p_arriba <= arriba;
      estado_nuevo <= actualizar_vely_go;
			if (posy+32 >= 394) then
			p_posy <= "0110001110"; --479-32+11
			else
				p_posy <= posy + vely;
			end if;

			
	when actualizar_vely =>
	pajaroMuerto <= '0';
		p_posy <= posy;
			
			if (enable = '0') then
				p_vely <= (others => '0');
				p_arriba <= '0';
				estado_nuevo <= gameover;
			elsif (arriba = '1' and vely > gravedad) then
				p_vely <= vely - gravedad;
				p_arriba <= arriba;
				estado_nuevo <= reposo;
			else
				p_vely <= vely + gravedad;
				p_arriba <= '0';
				estado_nuevo <= reposo;
			end if;
			
	 when actualizar_vely_go =>
		pajaroMuerto <= '1';
		p_posy <= posy;
		estado_nuevo <= gameover;
		p_vely <= vely + gravedad;
		p_arriba <= '0';

			
	when pajarosuelo =>
		pajaroMuerto <= '1';
		p_vely <= vely;
		p_arriba <= arriba;
		p_posy <= posy;
		estado_nuevo <= pajarosuelo;
			
end case;
end process;

dib : process (eje_x, eje_y, posy, dir, data, enable_memo)
begin
	if ((unsigned(eje_x) >= posx) and (unsigned(eje_x) < posx+32) and (unsigned(eje_y) >= posy) and (unsigned(eje_y) < posy+32)) then		
		red(0) <= data(2);
		red(1) <= data(2);
		red(2) <= data(2);
		green(0) <= data(1);
		green(1) <= data(1);
		green(2) <= data(1);
		blue(0) <= data(0);
		blue(1) <= data(0);
		
	if(enable_memo = '1') then
	
	if (dir = 1023) then
	p_dir <= (others => '0');
	else
	p_dir <= dir + 1;
	end if;
	
	else
	p_dir <= dir;
	end if;
	
	else
		p_dir <= dir;
		red <= "000"; --fondo negro
		green <= "000";
		blue <= "00";
	end if;
	
end process;


end Behavioral;

