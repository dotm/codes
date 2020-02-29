//--------------------------------------------------------------------------------------------------------------
//With Foundation's Notification
extension Notification.Name {
    static let publisherSendNotification = Notification.Name("publisher send notification")
}

class Publisher {
    var description = "observed object"
    
    init(name: String?) {
        if name != nil { description = name! }
    }
    convenience init(){
        self.init(name: nil)
    }
    
    func sendNotification(message: String){
        NotificationCenter.default.post(name: .publisherSendNotification, object: self, userInfo: ["message":message])
    }
}

class Subscriber {
    convenience init() {
        self.init(publisher: nil)
    }
    init(publisher: Publisher?) {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: .publisherSendNotification, object: publisher)
    }
    @objc private func notificationReceived(notification: NSNotification){
        if let publisher = notification.object as? Publisher{
            print("# Notification")
            print("- name: \(notification.name.rawValue)")
            print("- from: \(publisher.description)")
            print("- message: \(notification.userInfo?["message"] ?? "N/A")")
            print("")
        }else{
            print("Notification received")
        }
    }
    deinit {
        print("subscriber deinitialized")
    }
}

print("--------------------------------------------------------------------------------------------------")
let publisher = Publisher()
var subscriber: Subscriber? = Subscriber()
publisher.sendNotification(message: "Hello")
subscriber = nil    //subscriber object is deinitialized without needing to call removeObserver on it

print("\n---------------------------------------")
let mainPublisher = Publisher(name: "main publisher")
let mainSubscriber = Subscriber(publisher: mainPublisher)               //mainSubscriber only subscribes to mainPublisher
publisher.sendNotification(message: "Hello")                            //mainSubscriber doesn't get the message because it only subscribes to mainPublisher
mainPublisher.sendNotification(message: "Hello from main publisher")
NotificationCenter.default.removeObserver(mainSubscriber)               //mainSubscriber is no longer an observer
mainPublisher.sendNotification(message: "Hello from main publisher")    //mainSubscriber doesn't get the message because it's no longer subscribed to mainPublisher

print("--------------------------------------------------------------------------------------------------")

//--------------------------------------------------------------------------------------------------------------
//With NSObject Key-Value-Observing
class Counter2: NSObject {
    @objc dynamic var count = 0
    func increment(){
        count += 1
    }
    
    deinit {
        print("Publisher is deallocated")
    }
}

class Counter2Observer: NSObject {
    @objc weak var observed: Counter2!
    var observation: NSKeyValueObservation?
    let keypath = \Counter2Observer.observed.count
    
    init(observing observed: Counter2){
        self.observed = observed
        super.init()
        
        observation = observe(keypath, options: [.old, .new], changeHandler: { (object, change) in
            print("Count is changed from \(change.oldValue!) to \(change.newValue!).")
        })
        
    }
    
    deinit {
        print("Observer is deallocated")
    }
}

var observed2: Counter2? = Counter2()
var observer2: Counter2Observer? = Counter2Observer(observing: observed2!)

observed2?.increment()

observer2 = nil
observed2 = nil     //Publisher not deallocated!?

print("\n--------------------------------------------------------------------------------------------------")

//--------------------------------------------------------------------------------------------------------------
//Manual observer
protocol CounterObserverProtocol {
    func countChanged(oldValue: Int, newValue: Int)
}
class Counter {
    var count = 0 {
        didSet {
            observers.forEach { (observer) in observer.countChanged(oldValue: oldValue, newValue: count) }
        }
    }
    var observers: [CounterObserverProtocol] = []
    func addObserver(_ observer: CounterObserverProtocol){
        observers.append(observer)
    }
    func removeObserver(_ observer: CounterObserverProtocol){
        let observers_withoutDeletedObserver = observers.filter { (observerObj) -> Bool in
            return (observer as? AnyObject) !== (observerObj as? AnyObject)
        }
        observers = observers_withoutDeletedObserver
    }
    
    func increment(){
        count += 1
    }
    
    deinit {
        print("Publisher deallocated")
    }
}

class CounterObserver: CounterObserverProtocol {
    var observed: Counter
    init(observing observed: Counter){
        self.observed = observed
        observed.addObserver(self)
    }
    
    func countChanged(oldValue: Int, newValue: Int) {
        print("Count changed from \(oldValue) to \(newValue)")
    }
    func unsubscribe(){
        observed.removeObserver(self)
    }
    
    deinit {
        print("Observer is deallocated")
    }
}

var observed: Counter? = Counter()
var observer: CounterObserver? = CounterObserver(observing: observed!)

observed?.increment()

observer?.unsubscribe()
observer = nil  //if we don't unsubscribe, setting observer to nil will not deallocate the memory (memory leak)
observed = nil  //if we can't deallocate observer, we can't deallocate observed/publisher (memory leak)
