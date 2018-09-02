----------------------------------------------------------------------------------
-- Company: ESCUELA TECNICA SUPERIOR DE INGENIERIA - MASTER INGENIERIA DE TELECOMUNICACIONES
-- Engineer: FRANCISCO JOSE DIAZ, FRANCISCO JAVIER ORTIZ, ALBERTO FUENTES
-- 
-- Create Date:    12/01/2018
-- Project Name: FLAPPY BIRD

-- Module Name:    gestor - Behavioral 
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

entity gestor is

	 Generic ( COORDENADA_BIRD : unsigned (9 downto 0) := to_unsigned(100, 10);
				  COLOR_FONDO : STD_LOGIC_VECTOR (7 downto 0) := "01110111"; -- blanco de fondo
				  R_FONDO : STD_LOGIC_VECTOR (2 downto 0) := "011";
				  G_FONDO : STD_LOGIC_VECTOR (2 downto 0) := "101";
				  B_FONDO : STD_LOGIC_VECTOR (1 downto 0) := "11";
				  R_FONDO_BIRD : STD_LOGIC_VECTOR (2 downto 0) := "000";
				  G_FONDO_BIRD : STD_LOGIC_VECTOR (2 downto 0) := "000";
				  B_FONDO_BIRD : STD_LOGIC_VECTOR (1 downto 0) := "00";
				  VAL_SAT_CONT:integer:=20000;
				  ANCHO_CONTADOR:integer:=20);
				  
    Port ( clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  
			  boton : in STD_LOGIC;
			  
			  R : out  STD_LOGIC_VECTOR (2 downto 0);
           G : out  STD_LOGIC_VECTOR (2 downto 0);
           B : out  STD_LOGIC_VECTOR (1 downto 0);
			  
           enable : out  STD_LOGIC;
			  
			  resetJuego : out STD_LOGIC;
			  
			  Rbird : in STD_LOGIC_VECTOR (2 downto 0);
			  Gbird : in STD_LOGIC_VECTOR (2 downto 0);
			  Bbird : in STD_LOGIC_VECTOR (1 downto 0);
			  
			  muertoBird : in STD_LOGIC;
			  
			  Rcolumna1 : in STD_LOGIC_VECTOR (2 downto 0);
			  Gcolumna1 : in STD_LOGIC_VECTOR (2 downto 0);
			  Bcolumna1 : in STD_LOGIC_VECTOR (1 downto 0);
			  
			  Rcolumna2 : in STD_LOGIC_VECTOR (2 downto 0);
			  Gcolumna2 : in STD_LOGIC_VECTOR (2 downto 0);
			  Bcolumna2 : in STD_LOGIC_VECTOR (1 downto 0);
			  
			  Rcolumna3 : in STD_LOGIC_VECTOR (2 downto 0);
			  Gcolumna3 : in STD_LOGIC_VECTOR (2 downto 0);
			  Bcolumna3 : in STD_LOGIC_VECTOR (1 downto 0);
			  
           pasandoColumna1 : in  STD_LOGIC;
			  pasandoColumna2 : in  STD_LOGIC;
			  pasandoColumna3 : in  STD_LOGIC;
			  
			  cuentaColumna : out STD_LOGIC);
			  
end gestor;

architecture Behavioral of gestor is
type estado is (esperaInicioPartida, enPartida, enPartidaPasandoColumna, pajaroMuertoBotonPulsado, pajaroMuerto, esperaBoton);
signal estado_actual, nuevo_estado : estado := esperaInicioPartida;
signal colorPajaroDistintoFondo, colorColumnaDistintoFondo1, colorColumnaDistintoFondo2, colorColumnaDistintoFondo3, pajaroChocaConColumna : STD_LOGIC;
signal pasandoColumna : STD_LOGIC;

begin

pasandoColumna <= pasandoColumna1 or pasandoColumna2 or pasandoColumna3;

sinc : process (reset, clk) 
begin
	if (reset = '1') then
		estado_actual <= esperaInicioPartida;
	elsif (rising_edge(clk)) then
		estado_actual <= nuevo_estado;
	end if;
end process;

comb : process (muertoBird, Rbird, Gbird, Bbird, Rcolumna1, Gcolumna1, Bcolumna1, Rcolumna2, Gcolumna2, Bcolumna2, Rcolumna3, Gcolumna3, Bcolumna3, pasandoColumna, estado_actual, boton)
begin

if (Rbird /= R_FONDO_BIRD or Gbird /= G_FONDO_BIRD or Bbird /= B_FONDO_BIRD) then
	colorPajaroDistintoFondo <= '1';
else
	colorPajaroDistintoFondo <= '0';
end if;

if (Rcolumna1 /= R_FONDO or Gcolumna1 /= G_FONDO or Bcolumna1 /= B_FONDO) then
	colorColumnaDistintoFondo1 <= '1';
else
	colorColumnaDistintoFondo1 <= '0';
end if;

if (Rcolumna2 /= R_FONDO or Gcolumna2 /= G_FONDO or Bcolumna2 /= B_FONDO) then
	colorColumnaDistintoFondo2 <= '1';
else
	colorColumnaDistintoFondo2 <= '0';
end if;

if (Rcolumna3 /= R_FONDO or Gcolumna3 /= G_FONDO or Bcolumna3 /= B_FONDO) then
	colorColumnaDistintoFondo3 <= '1';
else
	colorColumnaDistintoFondo3 <= '0';
end if;

-- colorPajaroDistintoFondo <= ((Rbird /= R_FONDO) or (Gbird /= G_FONDO) or (Bbird /= B_FONDO));
-- colorColumnaDistintoFondo <= (Rcolumna /= R_FONDO and Gcolumna /= G_FONDO and Bcolumna /= B_FONDO);

pajaroChocaConColumna <= colorPajaroDistintoFondo and (colorColumnaDistintoFondo1 or colorColumnaDistintoFondo2 or colorColumnaDistintoFondo3);
--pajaroChocaConColumna <= '0';
if (colorPajaroDistintoFondo = '1') then
	R <= Rbird;
	G <= Gbird;
	B <= Bbird;
elsif (colorColumnaDistintoFondo1 = '1') then
	R <= Rcolumna1;
	G <= Gcolumna1;
	B <= Bcolumna1;
elsif (colorColumnaDistintoFondo2 = '1') then
	R <= Rcolumna2;
	G <= Gcolumna2;
	B <= Bcolumna2;
else
	R <= Rcolumna3;
	G <= Gcolumna3;
	B <= Bcolumna3;
end if;

nuevo_estado <= estado_actual;

cuentaColumna <= '0';

resetJuego <= '0';

enable <= '0';

case estado_actual is

	when esperaInicioPartida =>
		if (boton = '1') then
			nuevo_estado <= enPartida;
		end if;
		
	when enPartida =>
		if (muertoBird = '1' or pajaroChocaConColumna = '1') then
			if (boton = '1') then
				nuevo_estado <= pajaroMuertoBotonPulsado;
			else
				nuevo_estado <= pajaroMuerto;
			end if;
		else
			enable <= '1';
			if (pasandoColumna = '1') then
				nuevo_estado <= enPartidaPasandoColumna;
			end if;
		end if;
		
	when enPartidaPasandoColumna =>
		if (muertoBird = '1' or pajaroChocaConColumna = '1') then
			if (boton = '1') then
				nuevo_estado <= pajaroMuertoBotonPulsado;
			else
				nuevo_estado <= pajaroMuerto;
			end if;
		else
			enable <= '1';
			if (pasandoColumna = '0') then
				cuentaColumna <= '1';
				nuevo_estado <= enPartida;
			end if;
		end if;
		
	when pajaroMuertoBotonPulsado =>
		if (boton = '0') then
			nuevo_estado <= pajaroMuerto;
		end if;
		
	when pajaroMuerto =>
		if (boton = '1') then
			nuevo_estado <= esperaBoton;
		end if;
		
	when esperaBoton =>
		if (boton = '0') then
			nuevo_estado <= esperaInicioPartida;
		end if;
		
end case;
			
end process;

end Behavioral;

