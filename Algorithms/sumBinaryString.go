package main

import "fmt"

func sumBinary(a, b string) string {
	reversedSliceA := []rune{}
	reversedSliceB := []rune{}

	for _, v := range a {
		reversedSliceA = append([]rune{v}, reversedSliceA...)
	}
	for _, v := range b {
		reversedSliceB = append([]rune{v}, reversedSliceB...)
	}

	biggerLength := 0
	if len(a) > len(b) {
		biggerLength = len(a)
	} else {
		biggerLength = len(b)
	}
	reversedResult := make([]rune, biggerLength+1) //+1 for potential carry over

	carryOverMap := map[int]bool{}
	for i := 0; i <= biggerLength; i++ {
		carryOverValue, _ := carryOverMap[i]

		if i == biggerLength && carryOverValue {
			reversedResult[i] = '1'
		}

		valueA := '0'
		valueB := '0'
		if len(a) > i {
			valueA = reversedSliceA[i]
		}
		if len(b) > i {
			valueB = reversedSliceB[i]
		}

		if valueA == '0' && valueB == '0' && carryOverValue == true {
			reversedResult[i] = '1'
		} else if valueA == '0' && valueB == '0' && carryOverValue == false {
			reversedResult[i] = '0'
		} else if (valueA == '1' && valueB == '0' && carryOverValue == true) || (valueA == '0' && valueB == '1' && carryOverValue == true) {
			reversedResult[i] = '0'
			carryOverMap[i+1] = true
		} else if (valueA == '1' && valueB == '0' && carryOverValue == false) || (valueA == '0' && valueB == '1' && carryOverValue == false) {
			reversedResult[i] = '1'
		} else if valueA == '1' && valueB == '1' && carryOverValue == true {
			reversedResult[i] = '1'
			carryOverMap[i+1] = true
		} else if valueA == '1' && valueB == '1' && carryOverValue == false {
			reversedResult[i] = '0'
			carryOverMap[i+1] = true
		}
	}

	result := []rune{}
	for i, v := range reversedResult {
		if i == len(reversedResult)-1 && v == '0' {
			continue
		}

		result = append([]rune{v}, result...)
	}
	return string(result)
}

func testExample(a, b string) {
	result := sumBinary(a, b)
	fmt.Println(result)
}

func main() {
	testExample("0", "0")
	testExample("0", "1")
	testExample("1", "0")
	testExample("1", "1")
	testExample("10", "1011")
	testExample("1010", "1011")
	testExample("1111", "1111")
	testExample("111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111", "1")
}
