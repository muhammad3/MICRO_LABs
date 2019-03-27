library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.constants.all;


entity ACC is
  port (
    A          : in  std_logic_vector(numBit - 1 downto 0);
    B          : in  std_logic_vector(numBit - 1 downto 0);
    CLK        : in  std_logic;
    RST_n      : in  std_logic;
    ACCUMULATE : in  std_logic;
    --- ACC_EN_n   : in  std_logic;  -- optional use of the enable
    Y          : out std_logic_vector(numBit - 1 downto 0));
end entity ACC;


architecture STRUCTURAL of ACC is

  component MUX21_generic is
  	Generic ( N: integer:= numBit;
  		        DELAY_MUX: Time:= tp_mux);
  	Port (  A:	  In	std_logic_vector(N-1 downto 0) ;
  		      B:	  In	std_logic_vector(N-1 downto 0);
  		      SEL:	In	std_logic;
  		      Y:	  Out	std_logic_vector(N-1 downto 0));
  end component MUX21_generic;

  component RCA is
    generic (DRCAS : 	Time := 0 ns;
  	         DRCAC : 	Time := 0 ns;
  					 N: integer:= numBit);
  	Port (	A:	In	std_logic_vector(N-1 downto 0);
  		      B:	In	std_logic_vector(N-1 downto 0);
  		      Ci:	In	std_logic;
  		      S:	Out	std_logic_vector(N-1 downto 0);
  		      Co:	Out	std_logic);
  end component RCA;

  component FD_GENERIC is
    Generic (N: integer:= numBit);
  	Port (	D:	In	std_logic_vector(N-1 downto 0);
  		CK:	In	std_logic;
  		RESET:	In	std_logic;
  		Q:	Out	std_logic_vector(N-1 downto 0));
  end component;

  signal  out_mux   : std_logic_vector(numBit - 1 downto 0);
  signal  out_add   : std_logic_vector(numBit - 1 downto 0);
  signal  feed_back : std_logic_vector(numBit - 1 downto 0);


begin


  accMux : MUX21_generic
           port map(A => feed_back, B => B, SEL => ACCUMULATE, Y => out_mux);

  accAdder : RCA
             generic map(N=>numBit)
             Port Map(A => A, B => out_mux, Ci => '0', S => out_add);

  accRegister : FD_GENERIC
                port map (D => out_add, CK => CLK, RESET => RST_n, Q => feed_back);

  Y <=  feed_back;
end STRUCTURAL;


configuration CFG_ACC_STRUCTRAL of ACC is
  for STRUCTURAL

    for accMux : MUX21_generic
      use configuration  WORK.CFG_MUX21_GEN_STRUCTURAL;
    end for;

    for accAdder : RCA
      use configuration WORK.CFG_RCA_BEHAVIORAL;
    end for;

    for accRegister : FD_GENERIC
      use configuration WORK.CFG_FD_SYN_GEN;
    end for;

  end for;
end CFG_ACC_STRUCTRAL;
