LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
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
ENTITY Ticket_Machine IS
	PORT (
		CLK : IN STD_LOGIC;
		T : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		M : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		C : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		O : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		-- CLK 	= clock
		-- T	= Jenis tiket
		-- M 	= Jenis uang
		-- C	= Jenis uang yang akan dikeluarkan
		-- O	= Jenis tiket yang akan dikeluarkan
	);
END Ticket_Machine;

ARCHITECTURE behaviour OF Ticket_Machine IS
	TYPE state_types IS (S0, S1, S2, S3, S4, S5, S6);
	TYPE t_changes_array IS ARRAY (0 TO 3) OF INTEGER;
	SIGNAL changes_array : t_changes_array := (0, 0, 0, 0);
	-- S0 = idle
	-- S1 = pilih tiket 5K
	-- S2 = pilih tiket 10K
	-- S3 = pilih tiket 15K
	-- S4 = kembali 0
	-- S5 = kembali 5K
	-- S6 = kembali 10K
	-- S7 = kembali 15K (10K + 5K)
	-- S8 = keluar tiket

	SIGNAL PS, NS : state_types;
	-- PS = Present State
	-- NS = Next State
	SIGNAL currentIndex : INTEGER := 0;
	SIGNAL ticketPrice : INTEGER RANGE 0 TO 255 := 0;
	SIGNAL inputMoney : INTEGER RANGE 0 TO 255 := 0;
	SIGNAL currentMoney : INTEGER RANGE 0 TO 255 := 0;
	SIGNAL changeMoney : INTEGER RANGE 0 TO 255 := 0;
	-- ticketPrice 	= Mengubah tipe tiket menjadi integer
	-- inputMoney 	= Mengubah tipe input uang menjadi integer
	-- currentMoney	= Melacak dan menghitung jumlah uang yang ada didalam mesin.
BEGIN
	sync_proc : PROCESS (CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN
			PS <= NS;
		END IF;
	END PROCESS;

	comb_proc : PROCESS (PS, M, T)
		-- variable
	BEGIN
		CASE PS IS
			WHEN S0 => -- idle
				IF (T = "00" OR M /= "UUU") THEN
					NS <= S0;-- input invalid
				ELSE
					CASE T IS
						WHEN "01" =>
							ticketPrice <= 5;
							NS <= S1;
						WHEN "10" =>
							ticketPrice <= 10;
							NS <= S1;
						WHEN "11" =>
							ticketPrice <= 15;
							NS <= S1;
						WHEN OTHERS =>
							NS <= S0;
					END CASE;
				END IF;

			WHEN S1 => -- menunggu uang masuk
				IF (M = "000") THEN
					NS <= S1;
				ELSE
					CASE M IS
						WHEN "001" =>
							inputMoney <= 1;
							NS <= S2;
						WHEN "010" =>
							inputMoney <= 2;
							NS <= S2;
						WHEN "011" =>
							inputMoney <= 5;
							NS <= S2;
						WHEN "100" =>
							inputMoney <= 10;
							NS <= S2;
						WHEN "101" =>
							inputMoney <= 20;
							NS <= S2;
						WHEN "110" =>
							inputMoney <= 50;
							NS <= S2;
						WHEN "111" =>
							inputMoney <= 100;
							NS <= S2;
						WHEN OTHERS =>
							NS <= S1;
					END CASE;
				END IF;

			WHEN S2 => -- Menambahkan uang ke total dalam 
				currentMoney <= currentMoney + inputMoney;
				NS <= S3;

			WHEN S3 => -- Mencek apakah uang dalam machine melebihi harga tiket.
				IF currentMoney >= ticketPrice THEN
					O <= T;
					changeMoney <= currentMoney - ticketPrice;
					NS <= S4;
				ELSE
					NS <= S1;
				END IF;

			WHEN S4 => -- Melakukan perhitungan uang kembalian.
				IF changeMoney >= 100 THEN
					changeMoney <= changeMoney - 100;
					changes_array(currentIndex) <= 100;
					C <= "111";
				ELSIF changeMoney >= 50 THEN
					changeMoney <= changeMoney - 50;
					changes_array(currentIndex) <= 50;

					C <= "110";
				ELSIF changeMoney >= 20 THEN
					changeMoney <= changeMoney - 20;
					changes_array(currentIndex) <= 20;

					C <= "101";
				ELSIF changeMoney >= 10 THEN
					changeMoney <= changeMoney - 10;
					changes_array(currentIndex) <= 10;

					C <= "100";
				ELSIF changeMoney >= 5 THEN
					changeMoney <= changeMoney - 5;
					changes_array(currentIndex) <= 5;

					C <= "011";
				ELSIF changeMoney >= 2 THEN
					changeMoney <= changeMoney - 2;
					changes_array(currentIndex) <= 2;

					C <= "010";
				ELSIF changeMoney >= 1 THEN
					changeMoney <= changeMoney - 1;
					changes_array(currentIndex) <= 1;

					C <= "001";
				ELSE
					C <= "000";
					changes_array(currentIndex) <= 0;

				END IF;
				currentIndex <= currentIndex + 1;
				NS <= S5;

			WHEN S5 => -- Mencek apakah uang masih ada yang perlu dikembalikan.
				IF changeMoney > 0 THEN
					NS <= S4;
				ELSE
					NS <= S6;
				END IF;

			WHEN S6 => -- Reset
				ticketPrice <= 0;
				inputMoney <= 0;
				currentMoney <= 0;
				changeMoney <= 0;
				NS <= S0;
		END CASE;

		FOR i IN 0 TO 3 LOOP
			REPORT "Change=" & INTEGER'image(changes_array(i));
		END LOOP;
	END PROCESS;

END behaviour;