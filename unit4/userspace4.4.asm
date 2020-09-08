.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr print_string
    rts
    message: .text "printed via print string api"
    .byte 0
}
print_string: {
    //*(unsigned char *)$0300 = *message;
    //*(unsigned char *)$0301 = 't';
    //*(unsigned char *)$0302 = 'e';
    //*(unsigned char *)$0303 = 's';
    //*(unsigned char *)$0304 = 't';
    //*(unsigned char *)$0305 = message[2];
    //*(unsigned char *)$0306 = message[255];
    .label location = $300
    ldx #0
  //while (*message){
  //	*(location + i) = *message++;
  //	i++;
  //}
  //while (message){
  //	*(location+i) = message[i];
  //	i++;
  //}
  __b2:
    lda main.message,x
    sta location,x
    inx
    jmp __b2
}
