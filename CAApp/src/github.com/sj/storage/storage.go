package storage

import (
	"sync"
	"github.com/gorilla/sessions"
)

type caSession struct {
	Store sessions.Store
}

var instance *caSession
var once sync.Once

func GetInstance() *caSession {
	once.Do(func() {
		instance = &caSession{}
	})
	return instance
}