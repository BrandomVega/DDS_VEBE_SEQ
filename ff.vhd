-------------------------------------------------------------------------------



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FLIPFLOPS IS
	PORT(
		CLK,A,B,CLR: IN STD_LOGIC;
		SEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Q, QN: INOUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE FF OF FLIPFLOPS IS
SIGNAL Q_AUX: STD_LOGIC;
BEGIN	 	
	PROCESS(CLK,CLR) BEGIN	
		Q_AUX <= Q;
		IF (CLR='1')THEN
			Q<='0';
			Qn<='0';  
			Q_AUX<='0';
		ELSIF(CLK'EVENT AND CLK='1')THEN
			IF(SEL = "00")THEN		--D
				Q <= A;
				QN <= NOT(A);
			ELSIF(SEL = "01")THEN	  	--T
				Q<=Q_AUX XOR A;    
				QN<=NOT(Q)
			ELSIF(SEL = "10")THEN
				Q<=(A AND NOT(Q_AUX))OR(NOT(B)AND(Q_AUX));	 
				QN<=NOT(Q);
			ELSE
				
			END IF;
		END IF;
	END PROCESS;	
END ARCHITECTURE;