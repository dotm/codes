function reverseString(string){
  var arrayOfChars = string.split('')
  var reversedString = arrayOfChars.reduceRight((accumulator,element)=>{return accumulator+element},'')
  return reversedString
}