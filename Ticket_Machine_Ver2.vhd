library ieee;
use ieee.std_logic_1164.all;


-- Untuk M (Money)
-- 000 = Tidak ada
-- 001 = 1K
-- 010 = 2K
-- 011 = 5K
-- 100 = 10K
-- 101 = 20K
-- 110 = 50K
-- 111 = 100K

-- Untuk T (Ticket)
-- 00 = Tidak ada
-- 01 = 5K
-- 10 = 10K
-- 11 = 15K

--- Untuk C (Change)
-- 000 = Tidak ada
-- 001 = 1K
-- 010 = 2K
-- 011 = 5K
-- 100 = 10K
-- 101 = 20K
-- 110 = 50K
-- 111 = 100K


entity Ticket_Machine is
	port(
		CLK : in std_logic;
		T 	: in std_logic_vector (1 downto 0);
		M 	: in std_logic_vector (2 downto 0);
		C	: out std_logic_vector (2 downto 0);
		O	: out std_logic_vector(1 downto 0)
		-- CLK 	= clock
		-- T	= Jenis tiket
		-- M 	= Jenis uang
		-- C	= Jenis uang yang akan dikeluarkan
		-- O	= Jenis tiket yang akan dikeluarkan
	);
end Ticket_Machine;

architecture behaviour of Ticket_Machine is
	type state_types is (S0, S1, S2, S3, S4, S5, S6);
	-- S0 = idle
	-- S1 = pilih tiket 5K
	-- S2 = pilih tiket 10K
	-- S3 = pilih tiket 15K
	-- S4 = kembali 0
	-- S5 = kembali 5K
	-- S6 = kembali 10K
	-- S7 = kembali 15K (10K + 5K)
	-- S8 = keluar tiket

	signal PS, NS : state_types;
	-- PS = Present State
	-- NS = Next State
	
	signal ticketPrice 	: INTEGER range 0 to 255 := 0;
	signal inputMoney	: INTEGER range 0 to 255 := 0;
	signal currentMoney : INTEGER range 0 to 255 := 0;
	signal changeMoney	: INTEGER range 0 to 255 := 0;
	-- ticketPrice 	= Mengubah tipe tiket menjadi integer
	-- inputMoney 	= Mengubah tipe input uang menjadi integer
	-- currentMoney	= Melacak dan menghitung jumlah uang yang ada didalam mesin.
	
	
begin
	sync_proc : process(CLK)
	begin
		if(rising_edge(CLK)) then PS <= NS;
		end if;
	end process;
	
	comb_proc : process(PS, M, T)
	-- variable
	begin
		case PS is
			when S0 => -- idle
				if(T = "00" or M /= "000") then NS <= S0;-- input invalid
				else 
					case T is
						when "01" =>
							ticketPrice <= 5;
							NS	 	<= S1; 
						when "10" =>
							ticketPrice <= 10;
							NS	 	<= S1; 
						when "11" =>
							ticketPrice <= 15;
							NS	 	<= S1; 
						when others =>
							NS <= S0;
					end case;
				end if;
				
			when S1 => -- menunggu uang masuk
				if(M = "000") then NS <= S1;
				else
					case M is
					when "001" =>
						inputMoney <= 1;
						NS <= S2;
					when "010" =>
						inputMoney <= 2;
						NS <= S2;
					when "011" =>
						inputMoney <= 5;
						NS <= S2;
					when "100" =>
						inputMoney <= 10;
						NS <= S2;
					when "101" =>
						inputMoney <= 20;
						NS <= S2;
					when "110" =>
						inputMoney <= 50;
						NS <= S2;
					when "111" =>
						inputMoney <= 100;
						NS <= S2;
					when others =>
						NS <= S1;
				end case;			
				end if;

			when S2 => -- Menambahkan uang ke total dalam 
				 currentMoney <= currentMoney + inputMoney;
				 NS <= S3;
				 
			when S3 => -- Mencek apakah uang dalam machine melebihi harga tiket.
				if currentMoney > ticketPrice then
					O <= T;
					changeMoney <= currentMoney - ticketPrice;
					NS <= S5;
				else
					NS <= S1;
				end if;

			when S4 => -- Melakukan perhitungan uang kembalian.
				if changeMoney >= 100 then
					changeMoney <= changeMoney - 100;
					C <= "111";
				elsif changeMoney >= 50 then
					changeMoney <= changeMoney - 50;
					C <= "110";
				elsif changeMoney >= 20 then 
					changeMoney <= changeMoney - 20;
					C <= "101";
				elsif changeMoney >= 10 then
					changeMoney <= changeMoney - 10;
					C <= "100";
				elsif changeMoney >= 5 then
					changeMoney <= changeMoney - 5;
					C <= "011";
				elsif changeMoney >= 2 then
					changeMoney <= changeMoney - 2;
					C <= "010";
				elsif changeMoney >= 1 then
					changeMoney <= changeMoney - 1;
					C <= "001";
				else 
					C <= "000";
				end if;
				NS <= S5;
				
			when S5 => -- Mencek apakah uang masih ada yang perlu dikembalikan.
				if changeMoney > 0 then
					NS <= S4;
				else
					NS <= S6;
				end if;

			when S6 => -- Reset
				ticketPrice 	<= 0;
				inputMoney		<= 0;
				currentMoney 	<= 0;
				changeMoney		<= 0;
				NS <= S0;
			

		end case;

	end process;

end behaviour;