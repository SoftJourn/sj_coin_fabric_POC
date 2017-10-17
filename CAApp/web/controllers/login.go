package controllers

import (
	"net/http"
	"fmt"
	"CAApp/src/github.com/sj/ldap"
	"CAApp/web/models"
	"CAApp/src/github.com/sj/storage"
)


var data = &models.LoginModel{
	Username: "vpetryk",
	Password: "",

	Response: models.ResponseInfo{
		Success: false,
		IsResponse: false,
	},
}

func (app *Application) LoginHandler(w http.ResponseWriter, r *http.Request) {

	if r.FormValue("submitted") == "true" {

		fmt.Printf("%s\n", r.FormValue("submitted"))

		user, groups, err := ldap.GetUser(r.FormValue("Username"), r.FormValue("Password"))

		if err != nil {
			fmt.Printf("Error: %v\n", err)
			data.Response.Success = false
			data.Response.IsResponse = true
			data.Response.ErrorMessage = err.Error()
			renderTemplate(w, r, "login.html", data)
			data.Response.ErrorMessage = ""
			return
		}

		fmt.Printf("%v\n", user)
		fmt.Printf("%v\n", groups)

		store := storage.GetInstance().Store

		session, _ := store.Get(r, "cookie-name")
		session.Values["authenticated"] = true
		session.Values["username"] = user.Username
		session.Values["email"] = user.Email
		session.Save(r, w)

		http.Redirect(w, r, "/generate",  http.StatusSeeOther)
		return
	}
	renderTemplate(w, r, "login.html", data)
}

func (app *Application) LogoutHandler(w http.ResponseWriter, r *http.Request) {

	store := storage.GetInstance().Store

	session, _ := store.Get(r, "cookie-name")
	session.Values["authenticated"] = false
	session.Save(r, w)

	renderTemplate(w, r, "login.html", data)

}