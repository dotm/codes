//struct is value type, class is reference type
struct ExampleStructure {
    var x: Int
}
var variable1 = ExampleStructure(x: 1)
var variable2 = variable1
print("variable2.x", variable2.x)
variable1.x = 200
print("variable1.x", variable1.x)
print("variable2.x", variable2.x, "tidak berubah")

class ExampleClass {
    var x: Int = 1
}
var variable_a = ExampleClass()
var variable_b = variable_a
print("variable_b.x", variable_b.x)
variable_a.x = 200
print("variable_a.x", variable_a.x)
print("variable_b.x", variable_b.x, "ikut berubah")

//class can inherit other class
class SubClass: ExampleClass {
}

//class can have deinitializer
class AnotherClass {
    deinit {}
}
