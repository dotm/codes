import XCTest

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
            lastNode?.next = Node(key: key, value: value, prev: lastNode)
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
    
    func reverse(){
        if list_isEmpty {return}
        
        var currentNode: Node<KeyType,ValueType>? = headNode!
        var previousNode: Node<KeyType,ValueType>? = nil
        while currentNode != nil {
            previousNode = currentNode
            currentNode = currentNode?.next
            if currentNode == nil {
                headNode = previousNode
            }
            
            previousNode?.next = previousNode?.prev
            previousNode?.prev = currentNode
        }
    }
}
class Node<KeyType,ValueType> {
    var key: KeyType
    var value: ValueType
    var next: Node<KeyType,ValueType>?
    var prev: Node<KeyType,ValueType>?
    
    init(key: KeyType, value: ValueType, next: Node<KeyType,ValueType>? = nil, prev: Node<KeyType,ValueType>? = nil) {
        self.key = key
        self.value = value
        self.next = next
        self.prev = prev
    }
}

class LinkedListTest: XCTestCase {
    func testReverse(){
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
        let fifthNodeKey = 5
        let fifthNodeValue = "5"
        linkedList.insert(key: fifthNodeKey, value: fifthNodeValue)

        var listValues: [String] = []
        linkedList.traverse { (node) in
            listValues.append(node.value)
        }

        linkedList.reverse()
        var reversedValues: [String] = []
        linkedList.traverse { (node) in
            reversedValues.append(node.value)
        }

        XCTAssertEqual(listValues.reversed(), reversedValues, "Reverse function should reverse the nodes (head become tail, vice versa)")
    }

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
        XCTAssertEqual(linkedList.headNode?.next?.next?.prev?.value, secondNodeValue)
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
LinkedListTest.defaultTestSuite.run()
