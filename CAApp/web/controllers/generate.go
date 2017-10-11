package controllers

import (
	"net/http"
	"CAApp/web/models"
	"CAApp/src/github.com/sj/storage"
	"CAApp/src/github.com/sj/ca"
	"fmt"
)

func (app *Application) GenerateHandler(w http.ResponseWriter, r *http.Request) {

	store := storage.GetInstance().Store
	session, _ := store.Get(r, "cookie-name")

	if session.Values["authenticated"] != true {
		http.NotFound(w, r)
		return
	}

	username := session.Values["username"].(string)
	email := session.Values["email"].(string)

	data := &models.GenerateModel{

		Username: username,
		Email: email,

		Response: models.ResponseInfo{
			Success: false,
			IsResponse: false,
		},
	}


	if r.FormValue("submitted") == "true" {
		caCertificatePath := r.FormValue("caCertificatePath")
		caKeyPath := r.FormValue("caKeyPath")

		certificateInfo, err := ca.Generate(email, caCertificatePath, caKeyPath)
		if err != nil {
			fmt.Errorf("failed to generate certificate: %s", err)
		}
		//fmt.Printf("\ncertificateInfo.PrivateKey:\n%s", certificateInfo.PrivateKey)
		//fmt.Printf("\ncertificateInfo.PublicKey:\n%s", certificateInfo.PublicKey)
		//fmt.Printf("\ncertificateInfo.Certificate:\n%s", certificateInfo.Certificate)
		//fmt.Printf("\ncertificateInfo.CertificateString:\n%s", certificateInfo.CertificateString)
		//fmt.Printf("\ncertificateInfo.SKI:\n%s", certificateInfo.SKI)
		data.CertificateInfo = certificateInfo

	}
	renderTemplate(w, r, "generate.html", data)
}
