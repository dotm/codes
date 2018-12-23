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
    
    var slots: [LinkedList<KeyType,ValueType>]
    private let totalSlot: TotalHashSlot
    private let hashFunction: HashFunction
    
    init(totalSlot: TotalHashSlot, hashFunction: @escaping HashFunction) {
        guard totalSlot > 0 else {
            fatalError("invalid total slot")
        }
        self.totalSlot = totalSlot
        self.hashFunction = hashFunction
        self.slots = Array<LinkedList<KeyType,ValueType>>(repeating: LinkedList<KeyType,ValueType>(), count: totalSlot + 1)
    }
    func insert(key: KeyType, value: ValueType) {
        let digest = hashFunction(key,totalSlot)
        let linkedList = slots[digest]
        linkedList.insert(key: key, value: value)
        
        //debugging purpose
//        print("digest",digest)
//        linkedList.traverse {
//            (node) in print(node.value)
//        }
    }
    
    func delete(key: KeyType) -> Bool {
        let digest = hashFunction(key,totalSlot)
        let linkedList = slots[digest]
        
        guard !linkedList.isEmpty else {
            return false
        }
        let key_isFound_andDeleted = linkedList.delete(key: key)
        return key_isFound_andDeleted
    }
    
    func search(key: KeyType) -> ValueType? {
        let digest = hashFunction(key,totalSlot)
        let linkedList = slots[digest]
        
        let node = linkedList.search(key: key)
        let value = node?.value
        return value
    }
    
    subscript(index: KeyType) -> ValueType? {
        get { return search(key: index) }
        set { insert(key: index, value: newValue!) }
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
        
        let value_forSubscript = "11"
        hashtable[11] = value_forSubscript
        XCTAssertEqual(hashtable.search(key: 11)!, value_forSubscript, "Inserting with subscript should work")
        
        let thirdValue = "1c"
        XCTAssertNotEqual(firstValue, thirdValue)
        XCTAssertNotEqual(secondValue, thirdValue)
        hashtable[1] = thirdValue
        XCTAssertEqual(hashtable.search(key: 1)!, thirdValue, "Subscript should keep key unique (overwrite value if user inserts new value to existing index)")
    }
    
    func testDelete(){
        XCTAssertFalse(hashtable.delete(key: 1), "Deleting non-existing key should return false")
        hashtable.insert(key: 1, value: "test")
        XCTAssertTrue(hashtable.delete(key: 1), "Deleting existing key should return true")
        XCTAssertNil(hashtable.search(key: 1), "Delete should remove the key-value pair from the hash table")
    }
}
//HashTableTests.defaultTestSuite.run()

//Linked List
class LinkedList<KeyType,ValueType> where KeyType: Equatable {
    var headNode: Node<KeyType,ValueType>? = nil
    
    var isEmpty: Bool {
        return list_isEmpty
    }
    private var list_isEmpty: Bool {
        return headNode == nil
    }
    init() {
        
    }
    
    func insert(key: KeyType, value: ValueType){
        guard !list_isEmpty else {
            self.headNode = Node(key: key, value: value)
            return
        }
        
        var currentNode: Node<KeyType,ValueType>? = headNode!
        var key_isAlready_inLinkedList = currentNode?.key == key    //KEY IS UNIQUE
        var currentNode_isLastNode = currentNode?.next == nil
        while !currentNode_isLastNode, !key_isAlready_inLinkedList {
            currentNode = currentNode?.next
            key_isAlready_inLinkedList = currentNode?.key == key
            currentNode_isLastNode = currentNode?.next == nil
        }
        
        if key_isAlready_inLinkedList {
            currentNode?.value = value
        } else if currentNode_isLastNode{
            let lastNode = currentNode
            lastNode?.next = Node(key: key, value: value)
        }
    }
    
    func search(key: KeyType) -> Node<KeyType,ValueType>? {
        if list_isEmpty {return nil}
        
        var currentNode: Node<KeyType,ValueType>? = headNode!
        while currentNode != nil {
            if currentNode!.key == key {
                return currentNode
            }
            currentNode = currentNode?.next
        }
        return nil
    }
    
    func traverse(closure: (Node<KeyType,ValueType>)->()){
        if list_isEmpty {return}
        
        var currentNode: Node<KeyType,ValueType>? = headNode!
        while currentNode != nil {
            closure(currentNode!)
            currentNode = currentNode?.next
        }
    }
    
    func delete(key: KeyType) -> Bool {
        if list_isEmpty {return false}
        let value_isInList: Bool
        
        if headNode?.key == key {
            headNode = headNode?.next
            
            value_isInList = true
            return value_isInList
        }
        
        var currentNode: Node<KeyType,ValueType>? = headNode!
        var previousNode: Node<KeyType,ValueType>? = nil
        while currentNode != nil {
            if currentNode!.key == key {
                previousNode?.next = currentNode?.next
                
                value_isInList = true
                return value_isInList
            }
            previousNode = currentNode
            currentNode = currentNode?.next
        }
        
        value_isInList = false
        return value_isInList
    }
    
}
class Node<KeyType,ValueType> {
    var key: KeyType
    var value: ValueType
    var next: Node<KeyType,ValueType>?
    
    init(key: KeyType, value: ValueType, next: Node<KeyType,ValueType>? = nil) {
        self.key = key
        self.value = value
        self.next = next
    }
}

class LinkedListTest: XCTestCase {
    func testInitialization(){
        let linkedList = LinkedList<Int,Int>()
        XCTAssertNil(linkedList.headNode)
    }
    func testInsert(){
        //Insert to empty linked list
        let linkedList = LinkedList<Int,String>()
        let firstNodeKey = 1
        let firstNodeValue = "1"
        linkedList.insert(key: firstNodeKey, value: firstNodeValue)
        XCTAssertEqual(linkedList.headNode?.value, firstNodeValue)
        
        //Insert to list with existing index
        let newFirstNodeValue = "1a"
        linkedList.insert(key: 1, value: newFirstNodeValue)
        XCTAssertEqual(linkedList.headNode?.value, newFirstNodeValue)
        
        //Insert to a list that already have nodes
        let secondNodeKey = 2
        let secondNodeValue = "2"
        linkedList.insert(key: secondNodeKey, value: secondNodeValue)
        XCTAssertEqual(linkedList.headNode?.next?.value, secondNodeValue)
        let thirdNodeKey = 3
        let thirdNodeValue = "3"
        linkedList.insert(key: thirdNodeKey, value: thirdNodeValue)
        XCTAssertEqual(linkedList.headNode?.next?.next?.value, thirdNodeValue)
    }
    func testSearch(){
        let linkedList = LinkedList<Int,String>()
        
        //Search on empty linked list
        XCTAssertNil(linkedList.search(key: 0), "Searching on empty list should return nil")
        
        let firstNodeKey = 1
        let firstNodeValue = "1"
        linkedList.insert(key: firstNodeKey, value: firstNodeValue)
        let secondNodeKey = 2
        let secondNodeValue = "2"
        linkedList.insert(key: secondNodeKey, value: secondNodeValue)
        let thirdNodeKey = 3
        let thirdNodeValue = "3"
        linkedList.insert(key: thirdNodeKey, value: thirdNodeValue)
        
        XCTAssertNil(linkedList.search(key: 0), "Searching list for non-existent value should return nil")
        
        //Search linked list for existent value in head
        XCTAssertNotNil(linkedList.search(key: firstNodeKey))
        XCTAssertEqual(linkedList.search(key: firstNodeKey)?.value, firstNodeValue)
        
        //Search linked list for existent value not in head
        XCTAssertNotNil(linkedList.search(key: secondNodeKey))
        XCTAssertEqual(linkedList.search(key: secondNodeKey)?.value, secondNodeValue)
        
        //Search linked list for existent value in tail
        let lastNodeKey = thirdNodeKey
        let lastNodeValue = thirdNodeValue
        XCTAssertNotNil(linkedList.search(key: lastNodeKey))
        XCTAssertEqual(linkedList.search(key: lastNodeKey)?.value, lastNodeValue)
    }
    func testTraversal(){
        let linkedList = LinkedList<Int,String>()
        
        let firstNodeKey = 1
        let firstNodeValue = "1"
        linkedList.insert(key: firstNodeKey, value: firstNodeValue)
        let secondNodeKey = 2
        let secondNodeValue = "2"
        linkedList.insert(key: secondNodeKey, value: secondNodeValue)
        let thirdNodeKey = 3
        let thirdNodeValue = "3"
        linkedList.insert(key: thirdNodeKey, value: thirdNodeValue)
        let fourthNodeKey = 4
        let fourthNodeValue = "4"
        linkedList.insert(key: fourthNodeKey, value: fourthNodeValue)
        
        var listValues: [String] = []
        linkedList.traverse { (node) in
            listValues.append(node.value)
        }
        XCTAssertEqual(listValues, [firstNodeValue, secondNodeValue, thirdNodeValue, fourthNodeValue])
    }
    func testDelete(){
        let linkedList = LinkedList<Int,String>()
        
        XCTAssertFalse(linkedList.delete(key: 0), "Delete on empty list should return false")
        
        let firstNodeKey = 1
        let firstNodeValue = "1"
        linkedList.insert(key: firstNodeKey, value: firstNodeValue)
        let secondNodeKey = 2
        let secondNodeValue = "2"
        linkedList.insert(key: secondNodeKey, value: secondNodeValue)
        let thirdNodeKey = 3
        let thirdNodeValue = "3"
        linkedList.insert(key: thirdNodeKey, value: thirdNodeValue)
        let fourthNodeKey = 4
        let fourthNodeValue = "4"
        linkedList.insert(key: fourthNodeKey, value: fourthNodeValue)
        let fifthNodeKey = 5
        let fifthNodeValue = "5"
        linkedList.insert(key: fifthNodeKey, value: fifthNodeValue)
        
        XCTAssertFalse(linkedList.delete(key: 0), "Delete a non-existent value from list should return false")
        
        var listValues: [String]
        
        //Delete linked list for existent value in head
        XCTAssertTrue(linkedList.delete(key: firstNodeKey))
        
        listValues = []
        linkedList.traverse { (node) in
            listValues.append(node.value)
        }
        XCTAssertEqual(listValues, [secondNodeValue, thirdNodeValue, fourthNodeValue, fifthNodeValue])
        
        //Delete linked list for existent value in middle of list
        XCTAssertTrue(linkedList.delete(key: thirdNodeKey))
        listValues = []
        linkedList.traverse { (node) in
            listValues.append(node.value)
        }
        XCTAssertEqual(listValues, [secondNodeValue, fourthNodeValue, fifthNodeValue])
        
        //Delete linked list for existent value in tail
        let lastNodeKey = fifthNodeKey
        XCTAssertTrue(linkedList.delete(key: lastNodeKey))
        listValues = []
        linkedList.traverse { (node) in
            listValues.append(node.value)
        }
        XCTAssertEqual(listValues, [secondNodeValue, fourthNodeValue])
    }
}
//LinkedListTest.defaultTestSuite.run()
