


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY AUTOMATA IS 
	PORT(
	CLK, CLR, UD, EN: IN STD_LOGIC;
	D,JK,T: OUT STD_LOGIC;
	);
END ENTITY;

ARCHITECTURE AUTOMATA FOR AUTOMATA IS
BEGIN				
	PROCESS(CLK, CLR)BEGIN
		IF(CLR = '1')THEN
			D<='0';JK<='0';T<='0';
		ELSIF(CLK'EVENT AND CLK='1')THEN
			IF(EN = '0')THEN
				T<=T;
				JK<=JK;
				D<=D;
			ELSIF(EN = '1' AND UD = 1)THEN
				--construimos los flipflops, El menos significativo es T
				T<=T XOR '1';	 --T = T XOR Q
				JK = (JK AND (NOT(T)) OR (NOT(JK) AND T); --JK = JQ'+K'Q
				D<=(D AND (NOT JK)) OR (NOT(A)AND B AND C) OR (A AND NOT(C));		
			ELSIF(EN = '1' AND UD = 1)THEN
				T<=T XOR '1';	 --T = T XOR Q
				JK = (JK AND (NOT(T)) OR (NOT(JK) AND (T)); --JK = JQ'+K'Q
				D<=(D AND T) OR (D AND JK) OR (NOT D AND NOT JK AND NOT T);
			END IF;
		END IF;
	END PROCESS;  
	
	
	
END ARCHITECTURE;
	