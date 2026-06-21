; urediti tri broja po velicini

.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program
.data ;Cuvamo podatke
    a dw 15 ;napravili promenljivu na data segm sa vrijednoscu 15
    b dw -7 ;druga promenljiva, vrijednost -7
    c dw 9  ;treca promenljiva, vrijednost 9
.code ;Dio gdje pisemo kod

; PROCEDURA ZA STAMPANJE BROJA
print PROC ;stampa ono sto se nalazi u ax reg

    cmp ax, 0 ;Gledamo da li je broj u ax veci od nule
    jg else1 ;Ako jeste pozitivan, preskaci pretvaranje i skaci na 'else1'
    
    ; Ako je broj negativan, pretvaramo ga u pozitivan i stampamo minus
    mov cx, -1 ;Spremamo -1 u cx
    imul cx ;Mnozimo ax sa -1 (skidamo minus da postane pozitivan)
    mov bx, ax ;Sklanjamo taj pozitivan broj u bx

    add dl, 2dh ;2Dh je ASCII kod za znak minus ('-')
    mov ah, 2 ;DOS funkcija za ispis jednog karaktera
    int 21h ;Prekid koji ispisuje '-' ispred broja
    jmp petlja1 ;Skaci direktno na petlju za stampanje cifara

    else1:
    mov bx, ax ;Ako je broj pozitivan, samo ga prebaci u bx

    petlja1: ;Krunjenje broja zdesna nalijevo
        mov ax, bx ;Vracamo broj u ax za dijeljenje
        mov cx, 10 ;Djelilac je 10
        mov dx, 0 ;Cistimo gornji dio registra
        idiv cx ;Dijelimo sa 10 (kolicnik je u ax, ostatak u dx)
        mov bx, ax ;Cuvamo kolicnik u bx za sledeći krug

        add dl, 48 ;48 je ASCII '0', pretvaramo ostatak iz dl u karakter
        mov ah, 2 ;DOS funkcija za ispis
        int 21h ;Prekid koji ispisuje cifru (ovdje ce ih opet pisati unazad)

        cmp bx, 0 ;Gledamo ima li jos kolicnika
        jg petlja1 ;Ako ima, vrti petlju opet

    ret ;Povratak iz procedure print
    
print ENDP

;PROCEDURA ZA ZAMJENU VRIJEDNOSTI (SWAP)
swap PROC
    cmp ax, bx ;Uporedjujemo vrijednosti u ax i bx
    jl return_swap ;Jump if Less - ako je ax vec manji od bx, sve je u redu, skaci na izlaz
        
        ; Ako je ax veci od bx, radimo zamjenu mjesta preko cx registra
        mov cx, ax ;Sklanjamo ax u cx
        mov ax, bx ;Stavljamo bx u ax
        mov bx, cx ;Sadrzaj iz cx (stari ax) stavljamo u bx

    return_swap:
    ret ;Povratak iz procedure swap
swap ENDP

;GLAVNI PROGRAM
main:
    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

    ; 1. KORAK: Sredjujemo odnos između a i b
    mov ax, a ;Ucitavamo a u ax
    mov bx, b ;Ucitavamo b u bx
    call swap ;Zovemo swap (ako je a > b, zamijenice im mjesta u registrima)
    mov a, ax ;Vracamo (sada potencijalno manju) vrijednost u a
    mov b, bx ;Vracamo (sada potencijalno veću) vrijednost u b

    ; 2. KORAK: Sredjujemo odnos između a i c
    mov ax, a ;Ucitavamo trenutno a u ax
    mov bx, c ;Ucitavamo c u bx
    call swap ;Zovemo swap (nakon ovoga u ax/promenljivoj 'a' je sigurno najmanji od sva tri broja)
    mov a, ax ;Vracamo vrijednost u a
    mov c, bx ;Vracamo vrijednost u c

    ; 3. KORAK: Sredjujemo preostala dva broja (b i c)
    mov ax, b ;OVDJE IMA MALA LOGICKA GRESKA U REGISTRIMA! U mom kodu pise mov ax, c pa mov bx, b.
    mov bx, c ;Posto moja procedura 'swap' ocekuje da je PRVI broj u ax, a DRUGI u bx, moram ucitati b u ax, a c u bx!
    call swap ;Zovemo swap da poslozi b i c kako treba
    mov b, ax ;Vracamo sortiran manji u b
    mov c, bx ;Vracamo sortiran veci u c

    ;ISPIS REZULTATA
    
    ; Stampa broja 'a' (najmanji)
    mov ax, a ;Ucitavamo a u ax
    call print ;Stampamo ga

    ; Novi red
    mov dx, 10 ;10 je ASCII kod za Line Feed (novi red)
    mov ah, 2 ;DOS funkcija za ispis karaktera
    int 21h ;Prekid koji spusta kursor u novi red

    ; Stampa broja 'b' (srednji)
    mov ax, b ;Ucitavamo b u ax
    call print ;Stampamo ga

    ; Novi red
    mov dx, 10 ;Ponovo spremamo novi red
    mov ah, 2
    int 21h ;Prekid pomjera kursor dole

    ; Stampa broja 'c' (najveci)
    mov ax, c ;Ucitavamo c u ax
    call print ;Stampamo ga

    ; Gasenje programa
    mov ax, 4c00h ;Spremamo izlazni kod
    int 21h ;Prekid koji gasi program
end main ;Kraj cijelog koda