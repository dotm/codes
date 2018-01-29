class Main {
  public static void main(String[] args) {
    System.out.println(Singleton.getInstance());
    System.out.println(Singleton.getInstance());
    System.out.println(Singleton.getInstance().getSingletonData());
    
    System.out.println(Mario.getInstance());
    System.out.println(Mario.getInstance());
    Mario.getInstance().touchEnemy();
  }
}

class Singleton {
  private static Singleton uniqueInstance = new Singleton();
  
  private int singletonData = 1;
  
  private Singleton(){}
  
  public static Singleton getInstance(){
    return uniqueInstance;
  }
  
  public void singletonOperation(){}
  
  public int getSingletonData(){
    return singletonData;
  }
}
class Mario {
  private static Mario mario = new Mario();
  
  private boolean isBig = false;
  private boolean isInvincible = false;
  private boolean isAlive = true;
  
  private Mario(){}
  
  public static Mario getInstance(){
    return mario;
  }
  
  public void jump(){
    System.out.println("Mario jumps");
  }
  
  public void moveLeft(){
    System.out.println("Mario moves to the left");
  }
  
  public void moveRight(){
    System.out.println("Mario moves to the right");
  }
  
  public void touchEnemy(){
    if(isInvincible){
      System.out.println("Mario is invincible, enemy dies");
    }else{
      isAlive = false;
      System.out.println("Mario dies");
    }
  }
}