;zadatak y = 2a + b + 1

.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program

.data ;Cuvamo podatke
a dw 500 ;Definisemo 'a' (2 bajta) sa vrijednoscu 500
b dw 466 ;Definisemo 'b' (2 bajta) sa vrijednoscu 466
y dw ? ;Ovdje cemo sacuvati konacan rezultat
.code ;Dio gdje pisemo kod

main: ;Glavni dio programa

    mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
    mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

    ;ucitamo a
    mov ax, a ;Ubacujemo 500 u ax registar
    ;mnozimo sa 2
    shl ax, 1 ;Shift Left za 1 mjesto - mnozimo sa 2 (ax postaje 1000)   
    
    ;saberemo sa b
    add ax, b ;Dodajemo b na trenutnu vrijednost (1000 + 466 = 1466)
    ;povecamo za 1
    inc ax ;Povecavamo za 1 (1466 + 1 = 1467)

    ;sacuvamo u c
    mov y, ax ;Rezultat iz ax (1467) prebacujemo u promenljivu 'y'

    ;stampa
    mov ax, y ;Ponovo punimo ax sa rezultatom iz 'y' da ga spremimo za petlju
    mov cx, 10 ;U cx stavljamo 10 jer cemo sa njim dijeliti da odvajamo cifre
    mov bx, 0 ;U bx stavljamo 0, on ce nam sluziti kao brojac koliko imamo cifara na steku

pocetak: ;Pocetak prve petlje (rastavljanje broja)
    
    cmp ax, 0 ;Gledamo da li je ax dosao do nule
    jz kraj ;Ako jeste, sve cifre su skinute i bjezimo u sekciju za stampu

    mov dx, 0 ;Cistimo dx prije dijeljenja da ne dobijemo pogresan rezultat
    div cx ;Dijelimo ax sa 10. Kolicnik ide u ax, ostatak (cifra) ide u dx

    ; ax <-- ax/10
    ; dx <-- ax % 10

    ;moram da cuvam ax
    mov es, ax ;Sklanjamo kolicnik iz ax u es registar da nam se ne obrise, jer nam ax treba slobodan

    ;add dl, '0'
    ;mov ah, 2
    ;int 21h

    push dx ;Gurnemo ostatak (cifru) na stek. Prvo ce otici 7, pa 6, pa 4, pa 1
    inc bx ;Povecavamo brojac cifara u bx za jedan (da znamo koliko puta cemo raditi pop)

    ;vracam ax
    mov ax, es ;Vracamo kolicnik iz es registra nazad u ax za sledeci krug dijeljenja

    jmp pocetak ;Idemo ponovo na pocetak petlje za sledecu cifru

kraj: ;Kraj prve petlje, ovdje prelazimo na stampanje

;sada povlacim sa steka cifru po cifru
stampa: ;Pocetak druge petlje (ispis na ekran)

    cmp bx, 0 ;Gledamo da li je brojac cifara u bx dosao do nule
    jz kraj2 ;Ako jeste, odstampali smo sve cifre i idemo na gasenje programa
    
    pop dx ;Skidamo zadnju ubacenu cifru sa steka u dx registar (prva izlazi 1, pa 4, pa 6, pa 7)
        
    add dl, '0' ;Dodajemo ASCII '0' na cifru u dl da postane karakter spreman za ispis
    mov ah, 2 ;DOS funkcija 2 za stampanje jednog karaktera
    int 21h ;Prekid koji zapravo ispisuje tu cifru na ekran

    dec bx ;Smanjujemo brojac u bx za 1 jer smo upravo skinuli i odstampali jednu cifru
    jmp stampa ;Skaci nazad na pocetak stampe za sledecu cifru

kraj2: ;Konacni izlaz

    mov ah, 4ch ;Upisujemo 4ch za regularan izlaz iz programa
    int 21h ;Prekid koji gasi program i vraca nas u DOS

end main ;Kraj cijelog koda