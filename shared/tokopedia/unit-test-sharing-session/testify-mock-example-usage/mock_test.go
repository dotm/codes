package greet

import (
	"testify-mock-example-usage/mocks"
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/stretchr/testify/mock"
)

func Test_functionWithMock(t *testing.T) {
	//given
	mockGreeter := &mocks.IGreeter{}
	cannedResponse := "aoeuaeuaeu"

	//setup mock expectations
	mockGreeter.On("Greet", mock.Anything).Return(cannedResponse).
		Once() //expect to be called once

	//when
	result := functionWithMock(mockGreeter)

	//then
	assert.Equal(t, cannedResponse, result)
	mockGreeter.AssertExpectations(t)
}
