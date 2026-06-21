.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program

.data ;Cuvamo podatke
x   dw 342
y   dw 23
z   dw 0
niz dw 10, 20, 30, 40, 50 ;Niz od 5 elemenata (svaki zauzima po 2 bajta, tj. dw)
n   dw 5 ;Promenljiva koja cuva duzinu niza

.code ;Dio gdje pisemo kod

; 1. POTPROGRAM KOME ARG PREDAJEMO PREKO REGISTRA AX (Ispis broja unazad)

stampa proc

    mov cx, 10  ; U cx stavljamo 10, jer cemo uzastopno dijeliti sa 10 da izvucemo cifre
    
stampa_petlja_pocetak:

    cmp ax, 0 ;Gledamo da li je broj u ax pao na nulu
    je stampa_petlja_kraj ;Ako jeste, odstampali smo sve cifre i izlazimo
    
    mov dx, 0   ; ODGOVOR: DA, OVO JE APSOLUTNO NEOPHODNO! Instrukcija 'div' dijeli 32-bitni broj sastavljen od dx:ax sa cx. Ako ne ocistis dx, u njemu ce ostati djubre od prethodne operacije i program ce ti ili puci (Divide Error) ili dati pogresan rezultat!
    div cx      ; Dijelimo dx:ax sa 10. Kolicnik se vraca u ax, a ostatak (cifra) u dx
    
    mov bx, ax  ; Privremeno sklanjamo kolicnik u bx jer nam ax treba slobodan za DOS prekid
    
    add dl, '0' ; Na ostatak (koji je u dl) dodajemo ASCII vrijednost '0' da dobijemo karakter
    mov ah, 2   ; DOS funkcija 2 za ispis jednog karaktera
    int 21h     ; Prekid koji ispisuje cifru na ekran (unazad)
    
    mov ax, bx  ; Vracamo kolicnik iz bx nazad u ax za sledeci krug dijeljenja
    jmp stampa_petlja_pocetak ;Skaci nazad na pocetak petlje

stampa_petlja_kraj:
    ret ;Povratak iz funkcije stampa
    
stampa endp

; 2. PREDAJA PREKO STEKA, FUNKCIJA RACUNA RAZLIKU (a - b)

razlika proc
arg a, b : word ; Pomoćna deklaracija parametara (ako tvoj asembler podrzava 'arg' direktivu)

    push bp         ; Cuvamo staru vrijednost za bp na stek da ne pokvarimo prethodno stanje
    mov bp, sp      ; Postavljamo bp da pokazuje na trenutni vrh steka (pravimo aktivacioni zapis)

    mov ax, [bp+4]       ; Prvi argument (a) se nalazi na [bp+4] jer su na steku redom: argumenti, pa povratna adresa (2 bajta) i sacuvani bp (2 bajta)
    sub ax, [bp+6]       ; Oduzimamo drugi argument (b) koji se nalazi na [bp+6]
    
    pop bp          ; Vracamo staru vrijednost registra bp sa steka
    ret             ; Povratak u main (rezultat razlike ostaje u ax)
    
razlika endp

; 3. PREDAVANJE NIZA BROJEVA: ADRESA PRVOG ELEMENTA + BROJ ELEMENATA
suma_niza proc
arg niz_pocetak, niz_koliko: word ; Formalni parametri na steku

    push bp ;Cuvamo stari bp
    mov bp, sp ;Pravimo stack frame
    
    mov ax, 0       ; Tu cemo sabirati elemente (suma = 0). Preko ax se vraca i rezultat funkcije
    mov cx, 0       ; Postavljamo brojac petlje i = 0
    mov bx, [bp+4]  ; GRESKA: U tvom kodu je pisalo 'mov bx, niz_pocetak'. Da bi program znao odakle da cita sa steka, moras ucitati adresu niza preko [bp+4]!
    
suma_niza_petlja_poc:

    cmp cx, [bp+6]  ; GRESKA: Umjesto fiksnog 'cmp cx, n', ovdje poredis sa proslijedjenom duzinom niza sa steka koja je na [bp+6] (niz_koliko)
    je suma_niza_petlja_kraj ;Ako smo obradili sve elemente, iskaci van
    
    add ax, [bx]    ; Dodajemo u sumu (ax) vrijednost 16-bitnog elementa na koji pokazuje bx
    add bx, 2       ; Pomjeramo pointer bx za 2 bajta unaprijed jer radimo sa 'dw' (Word) nizom!
    inc cx          ; Povecavamo brojac petlje za 1
    jmp suma_niza_petlja_poc ;Idemo u sledeci krug sabiranja

suma_niza_petlja_kraj:    
    
    pop bp ;Vracamo stari bp
    ret 4  ; NAPOMENA: Posto smo na stek gurnuli 2 argumenta (duzina i adresa = 4 bajta), koristimo 'ret 4' da funkcija sama ocisti stek pri povratku!
    
suma_niza endp

; GLAVNI PROGRAM

main:
    
    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi
    
    ;Kod za funkciju 'razlika' (trenutno zakomentarisan, ali ispravan)
    ;mov ax, x
    ;mov bx, y
    ;push bx ;Guramo na stek prvo drugi argument (y)
    ;push ax ;Zatim guramo prvi argument (x) - argumenti idu u obrnutom redoslijedu
    ;call razlika
    ;mov z, ax ;z = razlika(x, y)
    
    ;Kod za funkciju 'suma_niza'
    lea ax, niz         ; Load Effective Address - ucitavamo pocetnu memorijsku adresu niza u ax
    mov bx, n           ; Ucitavamo broj elemenata (5) u bx
    push bx             ; Prvo guramo na stek broj elemenata (bice na [bp+6] unutar funkcije)
    push ax             ; Zatim guramo adresu niza (bice na [bp+4] unutar funkcije)
    call suma_niza      ; Pozivamo funkciju za sabiranje
    mov z, ax           ; Rezultat sume iz registra ax (10+20+30+40+50 = 150) prepisujemo u z
    
    ;Ispis rezultata
    mov ax, z ;Ucitavamo sumu (150) u ax
    call stampa ;Zovemo stampu (ispisace na ekranu '051' jer stampa unazad)
    
    ; Gasenje programa
    mov ah, 4ch
    int 21h

end main ;Kraj cijelog koda