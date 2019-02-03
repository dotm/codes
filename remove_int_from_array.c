int removeElement(int* nums, int numsSize, int val) {
  if(numsSize == 0){
    return 0;
  }

  int oldArrayPointer = 0;
  int newArrayPointer = 0;

  while(oldArrayPointer < numsSize){
    _Bool value_isNotFiltered = nums[oldArrayPointer] != val;
    if(value_isNotFiltered){
      nums[newArrayPointer] = nums[oldArrayPointer];
      //printf("value: %d\n", nums[newArrayPointer]);
      newArrayPointer++;
    }
    oldArrayPointer++;
  }

  int length = newArrayPointer;
  return length;
}