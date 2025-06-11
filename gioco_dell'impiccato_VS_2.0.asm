name "Gioco dell'impiccato"

data segment 

    ;VETTORI
    vet1 db '?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?'
    vet2 db '?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?','?'
    
    ;VETTORI CONTENENTI LA PAROLA PER OGNI LIVELLO
    liv_1 db 's','o','v','r','a','m','a','g','n','i','f','i','c','e','n','t','i','s','s','i','m','a','m','e','n','t','e','?'
    liv_2 db 'p','r','e','c','i','p','i','t','e','v','o','l','i','s','s','i','m','e','v','o','l','m','e','n','t','e','?'
    liv_3 db 'd','i','s','a','r','c','i','v','e','s','c','o','v','i','s','c','o','s','t','a','n','t','i','n','o','p','o','l','i','z','z','a','r','e','?'
    liv_4 db 'i','r','r','e','f','r','a','g','a','b','i','l','i','s','s','i','m','o','?'
    liv_5 db 'p','r','o','c','r','a','s','t','i','n','a','r','e','?'
    liv_6 db 'e','r','u','b','i','s','c','e','n','t','e','?'               
    liv_7 db 'c','a','l','l','i','d','o','?'
        
    ;VARIABILE CARATTARE
    char db ? 
    wasd db ?    
    pkey1 db ?
    pkey2 db ?
    scelta db 1
    vit_scelta db 0
    livello db 0
    appoggio dw 0
    livello_attuale db 0
    
    ;VARIABILE TENTATIVI
    tentativi db '6'    
    
    ;VARIABILI STRINGA E RISPOSTA
    msg1 db "Inserisci qui la parola: $" 
    msg2 db "TENTATIVI: $"   
    msg3 db '1'
    msg4 db "Attendere...$"
    msg5 db "LIVELLO ATTUALE: $"
    msg6 db "GIOCO DELL'IMPICCATO$"                
    msg7 db "Vuoi andare al prossimo livello?: $"
    msg8 db "Vuoi riprovare lo stesso livello?: $"    
    msg9 db "Congratulazioni, hai copletato tutti i livelli!$"
     
    vinto db "Hai vinto!!, avendo indovinato la parola [:)]$"
    perso db "Hai perso, avendo esaurito le possibilita'[:(]$"
         
    stringa_rigioca db "Vuoi rigiocare?: $"   
                                           
    modalita db "Scegli la modalita' in cui vuoi giocare: $"   
    
    modalita_1 db "Scelta(1): Gioca con un amico (max 35 caratteri inseribili per creare una parola/frase)$"
    modalita_2 db "Scelta(2): Gioca da solo, (parole da indovinare), sono presenti 7 livelli$"
            
    ;CONTATORI   
    i db 0    
    j dw 0     
    k db 0
    l dw 0
    
    ;COORDINATE SCELTA
    riga_scelta db 2
    colonna_scelta db 0
    
    ;COORDINATE LIVELLO
    riga_liv db 14
    colonna_liv db 1
    
    ;COORDINATE NUMERO LIVELLO
    riga_msg5 db 14
    colonna_msg5 db 1     
    
    ;COORDINATE TENTATIVI
    riga_tentativi db 10
    colonna_tentativi db 1    

    ;COORDINATE LETTERE
    riga_livello db 12
    colonna_livello db 1
        
    ;COORDINATE TRATTINI
    riga db 0
    colonna db 0
    
    ;COORDINATE ASTERISCO
    riga_asterisco db 0
    colonna_asterisco db 25  
        
    ;COORDINATE STAMPA IMPICCATO
    riga2 db 7
    colonna2 db 12
    
    ;COORDINATE STAMPA OMINO IMPICCATO
    omino_riga db 2
    omino_colonna db 2
    
    ;COORDINATE STAMPA OMINO IMPICCATO
    omino_riga2 db 4
    omino_colonna2 db 8
    
    ;STRINGHE IMPICCATO
    omino1 db " ______$"
    omino2 db " |    |$"
    omino3 db " |$"  
    omino4 db " |$"
    omino5 db " |$"
    omino6 db "_|_$"
    
ends

;-------------------------------------------------------------------

;macro per permettere lo spostamento dell'asterisco su e giu

movimento macro sposta
    
    mov ah,00h
    int 16h
    mov wasd,al
    
endm

;------------------------------------------------------------------- 

;macro per inserire la parola/frase

parola_invisibile macro vettore
    
    mov ah,00h
    int 16h             
    mov vettore[si],al
 
endm

;-------------------------------------------------------------------   

;macro per chiedere un carattere e inserirlo nella variabile char

carattere macro char
    
    mov ah,01h
    int 21h   
    mov char,al 
    mov cl,al
         
endm

;-------------------------------------------------------------------  

;macro per chiedere due caratteri per la risposta

risposta_macro macro risposta
    
    mov ah,01h
    int 21h
    mov risposta,al 
           
endm  

;-------------------------------------------------------------------     

;macro per visualizzare un messaggio/stringa

messaggio macro msg
    
    lea dx,msg
    mov ah,09h
    int 21h
                                                            
endm

;------------------------------------------------------------------- 

;macro per posizionare il cursore in una determinata coordinata

stampa macro stampr,stampc
    
    mov ah,02h
    mov dh,stampr
    mov dl,stampc
    int 10h

endm

;-------------------------------------------------------------------

code segment
       
    start:
    
        mov ax, data
        mov ds, ax
        mov es, ax       
	    
	    	    	    
        ;* CODICE PROGRAMMA *

;-------------------------------------------------------------------
	    
	    ;stampa messaggi della schermata inziziale 
	     
	    messaggio msg6
	    
	    mov riga_scelta,2
	    stampa riga_scelta,colonna_scelta
	    messaggio modalita
	    
	    inc colonna_scelta
;---------------------------------------------	     	    
	    mov riga_scelta,4	    
	    stampa riga_scelta,colonna_scelta	    
	    messaggio modalita_1	    
;---------------------------------------------	    
	    mov riga_scelta,6	    
	    stampa riga_scelta,colonna_scelta	    
	    messaggio modalita_2 	  
;---------------------------------------------	    
	    mov riga_scelta,4
	    mov colonna_scelta,0
	    stampa riga_scelta,colonna_scelta
	    
	    call colore_on
	    jmp richiedi_wasd

richiedi_wasd_color_on:

    call colore_on

;controllo carattere cliccato 
    
richiedi_wasd:
	    
	movimento wasd
	
	    cmp wasd,'w'
	    je su 
	    
	    cmp wasd,'W'
	    je su
	        	    
	        cmp wasd,'s'
	        je giu
	        
	        cmp wasd,'S'
	        je giu
	    
	    cmp wasd,0Dh
	    je scelta_1 
	    
    jmp richiedi_wasd

;posizionamento su e giu dell'asterisco con sfondo verde
   
su:
     
    cmp riga_scelta,4
    jle richiedi_wasd_color_on
        
        call colore_off 
        
        sub riga_scelta,2
        stampa riga_scelta,colonna_scelta  
    
        call colore_on
    
    jmp richiedi_wasd
    
giu:

    cmp riga_scelta,6
    jge richiedi_wasd_color_on 
        
        call colore_off  
         
        add riga_scelta,2
        stampa riga_scelta,colonna_scelta 
    
        call colore_on    
    
    jmp richiedi_wasd

;controllo scelta tra modalita_1 e modalita_2

scelta_1:

    cmp riga_scelta,4
    je modalita1
    
        cmp riga_scelta,6
        je modalita2
        
modalita1:
    
    call colore_off
    jmp Inizio_gioco 
    
modalita2:  

    inc livello
    mov vit_scelta,0
    mov scelta,2         

;----------------------------------------------------------

;ripulisce lo schermo e resetta tutto

riavvio:	 
        
        call pulisci-schermo
        messaggio msg4
	    mov cx,0
	    mov si,0
	    	    
ciclo_riazzera_vet1:
    
    cmp cx,35
    je azzera_registri
    
    mov vet1[si],03Fh      
    inc si
    inc cx
    
    jmp ciclo_riazzera_vet1
    
azzera_registri:

    mov si,0
    mov cx,0
        
ciclo_riazzera_vet2:

    cmp cx,26
    je Inizio_gioco 
    
    mov vet2[si],03Fh
    inc si
    inc cx       
    
    jmp ciclo_riazzera_vet2

Inizio_gioco:
	    
	    call pulisci-schermo
	     
        mov bp,0 
        mov di,0
        mov si,0
        mov ax,0
        mov bx,0
        mov cx,0
        mov dx,0
        
        mov i,0
        mov j,0
        mov k,0
        mov l,0
        mov riga,0
        mov colonna,0
        mov tentativi,'6'
        
        mov riga_asterisco,0
        mov colonna_asterisco,25
               
        mov riga2,7
        mov colonna2,12           
        
        mov omino_riga,2
        mov omino_colonna,2 
        
        mov omino_riga2,4
        mov omino_colonna2,8  
        
        mov riga_tentativi,10
        mov colonna_tentativi,1
        
        mov riga_livello,12
        mov colonna_livello,1

;controllo scelta
    
        cmp scelta,2
	    je pulisci-inizio
                       
        messaggio msg1

;scelta_1 inserisci la parola/frase nel vet1
      
ciclo-parola:                 
         
        parola_invisibile vet1
        
        cmp vet1[si],0Dh
        je vuoto  
   
        jmp asterisco
        
vuoto:                           

    stampa riga_asterisco,colonna_asterisco
        
        mov ah,02h
        mov dl,' '
        int 21h 
        
    jmp controllo_invio

asterisco:
    
            stampa riga_asterisco,colonna_asterisco
        
            mov ah,02h
            mov dl,'*'
            int 21h

controllo_invio:
        
        inc colonna_asterisco
                
        cmp vet1[si],0Dh
        je pulisci-inizio
        
            cmp si,35
            je pulisci-inizio 
                   
            inc si
                    
        jmp ciclo-parola

;pulisci schermo
               
pulisci-inizio:        
        
    call pulisci-schermo
     
modalita_1_2:

    mov di,si
    mov bp,si  
    mov cx,0 
    mov si,0
    
;stampa impiccato
   
    stampa omino_riga,omino_colonna
    
    messaggio omino1        
    
    inc omino_riga
    
    stampa omino_riga,omino_colonna
    
    messaggio omino2
    
    inc omino_riga
    
    stampa omino_riga,omino_colonna
    
    messaggio omino3
    
    inc omino_riga
    
    stampa omino_riga,omino_colonna
    
    messaggio omino4
    
    inc omino_riga
    
    stampa omino_riga,omino_colonna
    
    messaggio omino5
    
    inc omino_riga
    
    stampa omino_riga,omino_colonna
    
    messaggio omino6 

;controllo scelta
        
        cmp scelta,2
        jne modalit_1

;se scelta = modalita_2  

;controlla il livello
        
        cmp livello,1
        je livello_1  
        
            cmp livello,2
            je livello_2 
            
                cmp livello,3
                je livello_3 
                
                    cmp livello,4
                    je livello_4    
            
                    cmp livello,5
                    je livello_5  
                
                cmp livello,6
                je livello_6      
            
            cmp livello,7
            je livello_7  
       
        jmp stampa_trattino
  
livello_1:
    
    mov si,27  ;assegna questo valore (che sarebbe il numero di caratteri presenti nella parola) nei registri 
    mov bp,si
    mov di,si
    mov appoggio,si
    dec appoggio
    mov cx,0
    call livelli
    jmp utente
                        
livello_2:

    mov si,26 ;assegna questo valore (che sarebbe il numero di caratteri presenti nella parola) nei registri
    mov bp,si
    mov di,si
    mov appoggio,si
    dec appoggio
    mov cx,0
    call livelli
    jmp utente 
    
livello_3:

    mov si,34 ;assegna questo valore (che sarebbe il numero di caratteri presenti nella parola) nei registri
    mov bp,si
    mov di,si
    mov appoggio,si
    dec appoggio
    mov cx,0
    call livelli
    jmp utente
    
livello_4:

    mov si,18 ;assegna questo valore (che sarebbe il numero di caratteri presenti nella parola) nei registri                  
    mov bp,si
    mov di,si
    mov appoggio,si
    dec appoggio
    mov cx,0
    call livelli
    jmp utente
    
livello_5:
    
    mov si,13  ;assegna questo valore (che sarebbe il numero di caratteri presenti nella parola) nei registri        
    mov bp,si
    mov di,si
    mov appoggio,si
    dec appoggio
    mov cx,0
    call livelli
    jmp utente
               
livello_6:

    mov si,11 ;assegna questo valore (che sarebbe il numero di caratteri presenti nella parola) nei registri
    mov bp,si
    mov di,si
    mov appoggio,si
    dec appoggio
    mov cx,0
    call livelli
    jmp utente 
    
livello_7:

    mov si,7  ;assegna questo valore (che sarebbe il numero di caratteri presenti nella parola) nei registri
    mov bp,si
    mov di,si
    mov appoggio,si
    dec appoggio
    mov cx,0
    call livelli
    jmp utente

;modalita_1
    
modalit_1:

;stampa trattini in base a quanti sono i caratteri mentre se presente uno spazio stampa tre spazi vuoti
;controlli
     
stampa_trattino:      
    
    cmp cx,bp
    jge utente 
       
        cmp vet1[si],' '
        je incrementa_l
         
    jmp posiziona_stampa
        
incrementa_l:
    
    inc l    
    
    jmp stampa_tri_vuoto  
    
posiziona_stampa:
 
    stampa riga2,colonna2

    mov ah,02h
    mov dl,'_'
    int 21h
    
        inc colonna2    
    
    jmp stampa_mono_vuoto
    
stampa_tri_vuoto:

    stampa riga2,colonna2
    
    mov ah,02h
    mov dl,' '
    int 21h
        
        inc i
        inc colonna2 
       
        cmp i,3
        je incremento 
        
    jmp stampa_tri_vuoto
    
stampa_mono_vuoto:
    
    stampa riga2,colonna2
    
    mov ah,02h
    mov dl,' '
    int 21h
    
incremento:
    
    inc cx
    inc si
    inc colonna2
    mov i,0    
        
    jmp stampa_trattino

;stampa a schermo i messaggi TENTATIVI: se scelta = 1 altrimenti se sceta = 2 stampa TENTATIVI: e LIVELLO ATTUALE: 
;controlli
   
utente:
    
    mov si,0      
    mov colonna2,12 
    mov riga2,7
    
    stampa riga_tentativi,colonna_tentativi  
      
        messaggio msg2
            
            mov colonna_tentativi,12
            stampa riga_tentativi,colonna_tentativi
    
            mov ah,02h
            mov dl,tentativi
            int 21h

        cmp scelta,2
        je mostra_livello 
    
    jmp nascondi_livello 
     
mostra_livello:
        
    stampa riga_livello,colonna_livello
    
        messaggio msg5
            
            mov colonna_livello,18
            stampa riga_livello,colonna_livello
    
            mov ah,02h
            mov dl,msg3
            int 21h     
    
nascondi_livello:
    
    stampa riga,colonna
         
        mov si,0  
    
    jmp ciclo1

;controllo vittoria
    
ciclo2:
       
    cmp l,di
    je vittoria

    stampa riga,colonna
         
ciclo1:
    
    mov si,0 
    
    jmp carattere

richiedi_e_azzera:

    mov si,0  
    inc colonna

;chiedi carattere
;controllo se carattere e' gia stato inserito oppure no
    
carattere: 

    carattere char 
    
        cmp char,0Dh
        je carattere  
        
            cmp char,32
            je carattere
            
        cmp char,9
        je carattere

c1:
    
    cmp si,26
    je azzera_si

        cmp vet2[si],al
        je richiedi_e_azzera

        inc si
    
    jmp c1

azzera_si:

    mov si,0
      
c2:

    cmp vet2[si],03Fh
    je assegna 
    
        inc si   
    
    jmp c2

;se il carattere non e' stato inserito, viene inserito ora nel vet2 nell' indice vuoto
    
assegna:
      
    mov vet2[si],al          
    mov si,0

;controllo se carattere e' presente nella parola/frase
    
controllo:
                
    stampa riga2,colonna2
    
    cmp scelta,2
    je controllo_livelli                 
    
;controllo disponibile se scelta = 1
    
        cmp al,vet1[si]  
        je stampa-lettera
        
    jmp controllo_giocatore 

;controllo disponibile solo con scelta = 2
           
controllo_livelli:
    
    cmp l,di
    jge vittoria
    
        cmp livello,1
        je controllo_liv_1  
        
            cmp livello,2
            je controllo_liv_2 
            
                cmp livello,3
                je controllo_liv_3  
                
                cmp livello,4
                je controllo_liv_4   
            
            cmp livello,5
            je controllo_liv_5 
                
        cmp livello,6
        je controllo_liv_6      
            
    cmp livello,7
    je controllo_liv_7 

;controllo del carattere per ogni livello in base al livello attuale esempio livello = 1 
;controllera' solo liv_1

controllo_liv_1:
    
    cmp al,liv_1[si]
    je stampa-lettera
    jmp controllo_giocatore2
             
controllo_liv_2:

    cmp al,liv_2[si]
    je stampa-lettera
    jmp controllo_giocatore2
    
controllo_liv_3:

    cmp al,liv_3[si]
    je stampa-lettera
    jmp controllo_giocatore2
    
controllo_liv_4:

    cmp al,liv_4[si]
    je stampa-lettera
    jmp controllo_giocatore2
    
controllo_liv_5:

    cmp al,liv_5[si]
    je stampa-lettera
    jmp controllo_giocatore2
    
controllo_liv_6:

    cmp al,liv_6[si]
    je stampa-lettera
    jmp controllo_giocatore2
    
controllo_liv_7:

    cmp al,liv_7[si]
    je stampa-lettera
    jmp controllo_giocatore2

;controllo disponibile solo per scelta = 2 
   
controllo_giocatore2:
    
    inc j
        
        ;se j e' maggiore di "di" stampa corpo
            
        cmp j,di
        jg stampa-corpo
                      
            cmp si,di
            jge riazzero_si       

    jmp incrementa_colonna2

;controllo disponibile solo per scelta = 1   
         
controllo_giocatore:
   
        inc j
            
            ;se j e' maggiore di "di" stampa corpo  
            
            cmp j,di
            jg stampa-corpo
                      
                cmp si,di
                je riazzero_si 
                  
            cmp vet1[si],' '
            je controllo_spazio_vuoto
            
        jmp incrementa_colonna2

;incrementazione del l'indice e colonna per controllare 
;ogni singolo indice del vettore per verificare se il carattere e' presente nella parola/frase 
           
controllo_spazio_vuoto:

        add colonna2,4
        inc si 
                   
    jmp controllo     
    
incrementa_colonna2:   
         
        add colonna2,2             
        inc si 
                              
    jmp controllo    


;stampa a schermo il carattere presente nella parola/frase
    
stampa-lettera:     
    
    stampa riga2,colonna2
    
    cmp vet1[si],' '
    jne incrementa
    
        cmp vet1[si],0Dh
        jne incrementa 
    
    mov ah,02h
    mov dh,riga2
    mov dl,colonna2
    int 10h    
    
    add colonna2,2
    inc si    
           
    jmp controllo     

incrementa:

    inc l    
    
    mov ah,02h
    mov dh,riga2
    mov dl,colonna2
    int 10h
    
    mov ah,02h
    mov dl,char
    int 21h
    
    cmp scelta,2
    jne _salta_comparazione_ 
    
        cmp si,appoggio
        je riazzero_si   
    
    cmp si,appoggio
    je _salta_incremento_ 

_salta_comparazione_:
     
    inc si
    
_salta_incremento_:

    add colonna2,2     
    jmp controllo

;stampa il corpo 
    
stampa-corpo:
    
    stampa riga_tentativi,colonna_tentativi
    
    dec tentativi 
      
    mov ah,02h
    mov dl,tentativi
    int 21h 
    
    inc k              
    
;controllo per capire cosa stampare ad esepio k = 1 stampa testa poi k = 2 stampa anche le barre ecc... 

    cmp k,1
    je testa 
    
        cmp k,2
        je barra   
        
            cmp k,3
            je braccio_sinistro 
            
            cmp k,4
            je braccio_destro
        
        cmp k,5
        je gamba_sinistra

    cmp k,6
    je gamba_destra
    
testa:
    
    mov omino_riga2,4
    mov omino_colonna2,8 
    
    stampa omino_riga2,omino_colonna2
         
    mov ah,02h
    mov dl,1 
    int 21h    

    mov j,0 
    
    jmp controllo

barra: 

;posizione prima barra     

    mov omino_riga2,5
    mov omino_colonna2,8 
    
    stampa omino_riga2,omino_colonna2
    
    mov ah,02h
    mov dl,'|' 
    int 21h

;posizione seconda barra
        
        mov omino_riga2,6
        mov omino_colonna2,8  
    
        stampa omino_riga2,omino_colonna2
   
        mov ah,02h
        mov dl,'|' 
        int 21h 
        
        mov j,0
        
    jmp controllo
    
braccio_sinistro:

    mov omino_riga2,5
    mov omino_colonna2,7
    
    stampa omino_riga2,omino_colonna2
                     
    mov ah,02h
    mov dl,'/'                                      
    int 21h 
    
    mov j,0
    
    jmp controllo

braccio_destro:

    mov omino_riga2,5
    mov omino_colonna2,9
    
    stampa omino_riga2,omino_colonna2
    
    mov ah,02h
    mov dl,'\' 
    int 21h   

    mov j,0 
    
    jmp controllo
    
gamba_sinistra:

    mov omino_riga2,7
    mov omino_colonna2,7
    
    stampa omino_riga2,omino_colonna2
    
    mov ah,02h
    mov dl,'/' 
    int 21h   
  
    mov j,0
    
    jmp controllo    
                  
gamba_destra:

    mov omino_riga2,7
    mov omino_colonna2,9
    
    stampa omino_riga2,omino_colonna2
    
    mov ah,02h
    mov dl,'\' 
    int 21h
       
    mov j,0
    
    jmp fine    
      
riazzero_si:
    
    inc colonna
       
    mov riga2,7
    mov colonna2,12
        
    mov si,0
    mov j,0   
    
    jmp ciclo2 

;se utente perde controllo scelta 
        
fine: 

    call pulisci-schermo    
    mov ah,02h
    mov dh,2
    mov dl,1
    int 10h 
    
;se scelta = 2 porta vittoria_scelta = 0
;altrimenti salta su salta_passaggio_0

    cmp scelta,2
    jne salta_passaggio_0
    
    mov vit_scelta,0

salta_passaggio_0:
    
;stampa messaggio perso e jmp su controllo risposta

    messaggio perso  
    
        jmp riprovare?

;se utente vince controllo scelta 
    
vittoria:
    
    call pulisci-schermo   
    mov ah,02h
    mov dh,2
    mov dl,1
    int 10h
    
;se scelta = 2 porta vittoria_scelta = 1
;altrimenti salta su salta_passaggio_1

    cmp scelta,2
    jne salta_passaggio_1 
    
        mov vit_scelta,1
    
        inc livello
        inc msg3
;controllo livello, se livello e' maggiore-uguale a 8 salta su gioco_completato ovvero livelli finiti
    
    cmp livello,8
    jge gioco_completato  
    
salta_passaggio_1:          

;stampa messaggio vinto e jmp su controllo risposta
    
    messaggio vinto 
    
        jmp riprovare?   
    
gioco_completato:

;stampa msg9
              
    messaggio msg9

;il gioco termina automaticammente
     
        jmp termina

;controllo riprova

 
riprovare?:
    
    mov ah,02h
    mov dh,4
    mov dl,1
    int 10h

;controllo scelta
;scelta = 2 va su livel
;altrimenti vai su etichetta con_amico
   
    cmp scelta,2
    je livel

con_amico:

;stampa messaggio Vui rigiocare?

    messaggio stringa_rigioca

;salta su controllo se utente vuole rigiocare    

        jmp controllo_rigioca 
           
livel:

;controllo se vittoria_scelta = 1 va su prossimo livello
;altrimenti stampa msg8 e va su controllo rigioca
    
    cmp vit_scelta,1
    je prossimo_livello
   
        messaggio msg8
        
            jmp controllo_rigioca 
        
prossimo_livello:

;stammpa msg7

    messaggio msg7

;controllo utente se vuole rigiocare
;se "si" va su "riavvio" altrimenti va su "termina"

controllo_rigioca:
   
    risposta_macro pkey1 
    risposta_macro pkey2
    
    cmp pkey1,'s'    
    je pkey.2  
    
        cmp pkey1,'S'    
        je pkey.2    
    
    jmp termina
    
pkey.2:
    
    cmp pkey2,'i'
    je riavvio
       
        cmp pkey2,'I'    
        je riavvio   
    
    jmp termina
             
termina: 
          
    mov ax,4C00h
    int 21h
                 
ends

;-------------------------------------------------------------------

pulisci-schermo proc near
    
    mov ax,03h
    int 10h  
    
    ret
    
endp

;-------------------------------------------------------------------

colore_on proc near
    
    mov al,'*'
	mov ah,09h
	mov bh,0
	mov bl,10100000b
	mov cx,1
	int 10h  
		
	ret
    
endp

;-------------------------------------------------------------------

colore_off proc near
    
    mov al,' '
	mov ah,09h
	mov bh,0
	mov bl,00000000b
	mov cx,1
	int 10h 
	
	ret
       
endp   

;-------------------------------------------------------------------

livelli proc near

ciclo_livello:
    
    cmp cx,si
    je salta 
    
    stampa riga2,colonna2

    mov ah,02h
    mov dl,'_'
    int 21h
    
    inc colonna2
    
    stampa riga2,colonna2
    
    mov ah,02h
    mov dl,' '
    int 21h
    
    inc colonna2
    inc cx
    
    jmp ciclo_livello 
    
    salta:
    ret
    
endp
end start