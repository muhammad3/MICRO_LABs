library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity FD_GENERIC is
  Generic (N: integer:= numBit);
	Port (	D:	In	std_logic_vector(N-1 downto 0);
		CK:	In	std_logic;
		RESET:	In	std_logic;
		Q:	Out	std_logic_vector(N-1 downto 0));
end FD_GENERIC;


architecture BEHAVIORAL of FD_GENERIC is
begin
  PSYNCH: process(CK,RESET)
	begin
	  if CK'event and CK='1' then -- positive edge triggered:
	    if RESET='1' then -- active high reset
	      Q <= "0";
	    else
	      Q <= D; -- input is written on output
	    end if;
	  end if;
	end process;
end BEHAVIORAL;


architecture STRUCTURAL of FD_GENERIC is
  component FD
  	Port (	D:	In	std_logic;
  		CK:	In	std_logic;
  		RESET:	In	std_logic;
  		Q:	Out	std_logic);
  end component FD;

begin
  RIGISTER_NBIT: for I in 0 to N-1  generate
    fdMap : FD Port Map(D(I),CK, RESET, Q(I));
  end generate;

end STRUCTURAL;



configuration CFG_FD_GEN_BEHAVIORAL of FD_GENERIC is
  for BEHAVIORAL
  end for;
end CFG_FD_GEN_BEHAVIORAL;

configuration CFG_FD_ASYN_GEN of FD_GENERIC is
  for STRUCTURAL
    for RIGISTER_NBIT
      for all: FD
        use configuration work.CFG_FD_PLUTO;
      end for;
    end for;
  end for;
end CFG_FD_ASYN_GEN;

configuration CFG_FD_SYN_GEN of FD_GENERIC is
  for STRUCTURAL
    for RIGISTER_NBIT
      for all: FD
        use configuration work.CFG_FD_PIPPO;
      end for;
    end for;
  end for;
end CFG_FD_SYN_GEN;
