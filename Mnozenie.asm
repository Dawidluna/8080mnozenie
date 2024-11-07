	 ORG 800H  
	 LXI H,PIERWSZA_LICZBA  
	 RST 3  
	 CALL INPUT_NUMBER  
	 STA LICZBZMIENNA  
	 MVI C,1  
	 LXI H,DRUGA_LICZBA  
	 RST 3  
	 CALL INPUT_NUMBER  
	 LDA LICZBZMIENNA  
	 MVI A,0 ;reset rejestrów A i D  
	 MVI D,0  
MNOZENIE  
	 ADD B ;dodanie mno¿nika do akumulatora  
	 JC PRZENIESIENIE ;skok jeœli wartoœæ w akumulatorze przekroczy³o 255  
POWROT_MNOZENIE  
	 DCR C ;zmniejszenie mno¿nej o 1  
	 JNZ MNOZENIE ;ponawianie dodawania mno¿nika, a¿ mno¿na wyniesie 0  
	 MOV E,A ;przeniesienie reszty wyniku do rejestru E  
	 JMP POMNOZONO  
PRZENIESIENIE  
	 INR D ;dodajemy 1 do licznika wielokrotnoœci 256 wyniku  
	 JMP POWROT_MNOZENIE  
POMNOZONO ;wywo³ujemy funkcjê obliczaj¹c¹ i wypisuj¹c¹ cyfry dla kolejnych cyfr wyniku  
	 LXI H,TEKST_WYNIK  
	 RST 3  
	 MVI L,0 ;tu przechowywaæ bêdziemy informacjê o tym, czy wypisana ju¿ zosta³a pierwsza nie-zerowa cyfra wyniku  
	 LXI B,10000  
	 CALL OBLICZ_CYFRE  
	 LXI B,1000  
	 CALL OBLICZ_CYFRE  
	 LXI B,100  
	 CALL OBLICZ_CYFRE  
	 LXI B,10  
	 CALL OBLICZ_CYFRE  
	 MOV A,E  
	 ADI 48  
	 RST 1  
	 HLT  
OBLICZ_CYFRE  
	 STC ;ustawianie flagi przesuniêcia jako 1  
	 CMC ;negowanie flagi w celu wyzerowania  
	 MVI H,0 ;zerowanie H, tu bêdziemy przechowywaæ cyfrê wyniku  
INKR_CYFRE  
	 MOV A,D  
	 SUB B ;porównujemy najbardzie znacz¹ce bajty wyniku i kolejnej wielokrotnoœci 10  
	 JC WYPISZ_CYFRE ;jeœli bajt wyniku jest mniejszy, przechodzimy do wypisywania cyfry  
	 JZ POR_DRUGI_BAJT ;jeœli s¹ takie same, sprawdzamy mniej znacz¹cy bajt  
POWROT_KONWERSJA ;zmniejszamy wynik o wielokrotnoœæ 10  
	 MOV A,E  
	 SUB C ;najpierw odejmujemy mniej znacz¹cy bajt  
	 MOV E,A  
	 MOV A,D  
	 SBB B ;teraz bardziej znacz¹cy, musimy uwzglêdniæ przeniesienie  
	 MOV D,A  
	 INR H ;zwiêkszamy cyfrê, któr¹ chcemy wypisaæ o 1  
	 JMP INKR_CYFRE  
POR_DRUGI_BAJT  
	 MOV A,E  
	 SUB C  
	 JNC POWROT_KONWERSJA  
WYPISZ_CYFRE  
	 MOV A,L  
	 CPI 0 ;sprawdŸ, czy to nie jest pierwsza cyfra  
	 MOV A,H  
	 JNZ WYPISZ  
	 CPI 0  
	 JZ POMINIECIE ;nie wypisuj na pocz¹tku zer  
WYPISZ  
	 MVI L,1 ;pierwsza cyfra zosta³a ju¿ wypisana  
	 ADI 48 ;korekcja - wypisany zostanie znak ASCII  
	 RST 1  
POMINIECIE  
	 RET  
INPUT_NUMBER  
	 RST 2  
	 MOV B,A  
	 RET  
PIERWSZA_LICZBA 	 DB 'Podaj pierwsza liczbe: @'        
DRUGA_LICZBA 	 DB 10,13,'Wynik: @'   
TEKST_WYNIK 	 DB 10,13,'Wynik: @'   
LICZBZMIENNA 	 DB 0        
