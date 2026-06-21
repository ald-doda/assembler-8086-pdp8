; do {
;     c = x % 10
;     x = x / 10;
;     printf("%d", c);
; } while(x > 0);

; y1 = -16a -20b -24c
; y2 = a^2 + ab +ac
; y3 = (y1^2 + 1) / (y2^2 + 1)

.model small ;2 segmeta po 64 kb
.stack
.data
    a dw 5 ;napravili promenljivu na data segm sa vrijednoscu 5
    b dw -7 ;druga promenljiva, vrijednost -7
    c dw 9  ;treca promenljiva, vrijednost 9
    y1 dw ? ;nismo inicij vrijednost, ovdje ide rezultat za y1
    y2 dw ? ;ovdje ide rezultat za y2
    y3 dw ? ;ovdje ide konacan rezultat za y3
    aa dw ? ;cuva a*a (definisano, ali se ne koristi)
    t1 db 'y1 = $' ;Tekstualni string za ispis rezultata y1
    t2 db 'y2 = $' ;Tekstualni string za ispis rezultata y2
    t3 db 'y3 = $' ;Tekstualni string za ispis rezultata y3
.code

;PROCEDURA ZA STAMPANJE BROJA
print PROC ;stampa ono sto se nalazi u ax reg

    cmp ax, 0 ;Provjera znaka broja u ax
    jg else1 ;Ako je pozitivan, skaci na else1
    
    ; Pretvaranje negativnog broja u pozitivan radi stampe
    mov cx, -1
    imul cx ;Mnozimo sa -1
    mov bx, ax ;Sklanjamo pozitivan rezultat u bx

    add dl, 2dh ;2Dh je ASCII kod za znak minus ('-')
    mov ah, 2
    int 21h ;Ispisujemo minus na ekran
    jmp petlja1 ;Skaci na petlju za cifre

    else1:
    mov bx, ax ;Ako je pozitivan, samo prepisi u bx

    petlja1: ;Krunjenje broja zdesna nalijevo
        mov ax, bx
        mov cx, 10
        mov dx, 0
        idiv cx ;Dijelimo sa 10 (kolicnik u ax, ostatak u dx)
        mov bx, ax ;Cuvamo kolicnik za sledeci krug

        add dl, 48 ;48 je ASCII '0', pretvaramo ostatak u karakter
        mov ah, 2
        int 21h ;Stampa cifru (unazad)

        cmp bx, 0
        jg petlja1 ;Vrti ako ima jos cifara

    ret 
    
print ENDP

;GLAVNI PROGRAM
main:
    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

    ;RACUNANJE y2 = a^2 + ab + ac
    mov ax, a ; ax = a (5)
    imul ax    ; mnozi registar ax sa samim sobom (ax = 5 * 5 = 25), rezultat cuva u dx:ax
    mov y2, ax ; y2 = 25

    mov ax, a ; ax = 5
    mov bx, b ; bx = -7
    imul bx ;za mnozenje poz i neg bro (ax = 5 * -7 = -35)
    add y2, ax ; y2 = 25 + (-35) = -10

    mov ax, a ; ax = 5
    mov bx, c ; bx = 9
    imul bx ;za mnozenje poz i neg bro (ax = 5 * 9 = 45)
    add y2, ax ; y2 = -10 + 45 = 35

    ; Stampa teksta 'y2 = '
    mov dx, OFFSET t2
    mov ah, 9
    int 21h ;Prekid ispisuje string

    ; Stampa vrijednosti y2
    mov ax, y2
    call print ;Pozivamo stampu za broj 35

    ; Novi red
    mov dx, 10
    mov ah, 2
    int 21h

    ; RACUNANJE y1 = -16a - 20b - 24c
    mov ax, a ; ax = 5
    mov bx, -16 ; bx = -16
    imul bx ; ax = 5 * -16 = -80
    mov y1, ax ; y1 = -80

    mov ax, b ; ax = -7
    mov bx, -20 ; bx = -20
    imul bx ; ax = -7 * -20 = 140
    add y1, ax ; y1 = -80 + 140 = 60

    mov ax, c ; ax = 9
    mov bx, -24 ; bx = -24
    imul bx ; ax = 9 * -24 = -216
    add y1, ax ; y1 = 60 + (-216) = -156

    ; Stampa teksta 'y1 = '
    mov dx, OFFSET t1
    mov ah, 9
    int 21h

    ; Stampa vrijednosti y1
    mov ax, y1
    call print ;Pozivamo stampu za broj -156

    ; Novi red
    mov dx, 10
    mov ah, 2
    int 21h

    ;RACUNANJE y3 = (y1^2 + 1) / (y2^2 + 1)

    ; Sredjujemo imenilac (y2^2 + 1)
    mov ax, y2 ; ax = 35
    imul ax ; ax = 35 * 35 = 1225
    mov bx, ax ; bx = 1225
    inc bx  ;uvecava vrijednost za 1 (bx = 1226) -> IMENILAC SPREMAN

    ; Sredjujemo brojilac (y1^2 + 1)
    mov ax, y1 ; ax = -156
    imul ax ; ax = -156 * -156 = 24336
    inc ax  ;uvecava vrijednost za 1 (ax = 24337) -> BROJILAC SPREMAN

    ; Dijeljenje: brojilac (ax) / imenilac (bx)
    mov dx, 0 ;VRLO VAZNA NAPOMENA: Posto radim sa IDIV (oznaceno dijeljenje), preporucljivo je uraditi 'cwd' (Convert Word to Doubleword) umjesto 'mov dx, 0', jer 'mov dx, 0' moze pokvariti stvar ako je brojilac negativan. Posto je ovdje ax pozitivan (24337), mov dx, 0 radi, ali zapamti 'cwd' za ispit!
    idiv bx ; ax = ax / bx, dx = ax mod bx (24337 / 1226 = 19, ostatak u dx)
    mov y3, ax ; y3 = 19

    ; Stampa teksta 'y3 = '
    mov dx, OFFSET t3
    mov ah, 9
    int 21h

    ; Stampa vrijednosti y3
    mov ax, y3
    call print ;Pozivamo stampu za broj 19

    ; Novi red
    mov dx, 10
    mov ah, 2
    int 21h

    ; Izlaz iz programa
    mov ax, 4c00h
    int 21h
end main ;Kraj cijelog koda