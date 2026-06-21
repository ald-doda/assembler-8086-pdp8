.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program

.data ;Cuvamo podatke
a db 97 ;Definisemo promenljivu 'a' velicine 1 bajt sa vrijednoscu 97
.code ;Dio gdje pisemo kod
main: ;Glavni dio programa

    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

    mov al, a ;Kopiramo bajt iz promenljive 'a' u donji dio ax registra (al)
    cbw ;Prosirujemo 'al' na cijeli 'ax' registar da bismo mogli bezbjedno raditi sa 16-bitnim brojevima
    
    ;probamo da stampamo
    mov cx, 10 ;U cx registar stavljamo broj 10, jer cemo sa njim dijeliti da izvucemo cifre
pocetak: ;Oznaka za pocetak petlje
    
    cmp ax, 0 ;Uporedjujemo vrijednost u ax sa nulom
    jz kraj ;Ako je ax dosao do nule, skaci na kraj (zavrsili smo sa svim ciframa)

    mov dx, 0 ;Moramo ocistiti dx registar prije dijeljenja jer dx:ax zajedno cine djeljenik
    div cx ;Dijelimo broj iz ax sa 10 (iz cx). Rezultat ide u ax, a ostatak u dx

    ; ax <-- ax/10 (kolicnik ostaje u ax za sledeci krug)
    ; dx <-- ax % 10 (ostatak, tj. zadnja cifra, ide u dx)

    ;moram da cuvam ax
    mov bx, ax ;Privremeno sklanjamo kolicnik iz ax u bx, jer nam ax treba slobodan za funkciju stampe

    add dl, '0' ;Na ostatak u dl dodajemo ASCII vrijednost nule ('0' ili 48) da bismo broj pretvorili u karakter za stampu
    mov ah, 2 ;Sistemska funkcija 2 za stampanje jednog karaktera iz dl registra
    int 21h ;Prekid koji zapravo ispisuje tu cifru na ekran

    ;vracam ax
    mov ax, bx ;Vracamo sacuvani kolicnik iz bx nazad u ax da bismo u sljedecem krugu nastavili dijeljenje

    jmp pocetak ;Skaci nazad na pocetak petlje da obradimo sljedecu cifru

kraj: ;Oznaka za kraj petlje i izlaz

    mov ah, 4ch ;Kada je sve gotovo, tu upisujemo 4ch za izlaz iz programa
    int 21h ;Kada je program uspjesno obavljen, idemo na kraj

end main ;Ovdje se program zavrsava