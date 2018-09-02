----------------------------------------------------------------------------------
-- Company: ESCUELA TECNICA SUPERIOR DE INGENIERIA - MASTER INGENIERIA DE TELECOMUNICACIONES
-- Engineer: FRANCISCO JOSE DIAZ, FRANCISCO JAVIER ORTIZ, ALBERTO FUENTES
-- 
-- Create Date:    12/01/2018
-- Project Name: FLAPPY BIRD

-- Module Name:    driver - Behavioral 
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

entity driver is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           HS : out  STD_LOGIC;
           VS : out  STD_LOGIC;
			  eje_x : out STD_LOGIC_VECTOR (9 downto 0);
			  eje_y : out STD_LOGIC_VECTOR (9 downto 0);
			  pantalla : out STD_LOGIC;
			  pantalla_aux : out STD_LOGIC;
			  enable_memo : out STD_LOGIC;
			  RED_IN : in  STD_LOGIC_VECTOR (2 downto 0);
           GRN_IN : in  STD_LOGIC_VECTOR (2 downto 0);
           BLUE_IN : in  STD_LOGIC_VECTOR (1 downto 0);
           RED_OUT : out  STD_LOGIC_VECTOR (2 downto 0);
           GRN_OUT : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE_OUT : out  STD_LOGIC_VECTOR (1 downto 0));
end driver;

architecture Behavioral of driver is

component contador 
	Generic (Nbit: INTEGER := 8);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  resets : in  STD_LOGIC;
			  enable: in STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (Nbit-1 downto 0));
end component;

component contador_auxiliar is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           pantalla : out  STD_LOGIC);
end component;

component comparador
		Generic (Nbit: integer :=8;
					End_Of_Screen: integer :=10;
					Start_Of_Pulse: integer :=20;
					End_Of_Pulse: integer := 30;
					End_Of_Line: integer := 40);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
           O1 : out  STD_LOGIC;
           O2 : out  STD_LOGIC;
           O3 : out  STD_LOGIC);
end component;

signal clk_pixel, p_clk_pixel : STD_LOGIC; --Señales para DIV_FREC
signal blank_h, blank_v: STD_LOGIC;			--Señales para GEN_COLOR

--RESTO DE SE�ALES
signal exit_O3_X : STD_LOGIC;
signal exit_O3_Y : STD_LOGIC;
signal QX,QY : STD_LOGIC_VECTOR (9 downto 0);
signal enable_conty : STD_LOGIC;


begin
--PROCESO DE DIVISION DE FRECUENCIA A 25MHZ
p_clk_pixel <= not clk_pixel;

div_frec: process (clk,reset)
begin

if (reset = '1') then
	clk_pixel <= '0';
elsif (rising_edge(clk)) then
	clk_pixel <= p_clk_pixel;
end if;

end process;
-- FIN PROCESO DIVISION FRECUENCIA

--PROCESO DE GEN_COLOR
gen_color:process (blank_h, blank_v, RED_IN, GRN_IN, BLUE_IN)
begin

if (blank_h = '1' or blank_v = '1') then
	RED_OUT <= (others => '0');
	GRN_OUT <= (others => '0');
	BLUE_OUT <= (others => '0');
else
	RED_OUT <= RED_IN;
	GRN_OUT <= GRN_IN;
	BLUE_OUT <= BLUE_IN;
end if;
end process;
-- FIN PROCESO DE GEN_COLOR

--INSTANCIAS DE CONTADORES, COMPARADORES Y EL DIBUJA
conth: contador
	GENERIC MAP (Nbit=>10)
	PORT MAP (
		clk => clk,
		reset => reset,
		enable => clk_pixel,
		resets => exit_O3_X,
		Q => QX );
		
contv: contador
	GENERIC MAP (Nbit=>10)
	PORT MAP (
		clk => clk,
		reset => reset,
		enable => enable_conty,
		resets => exit_O3_Y,
		Q => QY );
		
contaux: contador_auxiliar
	PORT MAP (
		clk => clk,
		reset => reset,
		enable => exit_O3_Y,
		pantalla => pantalla_aux);

		
comph: comparador
	GENERIC MAP (Nbit=>10, End_Of_Screen =>639, Start_Of_Pulse => 655, End_Of_Pulse => 751, End_Of_Line => 799)
	PORT MAP (
		clk => clk,
		reset => reset,
		data => QX,
		O1 => blank_h,
		O2 => HS,
		O3 => exit_O3_X);
		
compv: comparador
	GENERIC MAP (Nbit=>10, End_Of_Screen =>479, Start_Of_Pulse => 489, End_Of_Pulse => 491, End_Of_Line => 520)
	PORT MAP (
		clk => clk,
		reset => reset,
		data => QY,
		O1 => blank_v,
		O2 => VS,
		O3 => exit_O3_Y);
		

-- FIN INSTANCIAS

--ASIGNACIONES
 enable_conty <= clk_pixel AND exit_O3_X;
 pantalla <= exit_O3_Y;
 eje_x <= QX;
 eje_y <= QY;
enable_memo <= clk_pixel;
 


end Behavioral;

