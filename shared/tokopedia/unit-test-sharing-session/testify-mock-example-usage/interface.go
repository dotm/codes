package greet

//go:generate $GOPATH/bin/mockery -all -output ./mocks

//IGreeter is the interface that will be mocked
type IGreeter interface {
	Greet(string) string
}
