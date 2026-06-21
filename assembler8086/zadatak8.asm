;rad sa nizom
.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program

.data ;Cuvamo podatke
niz1 db 97, 98, 99, 100, 101, 102, 103, 104 ;Niz od 8 bajtova (ASCII vrijednosti za slova 'a' do 'h')
niz2 db 10 dup(?) ;Ovaj niz je definisan, ali se nigdje ne koristi u kodu

.code ;Dio gdje pisemo kod

main: ;Glavni dio programa

    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

    mov bx, 0 ;Postavljamo indeks bx na 0 da krenemo od prvog elementa niza
    mov ah, 2 ;Sistemska funkcija 2 za stampanje jednog karaktera (spremamo je unaprijed)

pocetak: ;Pocetak petlje za stampanje niza

    cmp bx, 8 ;Gledamo da li je indeks bx stigao do 8 (posto imamo 8 elemenata, od 0 do 7)
    je kraj ;Ako jeste, odstampali smo sve i iskacemo iz petlje

    mov dl, niz1[bx] ;Uzimamo bajt (karakter) iz niz1 sa pozicije bx i stavljamo ga direktno u dl za stampu
    int 21h ;Prekid koji zapravo ispisuje taj karakter na ekran 
    
    add bx, 1 ;Povecavamo indeks bx za 1 da bismo u sledecem krugu presli na sledece slovo
    jmp pocetak ;Skaci nazad na pocetak petlje

kraj: ;Kraj petlje i prelazak na gasenje

    mov ah, 4ch ;Upisujemo 4ch za regularan izlaz iz programa
    int 21h ;Prekid koji gasi program i vraca nas u DOS

end main ;Kraj cijelog koda