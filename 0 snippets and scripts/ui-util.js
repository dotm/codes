/** Generate a random string that can be used as a unique ID. */
function generateRandomId (h = 16, s = s => Math.floor(s).toString(h)) {
    return s(Date.now() / 1000) + ' '.repeat(h).replace(/./g, () => s(Math.random() * h))
}

function formatDecimal (number){
    if(number){
        return number.toLocaleString('id')
    }else{
        return '0'
    }
}

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

function unformatDecimal (string){
    var result

    if(string){
        var arr = string.split(',')

        if(arr.length > 1){
            var after_comma = arr.pop()
            var newString = arr.join('')
            newString = newString.replace(/\D/g,'')
            result = parseFloat(newString +'.'+ after_comma)
        }else{
            result = parseInt(string.replace(/\D/g,''))
        }
        
        return result
    }else{
        return 0
    }
}

export { generateRandomId, formatDecimal, unformatDecimal, formatCurrency }