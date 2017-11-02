package controllers

import (
	"path/filepath"
	"os"
	"fmt"
	"net/http"
	"html/template"
	"CAApp/src/github.com/sj/services/faceService"
	"CAApp/src/github.com/sj/services/userService"
)

type Application struct {
	FaceService faceService.FaceService
	UserService userService.UserService
}

func renderTemplate(w http.ResponseWriter, r *http.Request, templateName string, data interface{}) {
	lp := filepath.Join("web", "templates", "layout.html")
	tp := filepath.Join("web", "templates", templateName)

	// Return a 404 if the template doesn't exist
	info, err := os.Stat(tp)
	if err != nil {
		if os.IsNotExist(err) {
			http.NotFound(w, r)
			return
		}
	}

	// Return a 404 if the request is for a directory
	if info.IsDir() {
		http.NotFound(w, r)
		return
	}

	resultTemplate, err := template.ParseFiles(tp, lp)
	if err != nil {
		// Log the detailed error
		fmt.Println(err.Error())
		// Return a generic "Internal Server Error" message
		http.Error(w, http.StatusText(500), 500)
		return
	}
	if err := resultTemplate.ExecuteTemplate(w, "layout", data); err != nil {
		fmt.Println(err.Error())
		http.Error(w, http.StatusText(500), 500)
	}
}
