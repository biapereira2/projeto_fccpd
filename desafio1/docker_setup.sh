NET_NAME=desafio1-net
docker network create $NET_NAME || true

docker build -t desafio1-server ./server
docker build -t desafio1-client ./client

docker run -d --name server --network $NET_NAME -p 8080:8080 desafio1-server
docker run -d --name client --network $NET_NAME desafio1-client


echo "Server logs:"
docker logs -f server &
