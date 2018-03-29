class Main {
  public static void main(String[] args) {
    SmartRoomFacade officeRoom = new SmartRoomFacade();
    officeRoom.open();
    officeRoom.close();
  }
}

class SmartRoomFacade {
  Door door;
  Window window;
  Electricity_SwitchBox switchBox;
  
  public SmartRoomFacade() {
    this.door = new Door();
    this.window = new Window();
    this.switchBox = new Electricity_SwitchBox();
  }
  
  public void open(){
    door.unlock();
    window.unlock();
    switchBox.on();
  }
  
  public void close(){
    door.close();
    door.lock();
    window.close();
    window.lock();
    switchBox.off();
  }
}

class Door {
  public void close() {
    System.out.println("Door is closed");
  }
  public void lock() {
    System.out.println("Door is locked");
  }
  public void unlock() {
    System.out.println("Door is unlocked");
  }
}

class Window {
  public void close() {
    System.out.println("Window is closed");
  }
  public void lock() {
    System.out.println("Window is locked");
  }
  public void unlock() {
    System.out.println("Window is unlocked");
  }
}

class Electricity_SwitchBox {
  public void off() {
    System.out.println("Electricity is turned off");
  }
  public void on() {
    System.out.println("Electricity is turned on");
  }
}