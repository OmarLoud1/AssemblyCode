;guessing game : Omar Loudghiri oxl51
;Relevent code from thunderbird was taken to implement nomenclature of this code


; There is a delay of approximately 1 seconds from one state to the next
; The loop delay is approx 100 * 87 * 3 CPU cycles 
; Using an oscillator frequeny of 100 kHz, a CPU cycle is 40 usec
; Therefore, the loop delay is about 1036 msec or aprrox 1 sec
 
; CPU configuration
; (16F84 with RC osc, watchdog timer off, power-up timer on)

	processor 16f84A
	include <p16F84A.inc>
	__config _RC_OSC & _WDT_OFF & _PWRTE_ON
; file register variables

nextS equ 0x0C 	; next state (output)
octr equ 0x0D	; outer-loop counter for delays
ictr equ 0x0E	; inner-loop counter for delays

; state definitions for Port B

S4 equ B'01000'
S3 equ B'00100'
S2 equ B'00010' 
S1 equ B'00001'
SOK equ B'00000'
SERR equ B'10000'
; input bits on Port A

G4 equ 3
G3 equ 2
G2 equ 1
G1 equ 0
; beginning of program code

	org 0x00	; reset at address 0
reset:	goto	Main	; skip reserved program addresses	

	org	0x08 	; beginning of user code
Main:	
; set up RB5-0 as outputs
	bsf	STATUS,RP0	; switch to bank 1 memory (not necessary in PIC18)
	movlw 0x0F
	movwf TRISB
	movlw 0xE0
	movwf TRISA
	bcf	STATUS,RP0; return to bank 0 memory (not necessary in PIC18)
	movlw State1
	movwf nextS


mloop:	; here begins the main program loop
; PORTA = nextS, i.e. PORTA is the next state
	movf nextS,W
	movwf PORTA
	
; test inputs, and compute next state
	;  if (State1)
	movlw State1
	xorwf PORTA,W
	btfss STATUS,Z ; 
	goto State2 ; 
	
OK:;when guessed right all light up
     btfsc PORTB,G1 
	goto setOK; 
    btfsc PORTB,G2 
	goto setOK; 
    btfsc PORTB,G3 
	goto setOK; 
    btfsc PORTB,G4 
	goto setOK; 
  ; restarts
    movlw S1
    movwf nextS
	goto delay
ERR:;when light 1 is on only G1 sets triggers ok
      btfsc PORTB,G1 
	goto setERR; 
    btfsc PORTB,G2 
	goto setERR; 
    btfsc PORTB,G3 
	goto setERR; 
    btfsc PORTB,G4 
	goto setERR; 
     movlw S1
    movwf nextS; restarts
	goto delay
setOK:
   
     movlw SERR
    movwf nextS
	goto delay

setERR:
   
    movlw SOK
    movwf nextS
	goto delay
	
State4:;when light 4 is on only G4 sets triggers ok
    
    btfsc PORTB,G1 
	goto setERR; 
    btfsc PORTB,G2 
	goto setERR; 
    btfsc PORTB,G3 
	goto setERR; 
    btfsc PORTB,G4 
	goto setOK; 
   ; next state is S1 it loops through them
    movlw S1
    movwf nextS
	goto delay

State3:;gwhen light 3 is on only G3 sets triggers ok
     btfsc PORTB,G1 
	goto setERR; 
    btfsc PORTB,G2 
	goto setERR; 
    btfsc PORTB,G3 
	goto setOK; 
    btfsc PORTB,G4 
	goto setERR; 
    ; next state is S4
    movlw S1
    movwf nextS
	goto delay	
	
State2:;when light 2 is on only G2 sets triggers ok
      btfsc PORTB,G1 
	goto setERR; 
    btfsc PORTB,G2 
	goto setOK; 
    btfsc PORTB,G3 
	goto setERR; 
    btfsc PORTB,G4 
	goto setERR; 
    ; next state is S3
    movlw S3
    movwf nextS
	goto	delay
State1:; when light 1 is on only G1 sets triggers ok
     btfsc PORTB,G1 
	goto setOK; 
    btfsc PORTB,G2 
	goto setERR; 
    btfsc PORTB,G3 
	goto setERR; 
    btfsc PORTB,G4 
	goto setERR; 
    ; next state is S2
    movlw S2
    movwf nextS
	goto	delay


	
;Omar Loudghiri


	
delay: ; create a delay of about 0.5 seconds
	; initialize outer loop counter to 100
	 movlw d'200'
	  movwf octr
d1:	 movlw d'13'
	  movwf octr	; initialize inner loop counter to 87
	  
d2: decfsz	ictr,F	; if (--ictr != 0) loop to d2
	goto 	d2		 	
	decfsz	octr,F	; if (--octr != 0) loop to d1 
	goto	d1 

endloop: ; end of main loop
	goto	mloop

	end		; end of program code		

PORTA








