class Main {
  public static void main(String[] args) {
    Component component = new ConcreteComponent();
    component.operation();
    BuyGood phone = new BuyPhone();
    phone.displayPrice();
    
    Component component_withA = new ConcreteDecoratorA(component);
    component_withA.operation();
    BuyGood phone_withMicroSD = new BuyMicroSD(phone);
    phone_withMicroSD.displayPrice();
    
    Component component_withB = new ConcreteDecoratorB(component);
    component_withB.operation();
    BuyGood phone_withHeadset = new BuyHeadset(phone);
    phone_withHeadset.displayPrice();
    
    Component component_withA_andB = new ConcreteDecoratorB(component_withA);
    component_withA_andB.operation();
    BuyGood phone_withHeadset_andMicroSD = new BuyMicroSD(phone_withHeadset);
    phone_withHeadset_andMicroSD.displayPrice();
  }
}

abstract class Component {
  public abstract void operation();
}
abstract class BuyGood {
  public abstract int getTotalPrice();
  
  void displayPrice(){
    System.out.println("Total Price (IDR):");
    System.out.println(getTotalPrice());
  }
}

class ConcreteComponent extends Component {
  public void operation(){
    System.out.println("String from ConcreteComponent");
  }
}
class BuyPhone extends BuyGood {
  public int getTotalPrice(){
    return 2000000;
  }
}

abstract class Decorator extends Component {
  public abstract void operation();
}
abstract class BuyGoodDecorator extends BuyGood {
  public abstract int getTotalPrice();
}

class ConcreteDecoratorA extends Decorator {
  // aggregate Component
  Component component;
  
  public ConcreteDecoratorA(Component component){
    this.component = component;
  }
  
  public void operation(){
    component.operation();
    System.out.println("String from ConcreteDecoratorA");
  }
}
class BuyMicroSD extends BuyGoodDecorator {
  BuyGood good;
  
  public BuyMicroSD(BuyGood good){
    this.good = good;
  }
  
  public int getTotalPrice(){
    return 75000 + good.getTotalPrice();
  }
}

class ConcreteDecoratorB extends Decorator {
  // aggregate Component
  Component component;
  
  public ConcreteDecoratorB(Component component){
    this.component = component;
  }
  
  public void operation(){
    component.operation();
    System.out.println("String from ConcreteDecoratorB");
  }
}
class BuyHeadset extends BuyGoodDecorator {
  BuyGood good;
  
  public BuyHeadset(BuyGood good){
    this.good = good;
  }
  
  public int getTotalPrice(){
    return 30000 + good.getTotalPrice();
  }
}