function formatCurrency (number){
    var result = '0'
    if(number){
        number = parseInt(number)

        var number_isNegative = false
        if(number < 0){
            number_isNegative = true
            number = Math.abs(number)
        }
        
        result = number.toLocaleString('id')
    }

    result = `Rp.${result},-`
    if(number_isNegative){
        result = `(${result})`
    }

    return result
}