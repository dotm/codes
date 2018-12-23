import UIKit
import XCTest

typealias MessageDigest = Int
typealias TotalHashSlot = Int

protocol HashTableProtocol {
    associatedtype KeyType: Equatable
    associatedtype ValueType
    mutating func insert(key: KeyType, value: ValueType)
    mutating func delete(key: KeyType) -> Bool
    func search(key: KeyType) -> ValueType?
}

//func trivialHashFunction(key: String, totalHashSlot: TotalHashSlot) -> MessageDigest {
//    let bytes: [Int] = key.utf8.map{Int($0)}
//    //print(bytes)  //[89, 111, 115, 104, 117, 97]
//    let hash: Int = bytes.reduce(0, &+)
//    //&+ is used to avoid overflow error
//    //error: Execution was interrupted, reason: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0).
//
//    return hash % totalHashSlot
//}
func trivialHashFunction(key: Int, totalHashSlot: TotalHashSlot) -> MessageDigest {
    return key % totalHashSlot
}

class HashTable<KeyType,ValueType>: HashTableProtocol where KeyType:Equatable {
    typealias HashFunction = (KeyType, TotalHashSlot) -> MessageDigest
    typealias Iteration = Int
    typealias KeyValuePair = (key: KeyType?, value: ValueType?)
    
    var slots: [KeyValuePair?]
    private let totalSlot: TotalHashSlot
    private let hashFunction: HashFunction
    
    init(totalSlot: TotalHashSlot, hashFunction: @escaping HashFunction) {
        guard totalSlot > 0 else {
            fatalError("invalid total slot")
        }
        self.totalSlot = totalSlot
        self.hashFunction = hashFunction
        self.slots = Array(repeating: nil, count: totalSlot)
    }
    func insert(key: KeyType, value: ValueType) {
        for i in 0..<totalSlot {
            let digest = linearProbe(key: key, totalHashSlot: totalSlot, iteration: i)
            var slot = slots[digest]
            
            let slot_isEmpty = slot == nil
            let key_isFound = slot?.key == key
            let slot_wasDeleted = slot?.key == nil
            if slot_isEmpty || key_isFound || slot_wasDeleted {
                //we use slots[digest] instead of slot, because slot variable is value type (changing it won't change the hash table slots array)
                slots[digest] = (key: key, value: value)
                return
            }
        }
        fatalError("Hashtable overflow")
    }
    
    func delete(key: KeyType) -> Bool {
        for i in 0..<totalSlot {
            let digest = linearProbe(key: key, totalHashSlot: totalSlot, iteration: i)
            var slot = slots[digest]
            
            let key_isFound = slot?.key == key
            if key_isFound {
                //we use slots[digest] instead of slot, because slot variable is value type (changing it won't change the hash table slots array)
                slots[digest]?.key = nil
                slots[digest]?.value = nil
                return true
            }
            
            let emptySlotFound = slot == nil
            if emptySlotFound { return false }
        }
        return false
    }
    
    func search(key: KeyType) -> ValueType? {
        for i in 0..<totalSlot {
            let digest = linearProbe(key: key, totalHashSlot: totalSlot, iteration: i)
            let slot = slots[digest]
            
            let key_isFound = slot?.key == key
            if key_isFound {
                return slot?.value
            }
            
            let emptySlotFound = slot == nil
            if emptySlotFound { return nil }
        }
        return nil
    }
    
    subscript(index: KeyType) -> ValueType? {
        get { return search(key: index) }
        set { insert(key: index, value: newValue!) }
    }
    
    func linearProbe(key: KeyType, totalHashSlot: TotalHashSlot, iteration: Iteration) -> MessageDigest {
        let hashFunction = self.hashFunction
        let hash = hashFunction(key,totalHashSlot)
        return (hash + iteration) % totalHashSlot
    }
    
    func quadraticProbe(key: KeyType, totalHashSlot: TotalHashSlot, iteration: Iteration) -> MessageDigest {
        let hashFunction = self.hashFunction
        let hash = hashFunction(key,totalHashSlot)
        let constant = 1
        let cx = constant * iteration
        let quadraticResult = cx * cx //cx^2
        return (hash + quadraticResult) % totalHashSlot
    }
    
    func doubleHashing(){
        
    }
}

class HashTableTests: XCTestCase {
    var hashtable: HashTable<Int,String>!
    override func setUp() {
        hashtable = HashTable<Int,String>(totalSlot: 10, hashFunction: trivialHashFunction)
    }
    
    func testInsert(){
        XCTAssertNil(hashtable.search(key: 1), "Searching non-existing key should return nil")
        
        let firstValue = "1a"
        hashtable.insert(key: 1, value: firstValue)
        XCTAssertEqual(hashtable.search(key: 1)!, firstValue, "Searching existing key should return the value of the index")
        
        let secondValue = "1b"
        hashtable.insert(key: 1, value: secondValue)
        XCTAssertNotEqual(firstValue, secondValue)
        XCTAssertEqual(hashtable.search(key: 1)!, secondValue, "Inserting with existing key should return the new value of the index (the value is overwritten with the new value)")
        
        let value_forSubscript = "4"
        hashtable[4] = value_forSubscript
        XCTAssertEqual(hashtable.search(key: 4)!, value_forSubscript, "Inserting with subscript should work")
        
        let thirdValue = "1c"
        XCTAssertNotEqual(firstValue, thirdValue)
        XCTAssertNotEqual(secondValue, thirdValue)
        hashtable[1] = thirdValue
        XCTAssertEqual(hashtable.search(key: 1)!, thirdValue, "Subscript should keep key unique (overwrite value if user inserts new value to existing index)")
    }
    
    func testCollision(){
        let firstValue = "1"
        hashtable.insert(key: 1, value: firstValue)
        
        let key_forCollision = 11 // 1 + totalSlot == 1 + 10 == 11
        let value_forCollision = "11"
        hashtable.insert(key: key_forCollision, value: value_forCollision)
        XCTAssertEqual(hashtable.search(key: 1)!, firstValue, "Collision should not overwrite value of other key")
        XCTAssertEqual(hashtable.search(key: 11)!, value_forCollision, "Hash Table should work even if collision of keys' digests occurs")
    }
    
    func testDelete(){
        XCTAssertFalse(hashtable.delete(key: 1), "Deleting non-existing key should return false")
        hashtable.insert(key: 1, value: "test")
        XCTAssertTrue(hashtable.delete(key: 1), "Deleting existing key should return true")
        XCTAssertNil(hashtable.search(key: 1), "Delete should remove the key-value pair from the hash table")
    }
}
//HashTableTests.defaultTestSuite.run()
