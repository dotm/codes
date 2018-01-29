var Singleton = {
  singletonData: 1,
  singletonOperation: function(){}
}
var Mario = {
  isBig: false,
  isInvincible: false,
  isAlive: true,
  jump: function(){console.log("Mario jumps")},
  moveLeft: function(){console.log("Mario moves to the left")},
  moveRight: function(){console.log("Mario moves to the right")},
  touchEnemy: function(){
    var mario = this
    if(mario.isInvincible){
      console.log("Mario is invincible, enemy dies");
    }else{
      mario.isAlive = false;
      console.log("Mario dies");
    }
  }
}