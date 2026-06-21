; void print(int a) {
;     if(a == 0) return;
;     print(a/10);
;     printf("%d", a%10);
; }

.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program
.data ;Cuvamo podatke
    arr dw 15, 20, 30, 40, -25, 75, 80 ;Niz 16-bitnih brojeva (ukupno 7 elemenata, tj. 14 bajtova)
    arr1 db 10 dup(?) ;Rezervisan niz koji se ne koristi ovdje
    i dw 0 ;Indeks (brojac) koji ce nam setati kroz niz za po 2 bajta
.code ;Dio gdje pisemo kod

;REKURZIVNA PROCEDURA ZA POZITIVNE BROJEVE
print_pos PROC a: WORD ;procedura koja stampa pozitivan broj rekurzivno
    
    push bp ;Cuvamo stari Base Pointer na stek
    mov bp, sp ;Pravimo stack frame za pristup argumentu 'a'

    cmp a, 0 ;Provjeravamo bazni uslov rekurzije (da li je broj dosao do 0)
    je return_print_pos ;Ako jeste nula, prekidamo dalju rekurziju i vracamo se nazad

    mov ax, a ;Ucitavamo trenutnu vrijednost 'a' u ax
    mov dx, 0 ;Cistimo dx prije dijeljenja
    mov cx, 10 ;Djelilac je 10
    div cx ;Dijelimo ax sa 10 (kolicnik ide u ax, ostatak/cifra ide u dx)

    push dx ;Guramo ostatak (cifru) na stek da je sacuvamo dok se dublja rekurzija ne zavrsi 
    
    push ax ;Guramo kolicnik na stek kao argument za sledeci, dublji poziv
    call print_pos ;REKURZIVNI POZIV - funkcija zove samu sebe sa smanjenim brojem

    pop dx ;Kada se dublja funkcija vrati, skidamo nasu sacuvanu cifru sa steka u dx
    add dx, '0' ;Pretvaramo tu cifru u ASCII karakter dodavanjem '0'
    mov ah, 2 ;DOS funkcija za ispis jednog karaktera
    int 21h ;Prekid koji zapravo ispisuje tu cifru na ekran
   
    return_print_pos:
        pop bp ;Vracamo stari Base Pointer
        ret 2 ;Zavrsavamo proceduru i cistimo 2 bajta argumenta sa steka

print_pos ENDP

;GLAVNA PROCEDURA ZA PRINT (UPRAVLJA ZNAKOM BROJA)
print PROC a: WORD
    
    push bp ;Cuvamo stari Base Pointer
    mov bp, sp ;Pravimo stack frame

    cmp a, 0 ;Gledamo da li je broj veci od nule
    jg call_print_pos ;Ako jeste pozitivan, skaci direktno na rekurziju

    cmp a, 0 ;Gledamo da li je broj bas nula
    je print_zero ;Ako jeste, skaci na poseban ispis za nulu

        ; --- AKO JE BROJ NEGATIVAN ---
        mov dx, '-' ;Stavljamo znak minus u dx
        mov ah, 2 ;DOS funkcija za stampu jednog karaktera
        int 21h ;Prekid koji odstampati '-' na ekran
        neg a ;Instrukcija NEG mijenja znak broju (pretvara npr. -25 u +25)
        jmp call_print_pos ;Sada kada je pozitivan, skaci na rekurziju

    print_zero: ; --- ISPIS NULE ---
        mov dx, '0' ;Pripremamo karakter nule
        mov ah, 2 ;DOS funkcija za ispis
        int 21h ;Stampa '0' na ekran
        jmp return_print ;Idemo na izlaz

    call_print_pos: ; --- POKRETANJE REKURZRE ---
        push a ;Guramo (sada sigurno pozitivan) broj na stek kao argument
        call print_pos ;Zovemo rekurzivnu proceduru da odradi posao


    return_print:
        pop bp ;Vracamo stari Base Pointer
        ret 2 ;Zavrsavamo proceduru i cistimo argument sa steka

    
print ENDP

;GLAVNI PROGRAM
main:
    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

    print_arr_loop: ;Petlja za prolazak kroz niz
    cmp i, 14 ;Posto niz ima 7 dw elemenata (7 * 2 = 14 bajtova), gledamo jesmo li stigli do kraja (indeks 14)
    je return_main ;Ako jesmo obradili sve bajtove, skaci na kraj programa

        mov bx, i ;Prebacujemo trenutni indeks 'i' u bx da mozemo adresirati niz
        mov ax, arr[bx] ;Uzimamo 16-bitni broj iz niza sa te pozicije i stavljamo ga u ax
        push ax ;Guramo taj broj na stek kao argument za proceduru 'print'
        call print ;Zovemo 'print' da odradi analizu znaka i rekurzivnu stampu

        ; Ispis razmaka izmedju brojeva
        mov dx, ' ' ;U dx stavljamo karakter razmaka (space)
        mov ah, 2 ;DOS funkcija za ispis karaktera
        int 21h ;Prekid koji stampa razmak na ekran

        add i, 2 ;OVDJE JE MALA ZAMKA: u mom kodu pise 'add i, 1'. Posto je niz 'dw' (2 bajta), moras skakati za po 2 bajta unaprijed! Popravi u 'add i, 2' da ne bi citao polovine brojeva!
        jmp print_arr_loop ;Skaci nazad na pocetak petlje za sledeci broj

    return_main:
    mov ah, 4ch ;Upisujemo 4ch za regularan izlaz iz programa
    int 21h ;Prekid koji gasi program i vraca nas u DOS
end main ;Kraj cijelog koda