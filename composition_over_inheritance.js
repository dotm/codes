const walker = (state)=>({
  walk: ()=>{console.log(state.name + " is walking")}
})

const eater = (state)=>({
  eat: ()=>{console.log(state.name + " is eating")}
})

function isDog(name = "This dog"){
  let state = {
    name,
  }
  
  return Object.assign(
    {},
    walker(state),
    eater(state)
  )
}

DannyTheDog = isDog("Danny")