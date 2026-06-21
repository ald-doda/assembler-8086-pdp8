;if konstrukcija
.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod (fali tacka: .model)

.stack ;Rezervisano mjesto za program


.data ;Cuvamo podatke
x db 2 ;8-bitna promenljiva x = 2
y db 45 ;8-bitna promenljiva y = 45
z db ? ;Ovdje cemo sacuvati rezultat

.code ;Dio gdje pisemo kod

main:

    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi
    
    ;PROVJERA PRVOG USLOVA: x + 4 == 2y
    mov ah, x ;Ucitavamo x u ah registar (ah = 2)
    add ah, 4    ; ah <- ah+4 -> ah postaje 2 + 4 = 6
    
    mov bh, y ;Ucitavamo y u bh registar (bh = 45)
    add bh, bh   ; bh <- bh + bh -> Sabiramo ga sa samim sobom, sto je y * 2 (bh = 45 + 45 = 90)
    
    cmp ah, bh ;Uporedjujemo ah (6) i bh (90)
    je inace ;Ako su jednaki, uslov pada i skacemo na 'inace' (6 != 90, pa idemo dalje)
    
    ;PROVJERA DRUGOG USLOVA: x >= 10
    mov ah, x ;Ponovo ucitavamo x u ah (ah = 2)
    cmp ah, 10 ;Uporedjujemo x sa 10
    jge inace ;Jump if Greater or Equal - ako je x veci ili jednak 10, uslov pada i skaci na 'inace' (2 nije >= 10, idemo dalje)
    
    ;THEN DIO (izvrsava se ako su oba uslova prosla)
    mov ah, x ;Ucitavamo x (2)
    add ah, y ;Dodajemo y (45) na to -> ah = 2 + 45 = 47
    mov z, ah       ; z =  x + y -> Upisujemo 47 u promenljivu 'z'
    
    ; Ispis slova 'b' na ekran
    mov dl, 98 ;98 je ASCII kod za malo slovo 'b'
    mov ah, 2 ;DOS funkcija 2 za ispis jednog karaktera iz dl
    int 21h ;Prekid koji stampa 'b'
    
    jmp kraj_if ;Preskacemo 'else' (inace) dio i idemo pravo na kraj
    
inace: ;ELSE DIO
    
    ; Ispis slova 'a' na ekran
    mov dl, 97 ;97 je ASCII kod za malo slovo 'a'
    mov ah, 2 ;DOS funkcija za ispis karaktera
    int 21h ;Prekid koji stampa 'a'
    
    mov ah, 0 ;Spremamo nulu u ah
    mov z, ah   ;z=0 -> Postavljamo z na 0 ako je neki uslov skocio ovdje
  
kraj_if: ;GASENJE PROGRAMA
    
    mov ah, 4ch ;Regularan izlaz iz programa
    int 21h
    
end main ;Kraj cijelog koda