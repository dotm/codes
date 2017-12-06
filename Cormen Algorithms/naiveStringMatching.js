function match(str,matcher){
  // if string or matcher is empty, return -1
  if (str.length === 0) return -1;
  if (matcher.length === 0) return -1;
  
  // check if any character in string match the first character of matcher
  for (var i=0; i<str.length; i++){
    // if there is a match
    if (str[i] === matcher[0]){
      // check if the string match all character in the matcher
      var matched = true;
      for (var j=0; j<matcher.length; j++){
        // if the index currently checked is outside the string index (overflow), return -1
        if (i+j >= str.length) return -1;
        // if any character doesn't match, go back to checking if any character in string match the first character of matcher
        if (str[i+j] !== matcher[j]){
          matched = false;
          break;
        }
      }
      // if all the character in the matcher match, return the index of the string character that match the first character of the matcher
      if (matched) return i;
    }
  }
  
  // if no match detected, return -1
  return -1
}