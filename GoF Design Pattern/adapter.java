class Main {
  public static void main(String[] args) {
    Adapter adapter = new Adapter();
    adapter.clientRequest();
    
    MarioKeyboardControllerAdapter userKeyboard = new MarioKeyboardControllerAdapter();
    userKeyboard.press_W();
    userKeyboard.press_A();
    userKeyboard.press_S();
    userKeyboard.press_D();
  }
}

interface Adaptee {
  public void doAction();
}
interface PlayerMovementControl {
  public void up();
  public void down();
  public void left();
  public void right();
}

class CurrentImplementation implements Adaptee {
  public void doAction(){
    System.out.println("Doing the requested action");
  }
}
class MarioController implements PlayerMovementControl {
  public void up(){
    System.out.println("Mario jumps");
  }
  public void down(){
    System.out.println("Mario ducks");
  }
  public void left(){
    System.out.println("Mario moves backward");
  }
  public void right(){
    System.out.println("Mario moves forward");
  }
}

interface Target {
  public void clientRequest();
}
interface KeyboardController {
  public void press_W();
  public void press_S();
  public void press_A();
  public void press_D();
}

class Adapter extends CurrentImplementation implements Target {
  public void clientRequest(){
    System.out.println("Client requests an action");
    this.doAction();
  }
}
class MarioKeyboardControllerAdapter extends MarioController implements KeyboardController {
  public void press_W(){
    this.up();
  }
  public void press_S(){
    this.down();
  }
  public void press_A(){
    this.left();
  }
  public void press_D(){
    this.right();
  }
}