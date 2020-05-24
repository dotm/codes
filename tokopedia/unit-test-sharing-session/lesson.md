# Unit Test + Mocking Sharing Session

Principles:
- Unit test should be fast (all test suite in one repo should ideally run below 1 minute)
- Unit test should be as painless as possible
	- Automate things that can be automated (e.g. mock generator)
	- For every 100 lines of code, the unit test for that code can be 150-300 lines
- While code coverage is important, program correctness is paramount.
- Some logic should be prioritized:
	- critical logic (things that can cause huge losses for the company) (legal, financial, customer, etc.)
	- often-used logic (login, register, lending page, etc.)
	- bug driven development (fix bug, write the test so it doesn't regress)
		- good for logic that is often nudged accidentally (kesenggol)

Basic:
- Test Structure
- Assert
- Test Doubles

Mocking Steps (with demonstration)(see `./testify-mock-example-usage` for finished example):
- make a file for the interface
- add the go generate comment
- generate the file or `go generate ./...`
- implement the interface
- use the interface
- test the interface usage by mocking
    - common error: wrong name, wrong argument, unchecked call
    - mock.Anything
    - don't forget to call `.AssertExpectations(t)` at the end (we can use defer)

Show test in production:
- Dummy vs. Mock
- Setup mock expectation should be before When
- building mock expectation
- side effect in mock expectation
- `package module` vs `package module_test`
	- use the same name as your package (package module) if you want to test private functions
	- append _test (package module_test) if you want to test Public functions

Run all test in production easily:
- `go test ./...` (must run below 1 minute)
- `./runtests.sh` (will also show code coverage)
	- look at code coverage output
	- we can check coverage output per directory when creating test:
		- `go test -coverprofile=coverage.out path/to/a/package`
		- `go tool cover -html=coverage.out`

----------------------------------------------------------------------
# Test structure

For the test, we will test per unit of functionality.
In OOP languages, the unit can be class, methods, or function.
In Go, the unit will be function or method (since we don't have class).

So in the test below, we are testing the createURL function.
The structuring here is based on BDD (behavior driven development):
```
describe-context
given-when-then
```

**First, we'll describe the createURL function.**

In other framework we might do it like this:
```
describe("createURL function"){}
```

but in Go (without additional framework) we just use
`func Test_createURL` as the describe statement.

**And then we give the context for createURL: one with positive case, another with negative case.**

In other framework we might do it like this:
```
describe("createURL function"){
    context("positive case"){}
}
```
but here, we just use `t.Run`.

**Finally we give the behavior expectation of createURL with each context.**

In other framework we might do it like this:
```
describe("createURL function"){
    context("positive case"){
        it("should return the correct URL without error"){
            //given
            //when
            //then
            assert()
        }
    }
}
```
but here we just use plain Go statements.

```
Given: given a certain arguments
When: something happens (the function is called with the arguments supplied in Given)
Then: something else SHOULD happens (should return something, should raise error, etc.)
```

The then part can be made more readable with assert/expect.

```
func Test_createURL(t *testing.T) {
	t.Run("positive case", func(t *testing.T) {
		//given
		endpointURL := validURL

		//when
		got, err := createURL(endpointURL, validRequestDTO)

		//then
		want := endpointURL + "?id=321321321&reason=2"
		assert.Equal(t, want, got)
		assert.NoError(t, err)
	})

	t.Run("with malformed URL", func(t *testing.T) {
		//given
		endpointURL := invalidURL

		//when
		got, err := createURL(endpointURL, validRequestDTO)

		//then
		assert.Empty(t, got)
		assert.Error(t, err)
	})
}
```

----------------------------------------------------------------------
# Assert

Assert here is to make the expectation more readable

So if we have
```
got := "something from the function"
want := "expected value"
```
instead of doing:
```
if got != want {
    t.Errorf("values not equal")
}
```
we can say: `assert.Equal(t, got, want)`

In some framework, the assert is called expect: `expect.Equal(t,got,want)`

Equal is one kind of matcher.

Other types of matcher: NotEqual, GreaterThan, LessThan, Nil, NotNil, Error, NotError

Please read the reference docs for the complete list.

----------------------------------------------------------------------
# Test Doubles Summary

https://blog.cleancoder.com/uncle-bob/2014/05/14/TheLittleMocker.html

Test Doubles:
What many people (informally) call mock is actually test double 

All of the terms below are test doubles:
- Dummy: something that shouldn't be used and acts just as a stand in.
	- e.g. used in dependency Injection. 
- Stub: something that return canned response.
	- e.g. a login method that always return wrong password error
- Spy: something that records messages that it received.
	- It knows what things are invoked through those messages, how many times they are invoked, and each invocation's arguments. 
- True mock (as in the formal definition of mock): a spy that have verify method.
	- This verify method contains assertions that the mock must fulfil
		- e.g. This method must be called two times with these parameters before that function can be called.
	- We move the assertions into the mock to make it easy to create mocking tools.
	- The mock is not so interested in the return values of functions. It’s more interested in what function were called, with what arguments, when, and how often.
- Fake: a test double that have business logic.
	- Fakes can get extremely complicated. So complicated they need unit tests of their own.
	- At the extremes the fake becomes the real system. But usually fake's business logic are simpler than the real system.
	- That being said, I don't use fake often. 

We can say that a true Mock is a kind of spy, a spy is a kind of stub, and a stub is a kind of dummy. But a fake isn’t a kind of any of them. It’s a completely different kind of test double.

----------------------------------------------------------------------
- https://godoc.org/github.com/stretchr/testify
- https://github.com/quii/learn-go-with-tests
- (Available in ./example_production_test.go) https://github.com/dhanapala-id/dol/blob/21c20801d7/internal/app/interface/repository/pusdafil/implementation/pusdafil_test.go

