package main

import (
	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
	"fmt"
	"reflect"
	"encoding/json"
	"strconv"
	"strings"
	"encoding/pem"
	"crypto/x509"
	"github.com/hyperledger/fabric/protos/utils"
)

var logger *shim.ChaincodeLogger

type CoinChain struct {
}

var currencyName string

var minterKey string = "minter"
var balancesKey string = "balances"
var currencyKey string = "currency"

//var channelName string = "mychannel"

//var foundationAccountType string = "foundation_"
var userAccountType string = "user_"

//For TransferFrom
var txBalancesMap map[string]uint
var lastTxId string

func (t *CoinChain) Init(stub shim.ChaincodeStubInterface) pb.Response  {

	/* args
		0 - minter ID
		1 - Currency name
	*/

	_, args := stub.GetFunctionAndParameters()

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expected 2")
	}

	currencyName = args[1]

	logger = shim.NewLogger(currencyName)
	logger.Infof("_____ %v Init _____", currencyName)

	currentUserId, err := getCurrentUserId(stub)
	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutState(currencyKey, []byte(currencyName))
	if err != nil {
		return shim.Error(err.Error())
	}

	logger.Info("minter ID: ", args[0])

	minterBytes := []byte(args[0])

	err = stub.PutState(minterKey, minterBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	currentUserAccount, err := stub.CreateCompositeKey(userAccountType, []string{currentUserId})
	if err != nil {
		return shim.Error(err.Error())
	}
	logger.Info("currentUserAccount ", currentUserAccount)

	balancesMap := t.getMap(stub, balancesKey)

	if len(balancesMap) == 0 {
		balancesMap = map[string]uint{currentUserAccount:0}
		t.saveMap(stub, balancesKey, balancesMap)
	}

	return shim.Success([]byte(currencyName))
}

func (t *CoinChain) Invoke(stub shim.ChaincodeStubInterface) pb.Response {

	function, args := stub.GetFunctionAndParameters()
	fmt.Println("invoke is running " + function)

	currentUserId, err := getCurrentUserId(stub)
	if err != nil {
		return shim.Error(err.Error())
	}
	logger.Info("sender (current user)", currentUserId)

	if lastTxId != stub.GetTxID() {
		txBalancesMap = make(map[string]uint)
	}

	if function == "getColor" {
		return t.getCurrency(stub, args)
	} else if function == "setColor" {
		return t.setCurrency(stub, args)
	} else if function == "mint"{
		return t.mint(stub, args)
	} else if function == "transfer" {
		return t.transfer(stub, args)
	} else if function == "transferFrom" {
		return t.transferFrom(stub, args)
	} else if function == "balanceOf" {
		return t.balanceOf(stub, args)
	} else if function == "distribute" {
		return t.distribute(stub, args)
	}
	fmt.Println("invoke did not find func: " + function)
	return shim.Error("Received unknown function invocation")
}

func (t *CoinChain) transfer(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	/* args
		0 - accountType (user_ , foundation_)
		1 - receiver ID
		2 - amount
	*/

	if len(args) != 3 {
		return shim.Error("Incorrect number of arguments. Expecting 3")
	}

	receiverAccountType := args[0]
	logger.Info("accountType ", receiverAccountType)

	receiver := args[1]
	logger.Info("receiver ", receiver)

	logger.Info("args[2] ", args[2])
	amount := t.parseAmountUint(args[2])
	logger.Info("amount ", amount)


	if amount == 0 {
		return shim.Error("Incorrect amount")
	}

	currentUserId, err := getCurrentUserId(stub)
	if err != nil {
		return shim.Error(err.Error())
	}

	currentUserAccount, err := stub.CreateCompositeKey(userAccountType, []string{currentUserId})
	if err != nil {
		return shim.Error(err.Error())
	}
	logger.Info("currentUserAccount ", currentUserAccount)

	receiverAccount, err := stub.CreateCompositeKey(receiverAccountType, []string{receiver})
	if err != nil {
		return shim.Error(err.Error())
	}
	logger.Info("receiverAccount ", receiverAccount)

	balancesMap := t.getMap(stub, balancesKey)

	if balancesMap[currentUserAccount] < amount {
		return shim.Error("Not enough coins")
	}

	balancesMap[currentUserAccount] -= amount
	balancesMap[receiverAccount] += amount

	t.saveMap(stub, balancesKey, balancesMap)

	return shim.Success([]byte(strconv.FormatUint(uint64(balancesMap[receiverAccount]), 10)))
}

func (t *CoinChain) transferFrom(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	/* args
		0 - sender account type (user_ , foundation_)
		1 - sender ID
		2 - receiver account type (user_ , foundation_)
		3 - receiver ID
		4 - amount
	*/

	if getBaseChaincodeName(stub) != "foundation" {
		return shim.Error("Only \"foundation\" chaincode allowed to invoke transferFrom method")
	}

	if len(args) != 5 {
		return shim.Error("Incorrect number of arguments. Expecting 5")
	}

	senderAccountType := args[0]
	logger.Info("sender account type ", senderAccountType)
	sender := args[1]
	logger.Info("sender ", sender)

	receiverAccountType := args[2]
	logger.Info("receiver account type ", receiverAccountType)
	receiver := args[3]
	logger.Info("receiver ", receiver)

	logger.Info("amount args[4] ", args[4])
	amount := t.parseAmountUint(args[4])
	logger.Info("amount ", amount)


	if amount == 0 {
		return shim.Error("Incorrect amount")
	}

	senderAccount, err := stub.CreateCompositeKey(senderAccountType, []string{sender})
	if err != nil {
		return shim.Error(err.Error())
	}
	logger.Info("senderAccount ", senderAccount)

	receiverAccount, err := stub.CreateCompositeKey(receiverAccountType, []string{receiver})
	if err != nil {
		return shim.Error(err.Error())
	}
	logger.Info("receiverAccount ", receiverAccount)

	balancesMap := t.getTransactionBalancesMap(stub)

	if balancesMap[senderAccount] < amount {
		return shim.Error("Not enough coins")
	}

	balancesMap[senderAccount] -= amount
	balancesMap[receiverAccount] += amount

	t.saveMap(stub, balancesKey, balancesMap)

	return shim.Success([]byte(strconv.FormatUint(uint64(balancesMap[receiverAccount]), 10)))
}

func (t *CoinChain) setCurrency(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	//Obsolete (setColor) not sure we need this. Chaincode name is currency name

	/* args
		0 - currency name
	*/

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	minterValue, err := stub.GetState(minterKey)
	if err != nil {
		return shim.Error(err.Error())
	}

	currentUserId, err := getCurrentUserId(stub)
	if err != nil {
		return shim.Error(err.Error())
	}

	if reflect.DeepEqual([]byte(currentUserId), minterValue) {
		return shim.Error("User has no permissions")
	}

	currency := args[0]

	err = stub.PutState(currencyKey, []byte(currency))
	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success([]byte(currency))
}

func (t *CoinChain) getCurrency(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	currency, err := stub.GetState(currencyKey)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + currencyKey + "\"}"
		return shim.Error(jsonResp)
	}
	return shim.Success(currency)
}

func (t *CoinChain) getMap(stub shim.ChaincodeStubInterface, mapName string) map[string]uint {

	logger.Info("------ getMap called")
	mapBytes, err := stub.GetState(mapName)
	if err != nil {
		return nil
	}

	var mapObject map[string]uint
	err = json.Unmarshal(mapBytes, &mapObject)
	if err != nil {
		return nil
	}
	logger.Info("received map", mapObject)
	return mapObject
}

func (t *CoinChain) saveMap(stub shim.ChaincodeStubInterface, mapName string, mapObject map[string]uint) pb.Response {
	logger.Info("------ saveBalancesMap called")
	balancesMapBytes, err := json.Marshal(mapObject)
	if err != nil {
		return shim.Error(err.Error())
	}
	err = stub.PutState(mapName, balancesMapBytes)
	if err != nil {
		return shim.Error(err.Error())
	}
	logger.Info("saved ", mapObject)
	return shim.Success(nil)
}

func (t *CoinChain) mint(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	/* args
		0 - amount
	*/

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	minterBytes, err := stub.GetState(minterKey)
	if err != nil {
		return shim.Error(err.Error())
	}

	minterString := string(minterBytes)
	logger.Info("minter ", minterString)

	currentUserId, err := getCurrentUserId(stub)
	if err != nil {
		return shim.Error(err.Error())
	}

	if currentUserId != minterString {
		return shim.Error("No permissions")
	}

	amount := t.parseAmountUint(args[0])
	if amount == 0 {
		return shim.Error("Incorrect amount")
	}

	currentUserAccount, err := stub.CreateCompositeKey(userAccountType, []string{currentUserId})
	if err != nil {
		return shim.Error(err.Error())
	}
	logger.Info("currentUserAccount ", currentUserAccount)


	balancesMap := t.getMap(stub, balancesKey)

	balancesMap[currentUserAccount] += amount
	t.saveMap(stub, balancesKey, balancesMap)

	return shim.Success([]byte(strconv.FormatUint(uint64(balancesMap[currentUserAccount]), 10)))
}

func (t *CoinChain) distribute(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	/* args
		0.. n-1 - accounts
		n - amount
	*/

	if len(args) < 3 {
		return shim.Error("Incorrect number of arguments. Expecting at least 3")
	}

	amount := t.parseAmountUint(args[len(args)-1])
	if amount == 0 {
		return shim.Error("Incorrect amount")
	}
	accounts := args[:len(args)-1]
	logger.Info("accounts: ", accounts)
	logger.Info("amount ", amount)

	currentUserId, err := getCurrentUserId(stub)
	if err != nil {
		return shim.Error(err.Error())
	}

	currentUserAccount, err := stub.CreateCompositeKey(userAccountType, []string{currentUserId})
	if err != nil {
		return shim.Error(err.Error())
	}
	logger.Info("currentUserAccount ", currentUserAccount)

	balancesMap := t.getMap(stub, balancesKey)

	if balancesMap[currentUserAccount] < amount {
		return shim.Error("Not enough coins")
	}

	mean := uint(amount/uint(len(accounts)))
	logger.Info("mean ", mean)

	var i uint = 0
	logger.Info("uint(len(accounts)) ", uint(len(accounts)))
	for i < uint(len(accounts)) {
		logger.Info("i ", i)

		receiverAccount, err := stub.CreateCompositeKey(userAccountType, []string{accounts[i]})
		if err != nil {
			return shim.Error(err.Error())
		}
		logger.Info("receiverAccount ", receiverAccount)

		balancesMap[currentUserAccount] -= mean
		logger.Info("balancesMap[currentUserAccount} ", balancesMap[currentUserAccount])
		logger.Info("receiverAccount ", receiverAccount)
		balancesMap[receiverAccount] += mean
		logger.Info("balancesMap[receiverAccount] ", balancesMap[receiverAccount])
		i += 1
	}
	t.saveMap(stub, balancesKey,balancesMap)
	return shim.Success(nil)
}

func (t *CoinChain) balanceOf(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	/* args
		0 - user ID
	*/

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	account, err := stub.CreateCompositeKey(userAccountType, []string{args[0]})
	if err != nil {
		return shim.Error(err.Error())
	}
	logger.Info("account ", account)

	balancesMap := t.getMap(stub, balancesKey)
	return shim.Success([]byte(fmt.Sprintf("%d", balancesMap[account])))
}

func getCurrentUserId(stub shim.ChaincodeStubInterface) (string, error) {

	var userId string

	creatorBytes, err := stub.GetCreator()
	if err != nil {
		return userId, err
	}

	creatorString :=fmt.Sprintf("%s",creatorBytes)
	index := strings.Index(creatorString, "-----BEGIN CERTIFICATE-----")
	certificate := creatorString[index:]
	block, _ := pem.Decode([]byte(certificate))

	cert, err := x509.ParseCertificate(block.Bytes)
	if err != nil {
		return userId, err
	}

	userId = cert.Subject.CommonName
	logger.Infof("---- UserID: %v ", userId)
	return userId, err
}

func getBaseChaincodeName(stub shim.ChaincodeStubInterface) string {

	sp, err := stub.GetSignedProposal()
	logger.Infof("sp %s", sp)

	proposal, err := utils.GetProposal(sp.ProposalBytes)
	if err != nil {
		logger.Error("err ", err)
	}

	header, err := utils.GetHeader(proposal.GetHeader())
	if err != nil {
		logger.Error("err ", err)
	}
	//logger.Info("header ", header)

	ext, err := utils.GetChaincodeHeaderExtension(header)
	if err != nil {
		logger.Error("err ", err)
	}
	logger.Info("ext.ChaincodeId.Name ", ext.ChaincodeId.Name)
	return ext.ChaincodeId.Name
}

func (t *CoinChain) getTransactionBalancesMap (stub shim.ChaincodeStubInterface) (map[string]uint) {

	txId := stub.GetTxID()

	logger.Info("lastTxId ", lastTxId)
	logger.Info("txId ", txId)

	if txId == lastTxId {
		return txBalancesMap
	} else {
		txBalancesMap = t.getMap(stub, balancesKey)
		lastTxId = txId
	}
	return txBalancesMap
}


func (t *CoinChain) parseAmountUint(amount string) uint {
	amount32, err := strconv.ParseUint(amount, 10, 32)
	if err != nil {
		return 0
	}
	return uint(amount32)
}

func main() {
	err := shim.Start(new(CoinChain))
	if err != nil {
		logger.Errorf("Error starting Coin Chain: %s", err)
	}
}