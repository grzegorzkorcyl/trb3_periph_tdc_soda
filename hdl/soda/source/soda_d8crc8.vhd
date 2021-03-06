
-- ########################################################################
-- crc engine rtl design 
-- copyright (c) www.electronicdesignworks.com 
-- source code generated by electronicdesignworks ip generator (crc).
-- documentation can be downloaded from www.electronicdesignworks.com 
-- ******************************** 
--license 
-- ******************************** 
-- this source file may be used and distributed freely provided that this
-- copyright notice, list of conditions and the following disclaimer is
-- not removed from the file.
-- any derivative work should contain this copyright notice and associated disclaimer.
-- this source code file is provided "as is" and without any warranty, 
-- without even the implied warranty of merchantability or fitness for a 
-- particular purpose.
-- ********************************
-- specification 
-- ********************************
-- file name : crc8_data8.vhd
-- description : crc engine entity 
-- clock : positive edge 
-- reset : active low
-- first serial: msb 
-- data bus width: 8 bits 
-- polynomial: (0 4 5 8) 
-- date: 12-mar-2013
-- version : 1.0
-- ########################################################################

library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_arith.all ;
use ieee.std_logic_unsigned.all ;

library work;
use work.trb_net_std.all;
use work.trb_net_components.all;
use work.trb_net16_hub_func.all; 
use work.soda_components.all;

entity soda_d8crc8 is
	port( 
		CLOCK				: in std_logic; 
		RESET				: in std_logic; 
		SOC_IN			: in std_logic; 
		DATA_IN			: in std_logic_vector(7 downto 0); 
		DATA_VALID_IN	: in std_logic; 
		EOC_IN			: in std_logic; 
		CRC_OUT			: out std_logic_vector(7 downto 0); 
		CRC_VALID_OUT	: out std_logic 
	);
end soda_d8crc8;

architecture behavioral of soda_d8crc8 is
	
	constant		crc_const: std_logic_vector(7 downto 0) := (others => '0');

	signal crc_r				: std_logic_vector(7 downto 0);
	signal crc_c				: std_logic_vector(7 downto 0);
	signal crc_i				: std_logic_vector(7 downto 0);
--	signal crc_const			: std_logic_vector(7 downto 0) := "00000000";
	signal crc_valid_out_S	: std_logic	:='0';

begin 

	
	crc_i<= crc_const when SOC_IN = '1' else
					crc_r;

	crc_c(0) <= DATA_IN(0) xor DATA_IN(3) xor DATA_IN(4) xor crc_i(0) xor crc_i(4) xor DATA_IN(6) xor crc_i(3) xor crc_i(6); 
	crc_c(1) <= DATA_IN(1) xor DATA_IN(4) xor DATA_IN(5) xor crc_i(1) xor crc_i(5) xor DATA_IN(7) xor crc_i(4) xor crc_i(7); 
	crc_c(2) <= DATA_IN(2) xor DATA_IN(5) xor DATA_IN(6) xor crc_i(2) xor crc_i(6) xor crc_i(5); 
	crc_c(3) <= DATA_IN(3) xor DATA_IN(6) xor DATA_IN(7) xor crc_i(3) xor crc_i(7) xor crc_i(6); 
	crc_c(4) <= DATA_IN(0) xor DATA_IN(7) xor crc_i(7) xor DATA_IN(3) xor crc_i(0) xor DATA_IN(6) xor crc_i(3) xor crc_i(6); 
	crc_c(5) <= DATA_IN(0) xor DATA_IN(1) xor crc_i(1) xor DATA_IN(7) xor crc_i(7) xor DATA_IN(3) xor crc_i(0) xor DATA_IN(6) xor crc_i(3) xor crc_i(6); 
	crc_c(6) <= DATA_IN(1) xor DATA_IN(2) xor crc_i(2) xor DATA_IN(4) xor crc_i(1) xor DATA_IN(7) xor crc_i(4) xor crc_i(7); 
	crc_c(7) <= DATA_IN(2) xor DATA_IN(3) xor crc_i(3) xor DATA_IN(5) xor crc_i(2) xor crc_i(5); 


--	crc_gen_process : process(CLOCK, RESET) 
--	begin
--		if(RESET = '1') then
--			crc_r <= "00000000" ;
--		elsif	rising_edge(CLOCK) then 
--			if(DATA_VALID_IN = '1') then 
--				crc_r <= crc_c; 
--			end if; 
--		end if;
--	end process crc_gen_process;
		 
	crc_gen_process : process(CLOCK, RESET) 
	begin
		if rising_edge(CLOCK) then
			if (RESET = '1') then
				crc_r	<= "00000000" ;
			elsif	(DATA_VALID_IN = '1') then 
				crc_r	<= crc_c;
			elsif (crc_valid_out_S='1') then
				crc_r	<= "00000000" ;
			end if; 
		end if;
	end process crc_gen_process;

	crc_valid_gen : process(CLOCK, RESET) 
	begin
		if rising_edge(CLOCK) then
			if (RESET = '1') then
				crc_valid_out_S	<= '0'; 
			elsif (DATA_VALID_IN = '1' and EOC_IN = '1') then 
				crc_valid_out_S	<= '1'; 
			else 
				crc_valid_out_S	<= '0'; 
			end if; 
		end if;
	end process crc_valid_gen; 


--	crc_valid_gen : process(CLOCK, RESET) 
--	begin
--		if(RESET = '1') then 
--			CRC_VALID_OUT		<= '0'; 
--		elsif	rising_edge(CLOCK) then 
--			if(DATA_VALID_IN = '1' and EOC_IN = '1') then 
--				CRC_VALID_OUT	<= '1'; 
--			else 
--				CRC_VALID_OUT	<= '0'; 
--			end if; 
--		end if;
--	end process crc_valid_gen; 
--

	CRC_VALID_OUT	<= crc_valid_out_S;
	CRC_OUT			<= crc_r;

end behavioral;