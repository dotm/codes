function templateMethod(obj){
  obj.primitiveOperation()
}
function cast_ultimateSpell(hero){
  if(hero.mana >= hero.ultimateSpell_mana){
    hero.ultimateSpell()
  }else{
    console.log("Mana is not enough!")
  }
}

function ConcreteClass1(){
  this.primitiveOperation = function(){
    console.log("Primitive Operation 1")
  }
}
function Lina(){
  this.mana = 1000
  this.ultimateSpell_mana = 680
  this.ultimateSpell = function lagunaBlade (){
    console.log("Lina cast Laguna Blade!")
  }
}

function ConcreteClass2(){
  this.primitiveOperation = function(){
    console.log("Primitive Operation 2")
  }
}
function Luna(){
  this.mana = 1000
  this.ultimateSpell_mana = 250
  this.ultimateSpell = function eclipse(){
    console.log("Luna cast Eclipse!")
  }
}

var a = new ConcreteClass1()
templateMethod(a)
var player1 = new Lina()
cast_ultimateSpell(player1)

var b = new ConcreteClass2()
templateMethod(b)
var player2 = new Luna()
cast_ultimateSpell(player2)