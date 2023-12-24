LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Ticket_Machine_tb IS
END Ticket_Machine_tb;

ARCHITECTURE bench OF Ticket_Machine_tb IS
	COMPONENT Ticket_Machine IS
		PORT (
			CLK : IN STD_LOGIC;
			T : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			M : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			C : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			O : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL CLK : STD_LOGIC;
	SIGNAL T : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL M : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL C : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL O : STD_LOGIC_VECTOR (1 DOWNTO 0);
	CONSTANT CLK_PERIOD : TIME := 0.1 ns;
	CONSTANT CLK_LIMIT : INTEGER := 50;
	SIGNAL i : INTEGER := 0;
BEGIN
	TM : Ticket_Machine PORT MAP(CLK, T, M, C, O);

	sync_proc : PROCESS
	BEGIN
		CLK <= '0';
		WAIT FOR CLK_PERIOD / 2;
		CLK <= '1';
		WAIT FOR CLK_PERIOD / 2;
		IF (i < CLK_LIMIT) THEN
			i <= i + 1;
		ELSE
			WAIT;
		END IF;
	END PROCESS;

	comb_proc : PROCESS
	BEGIN
		-- tiket 5K , bayar 5K--
		T <= "01";
		M <= "000";
		WAIT FOR CLK_PERIOD;
		M <= "011";
		WAIT FOR CLK_PERIOD * 2;
		WAIT FOR CLK_PERIOD * 2;

		WAIT FOR CLK_PERIOD * 2;

		WAIT FOR CLK_PERIOD * 2;

		WAIT FOR CLK_PERIOD * 2;
		WAIT FOR CLK_PERIOD * 2;
		ASSERT ((C = "000")) REPORT "Kembalian gagal jika memilih tiket 5K dengan pembayaran 5K" SEVERITY error;
		ASSERT (O = "01") REPORT "Tidak mengeluarkan tiket jika memilih tiket 5K dengan pembayaran 5K" SEVERITY error;
		WAIT FOR CLK_PERIOD;

		-- tiket 5K , bayar 10K--
		T <= "01";
		M <= "000";
		WAIT FOR CLK_PERIOD;
		M <= "100";
		WAIT FOR CLK_PERIOD;
		ASSERT ((C = "011")) REPORT "Kembalian gagal jika memilih tiket 5K dengan pembayaran 10K" SEVERITY error;
		WAIT FOR CLK_PERIOD;
		ASSERT (O = "01") REPORT "Tidak mengeluarkan tiket jika memilih tiket 5K dengan pembayaran 10K" SEVERITY error;
		WAIT FOR CLK_PERIOD;

		-- tiket 5K , bayar 20K--
		T <= "01";
		M <= "000";
		WAIT FOR CLK_PERIOD;
		M <= "101";
		WAIT FOR CLK_PERIOD;

		ASSERT ((C = "100")) REPORT "Kembalian gagal jika memilih tiket 5K dengan pembayaran 20K" SEVERITY error;
		WAIT FOR CLK_PERIOD;
		ASSERT ((C = "011")) REPORT "Kembalian gagal jika memilih tiket 5K dengan pembayaran 20K" SEVERITY error;
		WAIT FOR CLK_PERIOD;
		ASSERT (O = "01") REPORT "Tidak mengeluarkan tiket jika memilih tiket 5K dengan pembayaran 20K" SEVERITY error;
		WAIT FOR CLK_PERIOD;
		-- tiket 10K , bayar 5K, 5K--
		-- T <= "10";
		-- M <= "00";
		-- WAIT FOR CLK_PERIOD;
		-- M <= "01";
		-- WAIT FOR CLK_PERIOD;
		-- M <= "01";
		-- WAIT FOR CLK_PERIOD;

		-- ASSERT ((C1 = "00") AND (C2 = "00")) REPORT "Kembalian gagal jika memilih tiket 10K dengan pembayaran 5K dan 5K" SEVERITY error;
		-- WAIT FOR CLK_PERIOD;
		-- ASSERT (O = T) REPORT "Tidak mengeluarkan tiket jika memilih tiket 10K dengan pembayaran 5K dan 5K" SEVERITY error;
		-- WAIT FOR CLK_PERIOD * 2;
		-- -- tiket 10K , bayar 10K--
		-- T <= "10";
		-- M <= "00";
		-- WAIT FOR CLK_PERIOD;
		-- M <= "10";
		-- WAIT FOR CLK_PERIOD * 2;

		-- ASSERT ((C1 = "00") AND (C2 = "00")) REPORT "Kembalian gagal jika memilih tiket 10K dengan pembayaran 10K" SEVERITY error;
		-- ASSERT (O = T) REPORT "Tidak mengeluarkan tiket jika memilih tiket 10K dengan pembayaran 10K" SEVERITY error;
		-- WAIT FOR CLK_PERIOD;
		-- -- tiket 10K , bayar 20K--
		-- T <= "10";
		-- M <= "00";
		-- WAIT FOR CLK_PERIOD;
		-- M <= "11";
		-- WAIT FOR CLK_PERIOD;

		-- ASSERT ((C1 = "10") AND (C2 = "00")) REPORT "Kembalian gagal jika memilih tiket 10K dengan pembayaran 20K" SEVERITY error;
		-- WAIT FOR CLK_PERIOD;
		-- ASSERT (O = T) REPORT "Tidak mengeluarkan tiket jika memilih tiket 10K dengan pembayaran 20K" SEVERITY error;
		-- WAIT FOR CLK_PERIOD * 2;
		-- -- tiket 15K, bayar 5K, 5K, 5K --
		-- T <= "11";
		-- M <= "00";
		-- WAIT FOR CLK_PERIOD;
		-- M <= "01";
		-- WAIT FOR CLK_PERIOD;
		-- M <= "01";
		-- WAIT FOR CLK_PERIOD;
		-- M <= "01";
		-- WAIT FOR CLK_PERIOD;

		-- ASSERT ((C1 = "00") AND (C2 = "00")) REPORT "Kembalian gagal jika memilih tiket 15K dengan pembayaran 5K, 5K, dan 5K" SEVERITY error;
		-- WAIT FOR CLK_PERIOD;
		-- ASSERT (O = T) REPORT "Tidak mengeluarkan tiket jika memilih tiket 15K dengan pembayaran 5K, 5K, dan 5K" SEVERITY error;
		-- WAIT FOR CLK_PERIOD * 2;
		-- -- tiket 15K, bayar 10K, 5K --
		-- WAIT FOR CLK_PERIOD * 2;
		-- T <= "11";
		-- M <= "00";
		-- WAIT FOR CLK_PERIOD;
		-- M <= "10";
		-- WAIT FOR CLK_PERIOD;
		-- M <= "01";
		-- WAIT FOR CLK_PERIOD;

		-- ASSERT ((C1 = "00") AND (C2 = "00")) REPORT "Kembalian gagal jika memilih tiket 15K dengan pembayaran 10K dan 5K" SEVERITY error;
		-- WAIT FOR CLK_PERIOD;
		-- ASSERT (O = T) REPORT "Tidak mengeluarkan tiket jika memilih tiket 15K dengan pembayaran 10K dan 5K" SEVERITY error;
		-- WAIT FOR CLK_PERIOD * 2;
		-- -- tiket 15K, bayar 20K --
		-- T <= "11";
		-- M <= "00";
		-- WAIT FOR CLK_PERIOD;
		-- M <= "11";
		-- WAIT FOR CLK_PERIOD;

		-- ASSERT ((C1 = "01") AND (C2 = "00")) REPORT "Kembalian gagal jika memilih tiket 15K dengan pembayaran 20K" SEVERITY error;
		-- WAIT FOR CLK_PERIOD;
		-- ASSERT (O = T) REPORT "Tidak mengeluarkan tiket jika memilih tiket 15K dengan pembayaran 20K" SEVERITY error;
		-- WAIT FOR CLK_PERIOD * 2;

		WAIT;
	END PROCESS;
END bench;