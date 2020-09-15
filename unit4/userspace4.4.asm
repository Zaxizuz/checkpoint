.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr print_string
    rts
    message: .text "printed via print string api"
    .byte 0
}
// print_string(byte* zeropage(2) message)
print_string: {
    .label location = 4
    .label message = 2
    lda #<$300
    sta.z location
    lda #>$300
    sta.z location+1
    lda #<main.message
    sta.z message
    lda #>main.message
    sta.z message+1
  __b1:
    ldy #0
    lda (message),y
    cmp #0
    bne __b2
    tya
    tay
    sta (location),y
    jsr call_syscall02
    rts
  __b2:
    ldy #0
    lda (message),y
    sta (location),y
    inc.z location
    bne !+
    inc.z location+1
  !:
    inc.z message
    bne !+
    inc.z message+1
  !:
    jmp __b1
}
call_syscall02: {
    jsr enable_syscalls
    lda #1
    sta $d642
    nop
    rts
}
enable_syscalls: {
    lda #$47
    sta $d02f
    lda #$53
    sta $d02f
    rts
}
