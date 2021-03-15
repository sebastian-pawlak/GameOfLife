; "Game of Life", Atari XL/XE Intro 128B
; (122 bytes of code + 6 bytes of header)
; code by tr1x / Agenda
; requirements: original Atari XL/XE 64KB PAL
; version: 1.0
; release date: 2021-03-13

char	equ $40			; $40: heart
addr	equ $10
ptr1	equ $80-4
ptr2	equ $80-2
margin	equ $01
color2	equ $02c6
dlptr	equ $bc25
consol	equ $d01f


	org $0080

	; universe initialization
start	lda #char
	ldx #fig2-fig1-1
loop1	ldy fig1,x
	sta 256*(addr+1)+64,y
	ldy fig2,x
	sta 256*(addr+1)+64+(40*18),y
	dex
	bpl loop1

	; pointers initialization
loop2	lda #addr+margin
	sta dlptr
	lda #addr
	sta color2
	sta ptr1+1
	asl
	sta ptr2+1
	sta consol		; buzz

	; count number of neighbors
loop3	txa			; lda #$00
	ldx #$08
	clc
loop4	ldy ofs,x
	adc (ptr1),y
	dex
	bpl loop4

	; die, live or resurrect
	; (since we count 9 cells, not 8, we consider 4 and 3 neighbors)
	cmp #(4*char)%256
	beq skip1
	cmp #(3*char)%256
	beq skip2
	lda #$00		; die
	beq skip3		; jmp skip3
skip1	lda (ptr1),y		; stay alive or dead
	jmp skip3
skip2	lda #char		; resurrect
skip3	sta (ptr2),y

	; increment pointers
	inc ptr1
	inc ptr2
	bne loop3
	inc ptr1+1
	inc ptr2+1
	lda ptr1+1
	cmp #addr+5
	beq skip4
	cmp #(addr<<1)+5
	beq loop2
	bne loop3		; jmp loop3

	; pointers initialization
skip4	lda #addr
	sta ptr2+1
	asl
	sta ptr1+1
	lda #addr*2+margin
	sta dlptr

	bne loop3		; jmp loop3, infinity loop


	; offsets of cell's neighbors
ofs	.byte 41, 0, 1, 2, 40, 42, 80, 81, 82

	; the glider
fig1	.byte 40*0+6, 40*1+7, 40*2+5, 40*2+6, 40*2+7

	; the boat
fig2	.byte 40*0+25, 40*1+24, 40*1+26, 40*2+25, 40*2+26