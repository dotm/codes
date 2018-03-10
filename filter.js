function myfilter(arr,cb){
  return arr.reduce(
    (acc,cur) => {
      if (cb(cur)){
        acc.push(cur)
        return acc
      } else {
        return acc
      }
    },
    []
  )
}