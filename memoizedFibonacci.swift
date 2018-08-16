extension String:Error {}
func fibonacci(_ n: UInt) throws -> UInt {
    guard n > 0 else {
        throw "Invalid argument"
    }
    var memo: [UInt:UInt] = [:]
    
    func computeFibonacci(_ n: UInt) -> UInt {
        let result_isAlreadyComputed = memo[n] != nil
        
        if result_isAlreadyComputed {
            return memo[n]!
        }
        
        let result: UInt
        if n == 1 {
            result = 1
        }else if n == 2 {
            result = 1
        }else{
            result = computeFibonacci(n-1) + computeFibonacci(n-2)
            memo[n] = result  //store computed result
        }
        
        return result
    }
    return computeFibonacci(n)
}

try! fibonacci(40)
