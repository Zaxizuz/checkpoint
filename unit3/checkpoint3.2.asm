//Each function of the kernal is a no-args function
//The functions are placed in the SYSCALLS table surrounded by JMP and NOP
  .file [name="checkpoint3.2.bin", type="bin", segments="XMega65Bin"]
.segmentdef XMega65Bin [segments="Syscall, Code, Data, Stack, Zeropage"]
.segmentdef Syscall [start=$8000, max=$81ff]
.segmentdef Code [start=$8200, min=$8200, max=$bdff]
.segmentdef Data [startAfter="Code", min=$8200, max=$bdff]
.segmentdef Stack [min=$be00, max=$beff, fill]
.segmentdef Zeropage [min=$bf00, max=$bfff, fill]
  .label VIC_MEMORY = $d018
  .label SCREEN = $400
  .label COLS = $d800
  .const WHITE = 1
  //To save writing 0x4c and 0xEA all the time, we define them as constants
  .const JMP = $4c
  .const NOP = $ea
  .label current_screen_x = 6
  .label current_screen_line = 2
  .label current_screen_line_30 = 4
  .label current_screen_line_46 = 4
  .label current_screen_line_59 = 4
  .label current_screen_line_60 = 4
  .label current_screen_line_61 = 4
  .label current_screen_line_63 = 4
  .label current_screen_line_64 = 4
  .label current_screen_line_65 = 4
  .label current_screen_line_66 = 4
  .label current_screen_line_67 = 4
.segment Code
main: {
    rts
}
cpukil: {
    jsr exit_hypervisor
    rts
}
exit_hypervisor: {
    lda #1
    sta $d67f
    rts
}
reserved: {
    rts
}
vf011wr: {
    jsr exit_hypervisor
    rts
}
vf011rd: {
    jsr exit_hypervisor
    rts
}
alttabkey: {
    jsr exit_hypervisor
    rts
}
restorkey: {
    jsr exit_hypervisor
    rts
}
pagfault: {
    jsr exit_hypervisor
    rts
}
reset: {
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
    lda #0
    sta.z current_screen_x
    lda #<$400
    sta.z current_screen_line_30
    lda #>$400
    sta.z current_screen_line_30+1
    lda #<MESSAGE
    sta.z print_to_screen.msg
    lda #>MESSAGE
    sta.z print_to_screen.msg+1
    jsr print_to_screen
    lda #<$400
    sta.z current_screen_line
    lda #>$400
    sta.z current_screen_line+1
    jsr print_newline
    lda.z current_screen_line
    sta.z current_screen_line_63
    lda.z current_screen_line+1
    sta.z current_screen_line_63+1
    lda #0
    sta.z current_screen_x
    lda #<MESSAGE2
    sta.z print_to_screen.msg
    lda #>MESSAGE2
    sta.z print_to_screen.msg+1
    jsr print_to_screen
    jsr print_newline
    jsr test_memory
    jsr exit_hypervisor
    rts
}
test_memory: {
    // definitions for checkpoint 3.2
    .const mem_start = $800
    .label p = $b
    .label mem_end = 9
    lda #<0
    sta.z p
    sta.z p+1
    lda #<$800
    sta.z p
    lda #>$800
    sta.z p+1
    lda #<$800
    sta.z mem_end
    lda #>$800
    sta.z mem_end+1
    ldx #0
    txa
    sta.z current_screen_x
  __b1:
    lda.z p+1
    cmp #>$8000
    bcc b1
    bne !+
    lda.z p
    cmp #<$8000
    bcc b1
  !:
  __b8:
    lda.z current_screen_line
    sta.z current_screen_line_65
    lda.z current_screen_line+1
    sta.z current_screen_line_65+1
    lda #<MESSAGE3
    sta.z print_to_screen.msg
    lda #>MESSAGE3
    sta.z print_to_screen.msg+1
    jsr print_to_screen
    lda.z current_screen_line
    sta.z current_screen_line_60
    lda.z current_screen_line+1
    sta.z current_screen_line_60+1
    lda #<mem_start
    sta.z print_hex.value
    lda #>mem_start
    sta.z print_hex.value+1
    jsr print_hex
    lda.z current_screen_line
    sta.z current_screen_line_66
    lda.z current_screen_line+1
    sta.z current_screen_line_66+1
    lda #<MESSAGE4
    sta.z print_to_screen.msg
    lda #>MESSAGE4
    sta.z print_to_screen.msg+1
    jsr print_to_screen
    lda.z mem_end
    sta.z print_hex.value
    lda.z mem_end+1
    sta.z print_hex.value+1
    lda.z current_screen_line
    sta.z current_screen_line_61
    lda.z current_screen_line+1
    sta.z current_screen_line_61+1
    jsr print_hex
    jsr print_newline
    lda.z current_screen_line
    sta.z current_screen_line_67
    lda.z current_screen_line+1
    sta.z current_screen_line_67+1
    lda #0
    sta.z current_screen_x
    lda #<MESSAGE5
    sta.z print_to_screen.msg
    lda #>MESSAGE5
    sta.z print_to_screen.msg+1
    jsr print_to_screen
    rts
  b1:
    lda #0
  __b2:
    cmp #$ff
    bcc __b3
  __b5:
    cpx #1
    bne __b7
    jmp __b8
  __b7:
    inc.z p
    bne !+
    inc.z p+1
  !:
    lda.z p
    sta.z mem_end
    lda.z p+1
    sta.z mem_end+1
    jmp __b1
  __b3:
    ldy #0
    sta (p),y
    cmp (p),y
    beq __b4
    lda.z current_screen_line
    sta.z current_screen_line_64
    lda.z current_screen_line+1
    sta.z current_screen_line_64+1
    lda #<MESSAGE99
    sta.z print_to_screen.msg
    lda #>MESSAGE99
    sta.z print_to_screen.msg+1
    jsr print_to_screen
    lda.z p
    sta.z print_hex.value
    lda.z p+1
    sta.z print_hex.value+1
    lda.z current_screen_line
    sta.z current_screen_line_59
    lda.z current_screen_line+1
    sta.z current_screen_line_59+1
    jsr print_hex
    jsr print_newline
    lda #0
    sta.z current_screen_x
    ldx #1
    jmp __b5
  __b4:
    clc
    adc #1
    jmp __b2
}
// Go to nextline for checkpoint3.1
print_newline: {
    lda #$28
    clc
    adc.z current_screen_line
    sta.z current_screen_line
    bcc !+
    inc.z current_screen_line+1
  !:
    rts
}
//function showing hexadecimal numbers for checkpoint3.2
// print_hex(word zeropage(7) value)
print_hex: {
    .label __3 = $d
    .label __6 = $f
    .label value = 7
    ldx #0
  __b1:
    cpx #4
    bcc __b2
    lda #0
    sta hex+4
    lda #<hex
    sta.z print_to_screen.msg
    lda #>hex
    sta.z print_to_screen.msg+1
    jsr print_to_screen
    rts
  __b2:
    lda.z value+1
    cmp #>$a000
    bcc __b4
    bne !+
    lda.z value
    cmp #<$a000
    bcc __b4
  !:
    ldy #$c
    lda.z value
    sta.z __3
    lda.z value+1
    sta.z __3+1
    cpy #0
    beq !e+
  !:
    lsr.z __3+1
    ror.z __3
    dey
    bne !-
  !e:
    lda.z __3
    sec
    sbc #9
    sta hex,x
  __b5:
    asl.z value
    rol.z value+1
    asl.z value
    rol.z value+1
    asl.z value
    rol.z value+1
    asl.z value
    rol.z value+1
    inx
    jmp __b1
  __b4:
    ldy #$c
    lda.z value
    sta.z __6
    lda.z value+1
    sta.z __6+1
    cpy #0
    beq !e+
  !:
    lsr.z __6+1
    ror.z __6
    dey
    bne !-
  !e:
    lda.z __6
    clc
    adc #'0'
    sta hex,x
    jmp __b5
  .segment Data
    hex: .fill 5, 0
}
.segment Code
// Print message for checkpoint3.1
print_to_screen: {
    .label msg = 7
  __b1:
    ldy #0
    lda (msg),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (msg),y
    ldy.z current_screen_x
    sta (current_screen_line_30),y
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    inc.z current_screen_x
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($d) str, byte register(X) c, word zeropage(9) num)
memset: {
    .label end = 9
    .label dst = $d
    .label num = 9
    .label str = $d
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
syscall64: {
    jsr exit_hypervisor
    rts
}
syscall63: {
    jsr exit_hypervisor
    rts
}
syscall62: {
    jsr exit_hypervisor
    rts
}
syscall61: {
    jsr exit_hypervisor
    rts
}
syscall60: {
    jsr exit_hypervisor
    rts
}
syscall59: {
    jsr exit_hypervisor
    rts
}
syscall58: {
    jsr exit_hypervisor
    rts
}
syscall57: {
    jsr exit_hypervisor
    rts
}
syscall56: {
    jsr exit_hypervisor
    rts
}
syscall55: {
    jsr exit_hypervisor
    rts
}
syscall54: {
    jsr exit_hypervisor
    rts
}
syscall53: {
    jsr exit_hypervisor
    rts
}
syscall52: {
    jsr exit_hypervisor
    rts
}
syscall51: {
    jsr exit_hypervisor
    rts
}
syscall50: {
    jsr exit_hypervisor
    rts
}
syscall49: {
    jsr exit_hypervisor
    rts
}
syscall48: {
    jsr exit_hypervisor
    rts
}
syscall47: {
    jsr exit_hypervisor
    rts
}
syscall46: {
    jsr exit_hypervisor
    rts
}
syscall45: {
    jsr exit_hypervisor
    rts
}
syscall44: {
    jsr exit_hypervisor
    rts
}
syscall43: {
    jsr exit_hypervisor
    rts
}
syscall42: {
    jsr exit_hypervisor
    rts
}
syscall41: {
    jsr exit_hypervisor
    rts
}
syscall40: {
    jsr exit_hypervisor
    rts
}
syscall39: {
    jsr exit_hypervisor
    rts
}
syscall38: {
    jsr exit_hypervisor
    rts
}
syscall37: {
    jsr exit_hypervisor
    rts
}
syscall36: {
    jsr exit_hypervisor
    rts
}
syscall35: {
    jsr exit_hypervisor
    rts
}
syscall34: {
    jsr exit_hypervisor
    rts
}
syscall33: {
    jsr exit_hypervisor
    rts
}
syscall32: {
    jsr exit_hypervisor
    rts
}
syscall31: {
    jsr exit_hypervisor
    rts
}
syscall30: {
    jsr exit_hypervisor
    rts
}
syscall29: {
    jsr exit_hypervisor
    rts
}
syscall28: {
    jsr exit_hypervisor
    rts
}
syscall27: {
    jsr exit_hypervisor
    rts
}
syscall26: {
    jsr exit_hypervisor
    rts
}
syscall25: {
    jsr exit_hypervisor
    rts
}
syscall24: {
    jsr exit_hypervisor
    rts
}
syscall23: {
    jsr exit_hypervisor
    rts
}
syscall22: {
    jsr exit_hypervisor
    rts
}
syscall21: {
    jsr exit_hypervisor
    rts
}
syscall20: {
    jsr exit_hypervisor
    rts
}
syscall19: {
    jsr exit_hypervisor
    rts
}
syscall18: {
    jsr exit_hypervisor
    rts
}
syscall17: {
    jsr exit_hypervisor
    rts
}
syscall16: {
    jsr exit_hypervisor
    rts
}
syscall15: {
    jsr exit_hypervisor
    rts
}
syscall14: {
    jsr exit_hypervisor
    rts
}
syscall13: {
    jsr exit_hypervisor
    rts
}
securexit: {
    jsr exit_hypervisor
    rts
}
securentr: {
    jsr exit_hypervisor
    rts
}
syscall10: {
    jsr exit_hypervisor
    rts
}
syscall9: {
    jsr exit_hypervisor
    rts
}
syscall8: {
    jsr exit_hypervisor
    rts
}
syscall7: {
    jsr exit_hypervisor
    rts
}
syscall6: {
    jsr exit_hypervisor
    rts
}
syscall5: {
    jsr exit_hypervisor
    rts
}
syscall4: {
    jsr exit_hypervisor
    rts
}
syscall3: {
    jsr exit_hypervisor
    rts
}
syscall2: {
    jsr exit_hypervisor
    rts
}
//SYSCALL handlers
syscall1: {
    jsr exit_hypervisor
    rts
}
.segment Data
  //Some text to display
  MESSAGE: .text "Lin0385 operating system starting..."
  .byte 0
  MESSAGE2: .text "testing hardware"
  .byte 0
  MESSAGE3: .text "memory found at $"
  .byte 0
  MESSAGE4: .text " - $"
  .byte 0
  MESSAGE5: .text "finished testing hardware"
  .byte 0
  MESSAGE99: .text "memory error at"
  .byte 0
.segment Syscall
  //A table of up to 64 SYSCALL handlers expressed in a fairly readable and easy format
  //Each line is an instance of the struct SysCall from above, with the JMP opcode value
  //the address of the handler routine and the NOP opcode value
  SYSCALLS: .byte JMP
  .word syscall1
  .byte NOP, JMP
  .word syscall2
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
  .word syscall10
  .byte NOP, JMP
  .word securentr
  .byte NOP, JMP
  .word securexit
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
  .word syscall40
  .byte NOP, JMP
  .word syscall41
  .byte NOP, JMP
  .word syscall42
  .byte NOP, JMP
  .word syscall43
  .byte NOP, JMP
  .word syscall44
  .byte NOP, JMP
  .word syscall45
  .byte NOP, JMP
  .word syscall46
  .byte NOP, JMP
  .word syscall47
  .byte NOP, JMP
  .word syscall48
  .byte NOP, JMP
  .word syscall49
  .byte NOP, JMP
  .word syscall50
  .byte NOP, JMP
  .word syscall51
  .byte NOP, JMP
  .word syscall52
  .byte NOP, JMP
  .word syscall53
  .byte NOP, JMP
  .word syscall54
  .byte NOP, JMP
  .word syscall55
  .byte NOP, JMP
  .word syscall56
  .byte NOP, JMP
  .word syscall57
  .byte NOP, JMP
  .word syscall58
  .byte NOP, JMP
  .word syscall59
  .byte NOP, JMP
  .word syscall60
  .byte NOP, JMP
  .word syscall61
  .byte NOP, JMP
  .word syscall62
  .byte NOP, JMP
  .word syscall63
  .byte NOP, JMP
  .word syscall64
  .byte NOP
  //We can just ask KickC to make the TRAP table begin at the next multiple of $100, i.e., at $8100
  .align $100
  TRAPS: .byte JMP
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
