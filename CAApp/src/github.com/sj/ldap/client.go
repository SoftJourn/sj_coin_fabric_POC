package ldap

import (
	"flag"
	"log"
	"github.com/jtblin/go-ldap-client"
)

var base, bindDN, bindPassword, groupFilter, host, serverName, userFilter string
var port int
var useSSL bool
var skipTLS bool

type User struct {
	Username string
	Email string
	FirstName string
	LastName string
}

func GetUser(username string, password string) (User, []string, error) {

	flag.Parse()

	client := &ldap.LDAPClient{
		Base:         base,
		Host:         host,
		Port:         port,
		UseSSL:       useSSL,
		SkipTLS:      skipTLS,
		BindDN:       bindDN,
		BindPassword: bindPassword,
		UserFilter:   userFilter,
		GroupFilter:  groupFilter,
		Attributes:   []string{"givenName", "sn", "mail", "uid"},
		ServerName:   serverName,
	}
	defer client.Close()

	var user User

	ok, userData, err := client.Authenticate(username, password)
	if err != nil {
		return user, nil, err
	}
	if !ok {
		return user, nil, err
	}
	log.Printf("User: %+v", userData)

	user = User{
		Username:  userData["uid"],
		Email:     userData["mail"],
		FirstName: userData["givenName"],
		LastName:  userData["sn"],
	}

	groups, err := client.GetGroupsOfUser(username)
	if err != nil {
		return user, nil, err
	}
	log.Printf("Groups: %+v", groups)

	return user, groups, nil
}

func init() {
	flag.StringVar(&base, "base", "dc=ldap,dc=sjua", "Base LDAP")
	flag.StringVar(&bindDN, "bind-dn", "uid=vpetryk,ou=People,ou=Users,dc=ldap,dc=sjua", "Bind DN")
	flag.StringVar(&bindPassword, "bind-pwd", "", "Bind password")
	flag.StringVar(&groupFilter, "group-filter", "(memberUid=%s)", "Group filter")
	flag.StringVar(&host, "host", "ldap.softjourn.if.ua", "LDAP host")
	flag.IntVar(&port, "port", 389, "LDAP port")
	flag.StringVar(&userFilter, "user-filter", "(uid=%s)", "User filter")
	flag.StringVar(&serverName, "server-name", "", "Server name for SSL (if use-ssl is set)")
	flag.BoolVar(&useSSL, "use-ssl", false, "Use SSL")
	flag.BoolVar(&skipTLS, "skip-tls", true, "Skip TLS start")
}