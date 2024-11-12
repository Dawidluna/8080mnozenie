    ORG 800H
    LXI H,TEKST_PIERWSZA
    RST 3
    CALL WPROWADZ_LICZBE
    MOV B,H
    LXI H,TEKST_DRUGA
    RST 3
    CALL WPROWADZ_LICZBE
    MOV C,H
    MVI A,0             ;reset rejestrów A i D
    MVI D,0             
MNOZENIE 
    ADD B               ;dodanie mnożnika do akumulatora
    JC  PRZENIESIENIE   ;skok jeśli wartość w akumulatorze przekroczyła 255
POWROT_MNOZENIE
    DCR C               ;zmniejszenie mnożnej o 1
    JNZ MNOZENIE        ;ponawianie dodawania mnożnika, aż mnożna wyniesie 0
    MOV E,A             ;przeniesienie reszty wyniku do rejestru E
    JMP POMNOZONO
PRZENIESIENIE
    INR D               ;dodajemy 1 do licznika wielokrotności 256 wyniku
    JMP POWROT_MNOZENIE

POMNOZONO               ;wywołujemy funkcję obliczającą i wypisującą cyfry dla kolejnych cyfr wyniku
    LXI H,TEKST_WYNIK
    RST 3
    MVI L,0             ;tu przechowywać będziemy informację o tym, czy wypisana już została pierwsza nie-zerowa cyfra wyniku
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

WPROWADZ_LICZBE
    MVI H,0             ;zerowanie rejestru H, w którym przechowywana będzie liczba
    RST 2               ;użytkownik wprowadza znak
    SUI 48              ;korekcja wprowadzonej cyfry
    MOV H,A             ;przesunięcie pierwszej cyfry do rejestru H
WPROWADZ_CYFRE
    RST 2               ;użytkownik wprowadza znak
    CPI 13              ;sprawdzenie, czy użytkownik kliknął enter bez wprowadzania cyfry
    JZ POMINIECIE       ;jeśli tak, to zakończ wprowadzanie liczby
    SUI 48              ;korekcja wprowadzonej cyfry            
    MOV D,A             ;tymczasowo przechowujemy wprowadzoną cyfrę w rejestrze D
    MOV A,H             ;przesuwamy dotychczasową liczbę z rejestru H do akumulatora w celu pomnożenia przez 10
    MVI L,9             ;licznik ile razy musimy do siebie jeszcze dodać liczbę
MNOZENIE_10
    ADD H               
    DCR L               ;zmniejszenie licznika
    JNZ MNOZENIE_10     ;jeśli nie jest równy 0, to todajemy dalej
    ADD D               ;dodajemy do pomnożonej liczby tę, którą przechowaliśmy w rejestrze D
    MOV H,A             ;przekazujemy liczbę do rejestru H
    JMP WPROWADZ_CYFRE  ;przechodzimy do wprowadzania kolejnej cyfry

OBLICZ_CYFRE
    STC                 ;ustawianie flagi przesunięcia jako 1
    CMC                 ;negowanie flagi w celu wyzerowania
    MVI H,0             ;zerowanie H, tu będziemy przechowywać cyfrę wyniku
INKR_CYFRE  
    MOV A,D
    SUB B               ;porównujemy najbardzie znaczące bajty wyniku i kolejnej wielokrotności 10
    JC WYPISZ_CYFRE     ;jeśli bajt wyniku jest mniejszy, przechodzimy do wypisywania cyfry
    JZ POR_DRUGI_BAJT   ;jeśli są takie same, sprawdzamy mniej znaczący bajt
POWROT_KONWERSJA        ;zmniejszamy wynik o wielokrotność 10
    MOV A,E
    SUB C               ;najpierw odejmujemy mniej znaczący bajt
    MOV E,A
    MOV A,D             
    SBB B               ;teraz bardziej znaczący, musimy uwzględnić przeniesienie
    MOV D,A
    INR H               ;zwiększamy cyfrę, którą chcemy wypisać o 1
    JMP INKR_CYFRE
POR_DRUGI_BAJT
    MOV A,E
    SUB C
    JNC POWROT_KONWERSJA
WYPISZ_CYFRE
    MOV A,L
    CPI 0               ;sprawdź, czy to nie jest pierwsza cyfra
    MOV A,H
    JNZ WYPISZ
    CPI 0
    JZ POMINIECIE       ;nie wypisuj na początku zer
WYPISZ
    MVI L,1             ;pierwsza cyfra została już wypisana
    ADI 48              ;korekcja - wypisany zostanie znak ASCII
    RST 1
POMINIECIE
    RET

TEKST_WYNIK DB 10,13,'Wynik: @'
TEKST_PIERWSZA DB 'Podaj pierwsza liczbe (0-255): @'
TEKST_DRUGA DB 10,13,'Podaj druga liczbe (0-255): @'