;if - then - else

;if (x + 4 <> 2y) && x < 10
;   z = x + y
;else 
;   z = 0

.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program

.data ;Cuvamo podatke
x dw 20 ;Definisemo 16-bitnu promenljivu 'x' sa vrijednoscu 20
y dw 6 ;Definisemo 16-bitnu promenljivu 'y' sa vrijednoscu 6
z dw ? ;Ovdje cemo sacuvati rezultat
.code ;Dio gdje pisemo kod

main: ;Glavni dio programa

    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

    ;PROVJERA PRVOG USLOVA: x + 4 <> 2y
    mov ax, x ;Ucitavamo x u ax registar (ax = 20)
    add ax, 4 ;Dodajemo 4 na ax (ax = 20 + 4 = 24)
    
    mov bx, y ;Ucitavamo y u bx registar (bx = 6)
    shl bx, 1 ;Mnozimo y sa 2 preko SHL (bx = 6 * 2 = 12)   
    
    cmp ax, bx ;Uporedjujemo ax (24) i bx (12)
    je else1 ;Ako su jednaki, uslov "razlicito (<>)" pada i skacemo na else1 (ovdje nisu jednaki, idemo na sledecu provjeru)

    ;PROVJERA DRUGOG USLOVA: x < 10
    mov ax, x ;Ponovo ucitavamo x u ax (ax = 20)
    cmp ax, 10 ;Uporedjujemo x sa 10
    jge else1 ;Jump if Greater or Equal - ako je x veci ili jednak 10, uslov "manje (<)" pada i skacemo na else1 (20 jeste >= 10, tako da ovdje skacemo!)

    ;THEN DIO (izvrsava se samo ako oba uslova prodju)
    add ax, y ;Sabiramo x i y
    mov z, ax ;Zapisujemo rezultat u 'z'
    jmp kraj ;Preskacemo else dio i idemo na stampu    

else1: ;ELSE DI

    mov z, 0 ;Posto je drugi uslov pao, ovdje u 'z' upisujemo nulu

kraj: ;STAMPA REZULTATA
    
    ;probamo da stampamo
    mov cx, 10 ;U cx stavljamo 10 za dijeljenje i odvajanje cifara
    mov ax, z ;Ucitavamo konacan rezultat iz 'z' u ax registar (ax = 0)

pocetak: ;Petlja za rastavljanje broja
    
    cmp ax, 0 ;Gledamo da li je ax dosao do nule
    jz kraj2 ;Ako jeste, bjezi na kraj (u ovom slucaju ax je odmah 0, pa odmah skacemo na kraj2!)

    mov dx, 0 ;Cistimo dx prije dijeljenja
    div cx ;Dijelimo ax sa 10

    ; ax <-- ax/10
    ; dx <-- ax % 10

    ;moram da cuvam ax
    mov bx, ax ;Sklanjamo kolicnik u bx jer nam ax treba slobodan

    add dl, '0' ;Pretvaramo cifru u ASCII karakter
    mov ah, 2 ;DOS funkcija za ispis jednog karaktera
    int 21h ;Prekid koji ispisuje karakter na ekran

    ;vracam ax
    mov ax, bx ;Vracamo kolicnik nazad u ax za sledeci krug

    jmp pocetak ;Idemo opet na pocetak petlje

kraj2: ;GASENJE

    mov ah, 4ch ;Upisujemo 4ch za regularan izlaz
    int 21h ;Prekid koji gasi program i vraca nas u DOS

end main ;Kraj cijelog koda