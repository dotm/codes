package main

import (
	"fmt"
	"math"
)

type ErrNegativeSqrt float64
func (e ErrNegativeSqrt) Error() string {
	return fmt.Sprintf("cannot Sqrt negative number: %v",float64(e))
}
func Sqrt(x float64) (float64, error) {
	if x < 0 {
		return 0, ErrNegativeSqrt(x)
	}else if x == 0{
		return 0, nil
	}else{
		squareRootValue := 1.0
		acceptable_difference := 0.0000000001
		difference := math.Inf(1)

		for difference > acceptable_difference {
			old_squareRootValue := squareRootValue
			squareRootValue -= (squareRootValue * squareRootValue - x) / (2 * squareRootValue)
			difference = math.Abs(old_squareRootValue - squareRootValue)
		}
		return squareRootValue, nil
	}
}

func main() {
	fmt.Println(Sqrt(2))
	fmt.Println(Sqrt(-2))
}