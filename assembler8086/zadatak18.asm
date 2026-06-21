;for petlja
.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod (falila ti je tacka: .model)

.stack ;Rezervisano mjesto za program

.data ;Cuvamo podatke
x db 20 ;Pocetna vrijednost x = 20
z db 11 ;Pocetna vrijednost z = 11 (bice prebrisana u petlji)
a db 0  ;Nas brojac za for petlju (od 0 do 9)
w dw 123

.code ;Dio gdje pisemo kod

main:

    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi
    
    mov ah, 0
    mov a, ah           ; a:=0 -> Inicijalizujemo brojac petlje na nulu
    
uslov: ;Pocetak svakog kruga for petlje

    mov ah, a ;Ucitavamo trenutno 'a' u ah registar
    cmp ah, 10 ;Uporedjujemo brojac sa 10
    je kraj_petlje ;Ako je a == 10, uslov petlje vise ne vazi i iskacemo napolje

    mov ah, x ;Ucitavamo trenutnu vrijednost x u ah
    mov z, ah       ; z = x -> Prepisujemo vrijednost iz x u z
    
    ;mov ah, x
    inc ah ;Povecavamo privremenu vrijednost x za 1
    mov x, ah       ; x = x + 1 -> Cuvas uvecano x nazad u memoriju
    
    ;inkrementiramo a
    mov ah, a ;Ucitavamo brojac 'a' u ah
    inc ah ;Povecavamo brojac za 1
    mov a, ah       ; a++ -> Vracamo uvecani brojac u memoriju
    
    jmp uslov ;Skaci nazad na uslov da provjerimo da li idemo u novi krug
   
    
kraj_petlje: ;Ovdje stizemo kada 'a' postane 10

    mov al, z ;Ucitavamo poslednju sacuvanu vrijednost iz 'z' u al registar
    cbw ;Convert Byte to Word - siri 'al' na cijeli 'ax' registar da mozemo bezbjedno dijeliti
    mov cx, 10 ;U cx stavljamo 10, sa njim cemo kruniti cifre za stampu
    
    ;div radi na sledeci nacin
    ;ax dijeli sa cx
    ;kolicnik je u ax
    ;ostatak je u dx
    
pocetak_stampa: ;Petlja za ispis broja na ekran
    
    cmp ax, 0 ;Gledamo da li je kolicnik u ax dosao do nule
    jz kraj_stampa ;Ako jeste, odstampali smo sve cifre i idemo na izlaz
    
    mov dx, 0 ;Cistimo dx prije svakog dijeljenja (obavezno!)
    
    div cx ;Dijelimo ax sa 10 (kolicnik ide u ax, ostatak u dx)
    
    mov bx, ax ;Privremeno sklanjamo kolicnik u bx da oslobodimo registre za DOS prekid
    
    add dl, '0' ;Na ostatak u dl dodajemo ASCII vrijednost '0' da dobijemo karakter
    mov ah, 2 ;DOS funkcija 2 za ispis jednog karaktera
    int 21h ;Prekid koji zapravo ispisuje tu cifru na ekran (unazad)
    
    mov ax, bx ;Vracamo kolicnik iz bx nazad u ax za sledeci krug dijeljenja
    
    jmp pocetak_stampa ;Skaci nazad na pocetak stampe

kraj_stampa:

    ; Bezbjedno gasenje programa
    mov ah, 4ch
    int 21h

end main ;Kraj cijelog koda