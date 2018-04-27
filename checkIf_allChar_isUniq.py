def sortString(string):
  return ''.join(sorted(string))

#without any data structure (using sort only)
def checkIf_allChar_isUniq(string):
  sorted_string = sortString(string)
  for i in range(len(sorted_string)):
    allCharacter_isUnique = (i+1 == len(sorted_string))
    if allCharacter_isUnique:
      isUnique = True
    elif(sorted_string[i] == sorted_string[i+1]):
      isUnique = False
      break
  return isUnique