.model small ;Mali program od jednog segmenta za memoriju i jednog segmenta za kod
.stack ;Rezervisano mjesto za program
.data ;Cuvamo podatke
a db 97 ;Definisemo promjenljivu jednog bajta db, uoisujemo unutra 97
b dw ? ;sefinisemo rijec b koja trenutno nema vrijenodst nego je samo rezervisan prostor u memoriji
;razlika db - bajt, dw - rijec, 1 vs 2 bajta
;razlika druga je jer je jedna inijalizovana
; a druga samo ima prostor za nju
.code ;Dio gdje pisemo kod

main: ;Glavni dio programa

	mov ax, @data ;Iz podataka u ax registar privremeno upisujemo sve
	mov ds, ax ;A zatim to saljemo u ds registar da bismo mogli znati gdje se sta nalazi

	mov al, a ;kopiramo sadrzaj iz promjenljive a u al
	cbw ;convert byte to word, pretvaramo nasu rijec u bajt
    ;do sada je ona zauzimala samo pola regista ax
    ;odnosno dio al, a sada zauzima cio registar
    ;jer smo je prosirili

	mov b, ax ;sada nasu rijec saljemo u sacuvani prostor b
	
	mov ax, b ;a zatim dodajemo iz nase rijeci b u registar a
    ;ovo je slicno kao kod provjere apsolutnih vrijednosti
    ; kod pdp kao kad imamo ono LDA nesto pa onda STA pa opet LDA
	inc ax		; ovdje dodajemo 1 da bismo dobili 98
	
	mov dl, al ;premjestamo iz registra al u dl
    ;zasto?
    ;kada ispisujemo jedan karakter potrebno nam je
    ;da je on u dl
	mov ah, 2 ;zatim upisujemo dvojku u ah
    ;ta dvojka znaci da zelimo ispisati to
	int 21h ;Prekid nakon obavljanja svih ovih radnji

	mov ah, 4ch ;Kada je sve gotovo, tu upisujemo 4ch
	int 21h ;Kada je program uspjesno obavljen, idemo na kraj

end main ;Ovdje se program zavrsava

;objasnjenje, ne stampamo broj nego slovo!!!!!!!!!