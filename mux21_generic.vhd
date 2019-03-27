library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity MUX21_generic is
	Generic (N: integer:= numBit;
		 DELAY_MUX: Time:= tp_mux);
	Port (	A:	In	std_logic_vector(N-1 downto 0) ;
		B:	In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(N-1 downto 0));
end MUX21_generic;

architecture BEHAVIORAL of MUX21_generic is
begin
	process(A,B,SEL)
	begin
		case SEL is
		when '0' =>		Y <= B after DELAY_MUX;
		when '1' =>		Y <= A after DELAY_MUX;
		when others => null;
		end case;
	end process;
end BEHAVIORAL;


architecture STRUCTURAL of MUX21_generic is


	component MUX21

	Port (	A:	In	std_logic;
		B:	In	std_logic;
		S:	In	std_logic;
		Y:	Out	std_logic);

	end component;

begin

	  MUX_VECTOR: for I in 0 to N-1 generate
	    mux21map : MUX21  Port Map (A(I), B(I), SEL, Y(I));
	  end generate;



end STRUCTURAL;


configuration CFG_MUX21_GEN_BEHAVIORAL of MUX21_GENERIC is
	for BEHAVIORAL
	end for;
end CFG_MUX21_GEN_BEHAVIORAL;

configuration CFG_MUX21_GEN_STRUCTURAL of MUX21_GENERIC is
	for STRUCTURAL
	    for MUX_VECTOR
				for all : MUX21
					use configuration WORK.CFG_MUX21_STRUCTURAL;
				end for;
	    end for;
	end for;
end CFG_MUX21_GEN_STRUCTURAL;
