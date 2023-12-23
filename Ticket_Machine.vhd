LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- Untuk M (Money)
-- 000 = Tidak ada
-- 001 = 5K
-- 010 = 10K
-- 011 = 20K
-- 100 = 50K
-- 101 = 100K
-- Untuk T (Ticket)
-- 00 = Tidak ada
-- 01 = 5K
-- 10 = 10K
-- 11 = 15K
ENTITY Ticket_Machine IS
	PORT (
		CLK : IN STD_LOGIC;
		M : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		T : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		C1, C2, C3, C4 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		O : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
	);
END Ticket_Machine;

ARCHITECTURE behaviour OF Ticket_Machine IS
	TYPE state_types IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14);

	-- S0 = idle
	-- S1 = pilih tiket 5K
	-- S2 = pilih tiket 10K
	-- S3 = pilih tiket 15K
	-- S4 = kembali 0
	-- S5 = kembali 5K
	-- S6 = kembali 10K
	-- S7 = kembali 15K (10K + 5K)
	-- S8 = kembali 35K (10K + 5K)
	-- S9 = kembali 40K (10K + 5K)
	-- S10 = kembali 45K (10K + 5K)
	-- S11 = kembali 85K (10K + 5K)
	-- S12 = kembali 80K (10K + 5K)
	-- S13 = kembali 95K (10K + 5K)
	-- S14 = keluar tiket
	SIGNAL PS, NS, temp_NS : state_types;
BEGIN
	sync_proc : PROCESS (CLK, NS)
	BEGIN
		IF (rising_edge(CLK)) THEN
			PS <= NS;
		END IF;
	END PROCESS;

	comb_proc : PROCESS (PS, M, T)
	BEGIN
		C1 <= "000"; -- 0
		C2 <= "000"; -- 0
		C3 <= "000"; -- 0
		C4 <= "000"; -- 0
		O <= "00";

		CASE PS IS

			WHEN S0 => -- idle
				IF (T = "00" OR M = "000") THEN
					NS <= S0;-- input invalid

				ELSIF (T = "01" AND M /= "000") THEN
					NS <= S1; -- tiket 5K

				ELSIF (T = "10" AND M /= "000") THEN
					NS <= S2;-- tiket 10K

				ELSIF (T = "11" AND M /= "000") THEN
					NS <= S3; -- tiket 15K
				END IF;
				
			WHEN S1 => -- tiket 5K
				IF (M = "000") THEN
					NS <= S0; -- kembali ke S0

				ELSIF (M = "001") THEN
					NS <= S4; -- kembali 0K

				ELSIF (M = "010") THEN
					NS <= S5; -- kembali 5k

				ELSIF (M = "011") THEN
					NS <= S7; -- kembali 15K --> 10 + 5

				ELSIF (M = "100") THEN
					NS <= S10; -- kembali 45K --> 40 + 5

				ELSIF (M = "101") THEN
					NS <= S13; -- kembali 95K --> 50 + 20 + 20 + 5

				END IF;

			WHEN S2 => -- tiket 10K
				IF (M = "000") THEN
					NS <= S0; -- kembali ke S0

				ELSIF (M = "001") THEN
					NS <= S1; -- sisa 5k

				ELSIF (M = "010") THEN
					NS <= S4; -- kembali 0

				ELSIF (M = "011") THEN
					NS <= S6; -- kembali 10k

				ELSIF (M = "100") THEN
					NS <= S9; -- kembali 40k

				ELSIF (M = "101") THEN
					NS <= S12; -- kembali 90k

				END IF;

			WHEN S3 => -- tiket 15K

				IF (M = "000") THEN
					NS <= S0; -- kembali ke S0

				ELSIF (M = "001") THEN
					NS <= S2; -- sisa 10k

				ELSIF (M = "010") THEN
					NS <= S1; -- sisa 5k

				ELSIF (M = "011") THEN
					NS <= S5; -- kembali 5k

				ELSIF (M = "100") THEN
					NS <= S8; -- kembali 35k

				ELSIF (M = "101") THEN
					NS <= S11; -- kembali 85k

				END IF;
				--- Untuk C1 dan C2 (Change)
				-- 000 = 0
				-- 001 = 5K
				-- 010 = 10K
				-- 011 = 20K
				-- 100 = 50K
			WHEN S4 => -- kembali 0
				C1 <= "000"; -- 0
				C2 <= "000"; -- 0
				C3 <= "000"; -- 0
				C4 <= "000"; -- 0
				NS <= S14;

			WHEN S5 => -- kembali 5K (5 + 0 + 0 + 0)
				C1 <= "001"; -- 5
				C2 <= "000"; -- 0
				C3 <= "000"; -- 0
				C4 <= "000"; -- 0
				NS <= S14;

			WHEN S6 => -- kembali 10K (10 + 0 + 0 + 0)
				C1 <= "010"; -- 10
				C2 <= "000"; -- 0
				C3 <= "000"; -- 0
				C4 <= "000"; -- 0
				NS <= S14;

			WHEN S7 => -- kembali 15K (10 + 5K + 0 + 0)
				C1 <= "010"; -- 10
				C2 <= "001"; -- 5
				C3 <= "000"; -- 0
				C4 <= "000"; -- 0
				NS <= S14;

			WHEN S8 => -- kembali 35K (20 + 10 + 5K + 0)
				C1 <= "011"; -- 20
				C2 <= "010"; -- 10
				C3 <= "001"; -- 5
				C4 <= "000"; -- 0
				NS <= S14;

			WHEN S9 => -- kembali 40K (20 + 20 + 0 + 0)
				C1 <= "011"; -- 20
				C2 <= "011"; -- 20
				C3 <= "000"; -- 0
				C4 <= "000"; -- 0
				NS <= S14;

			WHEN S10 => -- kembali 45K (20 + 20 + 5 + 0)
				C1 <= "011"; -- 20
				C2 <= "011"; -- 20
				C3 <= "001"; -- 5
				C4 <= "000"; -- 0
				NS <= S14;

			WHEN S11 => -- kembali 85K (50 + 20 + 10 + 5)
				C1 <= "100"; -- 50
				C2 <= "011"; -- 20
				C3 <= "010"; -- 10
				C4 <= "001"; -- 5
				NS <= S14;

			WHEN S12 => -- kembali 90K (50 + 20 + 20 + 0)
				C1 <= "100"; -- 50
				C2 <= "011"; -- 20
				C3 <= "011"; -- 20
				C4 <= "000"; -- 0
				NS <= S14;

			WHEN S13 => -- kembali 95K (50 + 20 + 20 + 5)
				C1 <= "100"; -- 50
				C2 <= "011"; -- 20
				C3 <= "011"; -- 20
				C4 <= "001"; -- 5
				NS <= S14;

			WHEN S14 => -- keluar tiket
				O <= T;

				NS <= S0;

		END CASE;

	END PROCESS;

END behaviour;