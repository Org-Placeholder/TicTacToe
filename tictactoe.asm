xno		START	0
        LDA     #test
        LDT     testln
        JSUB    setclr
        JSUB    grddisp
        J       halt
.------------------------------------ SET COLOR ---------------------------------------
setclr  LDA     #27
        WD      #1
        LDA     #91
        WD      #1
        LDA     #52
        WD      #1
        LDA     #55
        WD      #1
        LDA     #59
        WD      #1
        LDA     #51
        WD      #1
        LDA     #48
        WD      #1
        LDA     #109
        WD      #1
        RSUB

remdec  LDA     #27
        WD      #1
        LDA     #91
        WD      #1
        LDA     #48
        WD      #1
        LDA     #109
        WD      #1
        RSUB

. ---------------------------------- GRID DISPLAY -------------------------------------


grddisp RMO     L,B
        JSUB    linep
        
        LDS     #0
        JSUB    disp
        
        JSUB    linep
        
        LDS     #3
        JSUB    disp
       
        JSUB    linep

        LDS     #6
        JSUB    disp
        
        JSUB    linep
        RSUB

linep   LDT     linelen
        LDA     #line
        RMO     L,B
        JSUB    printstr 
        RMO     B,L
        RSUB       

disp    LDT     tlen0
        LDX     #0
        ADDR    S,X
        LDCH    grdst,X
        LDX     #2
        STCH    temp0,X
        
        LDX     #1
        ADDR    S,X
        LDCH    grdst,X
        LDX     #6
        STCH    temp0,X
        
        LDX     #2
        ADDR    S,X
        LDCH    grdst,X
        LDX     #10
        STCH    temp0,X
        LDA     #temp0
        RMO     L,B
        JSUB    printstr
        RMO     B,L
        RSUB                 
. ---------------------------------- OUTPUT STRING -------------------------------------

printstr	STA	out
                LDX #0

cloop	LDCH	@out    . print each character in string one by one upto length in T.
        STA     a_bck
        STX     x_bck
        STT     t_bck
.	JSUB    setclr  
        LDA     a_bck
        LDX     x_bck
        LDT     t_bck
	WD	#1      . 1 is the device code for STDOUT
        LDA     #1
        ADDR    X, A
        COMPR   A, T
	JEQ     return
        RMO     A, X
        LDA	out
	ADD	#1
	STA	out
        J	cloop

return	LDA     #10
        WD      #1
        RSUB

a_bck   RESW    1
x_bck   RESW    1
t_bck   RESW    1
out 	RESW	1
. ---------------------------------- OUTPUT STRING END -------------------------------------
state   RESB    9    
test	BYTE	C'\e[1;31m This is red text \e[0m'
line    BYTE    C'-------------'
temp0   BYTE    C'|   |   |   |'
grdst   BYTE    C'XOXXOOOOX'    .hard coded for now.
tlen0   WORD    13
stlen   WORD    9
linelen WORD    13
testln  WORD    31
halt    J       halt
