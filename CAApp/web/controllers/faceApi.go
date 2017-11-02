package controllers

import (
	"net/http"
	"encoding/json"
	"CAApp/src/github.com/sj/ldap"
	"fmt"
	"github.com/docker/docker/pkg/urlutil"
	"os"
	"io/ioutil"
	"errors"
	"CAApp/src/github.com/sj/services/faceService"
	"CAApp/src/github.com/sj/types"
)

type RegisterRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
	ImageUrl string `json:"imageUrl"`
	ImageBytes [] byte`json:"imageBytes"`
	PersonGroupId string `json:"personGroupId"`
}

type RegisterResponse struct {
	Email string `json:"email"`
	FirstName string `json:"firstName"`
	LastName string `json:"lastName"`
	PersonId string `json:"personId"`
}

type LoginRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
	ImageUrl string `json:"imageUrl"`
	ImageBytes [] byte`json:"imageBytes"`
	Email string `json:"email"`
}

type LoginResponse struct {
	Email string `json:"email"`
	FirstName string `json:"firstName"`
	LastName string `json:"lastName"`
	PersonId string `json:"personId"`
	VerifyResponse faceService.VerifyResponse`json:"verifyResponse"`
}

func (app *Application) RegisterHandler(responseWriter http.ResponseWriter, request *http.Request) {

	var registerRequest RegisterRequest

	decoder := json.NewDecoder(request.Body)
	err := decoder.Decode(&registerRequest)
	if err != nil {
		http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
		return
	}

	var imageBytes []byte

	//For development +
	if len(registerRequest.ImageBytes) == 0 && urlutil.IsURL(registerRequest.ImageUrl) {
		imageBytes, err = app.FaceService.LoadImage(registerRequest.ImageUrl)
		if err != nil {
			http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
			return
		}
	} else {
		imageBytes = registerRequest.ImageBytes
	}
	//For development -

	ldapUser, _, err := ldap.GetUser(registerRequest.Username, registerRequest.Password)
	if err != nil {
		http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
		return
	}

	fmt.Printf("LDAP User: %v", ldapUser)

	userData := types.UserData{
		Email:     ldapUser.Email,
		FirstName: ldapUser.FirstName,
		LastName:  ldapUser.LastName,
		PersonGroupId: "1",
	}

	if len(imageBytes) > 0 {

		hasFace, _, err := app.FaceService.DetectFace(imageBytes)
		if err != nil {
			http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
			return
		}

		if hasFace {
			personId, err := app.FaceService.CreatePerson(registerRequest.PersonGroupId, registerRequest.Username)
			if err != nil {
				http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
				return
			}
			persistentFaceId, err := app.FaceService.AddFaceToPerson(registerRequest.PersonGroupId, personId , imageBytes)
			if err != nil {
				http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
				return
			}
			userData.PersonId = personId
			userData.PersistentFaceId = persistentFaceId
		} else {
			http.Error(responseWriter, "Face not found", http.StatusExpectationFailed)
			return
		}
	} else {
		http.Error(responseWriter,"Image not found", http.StatusExpectationFailed)
		return
	}

	//check if exists
	//_, err = app.getUserDataByEmail(userData.Email)
	//if err == nil {
	//	http.Error(responseWriter, "User already registered", http.StatusExpectationFailed)
	//	return
	//}

	result := app.addUser(userData)
	//result := addUser(userData) //File

	if !result {
		http.Error(responseWriter, "Failed to register user", http.StatusExpectationFailed)
		return
	}

	response := RegisterResponse {
		Email:     ldapUser.Email,
		FirstName: ldapUser.FirstName,
		LastName:  ldapUser.LastName,
		PersonId:  userData.PersonId,
	}

	js, err := json.Marshal(response)
	if err != nil {
		http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
		return
	}

	responseWriter.Header().Set("Content-Type", "application/json")
	responseWriter.Write(js)
	return
}

func (app *Application) FaceLoginHandler(responseWriter http.ResponseWriter, request *http.Request) {

	var loginRequest LoginRequest

	decoder := json.NewDecoder(request.Body)
	err := decoder.Decode(&loginRequest)
	if err != nil {
		http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
		return
	}

	var imageBytes []byte

	//For development +
	if len(loginRequest.ImageBytes) == 0 && urlutil.IsURL(loginRequest.ImageUrl) {
		imageBytes, err = app.FaceService.LoadImage(loginRequest.ImageUrl)
		if err != nil {
			http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
			return
		}
	} else {
		imageBytes = loginRequest.ImageBytes
	}
	//For development -

	var userData types.UserData
	var verifyResponse faceService.VerifyResponse
	if len(loginRequest.Email) == 0 || len(imageBytes) == 0 {
		ldapUser, _, err := ldap.GetUser(loginRequest.Username, loginRequest.Password)
		if err != nil {
			http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
			return
		}
		fmt.Printf("User: %v", ldapUser)

		userData, err = app.getUserDataByEmail(ldapUser.Email)
		if err != nil {
			http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
			return
		}
	} else {
		userData, err = app.getUserDataByEmail(loginRequest.Email)
		if err != nil {
			http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
			return
		}

		hasFace, faceId, err := app.FaceService.DetectFace(imageBytes)
		if err != nil {
			http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
			return
		}

		if hasFace {
			verifyResponse, err = app.FaceService.VerifyFace(faceId, userData.PersonId, userData.PersonGroupId)
			if err != nil {
				http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
				return
			}
			if !verifyResponse.IsIdentical {
				http.Error(responseWriter, "Error: Face not recognized", http.StatusExpectationFailed)
				return
			}

		} else {
			http.Error(responseWriter, "Error: Face not found", http.StatusExpectationFailed)
			return
		}
	}

	if &userData == nil {
		http.Error(responseWriter, "Error: User is not registered", http.StatusExpectationFailed)
		return

	} else {
		response := LoginResponse {
			Email: userData.Email,
			FirstName: userData.FirstName,
			LastName: userData.LastName,
			PersonId: userData.PersonId,
			VerifyResponse: verifyResponse,
		}

		js, err := json.Marshal(response)
		if err != nil {
			http.Error(responseWriter, err.Error(), http.StatusExpectationFailed)
			return
		}

		responseWriter.Header().Set("Content-Type", "application/json")
		responseWriter.Write(js)
		return
	}
}

//blockchain methods

func (app *Application) getUserDataByEmail (email string) (types.UserData, error) {

	userData, err := app.UserService.GetUserById(email)

	if err != nil {
		fmt.Printf("Error: %s\n", err.Error())
		return userData, err
	}
	return userData, err
}

func (app *Application) addUser(userData types.UserData) bool {
	err := app.UserService.AddUser(userData)
	if err != nil {
		fmt.Printf("Error: %s\n", err.Error())
	}
	return err == nil
}

// File methods
func addUser(userData types.UserData) bool {

	users, err := getUsers()
	if err != nil {
		fmt.Printf("Error: %s\n", err.Error())
		return false
	}

	users[userData.Email] = userData

	err = setUsers(users)
	if err != nil {
		fmt.Printf("Error: %s\n", err.Error())
		return false
	}

	return true
}

func getUserDataByEmail (email string) (types.UserData, error) {

	var userData types.UserData
	users, err := getUsers()

	if err != nil {
		fmt.Printf("Error: %s\n", err.Error())
		return userData, err
	}
	if userData, ok := users[email]; ok {
		return users[email], err
	} else {
		return userData, errors.New("User not found")
	}
}

func deleteUserDataByEmail (email string) error {
	users, err := getUsers()

	if err != nil {
		fmt.Printf("Error: %s\n", err.Error())
		return err
	}
	delete(users, email)
	return err
}

//File save implementation

var usersFilePath string = "/tmp/users"

func getUsers () (map[string]types.UserData, error) {

	var users map[string]types.UserData

	if _, err := os.Stat(usersFilePath); os.IsNotExist(err) {
		err = ioutil.WriteFile(usersFilePath, nil, 0644)
		if err != nil {
			fmt.Printf("Error: %s\n", err.Error())
			return users, err
		}
		users = make(map[string]types.UserData)
	} else {
		fileBytes, err := ioutil.ReadFile(usersFilePath)
		if err != nil {
			fmt.Printf("Error: %s\n", err.Error())
			return users, err
		}
		if len(fileBytes) > 0 {
			err = json.Unmarshal(fileBytes, &users)
			if err != nil {
				fmt.Printf("Error: %s\n", err.Error())
				return users, err
			}
		} else {
			users = make(map[string]types.UserData)
		}
	}
	return users, nil
}

func setUsers (users map[string]types.UserData) error {

	usersBytes, err := json.Marshal(users)
	if err != nil {
		fmt.Printf("Error: %s\n", err.Error())
		return err
	}

	err = ioutil.WriteFile(usersFilePath, usersBytes, 0644)
	if err != nil {
		fmt.Printf("Error: %s\n", err.Error())
		return err
	}
	return nil
}
