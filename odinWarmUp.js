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

function myEach(array,callback){
  for (i in array){
    callback(array[i])
  }
}
myEach([1,2,3,4], function(item){
  console.log(item);
});
function myMap(array,callback){
  // with myEach
  var newArray = []
  myEach(array,function(item){
    newArray.push( callback(item) )
  })
  return newArray
}
myMap([1,2,3,4], function(item){
  return item * 2;
});
function myMap(array,callback){
  // without myEach
  var newArray=[]
  for(i in array){
    newArray.push( callback(array[i]) )
  }
  return newArray
}
myMap([1,2,3,4], function(item){
  return item * 2;
});

