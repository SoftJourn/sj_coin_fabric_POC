package ca
import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/asn1"
	"encoding/pem"
	"fmt"
	"io/ioutil"
	"math/big"
	"strings"
	"time"
	"crypto/sha1"
	"fabric/bccsp/utils"
	"crypto/sha256"
)

type CertificateInfo struct {
	PublicKey string
	PrivateKey string
	Certificate string
	CertificateString string
	SKI string
}

func Generate(email string, caCertificatePath string, caKeyPath string) (CertificateInfo, error) {

	var certificateInfo CertificateInfo

	fmt.Println("Generate start...")

	rootPEM, err := ioutil.ReadFile(caCertificatePath)
	if err != nil {
		fmt.Printf("Cannot read root cert file: %s\n\n", err)
		return certificateInfo, err
	}

	rootKEY, err := ioutil.ReadFile(caKeyPath)
	if err != nil {
		fmt.Printf("Cannot read root key file: %s\n\n", err)
		return certificateInfo, err
	}
	//fmt.Printf("Root key: \n%s\n", rootKEY)

	var ok bool
	rootPool := x509.NewCertPool()
	ok = rootPool.AppendCertsFromPEM([]byte(rootPEM))
	if !ok {
		fmt.Printf("Failed to parse root certificate\n")
		return certificateInfo, err
	}

	opts := x509.VerifyOptions{
		//DNSName: "Jim",
		Roots:         rootPool,
		KeyUsages:     []x509.ExtKeyUsage{x509.ExtKeyUsageAny},
	}

	encKeyFromPEM, err := utils.PEMtoPrivateKey([]byte(rootKEY), nil)
	if err != nil {
		fmt.Printf("Failed converting DER to private key [%s]", err)
	}
	rootPrivateKey := encKeyFromPEM.(*ecdsa.PrivateKey)

	block, _ := pem.Decode([]byte(rootPEM))
	rootCert, _ := x509.ParseCertificate(block.Bytes)

	p, _ := pem.Decode([]byte(rootKEY))
	if p == nil {
		fmt.Printf("No private CA key pem block found\n")
		return certificateInfo, err
	}

	/******************** NEW CERTIFICATE *********************/

	privateKey, _ := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)

	privateEncPEM, err := utils.PrivateKeyToPEM(privateKey, nil)
	if err != nil {
		fmt.Printf("Failed converting private key to encrypted PEM [%s]", err)
	}

	fmt.Printf("\nPrivate key to encrypted PEM: \n%s\n", privateEncPEM)

	publicEncPEM, err := utils.PublicKeyToPEM(&privateKey.PublicKey, nil)
	if err != nil {
		fmt.Printf("Failed converting public key to PEM [%s]", err)
	}
	fmt.Printf("\nPublic key to encrypted PEM: \n%s\n", publicEncPEM)

	subjectKeyId, _ := getSubjectKey(privateKey)

	certTemplate := &x509.Certificate{
		SerialNumber:    big.NewInt(1658),
		IsCA:            false,
		BasicConstraintsValid: true,

		Subject: pkix.Name{
			CommonName:			email,
		},
		SignatureAlgorithm: x509.ECDSAWithSHA256,
		PublicKey:          privateKey.PublicKey,
		NotBefore:          time.Now(),
		NotAfter:           time.Now().Add(time.Hour * 48),
		SubjectKeyId:       subjectKeyId,
		KeyUsage:           x509.KeyUsageDigitalSignature,
	}

	rawCert, err := x509.CreateCertificate(rand.Reader, certTemplate, rootCert, &privateKey.PublicKey, rootPrivateKey)
	if err != nil {
		fmt.Printf("Error occurred during certificate creation: %s\n", err)
		return certificateInfo, err
	}

	cert, _ := x509.ParseCertificate(rawCert)

	privateSki := getPrivateSKI(privateKey)
	fmt.Printf("\nprivate SKI: %x\n\n ", privateSki[:])

	var certPEM = &pem.Block{
		Type:  "CERTIFICATE",
		Bytes: rawCert,
	}
	outBytes := pem.EncodeToMemory(certPEM)
	certificateString := strings.Replace(fmt.Sprintf("%s", outBytes), "\n","\\n", -1)

	fmt.Printf("New Certificate: \n%s\n\n", certificateString)
	//fmt.Printf("New Certificate: \n%s\n", outBytes)

	if _, err := cert.Verify(opts); err != nil {
		fmt.Printf("Failed to verify new certificate: %s\n\n\n", err.Error())
	} else {
		fmt.Printf(">>>>>>>>>>>>>>>>>>>> New certificate is VALID!\n")
	}

	certificateInfo.Certificate = fmt.Sprintf("%s", outBytes)
	certificateInfo.CertificateString = certificateString
	certificateInfo.PrivateKey = fmt.Sprintf("%s", privateEncPEM)
	certificateInfo.PublicKey = fmt.Sprintf("%s", publicEncPEM)
	certificateInfo.SKI = fmt.Sprintf("%x", privateSki[:])

	//fmt.Printf("certificateInfo: %v\n\n ", certificateInfo)
	return certificateInfo, err
}


// SKI returns the subject key identifier of this key.
func getPrivateSKI(privateKey *ecdsa.PrivateKey) (ski []byte) {
	// Marshall the public key
	raw := elliptic.Marshal(privateKey.Curve, privateKey.PublicKey.X, privateKey.PublicKey.Y)
	// Hash it
	hash := sha256.New()
	hash.Write(raw)
	return hash.Sum(nil)
}

func getSubjectKey(key *ecdsa.PrivateKey) ([]byte, error) {
	publicKey, err := x509.MarshalPKIXPublicKey(&key.PublicKey)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal public key: %s", err)
	}

	var subPKI subjectPublicKeyInfo
	_, err = asn1.Unmarshal(publicKey, &subPKI)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal public key: %s", err)
	}

	return bigIntHash(subPKI.SubjectPublicKey.Bytes), nil
}

type subjectPublicKeyInfo struct {
	Algorithm        pkix.AlgorithmIdentifier
	SubjectPublicKey asn1.BitString
}

func bigIntHash(n []byte) []byte {
	h := sha1.New()
	h.Write(n)
	return h.Sum(nil)
}