function x86_ComputerMaker(){
  function x86_Computer(){
    return {
      getDescription: () => {return "Windows x86 32-bit OS, 4GB RAM"}
    }
  }
  
  return {
    makeComputer: () => {return x86_Computer()}
  }
}

function x64_ComputerMaker(){
  function x64_Computer(){
    return {
      getDescription: () => {return "Windows x64 64-bit OS, 16GB RAM"}
    }
  }
  
  return {
    makeComputer: () => {return x64_Computer()}
  }
}

var factory1 = new x86_ComputerMaker();
var computer1 = factory1.makeComputer();
console.log(computer1.getDescription());

var factory2 = new x64_ComputerMaker();
var computer2 = factory2.makeComputer();
console.log(computer2.getDescription());