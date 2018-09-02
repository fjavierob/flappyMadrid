----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:49:39 11/07/2017 
-- Design Name: 
-- Module Name:    control_display_p1 - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sieteseg is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  punto : in STD_LOGIC;
           A : out  STD_LOGIC;
           B : out  STD_LOGIC;
           C : out  STD_LOGIC;
           D : out  STD_LOGIC;
           E : out  STD_LOGIC;
           F : out  STD_LOGIC;
           G : out  STD_LOGIC;
           DP : out  STD_LOGIC;
           AN : out  STD_LOGIC_VECTOR (3 downto 0));
end sieteseg;


architecture Behavioral of sieteseg is

component Divisorfrec 
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           saturado2 : out  STD_LOGIC);
end component;

component contador_sieteseg
    Port ( enable : in  STD_LOGIC;
			  clk : in  STD_LOGIC;
			  reset : in  STD_LOGIC;
			  sat : out  STD_LOGIC;
           cuenta : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component decodificador 
    Port ( binario : in  STD_LOGIC_VECTOR (3 downto 0);
           siete_seg : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

component reg_desp 
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           display_enable : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

signal siete_seg_aux : std_logic_vector (6 downto 0);
signal s_enable_cont2, s_enable_cont3, s_enable_cont4, s_enable_desp : std_logic;
signal s_binario, s_binario1, s_binario2, s_binario3, s_binario4 : std_logic_vector (3 downto 0);
signal s_an_aux : std_logic_vector (3 downto 0);
signal s_sat1, s_sat2, s_sat3 : std_logic;

begin

DP <= '1';

div1: Divisorfrec 
	PORT MAP (
		clk => clk,
		reset => reset,
		saturado2 => s_enable_desp);
		
desp1: reg_desp
	PORT MAP (
		clk => clk,
		reset => reset,
		display_enable => s_an_aux,
		enable => s_enable_desp );
		
		
cont1: contador_sieteseg
	PORT MAP (
		clk => clk,
		reset => reset,
		enable => punto,
		sat => s_sat1,
		cuenta => s_binario1 );
		
cont2: contador_sieteseg
	PORT MAP (
		clk => clk,
		reset => reset,
		enable => s_enable_cont2,
		sat => s_sat2,
		cuenta => s_binario2 );
		
cont3: contador_sieteseg
	PORT MAP (
		clk => clk,
		reset => reset,
		enable => s_enable_cont3,
		sat => s_sat3,
		cuenta => s_binario3 );
		
cont4: contador_sieteseg
	PORT MAP (
		clk => clk,
		reset => reset,
		enable => s_enable_cont4,
		sat => open,
		cuenta => s_binario4 );
		
decod1: decodificador 
	PORT MAP (
		binario => s_binario,
		siete_seg => siete_seg_aux );
		
A <= siete_seg_aux(6);
B <= siete_seg_aux(5);
C <= siete_seg_aux(4);
D <= siete_seg_aux(3);
E <= siete_seg_aux(2);
F <= siete_seg_aux(1);
G <= siete_seg_aux(0);
AN <= s_an_aux;
s_enable_cont2 <= punto and s_sat1;
s_enable_cont3 <= s_enable_cont2 and s_sat2;
s_enable_cont4 <= s_enable_cont3 and s_sat3;

multip : process (s_an_aux, s_binario1, s_binario2, s_binario3, s_binario4)
begin
case s_an_aux is

	when "1110" =>
		s_binario <= s_binario1;
	
	when "1101" =>
		s_binario <= s_binario2;
	
	when "1011" =>
		s_binario <= s_binario3;
	
	when others =>
		s_binario <= s_binario4;

end case;
end process;


end Behavioral;