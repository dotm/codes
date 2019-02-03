#include "stdio.h"

int strStr(char* haystack, char* needle) {
  _Bool needle_isEmpty = needle[0] == '\0';
  _Bool haystack_isEmpty = haystack[0] == '\0';
  if(needle_isEmpty){
    return 0;
  }else if(haystack_isEmpty || needle_isEmpty){
    return -1;
  }

  int startOfMatching_haystackIndex = 0;
  int willBeMatched_haystackIndex = 0;

  int willBeMatched_needleIndex = 0;
  //int totalCharactersMatched = willBeMatched_needleIndex;

  while(haystack[willBeMatched_haystackIndex] != '\0'){
    //printf("%c",haystack[willBeMatched_haystackIndex]);

    _Bool characterMatched = haystack[willBeMatched_haystackIndex] == needle[willBeMatched_needleIndex];
    if(characterMatched){
      willBeMatched_haystackIndex++;
      willBeMatched_needleIndex++;

      _Bool needleFound = needle[willBeMatched_needleIndex] == '\0';
      if(needleFound){
        return startOfMatching_haystackIndex;
      }
    }else{
      willBeMatched_needleIndex = 0;
      startOfMatching_haystackIndex++;
      willBeMatched_haystackIndex = startOfMatching_haystackIndex;
    }
  }

  return -1;
}

int main(void) {
  int index = strStr("ababceababcdx","ababcd");
  printf("%d",index);
  return 0;
}