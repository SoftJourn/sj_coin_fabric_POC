package web

import (
	"net/http"
	"fmt"
	"CAApp/web/controllers"
	"CAApp/src/github.com/sj/storage"
	"github.com/gorilla/sessions"
)

func Serve(app *controllers.Application) {
	fs := http.FileServer(http.Dir("web/assets"))
	http.Handle("/assets/", http.StripPrefix("/assets/", fs))

	http.HandleFunc("/login", app.LoginHandler)
	http.HandleFunc("/logout", app.LogoutHandler)
	http.HandleFunc("/generate", app.GenerateHandler)
	http.HandleFunc("/deploy", app.GenerateHandler)

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		http.Redirect(w, r, "/login", http.StatusTemporaryRedirect)
	})

	var storage = storage.GetInstance()
	storage.Store = sessions.NewCookieStore([]byte("something-very-secret"))


	fmt.Println("Listening (http://192.168.99.100:3000/) ...")
	http.ListenAndServe(":3000", nil)
}