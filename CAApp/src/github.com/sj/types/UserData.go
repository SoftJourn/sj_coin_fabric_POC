package types

type UserData struct {
	Email string `json:"email"`
	FirstName string `json:"firstName"`
	LastName string `json:"lastName"`
	PersonId string `json:"personId"`
	PersistentFaceId string `json:"persistentFaceId"`
	PersonGroupId string `json:"personGroupId"`
}