function ContextConstructor(obj){
  let strategy_state;
  switch(obj.strategy){
    case 'concreteStrategy1':
      strategy_state = "Perform first variant of behavior";
      break;
    case 'concreteStrategy2':
      strategy_state = "Perform second variant of behavior";
      break;
    default:
      throw Error("Invalid strategy arguments for ContextConstructor")
  }
  
  return {
    contextInterface: function(){console.log(strategy_state)}
  }
}
function Duck(obj){
  let quackSound;
  switch(obj.quackSound.toLowerCase()){
    case 'quack':
      quackSound = 'Quack';
      break;
    case 'squeak':
      quackSound = 'Squeak';
      break;
    default:
      throw Error("Invalid quackSound arguments for Duck")
  }
  
  return {
    performQuack: function(){console.log(quackSound)}
  }
}

var context1 = ContextConstructor({strategy: 'concreteStrategy1'})
context1.contextInterface()
var mallard = Duck({quackSound: "quack"})
mallard.performQuack()

var context2 = ContextConstructor({strategy: 'concreteStrategy2'})
context2.contextInterface()
var toyDuck = Duck ({quackSound: "squeak"})
toyDuck.performQuack()