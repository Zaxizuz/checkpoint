.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
//}
main: {
    lda #<message
    sta.z print_string.message
    lda #>message
    sta.z print_string.message+1
    jsr print_string
    jsr get_os_version
    lda #<get_os_version.version
    sta.z print_string.message
    lda #>get_os_version.version
    sta.z print_string.message+1
    jsr print_string
    rts
    message: .text "os version is"
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
get_os_version: {
    .label location = 6
    jsr call_syscall03
    lda #<$300
    sta.z location
    lda #>$300
    sta.z location+1
    ldx #0
  __b1:
    ldy #0
    lda (location),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (location),y
    sta version,x
    inx
    inc.z location
    bne !+
    inc.z location+1
  !:
    jmp __b1
    version: .fill $100, 0
}
call_syscall03: {
    jsr enable_syscalls
    lda #1
    sta $d643
    nop
    rts
}
