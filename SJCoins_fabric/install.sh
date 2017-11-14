docker build -t="node" .

docker run --name=node.example.com --hostname=node.example.com --network=fixtures_default --mount type=bind,source=/tmp/fabric-client-kvs_peerOrg1,target=/tmp/fabric-client-kvs_peerOrg1 -i -t -p 4000:4000 node
