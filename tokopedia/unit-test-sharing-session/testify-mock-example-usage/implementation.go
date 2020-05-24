package greet

//Greeter is the implementation of IGreeter
type Greeter struct {
}

//Greet with a name
func (g Greeter) Greet(name string) string {
	return "Hello " + name
}
