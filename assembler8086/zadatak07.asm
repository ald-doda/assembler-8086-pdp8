;stampam abeccedu
.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program

.data ;Cuvamo podatke
a db 97 ;Pocetna ASCII vrijednost za malo slovo 'a'
b db 26 ;Ukupan broj slova u abecedi koji nam sluzi kao brojac za petlju

.code ;Dio gdje pisemo kod
main: ;Glavni dio programa
    
    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

    mov dl, a ;Ubacujemo pocetno slovo (97) u dl registar, jer DOS odatle uzima karakter za stampu
    mov bl, b ;U bl registar stavljamo broj 26 koji ce nam se smanjivati u svakom krugu
    mov ah, 2 ;Sistemska funkcija 2 za stampanje jednog karaktera iz dl

pocetak: ;Pocetak petlje za stampanje cijele abecede

    cmp bl, 0 ;Gledamo da li je nas brojac u bl pao na nulu
    jz kraj ;Ako jeste (brojac je 0), odstampali smo svih 26 slova i idemo na izlaz 

    int 21h ;Prekid koji zapravo ispisuje trenutno slovo iz dl registra na ekran

    add dl, 1 ;Povecavamo ASCII vrijednost u dl za 1 (prelazimo na sledece slovo: 'a' postaje 'b', 'b' postaje 'c'...)
    sub bl, 1 ;Smanjujemo brojac u bl za 1 (ostalo nam je jos toliko slova za stampu)
    jmp pocetak ;Skaci nazad na pocetak petlje za sledeci karakter

kraj: ;Kraj petlje i gasenje programa

    mov ah, 4ch ;Upisujemo 4ch za regularan izlaz iz programa
    int 21h ;Prekid koji gasi program i vraca nas u DOS

end main ;Kraj cijelog koda