  .file [name="checkpoint2.2.bin", type="bin", segments="XMega65Bin"]
.segmentdef XMega65Bin [segments="Syscall, Code, Data, Stack, Zeropage"]
.segmentdef Syscall [start=$8000, max=$81ff]
.segmentdef Code [start=$8200, min=$8200, max=$bdff]
.segmentdef Data [startAfter="Code", min=$8200, max=$bdff]
.segmentdef Stack [min=$be00, max=$beff, fill]
.segmentdef Zeropage [min=$bf00, max=$bfff, fill]
  .label RASTER = $d012
  .label VIC_MEMORY = $d018
  .label SCREEN = $400
  .label BGCOL = $d021
  .label COLS = $d800
  .const BLACK = 0
  .const WHITE = 1
  .const JMP = $4c
  .const NOP = $ea
.segment Code
main: {
    .label sc = 4
    .label msg = 2
    lda #$14
    sta VIC_MEMORY
    ldx #' '
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    ldx #WHITE
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    lda #<SCREEN+$28
    sta.z sc
    lda #>SCREEN+$28
    sta.z sc+1
    lda #<MESSAGE
    sta.z msg
    lda #>MESSAGE
    sta.z msg+1
  __b1:
    ldy #0
    lda (msg),y
    cmp #0
    bne __b2
  __b3:
    lda #$34
    cmp RASTER
    beq __b4
    lda #$42
    cmp RASTER
    beq __b4
    lda #BLACK
    sta BGCOL
    jmp __b3
  __b4:
    lda #WHITE
    sta BGCOL
    jmp __b3
  __b2:
    ldy #0
    lda (msg),y
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage(4) str, byte register(X) c, word zeropage(2) num)
memset: {
    .label end = 2
    .label dst = 4
    .label num = 2
    .label str = 4
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    rts
  __b3:
    txa
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
cpukil: {
    rts
}
reserved: {
    rts
}
vf011wr: {
    rts
}
vf011rd: {
    rts
}
alttabkey: {
    rts
}
restorkey: {
    rts
}
pagfault: {
    rts
}
reset: {
    rts
}
syscall3F: {
    rts
}
syscall3E: {
    rts
}
syscall3D: {
    rts
}
syscall3C: {
    rts
}
syscall3B: {
    rts
}
syscall3A: {
    rts
}
syscall39: {
    rts
}
syscall38: {
    rts
}
syscall37: {
    rts
}
syscall36: {
    rts
}
syscall35: {
    rts
}
syscall34: {
    rts
}
syscall33: {
    rts
}
syscall32: {
    rts
}
syscall31: {
    rts
}
syscall30: {
    rts
}
syscall2F: {
    rts
}
syscall2E: {
    rts
}
syscall2D: {
    rts
}
syscall2C: {
    rts
}
syscall2B: {
    rts
}
syscall2A: {
    rts
}
syscall29: {
    rts
}
syscall28: {
    rts
}
syscall27: {
    rts
}
syscall26: {
    rts
}
syscall25: {
    rts
}
syscall24: {
    rts
}
syscall23: {
    rts
}
syscall22: {
    rts
}
syscall21: {
    rts
}
syscall20: {
    rts
}
syscall1F: {
    rts
}
syscall1E: {
    rts
}
syscall1D: {
    rts
}
syscall1C: {
    rts
}
syscall1B: {
    rts
}
syscall1A: {
    rts
}
syscall19: {
    rts
}
syscall18: {
    rts
}
syscall17: {
    rts
}
syscall16: {
    rts
}
syscall15: {
    rts
}
syscall14: {
    rts
}
syscall13: {
    rts
}
syscall10: {
    rts
}
syscallF: {
    rts
}
syscallE: {
    rts
}
syscallD: {
    rts
}
syscallC: {
    rts
}
syscallB: {
    rts
}
syscallA: {
    rts
}
syscall9: {
    rts
}
syscall8: {
    rts
}
syscall7: {
    rts
}
syscall6: {
    rts
}
syscall5: {
    rts
}
syscall4: {
    rts
}
syscall3: {
    rts
}
syscall0: {
    rts
}
syscall2: {
    lda #'<'
    sta SCREEN+$4e
    rts
}
syscall1: {
    lda #'>'
    sta SCREEN+$4f
    rts
}
.segment Data
  MESSAGE: .text "checkpoint2.2 by lin0385"
  .byte 0
.segment Syscall
  SYSCALLS: .byte JMP
  .word syscall1
  .byte NOP, JMP
  .word syscall2
  .byte NOP, JMP
  .word syscall0
  .byte NOP, JMP
  .word syscall3
  .byte NOP, JMP
  .word syscall4
  .byte NOP, JMP
  .word syscall5
  .byte NOP, JMP
  .word syscall6
  .byte NOP, JMP
  .word syscall7
  .byte NOP, JMP
  .word syscall8
  .byte NOP, JMP
  .word syscall9
  .byte NOP, JMP
  .word syscallA
  .byte NOP, JMP
  .word syscallB
  .byte NOP, JMP
  .word syscallC
  .byte NOP, JMP
  .word syscallD
  .byte NOP, JMP
  .word syscallE
  .byte NOP, JMP
  .word syscallF
  .byte NOP, JMP
  .word syscall10
  .byte NOP, JMP
  .word syscall13
  .byte NOP, JMP
  .word syscall14
  .byte NOP, JMP
  .word syscall15
  .byte NOP, JMP
  .word syscall16
  .byte NOP, JMP
  .word syscall17
  .byte NOP, JMP
  .word syscall18
  .byte NOP, JMP
  .word syscall19
  .byte NOP, JMP
  .word syscall1A
  .byte NOP, JMP
  .word syscall1B
  .byte NOP, JMP
  .word syscall1C
  .byte NOP, JMP
  .word syscall1D
  .byte NOP, JMP
  .word syscall1E
  .byte NOP, JMP
  .word syscall1F
  .byte NOP, JMP
  .word syscall20
  .byte NOP, JMP
  .word syscall21
  .byte NOP, JMP
  .word syscall22
  .byte NOP, JMP
  .word syscall23
  .byte NOP, JMP
  .word syscall24
  .byte NOP, JMP
  .word syscall25
  .byte NOP, JMP
  .word syscall26
  .byte NOP, JMP
  .word syscall27
  .byte NOP, JMP
  .word syscall28
  .byte NOP, JMP
  .word syscall29
  .byte NOP, JMP
  .word syscall2A
  .byte NOP, JMP
  .word syscall2B
  .byte NOP, JMP
  .word syscall2C
  .byte NOP, JMP
  .word syscall2D
  .byte NOP, JMP
  .word syscall2E
  .byte NOP, JMP
  .word syscall2F
  .byte NOP, JMP
  .word syscall30
  .byte NOP, JMP
  .word syscall31
  .byte NOP, JMP
  .word syscall32
  .byte NOP, JMP
  .word syscall33
  .byte NOP, JMP
  .word syscall34
  .byte NOP, JMP
  .word syscall35
  .byte NOP, JMP
  .word syscall36
  .byte NOP, JMP
  .word syscall37
  .byte NOP, JMP
  .word syscall38
  .byte NOP, JMP
  .word syscall39
  .byte NOP, JMP
  .word syscall3A
  .byte NOP, JMP
  .word syscall3B
  .byte NOP, JMP
  .word syscall3C
  .byte NOP, JMP
  .word syscall3D
  .byte NOP, JMP
  .word syscall3E
  .byte NOP, JMP
  .word syscall3F
  .byte NOP
  .align $100
  TRAPS: .byte JMP
  .word main
  .byte NOP, JMP
  .word reset
  .byte NOP, JMP
  .word pagfault
  .byte NOP, JMP
  .word restorkey
  .byte NOP, JMP
  .word alttabkey
  .byte NOP, JMP
  .word vf011rd
  .byte NOP, JMP
  .word vf011wr
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word cpukil
  .byte NOP
