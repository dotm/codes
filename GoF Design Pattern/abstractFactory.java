class Main {
  public static void main(String[] args) {
    Client client1 = new Client(new ConcreteFactory1());
    client1.getProductsDescription();
    Tracksuit adidasTracksuit = new Tracksuit(new AdidasTracksuitFactory());
    adidasTracksuit.getTracksuitDescription();
    
    Client client2 = new Client(new ConcreteFactory2());
    client2.getProductsDescription();
    Tracksuit nikeTracksuit = new Tracksuit(new NikeTracksuitFactory());
    nikeTracksuit.getTracksuitDescription();
  }
}

abstract class AbstractFactory {
  abstract AbstractProductA createProductA();
  abstract AbstractProductB createProductB();
}
abstract class TracksuitFactory {
  abstract Trousers makeTrousers();
  abstract Jacket makeJacket();
}

class ConcreteFactory1 extends AbstractFactory {
  AbstractProductA createProductA(){
    return new ProductA1();
  }
  
  AbstractProductB createProductB(){
    return new ProductB1();
  }
}
class AdidasTracksuitFactory extends TracksuitFactory {
  Trousers makeTrousers(){
    return new AdidasTrousers();
  }
  
  Jacket makeJacket(){
    return new AdidasJacket();
  }
}

class ConcreteFactory2 extends AbstractFactory {
  AbstractProductA createProductA(){
    return new ProductA2();
  }
  
  AbstractProductB createProductB(){
    return new ProductB2();
  }
}
class NikeTracksuitFactory extends TracksuitFactory {
  Trousers makeTrousers(){
    return new NikeTrousers();
  }
  
  Jacket makeJacket(){
    return new NikeJacket();
  }
}

abstract class AbstractProductA {
  abstract String getDescriptionProductA();
}
abstract class Trousers {
  abstract String getTrousersDescription();
}

class ProductA1 extends AbstractProductA {
  String getDescriptionProductA(){
    return "ProductA1";
  }
}
class AdidasTrousers extends Trousers {
  String getTrousersDescription(){
    return "Adidas Trousers";
  }
}

class ProductA2 extends AbstractProductA {
  String getDescriptionProductA(){
    return "ProductA2";
  }
}
class NikeTrousers extends Trousers {
  String getTrousersDescription(){
    return "Nike Trousers";
  }
}

abstract class AbstractProductB {
  abstract String getDescriptionProductB();
}
abstract class Jacket {
  abstract String getJacketDescription();
}

class ProductB1 extends AbstractProductB {
  String getDescriptionProductB(){
    return "ProductB1";
  }
}
class AdidasJacket extends Jacket {
  String getJacketDescription(){
    return "Adidas Jacket";
  }
}

class ProductB2 extends AbstractProductB {
  String getDescriptionProductB(){
    return "ProductB2";
  }
}
class NikeJacket extends Jacket {
  String getJacketDescription(){
    return "Nike Jacket";
  }
}

class Client {
  AbstractProductA productA;
  AbstractProductB productB;
  
  public Client(AbstractFactory abstractFactory){
    productA = abstractFactory.createProductA();
    productB = abstractFactory.createProductB();
  }
  
  void getProductsDescription(){
    System.out.println(
      productA.getDescriptionProductA() + " " + productB.getDescriptionProductB() + "."
    );
  }
}
class Tracksuit {
  Trousers trousers;
  Jacket jacket;
  
  public Tracksuit(TracksuitFactory tracksuitFactory){
    trousers = tracksuitFactory.makeTrousers();
    jacket = tracksuitFactory.makeJacket();
  }
  
  void getTracksuitDescription(){
    System.out.println(
      trousers.getTrousersDescription() + " with " + jacket.getJacketDescription() + "."
    );
  }
}