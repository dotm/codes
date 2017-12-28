class Main {
  public static void main(String[] args) {
    Creator creator1 = new ConcreteCreator1();
    Product product1 = creator1.factoryMethod();
    System.out.println(product1.getClass());
    
    ComputerMaker factory1 = new x86_ComputerMaker();
    Computer computer1 = factory1.makeComputer();
    System.out.println(computer1.getDescription());
    
    Creator creator2 = new ConcreteCreator2();
    Product product2 = creator2.factoryMethod();
    System.out.println(product2.getClass());
    
    ComputerMaker factory2 = new x64_ComputerMaker();
    Computer computer2 = factory2.makeComputer();
    System.out.println(computer2.getDescription());
  }
}

abstract class Creator {
  abstract Product factoryMethod();
}
abstract class ComputerMaker {
  abstract Computer makeComputer();
}

class ConcreteCreator1 extends Creator {
  Product factoryMethod(){
    return new ConcreteProduct1();
  }
}
class x86_ComputerMaker extends ComputerMaker {
  Computer makeComputer(){
    return new x86_Computer();
  }
}

class ConcreteCreator2 extends Creator {
  Product factoryMethod(){
    return new ConcreteProduct2();
  }
}
class x64_ComputerMaker extends ComputerMaker {
  Computer makeComputer(){
    return new x64_Computer();
  }
}

abstract class Product {}
abstract class Computer {
  abstract String getDescription();
}

class ConcreteProduct1 extends Product {}
class x86_Computer extends Computer {
  String getDescription(){
    return "Windows x86 32-bit OS, 4GB RAM";
  }
}

class ConcreteProduct2 extends Product {}
class x64_Computer extends Computer {
  String getDescription(){
    return "Windows x64 64-bit OS, 16GB RAM";
  }
}