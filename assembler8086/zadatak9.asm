;rad sa nizom
.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program

.data ;Cuvamo podatke
niz1 db 97, 98, 99, 100, 101, 102, 103, 104 ;Prvi niz od 8 bajtova (slova od 'a' do 'h')
niz2 db 10 dup(?) ;Drugi niz koji ima 10 praznih (neinicijalizovanih) mjesta

.code ;Dio gdje pisemo kod

main: ;Glavni dio programa

    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

;kopiranje nizova

    mov bx, 0 ;Postavljamo bx na 0, on ce nam sluziti kao indeks (pozicija) u nizu
    mov ah, 2 ;Ova linija je ovdje visak jer se ah ne koristi u prvoj petlji, ali ne smeta

pocetak: ;Pocetak petlje za kopiranje

    cmp bx, 8 ;Gledamo da li je indeks bx stigao do 8 (posto niz1 ima 8 elemenata, od 0 do 7)
    je kraj ;Ako jeste, iskopirali smo sve i iskacemo iz petlje

    mov al, niz1[bx] ;Uzimamo element iz niz1 sa pozicije bx i stavljamo ga u al registar
    mov niz2[bx], al ;Taj isti element iz al registra upisujemo u niz2 na istu poziciju bx    
    
    add bx, 1 ;Povecavamo indeks bx za 1 da predjemo na sledeci element u nizu
    jmp pocetak ;Skaci nazad na pocetak petlje

kraj: ;Kraj prve petlje

;stampa niza

    mov bx, 0 ;Resetujemo indeks bx na 0 da bismo krenuli od pocetka niz2
    mov ah, 2 ;DOS funkcija 2 za stampanje jednog karaktera (pripremamo je prije petlje)

pocetak1: ;Pocetak petlje za stampanje

    cmp bx, LENGTH niz2 ;Uporedjujemo bx sa ukupnom duzinom niz2 (sto je 10)
    je kraj1 ;Ako je bx stigao do 10, odstampali smo cijeli niz i idemo na kraj

    mov dl, niz2[bx] ;Uzimamo karakter iz niz2 sa pozicije bx i stavljamo ga u dl za stampu
    int 21h ;Prekid koji zapravo ispisuje taj karakter na ekran
    
    add bx, 1 ;Povecavamo indeks bx za 1 da predjemo na sledeci karakter
    jmp pocetak1 ;Skaci nazad na pocetak druge petlje

kraj1: ;Kraj cijelog posla i izlaz

    mov ah, 4ch ;Upisujemo 4ch za regularan izlaz iz programa
    int 21h ;Prekid koji gasi program i vraca nas u DOS

end main ;Kraj cijelog koda