TIMI:	EQU		#FD9F
JPCODE:	EQU		#C3
	ORG		#D000
        ;
SETHOK:	DI
	CP		3
        JR		Z,HOKOFF
        ;
        LD		BC,5
        LD		DE,HKSAVE
        LD		HL,TIMI
        LDIR
        LD		A,JPCODE
        LD		(TIMI),A
        LD		HL,INT
        LD		(TIMI+1),HL
        JR		RTN
        ;
HOKOFF:	LD		BC,5
	LD		DE,TIMI
        LD		HL,HKSAVE
        LDIR
        ;
RTN:	EI
	RET
        ;
INT:	LD		IX,COUNT
	DEC		(IX)
        JR		NZ,JR1
        LD		A,(IX+1)
        LD		(IX),A
        LD		B,64
        LD		HL,1024
        CALL		SCROLL
        LD		B,64
        LD		HL,1088
        CALL		SCROLL
JR1:	DEC		(IX+2)
	JR		NZ,JR2
        LD		A,(IX+3)
        LD		(IX+2),A
        LD		B,64
        LD		HL,1152
        CALL		SCROLL
JR2:	DEC		(IX+4)
	JR		NZ,JR3
        LD		A,(IX+5)
        LD		(IX+4),A
        LD		B,64
        LD		HL,1216
        CALL		SCROLL
JR3:	JP		HKSAVE
	;
SCROLL:	LD		C,#99
	PUSH		HL
        PUSH		BC
        OUT		(C),L
        OUT		(C),H
        EX		(SP),HL
        EX		(SP),HL
        LD		HL,WORK
        LD		A,B
        DEC		C
        INIR
        ;
        DEC		HL
        PUSH		HL
        OR		A
        LD		C,32
        JR		Z,J1
        SRL		A
        SRL		A
        SRL		A
        LD		C,A
J1:	XOR		A
LOOP2:	LD		B,8
LOOP:	RRA
	RL		(HL)
        DEC		HL
        DJNZ		LOOP
        RRA
        DEC		C
        JR		NZ,LOOP2
        POP		HL
        LD		B,8
LOOP3:	RRA
	JR		NC,J2
        SET		0,(HL)
J2:	DEC		HL
	DJNZ		LOOP3
        ;
        POP		BC
        POP		HL
        OUT		(C),L
        LD		A,#40
        ADD		A,H
        OUT		(C),A
        EX		(SP),HL
        EX		(SP),HL
        LD		HL,WORK
        DEC		C
        OTIR
        RET
        ;
HKSAVE:	DEFS		5
WORK:	DEFS		256
COUNT:	DEFB		1,1,2,2,3,3
