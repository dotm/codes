function isImageFile (string){
  if(/[\/.](gif|jpg|jpeg|tiff|png)$/i.test(string)){
      return true
  }else if(/^data:image/i.test(string)){
      return true
  }else{
      return false
  }
}