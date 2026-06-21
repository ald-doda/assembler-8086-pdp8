;zadatak y = 2a + b + 1

.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program

.data ;Cuvamo podatke
a dw 500 ;Definisemo 'a' kao 16-bitnu rijec (dw) sa vrijednoscu 500
b dw 466 ;Definisemo 'b' kao 16-bitnu rijec sa vrijednoscu 466
y dw ? ;Ovdje cemo sacuvati konacan rezultat (trenutno neinicijalizovano)
.code ;Dio gdje pisemo kod

main: ;Glavni dio programa

    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

    ;ucitamo a
    mov ax, a ;Ubacujemo vrijednost iz 'a' (500) u ax registar
    ;mnozimo sa 2
    shl ax, 1 ;Shift Left - pomjeramo bitove ulijevo za 1 mjesto, sto je isto kao da mnozimo sa 2 (ax postaje 1000)   
    
    ;saberemo sa b
    add ax, b ;Na trenutnu vrijednost u ax dodajemo b (1000 + 466 = 1466)
    ;povecamo za 1
    inc ax ;Povecavamo ax za 1 (1466 + 1 = 1467)

    ;sacuvamo u c
    mov y, ax ;Konacan rezultat iz ax (1467) prebacujemo u promenljivu 'y'

    ;stampa
    mov ax, y ;Ponovo punimo ax sa rezultatom iz 'y' da bismo ga spremili za stampanje
    mov cx, 10 ;U cx stavljamo 10 jer cemo sa njim dijeliti da odvajamo cifre
pocetak: ;Pocetak petlje za stampanje
    
    cmp ax, 0 ;Gledamo da li je ax dosao do nule
    jz kraj ;Ako jeste, iskacemo iz petlje na kraj

    mov dx, 0 ;Cistimo gornji dio (dx) prije nego sto pokrenemo dijeljenje
    div cx ;Dijelimo ax sa 10. Kolicnik ide u ax, ostatak (zadnja cifra) ide u dx

    ; ax <-- ax/10
    ; dx <-- ax % 10

    ;moram da cuvam ax
    mov bx, ax ;Sklanjamo kolicnik u bx, jer nam ax treba za sistemski poziv stampe

    add dl, '0' ;Dodajemo ASCII '0' na ostatak u dl da dobijemo karakter spreman za ekran
    mov ah, 2 ;DOS funkcija za ispis jednog karaktera iz dl
    int 21h ;Prekid koji zapravo stampa tu cifru

    ;vracam ax
    mov ax, bx ;Vracamo sacuvani kolicnik iz bx nazad u ax za sledeci krug dijeljenja

    jmp pocetak ;Idemo ponovo na pocetak petlje da obradimo sledecu cifru

kraj: ;Oznaka za kraj i gasenje programa

    mov ah, 4ch ;Upisujemo 4ch za regularan izlaz iz programa
    int 21h ;Prekid koji gasi program i vraca nas u DOS

end main ;Kraj cijelog koda