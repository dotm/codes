var array = [0,1,99,2]

function my_max (a){
  var x=a[0];
  for(var i in a){
    if (a[i] > x ){x=a[i]}
  };
  return x
};

var string="labocedihuy"

function vowel_count(s){
  var count=0
  var a=s.toLowerCase().split("")
  for(var i in a){
    switch(a[i]){
      case "a":
      case "o":
      case "e":
      case "i":
      case "u":
      case "y":
        count++;
        break;
    }
  };
  return count
};

function reverse(s){
  return s.split("").reverse().join("")
};