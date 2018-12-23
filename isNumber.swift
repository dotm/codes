enum NumberSign {
    case positive
    case negative
}
func isNumber(_ s: String) -> Bool {
    var numbers: [Int] = []
    var sign: NumberSign? = nil
    var exponents: [Int]? = nil
    var exponentSign: NumberSign? = nil
    var decimalPointPosition: Int? = nil
    
    var trimmedString = s.trimmingCharacters(in: .whitespacesAndNewlines)
    
    for (index,character) in trimmedString.enumerated() {
        switch character {
        case "+":
            if exponents == nil {
                if(index == 0 && sign == nil){
                    sign = .positive
                }else{
                    return false
                }
            } else {
                if(exponents?.count == 0 && exponentSign == nil){
                    exponentSign == .positive
                }else{
                    return false
                }
            }
        case "-":
            if exponents == nil {
                if(index == 0 && sign == nil){
                    sign = .negative
                }else{
                    return false
                }
            } else {
                if(exponents?.count == 0 && exponentSign == nil){
                    exponentSign == .negative
                }else{
                    return false
                }
            }
        case "e":
            if exponents != nil {
                return false
            }else{
                exponents = []
            }
        case ".":
            if decimalPointPosition != nil || exponents != nil {
                return false
            }else{
                decimalPointPosition = index
            }
        case "0","1","2","3","4","5","6","7","8","9":
            let value = Int(String(character))!
            if exponents == nil {
                numbers.append(value)
            }else{
                exponents?.append(value)
            }
        default:
            return false
        }
    }
    
    if numbers.count == 0 {return false}
    if exponents?.count == 0 {return false}
    
    return true
}
