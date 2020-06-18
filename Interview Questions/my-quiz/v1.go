package main

DELETE_THIS_MISTAKE_CHEATSHEET
//inconsistent naming (Printer and log)
//unclear name x and p.x
//incorrect output
//unresolved export warning on Printer

/*
Change anything you want, but keep these requirements:
1. must print: 1 3
2. printableStruct and Printer should not be deleted
3. printableStruct should still conforms to Printer interface
*/

// type Printer interface {
// 	log(x string)
// }

// type printableStruct struct {
// 	x int
// }

// func (p printableStruct) log(x string) {
// 	fmt.Println(x, p.x)
// }

// func main() {
// 	printableStruct{}.log("3")
// }

DELETE_THIS_MISTAKE_CHEATSHEET
//off by one error on loop, typo multply
//single responsibility principle broken in multipl (side effect)
//unprotected casting
//x variable is not passed to x parameter

/*
Change anything you want, but keep these requirements:
1. must print:
	multiply three times with result:30
	multiply three times with result:30
	multiply three times with result:30
2. multiply function should not be deleted
3. variable x should not be changed
*/

// func main() {
// 	var x interface{}
// 	x = 5
// 	for i := 0; i <= 3; i++ {
// 		multply(4, x.(int))
// 	}
// }

// func multply(x, y int) int {
// 	fmt.Println("multiply threes time with result:", x*y)
// 	return x * y
// }
