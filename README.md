### Hyperledger Fabric POC

### Prerequisites and setup:

	* [Docker](https://www.docker.com/products/overview) - v1.12 or higher
	* [Docker Compose](https://docs.docker.com/compose/overview/) - v1.8 or higher
	* [Git client](https://git-scm.com/downloads) - needed for clone commands

### Instalation
	1. Clone sources from repositoty
		git clone https://github.com/SoftJourn/sj_coin_fabric_POC.git
	2. Go to fixtures folder
		cd /sj_coin_fabric_POC/SJCoins_fabric/fixtures/
	3. Execute Docker Compose command
		docker-compose up
		
### What it does?
	
	*Creates fixtures_default network
	
	* Adds fabric containerrs to network with Docker hosts
		- orderer.example.com
		- peer0.org1.example.com
		- peer0.org2.example.com
		- ca.org1.example.com
		- ca.org2.example.com
	
	* Adds Node.js SDK API Client container to network
		- Source folder: \sj_coin_fabric_POC\SJCoins_fabric\
		- Docker host: node.example.com:4000
		- VPS host: http://sjfabric.softjourn.if.ua:4000
	
	* Adds CAApp container to network
		- Source  repository: https://github.com/SoftJourn/CAApp.git
		- Docker host: caapp.example.com:3000
		- VPS Web App URL: http://sjfabric.softjourn.if.ua:3000
		- VPS Face API URLs:
			http://sjfabric.softjourn.if.ua:3000/api/login
			http://sjfabric.softjourn.if.ua:3000/api/register
	
	* Adds Fabric Angular 2 application container to network
		- Source repository: https://github.com/SoftJourn/sj_coin_fabric_POC.git
		- Source folder: \sj_coin_fabric_POC\SJCcoins_app\
		- Docker host: fabricapp.example.com:4200
		- VPS Web App URL: http://sjfabric.softjourn.if.ua:4200/

### Face Api Initialization
	
	1. Go to http://sjfabric.softjourn.if.ua:4200/
	2. Enroll User
	3. Create channel
	4. Connect peer to channel (peer0.org1.example.com:7051)
	5. Deploy chaincode 
		Chaincode Name: usr
		Chaincode Path: github.com/users
		Arguments: org1
	6. Initialize Chaincode
		