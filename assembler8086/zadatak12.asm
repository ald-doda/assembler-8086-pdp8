; provjera da li je broj prost

.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program
.data ;Cuvamo podatke
    a dw 18 ;Broj koji provjeravamo (16-bitna rijec)
    prost_msg db 'Broj je prost$' ;Poruka ako je broj prost
    slozen_msg db 'Broj nije prost$' ;Poruka ako broj nije prost
.code ;Dio gdje pisemo kod

;PROCEDURA ZA STAMPANJE BROJA
print PROC ;stampa ono sto se nalazi u ax reg

    cmp ax, 0 ;Provjeravamo da li je broj u ax veci od nule
    jg else1 ;Ako jeste pozitivan, preskacemo pretvaranje i idemo na 'else1'
    
    ; Ako je broj negativan, pretvaramo ga u pozitivan za stampu
    mov cx, -1 ;Stavljamo -1 u cx
    imul cx ;Mnozimo ax sa -1 da skinemo minus (ax postaje pozitivan)
    mov bx, ax ;Sklanjamo taj pozitivan broj u bx

    add dl, 2dh ;2Dh je ASCII kod za znak minus ('-'). Pripremamo ga za stampu
    mov ah, 2 ;DOS funkcija za ispis jednog karaktera
    int 21h ;Prekid koji stampa znak minus ispred broja
    jmp petlja1 ;Skacemo direktno na petlju za stampanje cifara

    else1:
    mov bx, ax ;Ako je broj odmah bio pozitivan, samo ga prepisujemo u bx

    petlja1: ;Petlja koja kruni broj i stampa cifru po cifru (unazad)
        mov ax, bx ;Vracamo broj u ax
        mov cx, 10 ;Djelilac je 10
        mov dx, 0 ;Cistimo dx prije dijeljenja
        idiv cx ;Dijelimo ax sa 10 (kolicnik u ax, ostatak u dx)
        mov bx, ax ;Cuvamo kolicnik u bx za sledeci krug

        add dl, 48 ;48 je ASCII kod za '0'. Pretvaramo ostatak iz dl u karakter
        mov ah, 2 ;DOS funkcija za ispis karaktera
        int 21h ;Prekid koji ispisuje cifru na ekran

        cmp bx, 0 ;Gledamo da li nam je ostalo jos kolicnika za dijeljenje
        jg petlja1 ;Ako je kolicnik veci od 0, idemo opet u petlju za sledecu cifru

    ret ;Povratak iz procedure print
    
print ENDP

;PROCEDURA ZA PROVJERU PROSTOG BROJA
prost PROC 
    ;provjerava da li je ax prost
    ;rezultat smjesta u ax 
    ; 1 prost
    ; 0 slozen

    mov bx, 2 ;Krecemo provjeru dijeljenja od broja 2 (prvi potencijalni djelilac)
    mov cx, ax ;Sklanjamo nas broj iz ax u cx da nam se ne pokvari tokom mnozenja i dijeljenja

    petlja2: ;Glavna petlja za testiranje djeljivosti
        mov ax, bx ;Stavljamo trenutni djelilac u ax
        imul ax ;Mnozimo bx sa samim sobom (ax = bx * bx) - provjera kvadratnog korijena

        cmp ax, cx ;Uporedjujemo (bx * bx) sa nasim brojem u cx
        jg return_prost ;Ako je kvadrat djelioca veci od broja, znaci da nema djelioca i broj je PROST!

        mov ax, cx ;Vracamo nas broj u ax da ga podijelimo
        mov dx, 0 ;Cistimo gornji dio registra
        idiv bx ;Dijelimo nas broj sa trenutnim djeliocem u bx

        cmp dx, 0 ;Gledamo ostatak dijeljenja (dx)
        je return_slozen ;Ako je ostatak 0, broj je djeljiv sa bx, sto znaci da je SLOZEN!

        inc bx ;Ako nije djeljiv, povecavamo djelilac za 1 (testiramo sledeci broj)
        jmp petlja2 ;Idemo ponovo u petlju


    return_prost:
        mov ax, 1 ;U ax upisujemo 1 (kod za PROST broj)
        ret ;Vracamo se nazad u main
    
    return_slozen:
        mov ax, 0 ;U ax upisujemo 0 (kod za SLOZEN broj)
        ret ;Vracamo se nazad u main
prost ENDP

;GLAVNI PROGRAM
main:
    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

    mov ax, a ;Ucitavamo nas broj (18) u ax registar
    call prost ;Pozivamo proceduru 'prost' da ga testira

    cmp ax, 0 ;Gledamo sta nam je funkcija vratila u ax (0 ili 1)
    je print_slozen ;Ako je vratila 0, skaci na dio koji ispisuje da je broj slozen

        ; Ako je vratila 1, izvrsava se ovaj dio (prost)
        mov dx, OFFSET prost_msg ;Uzimamo adresu poruke da je broj prost
        mov ah, 9 ;DOS funkcija 9 za ispis cijelog stringa
        int 21h ;Prekid koji ispisuje 'Broj je prost'

        jmp retun_main ;Preskacemo else dio i idemo na izlaz
        
    print_slozen: ; Else dio (ako je broj slozen)

        mov dx, OFFSET slozen_msg ;Uzimamo adresu poruke da broj nije prost
        mov ah, 9 ;DOS funkcija 9 za ispis cijelog stringa
        int 21h ;Prekid koji ispisuje 'Broj nije prost'

    retun_main: ;Kraj programa
        mov ax, 4c00h ;Konstrukcija koja radi isto sto i mov ah, 4ch (prekida program bez greske)
        int 21h ;Konacan prekid koji gasi program
end main ;Kraj cijelog koda