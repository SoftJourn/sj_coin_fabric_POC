package faceService

import (
	"net/http"
	"time"
	"fmt"
	"bytes"
	"encoding/json"
	"io/ioutil"
)

var netClient = &http.Client{
	Timeout: time.Second * 20,
}

type FaceService struct {
	BaseUrl string
	AppKey string
}

func NewFaceService(baseUrl string, appKey string) *FaceService {
	return &FaceService{
		BaseUrl: baseUrl,
		AppKey: appKey,
	}
}

func (s *FaceService) DetectFace(imageBytes []byte) (bool, string, error) {

	var faceId string
	var url string = s.BaseUrl + "detect?returnFaceId=true&returnFaceLandmarks=false"

	result, err := s.CallFaceService(url, imageBytes, "application/octet-stream")
	if err != nil {
		return false, faceId, err
	}

	detectResponse := []DetectInfo{}
	err = json.Unmarshal(result.BodyBytes, &detectResponse)
	if err != nil {
		return false, faceId, err
	}

	if len(detectResponse) == 1 {
		faceId = detectResponse[0].FaceId
		fmt.Printf("\nFace found - FaceId: %s\n", detectResponse[0].FaceId)
		return true, faceId, err
	} else {
		fmt.Printf("\nFaces found : %v\n", len(detectResponse))
		return false, faceId, err
	}
}

func (s *FaceService) CreatePerson(personGroupId, name string) (string, error) {

	var personId string

	person := Person{
		Name: name,
	}

	personBytes, err := json.Marshal(person)
	if err != nil {
		return personId, err
	}

	var url string = s.BaseUrl + "persongroups/" + personGroupId +"/persons"

	result, err := s.CallFaceService(url, personBytes, "application/json")
	if err != nil {
		return personId, err
	}

	var personData map[string]string
	err = json.Unmarshal(result.BodyBytes, &personData)
	if err != nil {
		return personId, err
	}
	personId = personData["personId"]
	fmt.Printf("\npersonId: %s\n", personId)
	return personId, err
}

func (s *FaceService) AddFaceToPerson(personGroupId string, personId string, imageBytes []byte) (string, error) {

	var persistedFaceId string
	url := s.BaseUrl + "persongroups/" + personGroupId + "/persons/" + personId + "/persistedFaces"

	result, err := s.CallFaceService(url, imageBytes, "application/octet-stream")
	if err != nil {
		return persistedFaceId, err
	}
	var faceData map[string]string
	err = json.Unmarshal(result.BodyBytes, &faceData)
	if err != nil {
		return persistedFaceId, err
	}
	fmt.Printf("\npersistedFaceId: %s\n", faceData["persistedFaceId"])
	return faceData["persistedFaceId"], err
}

func (s *FaceService) VerifyFace (faceId string, personId string, personGroupId string) (VerifyResponse, error) {

	request := VerifyBody{
		FaceId:faceId,
		PersonId: personId,
		PersonGroupId: personGroupId,
	}

	var verifyResponse VerifyResponse

	requestBytes, err := json.Marshal(request)
	if err != nil {
		return verifyResponse, err
	}

	url := s.BaseUrl + "verify"

	result, err := s.CallFaceService(url, requestBytes, "application/json")
	if err != nil {
		return verifyResponse, err
	}

	err = json.Unmarshal(result.BodyBytes, &verifyResponse)
	if err != nil {
		fmt.Printf("\nError: %s\n", err)
		return verifyResponse, err
	}
	fmt.Printf("\nverifyResponse.IsIdentical: %v\n", verifyResponse.IsIdentical)
	fmt.Printf("\nverifyResponse.Confidence: %v\n", verifyResponse.Confidence)
	return verifyResponse, err
}

func (s *FaceService) CallFaceService(url string, body []byte, contentType string) (ResponseResult, error) {

	request, _ := http.NewRequest(http.MethodPost, url, bytes.NewReader(body))
	request.Header.Add("Content-Type", contentType)
	request.Header.Add("Ocp-Apim-Subscription-Key", s.AppKey)

	var result ResponseResult

	response, err := netClient.Do(request)
	if err != nil {
		return result, err
	}
	defer response.Body.Close()
	result.Status = response.StatusCode
	bodyBytes, err := ioutil.ReadAll(response.Body)
	if err != nil {
		return result, err
	}
	fmt.Printf("\nresult.Status: %v\n",result.Status)
	fmt.Printf("\nbodyBytes: %s\n",bodyBytes)

	result.BodyBytes = bodyBytes
	return result, err
}

func (s *FaceService) LoadImage (url string) ([]byte, error) {
	response, err := netClient.Get(url)
	if err != nil {
		return nil, err
	}
	defer response.Body.Close()

	bodyBytes, err := ioutil.ReadAll(response.Body)

	if err != nil {
		return nil, err
	}
	return bodyBytes, err
}