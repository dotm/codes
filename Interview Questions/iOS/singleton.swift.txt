class Singleton {
    private static var instance: Singleton?
    static var sharedInstance: Singleton {
        if let existingInstance = instance {
            return existingInstance
        }else{
            let newInstance = Singleton()
            instance = newInstance
            return newInstance
        }
    }
    private init(){
        print("Singleton initialized")
    }
    
    var publicProperty = 0
}

print(Singleton.sharedInstance.publicProperty)
let instance1 = Singleton.sharedInstance
let instance2 = Singleton.sharedInstance
instance1 === instance2                         //both instance refers to the same object

