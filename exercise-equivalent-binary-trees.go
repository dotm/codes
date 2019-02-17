package main

import (
	"golang.org/x/tour/tree"
	"fmt"
)
// Walk walks the tree t sending all values
// from the tree to the channel ch.
func Walk(t *tree.Tree, ch chan int) {
	//recursively walk the tree
	var walk func(t *tree.Tree)
	walk = func(t *tree.Tree) {
		if t == nil { return }
		walk(t.Left)
		ch <- t.Value
		walk(t.Right)
	}
	walk(t)
	
	defer close(ch)  // <- closes the channel when this function returns
}


// Same determines whether the trees
// t1 and t2 contain the same values.
func Same(t1, t2 *tree.Tree) bool {
	channel1 := make(chan int); channel2 := make(chan int);
	go Walk(t1, channel1); go Walk(t2, channel2);
	
	for {
		value1, channel1_stillOpen := <- channel1
		value2, channel2_stillOpen := <- channel2
		
		oneChannelNotOpen := channel1_stillOpen != channel2_stillOpen
		if oneChannelNotOpen {return false}
		if value1 != value2 {return false}
		
		bothChannelsClosed := !channel1_stillOpen && !channel2_stillOpen
		if bothChannelsClosed {break}
	}
	return true
}

func main() {
	fmt.Println(Same(tree.New(1), tree.New(1)))
	fmt.Println(Same(tree.New(1), tree.New(2)))
}
