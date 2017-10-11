package main
import (
	"CAApp/web"
	"CAApp/web/controllers"
)

func main() {
	// Make the web application listening
	app := &controllers.Application{
	}
	web.Serve(app)
}