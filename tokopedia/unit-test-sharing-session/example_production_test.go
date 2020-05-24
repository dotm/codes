package pusdafilimpl

import (
	"context"
	"fmt"
	"net/http"
	"testing"

	"github.com/dhanapala-id/dol/internal/pkg/curl"
	mockCurl "github.com/dhanapala-id/dol/internal/pkg/curl/mocktestify"
	mockDatabase "github.com/dhanapala-id/dol/internal/pkg/database/mocktestify"
	mockQueue "github.com/dhanapala-id/dol/internal/pkg/queue/mocktestify"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"

	"github.com/dhanapala-id/dol/internal/app/domain/constant"
	"github.com/dhanapala-id/dol/internal/app/domain/model/extpartner"
	"github.com/dhanapala-id/dol/internal/app/domain/model/pusdafil"
)

const baseURL = "http://whatever.com/api/to"
const inquiryEndpoint = "/Inquiry"
const validURL = baseURL + inquiryEndpoint
const invalidURL = "example:// of a malformed url"
const exampleUsername = "admin"
const examplePassword = "1234"
const timeoutInSeconds = 10
const cacheLimit = "30"

func createMockConfig(username, password, baseURL, inquiryEndpoint, timeout, cacheLimit interface{}) map[string]interface{} {
	return map[string]interface{}{
		constant.PusdafilUsername:   username,
		constant.PusdafilPassword:   password,
		constant.PusdafilBaseURL:    baseURL,
		constant.PusdafilInquiry:    inquiryEndpoint,
		constant.PusdafilTimeout:    timeout,
		constant.PusdafilCacheLimit: cacheLimit,
	}
}

func createMockEndpointDataConfig(username, password, baseURL, inquiryEndpoint interface{}) map[string]interface{} {
	return map[string]interface{}{
		constant.PusdafilUsername:   username,
		constant.PusdafilPassword:   password,
		constant.PusdafilBaseURL:    baseURL,
		constant.PusdafilInquiry:    inquiryEndpoint,
		constant.PusdafilTimeout:    timeoutInSeconds,
		constant.PusdafilCacheLimit: cacheLimit,
	}
}

var validMockConfig = createMockConfig(exampleUsername, examplePassword, baseURL, inquiryEndpoint, timeoutInSeconds, cacheLimit)
var validRequestDTO = pusdafil.RequestDTO{ID: 321321321, Reason: pusdafil.ReasonExistingBorrower}
var emptyResponseDTO = pusdafil.ResponseDTO{}
var validResponseDTO = pusdafil.ResponseDTO{NoIdentitas: "3207025501730003"}
var emptyParamRes = []extpartner.DBHitCacheCheck{}
var validParamRes = []extpartner.DBHitCacheCheck{
	extpartner.DBHitCacheCheck{ReferenceRequestUUID: "some uuid"},
}
var emptyResponse = []string{}
var malformedJSONString = "this is a malformed JSON string"
var malformedResponse = []string{malformedJSONString}
var validResponseString = `{"no_identitas": "3207025501730003"}`
var validResponse = []string{validResponseString}

//dummies are just stand in
//  it won't be used for anything
//  it should not have expectations attached to it (e.g. with .On() method)
var dummyProducer = &mockQueue.Producer{}
var dummyRequestor = curl.NewHttpRequestor(curl.NewHTTPClient())
var dummyDB = &mockDatabase.DB{}

func Test_Inquiry(t *testing.T) {
	t.Run("hit cache successful", func(t *testing.T) {
		//given
		mockProducer := &mockQueue.Producer{}
		mockDB := &mockDatabase.DB{}
		d := Dependencies{dummyRequestor, mockDB, mockProducer, validMockConfig}

		//setup mock expectations
		simulateFetchDataFromCache(mockDB, validParamRes, validResponse)
		shouldPublishToQueue(mockProducer)

		//when
		resp, err := d.Inquiry(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, validResponseDTO, resp)
		assert.NoError(t, err)
		mockDB.AssertExpectations(t)
		mockProducer.AssertExpectations(t)
	})

	t.Run("hit cache successful but with malformed data", func(t *testing.T) {
		//given
		mockProducer := &mockQueue.Producer{}
		mockDB := &mockDatabase.DB{}
		d := Dependencies{dummyRequestor, mockDB, mockProducer, validMockConfig}

		//setup mock expectations
		simulateFetchDataFromCache(mockDB, validParamRes, malformedResponse)
		shouldPublishToQueue(mockProducer)

		//when
		resp, err := d.Inquiry(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, emptyResponseDTO, resp)
		assert.NoError(t, err) //is this correct behavior? (failed to marshall but return no error)
		mockDB.AssertExpectations(t)
		mockProducer.AssertExpectations(t)
	})

	t.Run("hit cache failed and will not hit external API", func(t *testing.T) {
		//this case originally is here so that
		//  repeated request wouldn't hit external API
		//however, in the current implementation
		//  any kind of error from hit cache will disallow hitting external API
		//the test case below is used to demonstrate such example

		t.Run("with nonexistent cache limit config", func(t *testing.T) {
			//given
			config := createMockConfig(exampleUsername, examplePassword, baseURL, inquiryEndpoint, timeoutInSeconds, nil)
			d := Dependencies{dummyRequestor, dummyDB, dummyProducer, config}

			//when
			resp, err := d.Inquiry(context.TODO(), validRequestDTO)

			//then
			assert.Equal(t, resp, emptyResponseDTO)
			assert.Error(t, err)
		})
	})

	t.Run("hit cache failed and hit external API failed", func(t *testing.T) {
		//given
		mockDB := &mockDatabase.DB{}
		mockProducer := &mockQueue.Producer{}
		mockRequestor := &mockCurl.IHttpRequestor{}
		mockRequest := &mockCurl.IHttpRequest{}
		d := Dependencies{mockRequestor, mockDB, mockProducer, validMockConfig}

		//setup mock expectations
		mockResponse := createMockResponseAndSetExpectations(false, nil)
		simulateFetchDataFromCache(mockDB, validParamRes, emptyResponse)
		simulateFetchDataFromAPI(mockRequestor, mockRequest, mockResponse)
		shouldPublishToQueue(mockProducer)

		//when
		resp, err := d.Inquiry(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, emptyResponseDTO, resp)
		assert.Error(t, err)
		mockDB.AssertExpectations(t)
		mockProducer.AssertExpectations(t)
		mockRequestor.AssertExpectations(t)
		mockRequest.AssertExpectations(t)
		mockResponse.AssertExpectations(t)
	})

	t.Run("hit cache failed and hit external API successful", func(t *testing.T) {
		//given
		mockDB := &mockDatabase.DB{}
		mockProducer := &mockQueue.Producer{}
		mockRequestor := &mockCurl.IHttpRequestor{}
		mockRequest := &mockCurl.IHttpRequest{}
		d := Dependencies{mockRequestor, mockDB, mockProducer, validMockConfig}

		//setup mock expectations
		mockResponse := createMockResponseAndSetExpectations(true, []byte(validResponseString))
		simulateFetchDataFromCache(mockDB, validParamRes, emptyResponse)
		simulateFetchDataFromAPI(mockRequestor, mockRequest, mockResponse)
		shouldPublishToQueue(mockProducer)

		//when
		resp, err := d.Inquiry(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, validResponseDTO, resp)
		assert.NoError(t, err)
		mockDB.AssertExpectations(t)
		mockProducer.AssertExpectations(t)
		mockRequestor.AssertExpectations(t)
		mockRequest.AssertExpectations(t)
		mockResponse.AssertExpectations(t)
	})
}

func Test_hitCache(t *testing.T) {

	t.Run("positive test case", func(t *testing.T) {
		//given
		mockProducer := &mockQueue.Producer{}
		mockDB := &mockDatabase.DB{}
		d := Dependencies{dummyRequestor, mockDB, mockProducer, validMockConfig}

		//setup mock expectations
		simulateFetchDataFromCache(mockDB, validParamRes, validResponse)
		shouldPublishToQueue(mockProducer)

		//when
		resp, err := d.hitCache(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, resp, validResponseString)
		assert.NoError(t, err)
		mockDB.AssertExpectations(t)
		mockProducer.AssertExpectations(t)
	})

	t.Run("with empty cache record", func(t *testing.T) {
		//given
		mockDB := &mockDatabase.DB{}
		d := Dependencies{dummyRequestor, mockDB, dummyProducer, validMockConfig}

		//setup mock expectations
		simulateFetchDataFromCache(mockDB, validParamRes, emptyResponse)

		//when
		resp, err := d.hitCache(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, resp, "")
		assert.NoError(t, err)
		mockDB.AssertExpectations(t)
	})

	t.Run("with nonexistent cache record", func(t *testing.T) {
		//given
		mockDB := &mockDatabase.DB{}
		d := Dependencies{dummyRequestor, mockDB, dummyProducer, validMockConfig}

		//setup mock expectations
		simulateFetchDataFromCache(mockDB, emptyParamRes, emptyResponse)

		//when
		resp, err := d.hitCache(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, resp, "")
		assert.NoError(t, err)
		mockDB.AssertExpectations(t)
	})

	t.Run("with error fetching data from cache", func(t *testing.T) {
		//given
		mockDB := &mockDatabase.DB{}
		d := Dependencies{dummyRequestor, mockDB, dummyProducer, validMockConfig}

		//setup mock expectations
		simulateFetchDataFromCacheError(mockDB)

		//when
		resp, err := d.hitCache(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, resp, "")
		assert.Error(t, err)
		mockDB.AssertExpectations(t)
	})

	t.Run("with nonexistent cache limit config", func(t *testing.T) {
		//given
		config := createMockConfig(exampleUsername, examplePassword, baseURL, inquiryEndpoint, timeoutInSeconds, nil)
		d := Dependencies{dummyRequestor, dummyDB, dummyProducer, config}

		//when
		resp, err := d.hitCache(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, resp, "")
		assert.Error(t, err)
	})
}

func Test_inquiry(t *testing.T) {
	t.Run("positive case", func(t *testing.T) {
		//given
		mockProducer := &mockQueue.Producer{}
		mockRequestor := &mockCurl.IHttpRequestor{}
		mockRequest := &mockCurl.IHttpRequest{}
		d := Dependencies{mockRequestor, dummyDB, mockProducer, validMockConfig}

		//setup mock expectations
		mockResponse := createMockResponseAndSetExpectations(true, []byte(validResponseString))
		simulateFetchDataFromAPI(mockRequestor, mockRequest, mockResponse)
		shouldPublishToQueue(mockProducer)

		//when
		resp, err := d.inquiry(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, validResponseDTO, resp)
		assert.NoError(t, err)
		mockProducer.AssertExpectations(t)
		mockRequestor.AssertExpectations(t)
		mockRequest.AssertExpectations(t)
		mockResponse.AssertExpectations(t)
	})

	t.Run("server return malformed JSON", func(t *testing.T) {
		//given
		mockProducer := &mockQueue.Producer{}
		mockRequestor := &mockCurl.IHttpRequestor{}
		mockRequest := &mockCurl.IHttpRequest{}
		d := Dependencies{mockRequestor, dummyDB, mockProducer, validMockConfig}

		//setup mock expectations
		mockResponse := createMockResponseAndSetExpectations(true, []byte(malformedJSONString))
		simulateFetchDataFromAPI(mockRequestor, mockRequest, mockResponse)
		shouldPublishToQueue(mockProducer)

		//when
		resp, err := d.inquiry(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, resp, emptyResponseDTO)
		assert.Error(t, err)
		mockProducer.AssertExpectations(t)
		mockRequestor.AssertExpectations(t)
		mockRequest.AssertExpectations(t)
		mockResponse.AssertExpectations(t)
	})

	t.Run("internal server error", func(t *testing.T) {
		//given
		mockProducer := &mockQueue.Producer{}
		mockRequestor := &mockCurl.IHttpRequestor{}
		mockRequest := &mockCurl.IHttpRequest{}
		d := Dependencies{mockRequestor, dummyDB, mockProducer, validMockConfig}

		//setup mock expectations
		mockResponse := createMockResponseAndSetExpectations(false, nil) //for example because server return 500 (internal server error)
		simulateFetchDataFromAPI(mockRequestor, mockRequest, mockResponse)
		shouldPublishToQueue(mockProducer)

		//when
		resp, err := d.inquiry(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, resp, emptyResponseDTO)
		assert.Error(t, err)
		mockProducer.AssertExpectations(t)
		mockRequestor.AssertExpectations(t)
		mockRequest.AssertExpectations(t)
		mockResponse.AssertExpectations(t)
	})

	t.Run("with nonexistent timeout config", func(t *testing.T) {
		//given
		config := createMockConfig(exampleUsername, examplePassword, baseURL, inquiryEndpoint, nil, cacheLimit)
		d := Dependencies{dummyRequestor, dummyDB, dummyProducer, config}

		//when
		resp, err := d.inquiry(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, resp, emptyResponseDTO)
		assert.Error(t, err)
	})

	t.Run("with malformed URL", func(t *testing.T) {
		//given
		config := createMockConfig(exampleUsername, examplePassword, invalidURL, inquiryEndpoint, timeoutInSeconds, cacheLimit)
		d := Dependencies{dummyRequestor, dummyDB, dummyProducer, config}

		//when
		resp, err := d.inquiry(context.TODO(), validRequestDTO)

		//then
		assert.Equal(t, resp, emptyResponseDTO)
		assert.Error(t, err)
	})
}

func Test_getInquiryEndpointData(t *testing.T) {
	t.Run("positive case", func(t *testing.T) {
		//given
		d := Dependencies{dummyRequestor, dummyDB, dummyProducer, validMockConfig}

		//when
		rawURL, username, password, err := d.getInquiryEndpointData()

		//then
		assert.NoError(t, err)
		//should return the correct data from config
		assert.Equal(t, validURL, rawURL)
		assert.Equal(t, exampleUsername, username)
		assert.Equal(t, examplePassword, password)
	})

	//Example of table driven test ~kodok
	t.Run("config doesn't supply required fields", func(t *testing.T) {
		const wrongType int = 123
		table := []struct {
			invalidField string
			config       map[string]interface{}
		}{
			{invalidField: "username", config: createMockEndpointDataConfig(nil, examplePassword, baseURL, inquiryEndpoint)},
			{invalidField: "username", config: createMockEndpointDataConfig("", examplePassword, baseURL, inquiryEndpoint)},
			{invalidField: "username", config: createMockEndpointDataConfig(wrongType, examplePassword, baseURL, inquiryEndpoint)},
			{invalidField: "password", config: createMockEndpointDataConfig(exampleUsername, nil, baseURL, inquiryEndpoint)},
			{invalidField: "password", config: createMockEndpointDataConfig(exampleUsername, "", baseURL, inquiryEndpoint)},
			{invalidField: "password", config: createMockEndpointDataConfig(exampleUsername, wrongType, baseURL, inquiryEndpoint)},
			{invalidField: "baseURL", config: createMockEndpointDataConfig(exampleUsername, examplePassword, nil, inquiryEndpoint)},
			{invalidField: "baseURL", config: createMockEndpointDataConfig(exampleUsername, examplePassword, "", inquiryEndpoint)},
			{invalidField: "baseURL", config: createMockEndpointDataConfig(exampleUsername, examplePassword, wrongType, inquiryEndpoint)},
			{invalidField: "endpoint", config: createMockEndpointDataConfig(exampleUsername, examplePassword, baseURL, nil)},
			{invalidField: "endpoint", config: createMockEndpointDataConfig(exampleUsername, examplePassword, baseURL, "")},
			{invalidField: "endpoint", config: createMockEndpointDataConfig(exampleUsername, examplePassword, baseURL, wrongType)},
		}

		for _, tableCell := range table {
			t.Run("invalid "+tableCell.invalidField, func(t *testing.T) {
				//given
				config := tableCell.config
				d := Dependencies{dummyRequestor, dummyDB, dummyProducer, config}

				//when
				_, _, _, err := d.getInquiryEndpointData()

				//then
				assert.Error(t, err)
			})
		}
	})
}

func Test_createRequestForPusdafil(t *testing.T) {
	t.Run("positive case", func(t *testing.T) {
		//given
		config := validMockConfig
		d := Dependencies{dummyRequestor, dummyDB, dummyProducer, config}

		//when
		_, err := d.createRequestForPusdafil(validRequestDTO)

		//then
		assert.NoError(t, err)
	})

	t.Run("with malformed URL", func(t *testing.T) {
		//given
		config := createMockConfig(exampleUsername, examplePassword, invalidURL, inquiryEndpoint, timeoutInSeconds, cacheLimit)
		d := Dependencies{dummyRequestor, dummyDB, dummyProducer, config}

		//when
		got, err := d.createRequestForPusdafil(validRequestDTO)

		//then
		assert.Empty(t, got)
		assert.Error(t, err)
	})
}

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

func Test_New(t *testing.T) {
	//for now, this is just for formality (increasing code coverage)
	//but if later we add logic on the New function,
	//then we can test that logic here.

	//given

	//when
	d := New(dummyRequestor, dummyDB, dummyProducer, validMockConfig)

	//then
	assert.NotNil(t, d.httpClient)
	assert.NotNil(t, d.slaveDB)
	assert.NotNil(t, d.producer)
	assert.NotNil(t, d.cfg)
}

func simulateFetchDataFromAPI(mockRequestor *mockCurl.IHttpRequestor, mockRequest *mockCurl.IHttpRequest, mockResponse *mockCurl.IHttpResponse) {
	anyString := mock.AnythingOfType("string")
	mockRequestor.On("NewHttpRequest", http.MethodGet, anyString).Return(mockRequest)
	mockRequest.On("SetHeader", anyString, anyString)
	mockRequest.On("Do", mock.Anything, mock.Anything).Return(mockResponse, nil)
}

func createMockResponseAndSetExpectations(successful bool, response []byte) *mockCurl.IHttpResponse {
	mockResponse := &mockCurl.IHttpResponse{}
	mockResponse.On("IsSuccess").Return(successful)
	//this is coupled to the implementation
	//we assume here that if IsSuccess is true, GetBody won't be called
	if successful {
		mockResponse.On("GetBody").Return(response)
	}
	return mockResponse
}

//Example of mocking with side effect ~kodok
func simulateFetchDataFromCache(mockDB *mockDatabase.DB, paramResReturned []extpartner.DBHitCacheCheck, responseReturned []string) {
	mockDB.On("NamedSelect", mock.Anything, mock.Anything, mock.Anything, mock.Anything).
		Run(func(args mock.Arguments) {
			paramRes, isParamRes := args.Get(1).(*[]extpartner.DBHitCacheCheck)
			if isParamRes {
				*paramRes = paramResReturned
				return
			}

			response, isResponse := args.Get(1).(*[]string)
			if isResponse {
				*response = responseReturned
				return
			}
		}).
		Return(nil)
}

func simulateFetchDataFromCacheError(mockDB *mockDatabase.DB) {
	mockDB.On("NamedSelect", mock.Anything, mock.Anything, mock.Anything, mock.Anything).
		Return(fmt.Errorf("error fetching data from cache"))
}

func shouldPublishToQueue(mockProducer *mockQueue.Producer) {
	mockProducer.On("Publish", constant.TopicDOLPartnerEvents, mock.Anything).Return(nil).Once()
}
