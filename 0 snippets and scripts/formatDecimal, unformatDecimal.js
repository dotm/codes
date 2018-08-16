function formatDecimal (number){
    if(number){
        return number.toLocaleString('id')
    }else{
        return '0'
    }
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
