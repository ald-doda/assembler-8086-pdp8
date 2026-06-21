;rad sa nizom
.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod (fali ti tacka ispred model u tvom kodu, dodaj je: .model small)

.stack ;Rezervisano mjesto za program

.data ;Cuvamo podatke
    niz db 10 dup(?)  ;Prvi niz od 10 praznih bajtova
    niz2 db 10 dup(?) ;Drugi niz od 10 praznih bajtova koji ce primiti kopiju
    a db 97           ;ASCII vrijednost za malo slovo 'a'
    nl db 10          ;ASCII vrijednost za Line Feed (novi red)

.code ;Dio gdje pisemo kod

main: ;Glavni dio programa
    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi
    
    mov bx, 0 ;Postavljamo indeks bx na 0 za prvu petlju
    
;1. PETLJA: PUNJENJE PRVOG NIZA
pocetak:
    
    cmp bx, LENGTH niz ;Gledamo da li je indeks bx stigao do kraja niza (do 10)
    je kraj ;Ako jeste, napunili smo niz i iskacemo van

    mov ah, a ;Ucitavamo slovo 'a' (97) u ah registar
    mov niz[bx], ah     ;niz[i]=a -> Upisujemo to slovo u niz na poziciju bx
    
    inc bx ;Povecavamo indeks za 1 da predjemo na sledece polje

    jmp pocetak ;Vrati se na pocetak prve petlje
    
kraj:

    mov bx, 0 ;Resetujemo indeks bx na 0 za stampanje
    
; 2. PETLJA: STAMPANJE PRVOG NIZA SA NOVIM REDOM
petlja_stampa:

    cmp bx, LENGTH niz ;Provjeravamo jesmo li odstampali svih 10 elemenata
    je kraj_stampa ;Ako jesmo, idemo dalje

    mov dl, niz[bx] ;Uzimamo slovo iz niza i stavljamo u dl
    mov ah, 2 ;DOS funkcija za ispis karaktera
    int 21h ;Ispisujemo slovo 'a'

    mov dl, nl ;U dl stavljamo vrijednost 10 (novi red)
    mov ah, 2 ;Spreman DOS poziv
    int 21h ;Prekid koji spusta kursor u novi red (zato ce slova ici jedno ispod drugog)
    
    inc bx ;Idemo na sledeci element
    jmp petlja_stampa ;Vrati se na pocetak stampe

kraj_stampa:

    mov bx, 0 ;Resetujemo indeks bx na 0 za kopiranje
    
;3. PETLJA: KOPIRANJE NIZA1 U NIZ2
petlja_kopija:

    cmp bx, LENGTH niz ;Gledamo jesmo li prošli kroz cijeli niz
    je kraj_kopija ;Ako jesmo, kopiranje je zavrseno
    
    mov ah, niz[bx]    ;Uzimamo element iz prvog niza preko indeksa bx
    mov niz2[bx], ah   ;Prebacujemo taj isti element u niz2 na istu poziciju bx
    
    inc bx ;Pomjeramo indeks za jedno mjesto unaprijed
    jmp petlja_kopija ;Vrati se na kopiranje

kraj_kopija:

    mov bx, 0    ;Resetujemo indeks bx na 0 za zadnju stampu
    
;4. PETLJA: STAMPANJE KOPIRANOG NIZA (SVE U JEDNOM REDU)
stampa_kopija:
    
    cmp bx, LENGTH niz2 ;Gledamo jesmo li odstampali cijeli niz2 (svih 10)
    je kraj_stampa_kopija ;Ako jesmo, gotov je program
    
    mov dl, niz2[bx] ;Uzimamo slovo iz niz2 u dl
    mov ah, 2 ;Sprema funkciju za ispis
    int 21h ;Stampa slovo (ovdje nema 'nl', pa ce se ispisati spojeno u istom redu)
    
    inc bx ;Idemo na sledece slovo
    jmp stampa_kopija ;Vrati se na stampu kopije
    
kraj_stampa_kopija:

    ; Bezbjedno gasenje programa
    mov ah, 4ch
    int 21h
    
end main ;Kraj cijelog koda