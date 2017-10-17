package models

import "CAApp/src/github.com/sj/ca"

type LoginModel struct {
	Username string
	Password string
	Response ResponseInfo
}

type ResponseInfo struct {
	Success      bool
	IsResponse   bool
	ErrorMessage string
	Message string
}

type GenerateModel struct {
	Email string
	Username string
	CertificateInfo ca.CertificateInfo
	Response ResponseInfo
}



