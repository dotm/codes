class Main {
  public static void main(String[] args) {
    ConcreteClass1 a = new ConcreteClass1();
    a.primitiveOperation();
    Luna player1 = new Luna();
    player1.cast_ultimateSpell();
    
    ConcreteClass2 b = new ConcreteClass2();
    b.primitiveOperation();
    Lina player2 = new Lina();
    player2.cast_ultimateSpell();
  }
}

abstract class AbstractClass {
  void templateMethod(){
    primitiveOperation();
  }
  
  abstract void primitiveOperation();
}
abstract class Hero {
  int mana;
  int ultimateSpell_mana;
  
  public Hero(int mana, int ultimateSpell_mana){
    this.mana = mana;
    this.ultimateSpell_mana = ultimateSpell_mana;
  }
  
  public void cast_ultimateSpell(){
    Boolean canCastSpell =
      check_ifMana_isEnough();
    
    if(canCastSpell){
      castUltimate();
    }else{
      System.out.println("Mana is not enough!");
    }
  }
  
  private Boolean check_ifMana_isEnough(){
    return (mana >= ultimateSpell_mana);
  }
  
  abstract void castUltimate();
}

class ConcreteClass1 extends AbstractClass {
  void primitiveOperation(){
    System.out.println("Primitive Operation 1");
  }
}
class Luna extends Hero {
  public Luna(){
    super(1000,250);
  }
  
  void castUltimate(){
    System.out.println("Luna cast Eclipse!");
  }
}

class ConcreteClass2 extends AbstractClass {
  void primitiveOperation(){
    System.out.println("Primitive Operation 2");
  }
}
class Lina extends Hero {
  public Lina(){
    super(1000,680);
  }
  
  void castUltimate(){
    System.out.println("Lina cast Laguna Blade!");
  }
}