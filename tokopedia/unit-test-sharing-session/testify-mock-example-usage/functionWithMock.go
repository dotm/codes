package greet

//This will be the layer outside of Greeter (Clean architecture)
// that will use the Greeter through an interface
// and that will be the FUT (Function Under Test)
func functionWithMock(g IGreeter) string {
	return g.Greet("world!")
}
