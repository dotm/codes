//Use direct address table (instead of hash table)
//when the maximum slot is not large and is static (known ahead of time)
//or in other words, if the number of possible keys is small and unique

class DirectAddressTable<ValueType> {
    var slots: [ValueType?] //available index is from 0 up to maximumSlot (total count of array is hence maximumSlot + 1)
    private let maximumSlot: Int
    
    func insert(element: ValueType, toSlot index: Int) -> Bool{
        if index < 0 || index > maximumSlot {return false}
        if slots[index] != nil {return false}
        
        slots[index] = element
        return true
    }
    func searchElement(atIndex index: Int) -> ValueType? {
        return slots[index]
    }
    func deleteElement(atIndex index: Int){
        slots[index] = nil
    }
    func overwrite(element: ValueType, toSlot index: Int){
        slots[index] = element
    }
    
    init(maximumSlot: Int){
        guard maximumSlot > 0 else {
            fatalError("invalid maximum slot")
        }
        self.maximumSlot = maximumSlot
        self.slots = Array<ValueType?>(repeating: nil, count: maximumSlot + 1)
    }
}

//Tests
let maximumSlot = 10
let table = DirectAddressTable<String>(maximumSlot: maximumSlot)
let str = "Joe"
table.insert(element: str, toSlot: 1) == true
table.insert(element: str, toSlot: -1) == false
table.insert(element: str, toSlot: maximumSlot+1) == false
table.searchElement(atIndex: 1) == str
table.searchElement(atIndex: 0) == nil
table.insert(element: str, toSlot: 1) == false
table.overwrite(element: "Gan", toSlot: 1)
table.searchElement(atIndex: 1) == "Gan"
table.deleteElement(atIndex: 1)
table.searchElement(atIndex: 1) == nil

