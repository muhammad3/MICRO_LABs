library IEEE;
use IEEE.std_logic_1164.all; --  library IEEE: includes the definition of  standard logic
use WORK.constants.all; -- library WORK user-defined

entity ND2 is
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		Y:	Out	std_logic);
end ND2;


-- first architecture
architecture ARCH1 of ND2 is

begin
	Y <= not( A and B) after NDDELAY; 

end ARCH1;


--second architecture
architecture ARCH2 of ND2 is

begin
     -- process name
     --  |
     -- \/
	P1: process(A,B) -- all inputs in the sensitivity list: this is a
			 -- combinational gate
	begin
	  if (A='1') and (B='1') then
	    Y <='0' after NDDELAY;
	  elsif (A='0') or (B='0') then 
	    Y <='1' after NDDELAY;
	  end if;
	end process;

end ARCH2;


configuration CFG_ND2_ARCH1 of ND2 is
	for ARCH1
	end for;
end CFG_ND2_ARCH1;

configuration CFG_ND2_ARCH2 of ND2 is
	for ARCH2
	end for;
end CFG_ND2_ARCH2;

