package controllers

import (
	"net/http"
	"CAApp/web/models"
	"CAApp/src/github.com/sj/storage"
	"CAApp/src/github.com/sj/ca"
	"fmt"
	"strings"
	"io/ioutil"
)

const KvsIdentityTemplate string = "{\"name\":\"{{USERNAME}}\",\"mspid\":\"Org1MSP\",\"roles\":null,\"affiliation\":\"\",\"enrollmentSecret\":\"hfYBbCUYMXzO\",\"enrollment\":{\"signingIdentity\":\"{{SKI}}\",\"identity\":{\"certificate\":\"{{CERTIFICATE}}\"}}}"

func (app *Application) GenerateHandler(w http.ResponseWriter, r *http.Request) {

	fmt.Printf("\nGenerateHandler\n")

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
		data.Response.IsResponse = true
		data.Response.Success = true

		caCertificatePath := r.FormValue("caCertificatePath")
		caKeyPath := r.FormValue("caKeyPath")

		certificateInfo, err := ca.Generate(email, caCertificatePath, caKeyPath)
		if err != nil {
			fmt.Errorf("failed to generate certificate: %s", err)
		}

		data.CertificateInfo = certificateInfo

		if r.RequestURI == "/deploy" {
			kvsPath := r.FormValue("kvsPath")

			if len(kvsPath) == 0 {
				data.Response.Success = false
				data.Response.ErrorMessage = "Incorrect kvsPath"
				renderTemplate(w, r, "generate.html", data)
				data.Response.ErrorMessage = ""
				return
			}

			identityString := strings.Replace(KvsIdentityTemplate, "{{USERNAME}}", email, -1)
			identityString = strings.Replace(identityString, "{{SKI}}", certificateInfo.SKI, -1)
			identityString = strings.Replace(identityString, "{{CERTIFICATE}}", certificateInfo.CertificateString, -1)

			err = ioutil.WriteFile(kvsPath + "/" + email, []byte(identityString), 0664)
			if err != nil {
				data.Response.Success = false
				data.Response.ErrorMessage = err.Error()
				renderTemplate(w, r, "generate.html", data)
				data.Response.ErrorMessage = ""
				return
			}

			err = ioutil.WriteFile(kvsPath + "/" + certificateInfo.SKI + "-pub", []byte(certificateInfo.PublicKey), 0664)
			if err != nil {
				data.Response.Success = false
				data.Response.ErrorMessage = err.Error()
				renderTemplate(w, r, "generate.html", data)
				data.Response.ErrorMessage = ""
				return
			}
			err = ioutil.WriteFile(kvsPath + "/" + certificateInfo.SKI + "-priv", []byte(certificateInfo.PrivateKey), 0664)
			if err != nil {
				data.Response.Success = false
				data.Response.ErrorMessage = err.Error()
				renderTemplate(w, r, "generate.html", data)
				data.Response.ErrorMessage = ""
				return
			}

			data.Response.Success = true
			data.Response.Message = "Successfully deployed"
			renderTemplate(w, r, "generate.html", data)
			data.Response.Message = ""
		}

	}
	renderTemplate(w, r, "generate.html", data)
}