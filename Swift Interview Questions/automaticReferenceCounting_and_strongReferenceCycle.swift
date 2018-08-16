class ClassName {
    let property = "Executing closure"
    lazy var closure: () -> () = {
        [unowned self] in     //omitting this capture list will cause reference cycle
        print(self.property)
    }
    
    deinit {
        print("deinitialized")
    }
}

print("Should deallocate an object if there's still at least one strong reference to it")
var reference1: ClassName? = ClassName()
var reference2 = reference1
weak var reference3 = reference1
reference1 = nil
reference2 = nil

print("\nClosure is also a reference type")
var object: ClassName? = ClassName()
object?.closure()
object = nil

