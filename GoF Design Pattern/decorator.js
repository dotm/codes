function Component(){
  function operation(){
    console.log("String from ConcreteComponent")
  }
  
  function with_(...decoratorsArray){
    let behaviorArray = [operation]
    decoratorsArray.forEach(function(decorator){
      behaviorArray.push(decorator.addedBehavior)
    })
    return {
      operation: function(){
        // execute each behavior
        behaviorArray.forEach(function(behavior){behavior()})
      }
    }
  }
  
  return{with_, operation}
}
function Phone(){
  let price = 2000000

  function displayPrice(){
    let totalPrice = price
    console.log("Total Price (IDR):")
    console.log(totalPrice)
  }
  
  function with_(...phoneAccessories){
    let totalPrice = price
    phoneAccessories.forEach(
      (decorator) => {totalPrice = totalPrice + decorator.price}
    )
    
    return {displayPrice: function (){
        console.log("Total Price (IDR):")
        console.log(totalPrice)
      }
    }
  }
  
  return {with_, displayPrice}
}

let concreteDecoratorA = {
  addedBehavior: function(){console.log("String from ConcreteDecoratorA")}
}
let concreteDecoratorB = {
  addedBehavior: function(){console.log("String from ConcreteDecoratorB")}
}
let MicroSD = {price: 75000}
let Headset = {price: 30000}

let concreteComponent = Component()
concreteComponent.operation()
let phone = Phone()
phone.displayPrice()

concreteComponent.with_(concreteDecoratorA).operation()
phone.with_(MicroSD).displayPrice()

concreteComponent.with_(concreteDecoratorB).operation()
phone.with_(Headset).displayPrice()

concreteComponent.with_(concreteDecoratorA, concreteDecoratorB).operation()
phone.with_(Headset, MicroSD).displayPrice()