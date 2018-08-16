//Challenge: Check if a year is leap year (tahun kabisat)
extension BinaryInteger {
    //extension BinaryInteger (bukan extension Int) supaya bisa dipakai: Int, UInt, Int8, UInt8, Int16, UInt16, Int32, UInt32, Int64, UInt64
    
    func isDivisibleBy(_ num: Self) -> Bool {
        return self % num == 0
    }
    
    func isLeapYear() -> Bool {
        let year = self
        if year.isDivisibleBy(400){
            return true
        }else if year.isDivisibleBy(100){
            return false
        }else if year.isDivisibleBy(4){
            return true
        }else{
            return false
        }
    }
}

100.isDivisibleBy(5)
2015.isLeapYear()
2000.isLeapYear()
2100.isLeapYear()
2004.isLeapYear()
