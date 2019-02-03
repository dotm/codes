#include "stdio.h"

typedef unsigned char *byte_pointer;

void show_bytes_in_hex(byte_pointer cursor, size_t length){
  int i;
  for(i=0; i<length; i++){
    printf("%.2x",cursor[i]);
  }
  printf("\n");
}

void show_int_in_hex(int x){
  show_bytes_in_hex((byte_pointer) &x, sizeof(int));
}

int main(void) {
  show_int_in_hex(100);
  return 0;
}