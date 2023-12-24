
# MRT Ticketing Machine

Proyek MRT Ticketing Machine bertujuan untuk merancang dan mensimulasikan sebuah mesin penjualan tiket Mass Rapid Transit (MRT) yang efisien dan user-friendly. Mesin ini akan memfasilitasi proses pembelian tiket dengan menyediakan tiga opsi tiket dengan harga berbeda (5k, 10k, dan 15k). Penumpang akan dapat memilih tiket yang diinginkan dan melakukan pembayaran menggunakan pecahan uang tertentu (5k, 10k, 20k, 50k, 100k rupiah). Selain itu,  sistem juga diharapkan dapat melakukan error handling terhadap input yang tidak sesuai.

# Implementation

Ticketing machine ini memiliki 3 input dan akan menghasilkan 2 output, berikut penjelasan tiap portnya:
#### Input:
- CLK: Input clock untuk mengatur timing dan siklus program
- T: Input yang merepresentasikan tipe tiket yang bervariasi(5k, 10k, 15k)
- M: Input yang merepresentasikan uang yang diinput user untuk membayar tiket(1k, 2k, 5k, 10k, 20k, 50k, 100k)
#### Output:
- C: Output yang merepresentasikan kembalian dari hasil pembelian tiket
- O: Output yang merepresentasikan tiket yang telah dibeli, O hanya meneruskan input T di awal

# Code Explanation

- Entity Declaration: Declares an entity named Ticket_Machine with input ports CLK, T, and M, and output ports C and O. T, M, C, and O are vectors of specific sizes.
```
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
```

- Clock Process: A synchronous process triggered on the rising edge of the clock (CLK). Updates the present state (PS) with the next state (NS).
```
	sync_proc : PROCESS (CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN
			PS <= NS;
		END IF;
	END PROCESS;
```

-  Combinational Process: A process sensitive to changes in PS, M, and T. It contains the main state transition and control logic for the ticket machine
```
comb_proc : PROCESS (PS, M, T)
BEGIN
    -- Main state transition and control logic
END PROCESS;
```
- FSM implementation: There are 6 state in this project, including the idle state and the reset state.
```
CASE PS IS
    WHEN S0 => -- idle
    WHEN S1 => -- menunggu uang masuk
    WHEN S2 => -- Menambahkan uang ke total dalam 
    WHEN S3 => -- Mencek apakah uang dalam machine melebihi harga tiket.
    WHEN S4 => -- Melakukan perhitungan uang kembalian.
    WHEN S5 => -- Mencek apakah uang masih ada yang perlu dikembalikan.
    WHEN S6 => -- Reset
END CASE;
```
- Report Block: A block to report changes after the transaction occured.
```
FOR i IN 0 TO 3 LOOP
	REPORT "Change=" & INTEGER'image(changes_array(i));
END LOOP;
```
