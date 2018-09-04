protocol Component {
    func getDescriptions()
    var description: String {get}
}

class Composite: Component {
    var children: [Component] = []
    let description: String
    func getDescriptions(){
        print(self.description)
        for component in children {
            component.getDescriptions()
        }
    }
    
    //other methods and properties...
    func addChild(_ child: Component){
        children.append(child)
    }
    
    init(description: String){
        self.description = description
    }
}

class Leaf: Component {
    let description: String
    func getDescriptions(){
        print(self.description)
    }
    
    //other methods and properties...
    
    init(description: String){
        self.description = description
    }
}

//A leaf is a component
let leaf_1 = Leaf(description: "Leaf 1")
leaf_1.getDescriptions()

let leaf_2 = Leaf(description: "Leaf 2")

//A composite is a component
let composite_1 = Composite(description: "Composite 1")
composite_1.addChild(leaf_1)
composite_1.addChild(leaf_2)
composite_1.getDescriptions()

//A composite can contain another composite
let leaf_3 = Leaf(description: "Leaf 3")
let composite_2 = Composite(description: "Composite 2")
composite_2.addChild(leaf_3)
composite_2.addChild(composite_1)
composite_2.getDescriptions()
