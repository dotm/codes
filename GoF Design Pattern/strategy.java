class Main {
  public static void main(String[] args) {
    Context client1 = new Client1();
    client1.contextInterfaceToBehavior();
    Duck mallard = new MallardDuck();
    mallard.performQuack();
    
    Context client2 = new Client2();
    client2.contextInterfaceToBehavior();
    Duck toyDuck = new ToyDuck();
    toyDuck.performQuack();
  }
}

interface Strategy {
  public void behavior();
}
interface QuackBehavior {
  public void quack();
}

class ConcreteStrategy1 implements Strategy {
  public void behavior(){
    System.out.println("Perform first variant of behavior");
  }
}
class ConcreteStrategy2 implements Strategy {
  public void behavior(){
    System.out.println("Perform second variant of behavior");
  }
}
class Quack implements QuackBehavior {
  public void quack(){
    System.out.println("Quack");
  }
}
class Squeak implements QuackBehavior {
  public void quack(){
    System.out.println("Squeak");
  }
}

abstract class Context {
  Strategy strategy;
  
  public void contextInterfaceToBehavior(){
    strategy.behavior();
  }
}
abstract class Duck {
  QuackBehavior quackBehavior;
  
  public void performQuack(){
    quackBehavior.quack();
  }
}

class Client1 extends Context {
  public Client1(){
    // set one algorithm for the behavior
    strategy = new ConcreteStrategy1();
  }
}
class MallardDuck extends Duck {
  public MallardDuck(){
    quackBehavior = new Quack();
  }
}
class Client2 extends Context {
  public Client2(){
    // set one algorithm for the behavior
    strategy = new ConcreteStrategy2();
  }
}
class ToyDuck extends Duck {
  public ToyDuck(){
    quackBehavior = new Squeak();
  }
}