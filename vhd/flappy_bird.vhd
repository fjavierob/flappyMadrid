----------------------------------------------------------------------------------
-- Company: ESCUELA TECNICA SUPERIOR DE INGENIERIA - MASTER INGENIERIA DE TELECOMUNICACIONES
-- Engineer: FRANCISCO JOSE DIAZ, FRANCISCO JAVIER ORTIZ, ALBERTO FUENTES
-- 
-- Create Date:    12/01/2018
-- Project Name: FLAPPY BIRD
-- Module Name:    flappy_bird - Behavioral 
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

entity flappy_bird is
    Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           boton : in  STD_LOGIC;
           AN : out  STD_LOGIC_VECTOR (3 downto 0);
           DP : out  STD_LOGIC;
           A : out  STD_LOGIC;
           B : out  STD_LOGIC;
           C : out  STD_LOGIC;
           D : out  STD_LOGIC;
           E : out  STD_LOGIC;
           F : out  STD_LOGIC;
           G : out  STD_LOGIC;
           HS : out  STD_LOGIC;
           VS : out  STD_LOGIC;
           RED : out  STD_LOGIC_VECTOR (2 downto 0);
           GRN : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE : out  STD_LOGIC_VECTOR (1 downto 0));
end flappy_bird;

architecture Behavioral of flappy_bird is

-- ----------------------- --
-- DECLARACION COMPONENTES --
-- ----------------------- --

component control_display is
Port ( clk : in STD_LOGIC;
		 reset : in STD_LOGIC;
		 enable : in STD_LOGIC;
		 rand : out STD_LOGIC_VECTOR (3 downto 0);
		 A : out STD_LOGIC;
		 B : out STD_LOGIC;
		 C : out STD_LOGIC;
		 D : out STD_LOGIC;
		 E : out STD_LOGIC;
		 F : out STD_LOGIC;
		 G : out STD_LOGIC;
		 DP : out STD_LOGIC;
		 AN : out STD_LOGIC_VECTOR (3 downto 0));
end component;

COMPONENT memoria is
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
  );
END COMPONENT;

COMPONENT ROM1ColPosy is
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END COMPONENT;


COMPONENT ROM2ColHueco is
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END COMPONENT;

component gestor is

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
			 
end component;

component driver is
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
end component;

component bird is

		Generic (gravedad: integer := 2;
					posx: integer := 100);
					
    Port ( eje_x : in  STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (9 downto 0);
			  O3 : in STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           boton : in  STD_LOGIC;
			  enable : in STD_LOGIC;
			  enable_memo : in STD_LOGIC;
			  pajaroMuerto : out STD_LOGIC;
			  data : in  STD_LOGIC_VECTOR (2 downto 0);
           direcc : out  STD_LOGIC_VECTOR (9	downto 0);
           red : out  STD_LOGIC_VECTOR (2 downto 0);
           green : out  STD_LOGIC_VECTOR (2 downto 0);
           blue : out  STD_LOGIC_VECTOR (1 downto 0));
end component;

component Columna is

	 Generic (coordenada_pajaro : unsigned(9 downto 0) := to_unsigned(100,10);
				retardo : integer := 641;
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
end component;

component gestorROMcolumnas is
Port ( 
			  clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  rand : in STD_LOGIC_VECTOR (3 downto 0);
			  data_posy : in  STD_LOGIC_VECTOR (9 downto 0);
           data_hueco : in  STD_LOGIC_VECTOR (9 downto 0);
           dir_posy : out  STD_LOGIC_VECTOR (3 downto 0);
           dir_hueco : out  STD_LOGIC_VECTOR (3 downto 0);
           pide: in  STD_LOGIC;
           da_hueco : out  STD_LOGIC_VECTOR (9 downto 0);
           da_posy : out  STD_LOGIC_VECTOR (9 downto 0));
end component;

-- FIN DECLARACIÓN COMPONENTES --

-- --------------------------- --
-- SEÑALES INTERNAS AUXILIARES --
-- --------------------------- --

signal s_rand : STD_LOGIC_VECTOR (3 downto 0);

signal s_eje_x, s_eje_y : STD_LOGIC_VECTOR (9 downto 0);
signal s_O3, s_O3_aux : STD_LOGIC;
signal s_red_bird, s_grn_bird, s_red_driver, s_grn_driver, s_red_col1, s_grn_col1, s_red_col2, s_grn_col2,s_red_col3, s_grn_col3  : STD_LOGIC_VECTOR (2 downto 0);
signal s_blue_bird, s_blue_driver, s_blue_col1, s_blue_col2, s_blue_col3  : STD_LOGIC_VECTOR (1 downto 0);

signal s_pajaromuerto, s_pasandocolumna1, s_pasandocolumna2,s_pasandocolumna3 : STD_LOGIC;
signal s_enable_sseg, s_enable_gestor : STD_LOGIC;
signal s_reset, s_reset_gestor : STD_LOGIC;

signal addra : std_logic_vector (9 downto 0);
signal douta : std_logic_vector (2 downto 0);
signal memo_bird : STD_LOGIC;

signal posydata_aux : STD_LOGIC_VECTOR (9 downto 0);
signal posydir_aux : STD_LOGIC_VECTOR (3 downto 0);

signal huecodata_aux : STD_LOGIC_VECTOR (9 downto 0);
signal huecodir_aux : STD_LOGIC_VECTOR (3 downto 0);

signal s_pide_aux : STD_LOGIC;
signal posy_gestor, hueco_gestor : STD_LOGIC_VECTOR (9 downto 0);

signal s_pide1, s_pide2, s_pide3 : STD_LOGIC;

-- FIN SEÑALES INTERNAS --

begin

s_reset <= s_reset_gestor OR reset;
s_pide_aux <= s_pide1 OR s_pide2 OR s_pide3;

-- ------------------------- --
-- INSTANCIACIÓN COMPONENTES --
-- ------------------------- --

memo : memoria
  PORT MAP (
    clka => clk,
    addra => addra,
    douta => douta
  );

ROMPosy : ROM1ColPosy
 PORT MAP (
				clka => clk,
				addra => posydir_aux,
				douta => posydata_aux
			 );
			 
ROMHueco : ROM2ColHueco
 PORT MAP (
				clka => clk,
				addra => huecodir_aux,
				douta => huecodata_aux
			 );
  
gest : gestor
	PORT MAP (
		clk => clk,
		reset => reset,
		boton => boton,
			  
		R => s_red_driver,
      G => s_grn_driver,
      B => s_blue_driver,
			  
      enable => s_enable_gestor,
			  
		resetJuego => s_reset_gestor,
			  
		Rbird => s_red_bird,
		Gbird => s_grn_bird,
		Bbird => s_blue_bird,
			  
		muertoBird => s_pajaromuerto,
			  
		Rcolumna1 => s_red_col1,
	   Gcolumna1 => s_grn_col1,
		Bcolumna1 => s_blue_col1,
			  
      pasandoColumna1 => s_pasandocolumna1,
		
		Rcolumna2 => s_red_col2,
	   Gcolumna2 => s_grn_col2,
		Bcolumna2 => s_blue_col2,
			  
      pasandoColumna2 => s_pasandocolumna2,
		
		Rcolumna3 => s_red_col3,
	   Gcolumna3 => s_grn_col3,
		Bcolumna3 => s_blue_col3,
			  
      pasandoColumna3 => s_pasandocolumna3,
			  
		cuentaColumna => s_enable_sseg);
		
columna1 : columna
	PORT MAP (
		clk => clk,
		reset => s_reset,
		eje_x => s_eje_x,
      eje_y => s_eje_y,
		newpantalla => s_O3,
		enable => s_enable_gestor,
		data_posy => posy_gestor,
		data_hueco => hueco_gestor,
      pide_datos => s_pide1,
      RED => s_red_col1,
      GRN => s_grn_col1,
      BLUE => s_blue_col1,
		pasandocolumna => s_pasandocolumna1);
				
columna2 : columna
	GENERIC MAP (
					 retardoinicio =>853)

	PORT MAP (
		clk => clk,
		reset => s_reset,
		eje_x => s_eje_x,
      eje_y => s_eje_y,
		newpantalla => s_O3,
		enable => s_enable_gestor,
		data_posy => posy_gestor,
		data_hueco => hueco_gestor,
      pide_datos => s_pide2,
      RED => s_red_col2,
      GRN => s_grn_col2,
      BLUE => s_blue_col2,
		pasandocolumna => s_pasandocolumna2);
		
columna3 : columna
	GENERIC MAP (
					 retardoinicio =>1023)

	PORT MAP (
		clk => clk,
		reset => s_reset,
		eje_x => s_eje_x,
      eje_y => s_eje_y,
		newpantalla => s_O3,
		enable => s_enable_gestor,
		data_posy => posy_gestor,
		data_hueco => hueco_gestor,
      pide_datos => s_pide3,
      RED => s_red_col3,
      GRN => s_grn_col3,
      BLUE => s_blue_col3,
		pasandocolumna => s_pasandocolumna3);
		
gestorROM : gestorROMcolumnas
	port MAP (
		clk => clk,
		reset => s_reset,
		rand => s_rand,
		data_posy => posydata_aux,
      data_hueco => huecodata_aux,
      dir_posy => posydir_aux,
      dir_hueco => huecodir_aux,
      pide => s_pide_aux,
      da_hueco => hueco_gestor,
		da_posy => posy_gestor);


driver_vga: driver
	PORT MAP (
		clk => clk,
		reset => reset,
		HS => HS,
		VS => VS,
		eje_x => s_eje_x,
		eje_y => s_eje_y,
		pantalla => s_O3,
		enable_memo => memo_bird,
		pantalla_aux => s_O3_aux,
		RED_IN => s_red_driver,
		RED_OUT => RED,
		BLUE_IN => s_blue_driver,
		BLUE_OUT => BLUE,
		GRN_IN => s_grn_driver,
		GRN_OUT => GRN);
		
pajaro: bird
	PORT MAP (
		clk => clk,
		reset => s_reset,
		eje_x => s_eje_x,
		eje_y => s_eje_y,
		O3 => s_O3_aux,
		boton => boton,
		enable_memo => memo_bird,
		data => douta,
      direcc => addra,
		pajaroMuerto => s_pajaromuerto,
		enable => s_enable_gestor,
		red => s_red_bird,
		blue => s_blue_bird,
		green => s_grn_bird);
		
		
puntuacion: control_display
	PORT MAP (
		clk => clk,
		reset => reset,
		rand => s_rand,
		enable => s_enable_sseg,
		A => A,
		B => B,
		C => C,
		D => D,
		E => E,
		F => F,
		G => G,
		DP => DP,
		AN => AN);
		
-- FIN INSTANCIACIÓN COMPONENTES --


end Behavioral;

