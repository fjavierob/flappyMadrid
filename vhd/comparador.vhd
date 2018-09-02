----------------------------------------------------------------------------------
-- Company: ESCUELA TECNICA SUPERIOR DE INGENIERIA - MASTER INGENIERIA DE TELECOMUNICACIONES
-- Engineer: FRANCISCO JOSE DIAZ, FRANCISCO JAVIER ORTIZ, ALBERTO FUENTES
-- 
-- Create Date:    12/01/2018
-- Project Name: FLAPPY BIRD

-- Module Name:    comparador - Behavioral  
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

entity comparador is
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
end comparador;

architecture Behavioral of comparador is

signal PValor_O1, PValor_O2, PValor_O3: STD_LOGIC; 

begin

sinc:process(clk, reset)		--Este comparador es sincrono porque necesitamos guardar la salida
begin
	if (reset = '1') then
		O1 <= '0';
		O2 <= '0';
		O3 <= '0';
	elsif(rising_edge(clk)) then
		O1 <= PValor_O1;
		O2 <= PValor_O2;
		O3 <= PValor_O3;
	end if;
end process;

comb:process(data)
begin
	
	PValor_O1 <= '0';
	PValor_O2 <= '0';
 	PValor_O3 <= '0';

if(unsigned(data) > End_Of_Screen) then  --Si me he salido de la pantalla, es decir, data > 639 (en el caso X) o data > 479 (en el caso Y) ... GenColor mandara el color 0 (negro)
PValor_O1 <= '1';
end if;

if( unsigned(data) > Start_Of_Pulse AND unsigned(data) < End_Of_Pulse) then --Si el contador esta en un momento en el que toca dar un pulso de sincronismo
PValor_O2 <= '1';																				-- Doy un pulso en HS para que empiece una nueva linea, en caso de lineas
end if;																							--Doy un puslo en VS, en el caso de que haya que comenzar una nueva pantalla

if (unsigned(data) = End_Of_Line) then			--Si ya he llegado al final de la linea, estoy fuera de la pantalla, y he dado el pulso.
PValor_O3 <= '1';										--Reset sincrono para que comience la cuenta de pixel de nuevo.
end if;													--Ademas, el contador X habilitara al contador Y para que cuente uno.
															--Ademas, el contador Y, cuando 03 = '1', significara FIN DE PANTALLA. Puede servir para mover el muñeco en el caso de un juego 3 pixel x pantalla.
	
	
end process;


end Behavioral;

