extension Array {
    mutating func exchange(firstIndex: Int, secondIndex: Int){
        let firstElement = self[firstIndex]
        self[firstIndex] = self[secondIndex]
        self[secondIndex] = firstElement
    }
}
extension Array where Element: Comparable {
    mutating func partition() -> Int? {
        if self.count <= 0 {return nil}
        if self.count == 1 {return nil}
        
        let lastIndex = self.count-1
        let pivot = self[lastIndex]
        var lastIndex_whereTheElementValue_islessThanPivot = -1
        for i in 0..<lastIndex{ //last index is excluded because it's element is the pivot
            if self[i] <= pivot {
                lastIndex_whereTheElementValue_islessThanPivot += 1
                self.exchange(firstIndex: i, secondIndex: lastIndex_whereTheElementValue_islessThanPivot)
            }
        }
        lastIndex_whereTheElementValue_islessThanPivot += 1
        
        self.exchange(firstIndex: lastIndex, secondIndex: lastIndex_whereTheElementValue_islessThanPivot)
        return lastIndex_whereTheElementValue_islessThanPivot
    }
    mutating func randomizedPartition() -> Int? {
        let randomIndex = Int.random(in: 0..<self.count)
        let lastIndex = self.count-1
        self.exchange(firstIndex: randomIndex, secondIndex: lastIndex)
        return self.partition()
    }
    
    /// Get the order statistic where the order statistic range is from 1 to the length of array (array.count)
    mutating func selection(orderStatistic: Int) -> Element? {
        let invalidOrderStatistic = orderStatistic < 1 || orderStatistic > self.count
        if invalidOrderStatistic {
            print("Invalid order statistic")
            return nil
        }
        
        if self.count == 1 {return self.first}
        
        guard let pivotIndex = self.partition() else {
            return nil
        }
        
        let selectedOrderStatistic = orderStatistic - 1 // minus one because array is zero-indexed
        if selectedOrderStatistic == pivotIndex {
            print(pivotIndex)
            let pivotValue = self[pivotIndex]
            return pivotValue
        }else if selectedOrderStatistic < pivotIndex {
            var subset_ofValues_lowerThanPivotValue = Array(self[0..<pivotIndex])
            return subset_ofValues_lowerThanPivotValue.selection(orderStatistic: orderStatistic)
        }else{
            let index_afterPivot = pivotIndex + 1
            var subset_ofValues_greaterThanPivotValue = Array(self[index_afterPivot..<self.count])
            return subset_ofValues_greaterThanPivotValue.selection(orderStatistic: orderStatistic-index_afterPivot)
        }
    }
}

var x = [2,8,7,1,3,5,6,4]
x.selection(orderStatistic: 5) == 5

