;if - then - else
.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program

.data ;Cuvamo podatke
x dw 2 ;Definisemo 16-bitnu promenljivu 'x' sa vrijednoscu 2
y dw 6 ;Definisemo 16-bitnu promenljivu 'y' sa vrijednoscu 6
z dw ? ;Ovdje cemo sacuvati rezultat uslova
.code ;Dio gdje pisemo kod

;DEFINICIJA PROCEDURE ZA STAMPANJE
stampa PROC a : WORD ;Pravimo proceduru 'stampa' koja prima jedan 16-bitni argument 'a'

    push bp ;Cuvamo stari Base Pointer na stek da ga ne pokvarimo
    mov bp, sp ;Postavljamo bp da pokazuje na vrh steka (pravimo stack frame za pristup parametrima)
    
    ;probamo da stampamo
    mov cx, 10 ;U cx stavljamo 10 za dijeljenje
    mov ax, a ;Ucitavamo prosledjeni argument 'a' u ax registar

pocetak: ;Petlja za rastavljanje broja na cifre
    
    cmp ax, 0 ;Gledamo da li je ax nula
    jz kraj2 ;Ako jeste, zavrsili smo sa ciframa i idemo na izlaz iz funkcije

    mov dx, 0 ;Cistimo dx prije dijeljenja
    div cx ;Dijelimo ax sa 10 (kolicnik u ax, ostatak/cifra u dx)

    ; ax <-- ax/10
    ; dx <-- ax % 10

    ;moram da cuvam ax
    mov bx, ax ;Sklanjamo kolicnik u bx jer nam ax treba za stampu

    add dl, '0' ;Pretvaramo cifru u ASCII karakter
    mov ah, 2 ;DOS funkcija za ispis jednog karaktera
    int 21h ;Prekid koji stampa cifru na ekran (ovdje ce ih opet stampati unazad)

    ;vracam ax
    mov ax, bx ;Vracamo kolicnik nazad u ax za sledeci krug

    jmp pocetak ;Idemo opet na pocetak petlje

kraj2: ;Kraj procedure

    pop bp ;Vracamo stari Base Pointer sa steka
    ret 2 ;Vraca se iz procedure i automatski cisti 2 bajta argumenta sa steka (jer smo poslali dw)      

stampa ENDP ;Kraj definicije procedure

main: ;Glavni dio programa

    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

    ;IF DIO
    mov ax, x ;Ucitavamo x u ax registar (ax = 2)
    add ax, 4 ;Dodajemo 4 na ax (ax = 2 + 4 = 6)
    
    mov bx, y ;Ucitavamo y u bx registar (bx = 6)
    shl bx, 1 ;Mnozimo y sa 2 preko SHL (bx = 6 * 2 = 12)   
    
    cmp ax, bx ;Uporedjujemo ax (6) i bx (12)
    je else1 ;Ako su jednaki (6 == 12), skaci na else1 (ovdje nisu jednaki, idemo dalje)

    mov ax, x ;Ponovo ucitavamo x u ax (ax = 2)
    cmp ax, 10 ;Uporedjujemo x sa 10
    jge else1 ;Jump if Greater or Equal - ako je x veci ili jednak 10, skaci na else1 (2 nije >= 10, idemo dalje)

    ;THEN DIO (izvrsava se ako uslovi gore NISU ispunjeni) ---
    add ax, y ;Na ax (gdje je x=2) dodajemo y (6), pa je ax = 8
    mov z, ax ;Upisujemo tih 8 u promenljivu 'z'
    jmp kraj ;Preskacemo else dio i idemo na stampu   

else1: ;ELSE DIO

    mov z, 0 ;Ako je bilo sta od gore ispunjeno, u 'z' upisujemo nulu

kraj: ;STAMPA

    mov ax, z ;Ucitavamo konacan rezultat iz 'z' u ax registar (ovdje je z = 8)
    push ax ;Guramo ax na stek kao argument za proceduru
    call stampa ;Pozivamo nasu proceduru 'stampa' da ispise broj na ekran
    ;add sp, 2 ;Ova linija je zakomentarisana jer 'ret 2' unutar funkcije vec brise argument sa steka!

    mov ah, 4ch ;Upisujemo 4ch za izlaz iz programa
    int 21h ;Prekid koji gasi program

end main ;Kraj cijelog koda