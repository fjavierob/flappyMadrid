----------------------------------------------------------------------------------
-- Company: ESCUELA TECNICA SUPERIOR DE INGENIERIA - MASTER INGENIERIA DE TELECOMUNICACIONES
-- Engineer: FRANCISCO JOSE DIAZ, FRANCISCO JAVIER ORTIZ, ALBERTO FUENTES
-- 
-- Create Date:    12/01/2018
-- Project Name: FLAPPY BIRD

-- Module Name:    control_display - Behavioral 
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

entity control_display is
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
end control_display;

architecture Behavioral of control_display is

-- --------------------------- --
-- SEÑALES INTERNAS AUXILIARES --
-- --------------------------- --

signal s_sat_enable_rd: STD_LOGIC;

signal enable_c1, enable_c2, enable_c3, enable_c4: STD_LOGIC;
signal sat_c1, sat_c2, sat_c3: STD_LOGIC;
signal cuenta_c1, cuenta_c2, cuenta_c3, cuenta_c4: STD_LOGIC_VECTOR(3 downto 0);

signal display_enable_aux: STD_LOGIC_VECTOR (3 downto 0);

signal s_siete: STD_LOGIC_VECTOR (6 downto 0);

signal digito_mostrando: STD_LOGIC_VECTOR (3 downto 0);

-- ----------------------- --
-- DECLARACIÓN COMPONENTES --
-- ----------------------- --

component cont_digito
port ( clk : in STD_LOGIC;
		 enable : in  STD_LOGIC;
       reset : in  STD_LOGIC;
		 sat : out STD_LOGIC;
       cuenta : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component decodificador
port ( siete_seg : out STD_LOGIC_VECTOR (6 downto 0);
       binario : in  STD_LOGIC_VECTOR (3 downto 0));
end component;

component div_frec
port ( clk : in  STD_LOGIC;
       reset : in  STD_LOGIC;
		 rand : out STD_LOGIC_VECTOR (3 downto 0);
       sat : out  STD_LOGIC);
end component;

component reg_desp
port ( clk : in STD_LOGIC;
		 reset : in STD_LOGIC;
		 enable : in STD_LOGIC;
		 display_enable : out STD_LOGIC_VECTOR (3 downto 0));
end component;

-- FIN DECLARACIÓN COMPONENTES --

begin

	DP <= '1';
	
	AN <= display_enable_aux;
	
	A <= s_siete(6);
	B <= s_siete(5);
	C <= s_siete(4);
	D <= s_siete(3);
	E <= s_siete(2);
	F <= s_siete(1);
	G <= s_siete(0);
	
	enable_c1 <= enable;
	enable_c2 <= sat_c1 and enable_c1;
	enable_c3 <= sat_c2 and enable_c2;
	enable_c4 <= sat_c3 and enable_c3;
	
	
	
-- ------------------------- --
-- INSTANCIACIÓN COMPONENTES --
-- ------------------------- --
	
	dv: div_frec
	port map (
		clk => clk,
		reset => reset,
		rand => rand,
		sat => s_sat_enable_rd);
		
	cont1: cont_digito
	port map (
		clk => clk,
		reset => reset,
		cuenta => cuenta_c1,
		enable => enable_c1,
		sat =>sat_c1 );
		
	cont2: cont_digito
	port map (
		clk => clk,
		reset => reset,
		cuenta => cuenta_c2,
		enable => enable_c2,
		sat => sat_c2);
	
	cont3: cont_digito
	port map (
		clk => clk,
		reset => reset,
		cuenta => cuenta_c3,
		enable => enable_c3,
		sat => sat_c3);
		
	cont4: cont_digito
	port map (
		clk => clk,
		reset => reset,		
		cuenta => cuenta_c4,
		enable => enable_c4,
		sat => open);
	
	registro: reg_desp
	port map (
		clk => clk,
		reset => reset,
		enable => s_sat_enable_rd,
		display_enable => display_enable_aux);
		
	decod: decodificador
	port map (
		binario => digito_mostrando,
		siete_seg => s_siete);
	
	-- FIN INSTANCIACIÓN COMPONENTES --
	
	-- --------------------------------------------- --
	-- Proceso para cambiar el dígito que se muestra --
	-- --------------------------------------------- --
	
	cambiaDigito: process (display_enable_aux, cuenta_c1, cuenta_c2, cuenta_c3, cuenta_c4)
	begin
		case display_enable_aux is
			when "1110" => 
				digito_mostrando <= cuenta_c1;
			when "1101" => 
				digito_mostrando <= cuenta_c2;
			when "1011" => 
				digito_mostrando <= cuenta_c3;
			when others =>
				digito_mostrando <= cuenta_c4;
		end case;
	end process;	
	
	
	
end Behavioral;

