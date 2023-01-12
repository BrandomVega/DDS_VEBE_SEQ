LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;		   

ENTITY PISO IS
	PORT(	   
		CLK, CLR, EN: IN STD_LOGIC;
		DATA: IN STD_LOGIC_VECTOR(6 DOWNTO 0);	  
		SEGMENTOS: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		QN: INOUT STD_LOGIC	
	);
END ENTITY;


ARCHITECTURE PISO OF PISO IS 

SIGNAL QAUX: STD_LOGIC_VECTOR(6 DOWNTO 0);	
TYPE ESTADOS IS(A,B,C,D,E,F,G);	
ATTRIBUTE CODIGOS: STRING;
ATTRIBUTE CODIGOS OF ESTADOS: TYPE IS
--Codigos de los estados, pudo ser cualquiera
"0000" & --A--	  
"0001" & --B--
"0011" & --C--
"0010" & --D--
"0110" & --E--
"0111" & --F--
"1111" ; --G--


SIGNAL EDO, NEXT_EDO: ESTADOS;

BEGIN		
	
	--Habilitador 
	PROCESS(CLR, CLK, EN)BEGIN
		IF(CLR = '1')THEN
			EDO<=A;
		ELSIF(EN='1')THEN
			EDO<=EDO;
		ELSIF(CLK'EVENT AND CLK='1')THEN
			EDO<=NEXT_EDO;
		END IF;
	END PROCESS;
	
	
	--registro piso
	PROCESS(CLR, CLK) BEGIN		
		IF(CLR='1')THEN
			QAUX <= (OTHERS => '0');
		ELSIF(CLK'EVENT AND CLK='1')THEN 
			IF(EN = '1')THEN
				QAUX<=DATA;	
			ELSE
				QAUX(5 DOWNTO 0) <= QAUX(6 DOWNTO 1);  
				QAUX(6)<='0';
			END IF;	   
		END IF;	
	END PROCESS;   
	QN <= QAUX(0);		   
	--COMBINACIONAL
	PROCESS(QN, EDO)BEGIN
		CASE EDO IS WHEN  --Cuando EDO es A, pregunta cual es la entrada y avanza
			A=>IF(QN = '0')THEN	
				NEXT_EDO<=E;
			ELSE
				NEXT_EDO<=B;
			END IF;
			WHEN
			E=>IF(QN = '0')THEN
				NEXT_EDO<=F;
			ELSE
				NEXT_EDO<=B;
			END IF;
			WHEN 
			F=>IF(QN='0')THEN
				NEXT_EDO<=G;
			ELSE
				NEXT_EDO<=B; 
			END IF;
			WHEN 
			G=>IF(QN='0')THEN
				NEXT_EDO<=G;
			ELSE
				NEXT_EDO<=B;  
			END IF;
			WHEN 
			B=>IF(QN='1')THEN
				NEXT_EDO<=C;
			ELSE
				NEXT_EDO<=E;  
			END IF;
			WHEN 
			C=>IF(QN='1')THEN
				NEXT_EDO<=D;
			ELSE
				NEXT_EDO<=E; 
			END IF;
			WHEN 
			D=>IF(QN='1')THEN
				NEXT_EDO<=D;
			ELSE
				NEXT_EDO<=E;
			END IF;
			
			WHEN OTHERS => NULL;
		END CASE;
END PROCESS;

--COMBINACIONAL
			
SEGMENTOS<=
	"0000000" WHEN (EDO=A OR EDO=B OR EDO=C OR EDO=E OR EDO=F) ELSE
	"1111111" WHEN (EDO=D OR EDO=G) ELSE
	"1010101";
	
	
END ARCHITECTURE;
