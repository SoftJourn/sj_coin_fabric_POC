package faceService

type ResponseResult struct {
	BodyBytes []byte
	Status int
}

type DetectInfo struct {
	FaceId   string      		`json:"faceId"`
	//	FaceRectangle interface{}	`json:"faceRectangle"`
}

type Person struct {
	Name string `json:"name"`
	UserData string `json:"userData"`
}

type VerifyBody struct {
	FaceId string	`json:"faceId"`
	PersonId string	`json:"personId"`
	PersonGroupId string	`json:"personGroupId"`
}

type VerifyResponse struct {
	IsIdentical bool	`json:"isIdentical"`
	Confidence float32	`json:"confidence"`
}
