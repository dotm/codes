import Foundation

extension BinaryInteger {
    func isOdd() -> Bool{
        return self % 2 != 0
    }
    func isEven() -> Bool{
        return self % 2 == 0
    }
}

func exponentiate_basic(base: Int, exponent: Int) -> Int {
    var result = 1
    for _ in 0..<exponent {
        result *= base
    }
    return result
}
func exponentiate_DnQ(base: Int, exponent: Int) -> Int {
    if exponent == 0 {
        return 1
    }else if exponent == 1 {
        return base
    }else if exponent.isOdd() {
        return base * exponentiate_DnQ(base: (base * base), exponent: (exponent-1)/2)
    }else if exponent.isEven() {
        return exponentiate_DnQ(base: (base * base), exponent: exponent/2)
    }
    return -1
}

func countTime(_ fn: @autoclosure () -> Any) -> Double {
    let startTime = DispatchTime.now()
    fn()
    let endTime = DispatchTime.now()
    let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
    let timeInterval_inSeconds =  Double(nanoTime) / 1_000_000_000
    return timeInterval_inSeconds
}

countTime(print("Hello"))
countTime(print("Hello"))
countTime(print("Hello"))
countTime(exponentiate_basic(base: 2, exponent: 50))
countTime(exponentiate_DnQ(base:2, exponent:50))

