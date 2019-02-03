void printBinary(int n){
  int c, k;
  for (c = 31; c >= 0; c--){
    k = n >> c;
 
    if (k & 1)
      printf("1");
    else
      printf("0");
  }
  printf("\n");
}