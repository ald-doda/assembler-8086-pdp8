.model small ;Memorijski model za jedan segment za kod i jedan segment za podatke, uvijek isti
.stack ;Rezervisemo prostor u memorijskom steku
.data ;Cuvamo podatke
poruka db 'Pozdrav svima','$' ;poruka je naziv promjenljive koju smo deklarisali
;db - define byte, rezervise se prostor za svaki karakter rijeci
;$ - oznacava kraj stringa, kad dodjes tu staje
.code ;pocetak segmenta dje se izvrsava kod
;ovo gore je segment gdje se cuvaju podaci

main: ;oznaka gdje se pise glavni program
mov ax, @data ;mov - move, iz @data prepisujemo u ax
mov ds, ax ;mov - move, iz ax prepisujemo u Data Segment centar - DS, kazemo dje se nalaze podaci

mov ah, 9 ;poziv 9 znaci da zelimo ispisati string
mov dx, OFFSET poruka ;stavljamo u dx tacnu udaljenost adrese poruke unutar segmenta
;znamo dje tekst pocinje uz pomoc nje
int 21h ;kada vidimo da se sve zavrsilo imamo prekid

mov ah, 4ch ;uz 4ch zavrsavamo program i tu je kraj 
int 21h ;jos jedan prekid koji priprema kraj

end main ;Kraj programa, karakteristicno za svaki