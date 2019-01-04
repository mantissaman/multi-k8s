docker build -t mantissaman/multi-client:latest -t mantissaman/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t mantissaman/multi-server:latest -t mantissaman/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t mantissaman/multi-worker:latest -t mantissaman/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push mantissaman/multi-client:latest
docker push mantissaman/multi-server:latest
docker push mantissaman/multi-worker:latest

docker push mantissaman/multi-client:$SHA
docker push mantissaman/multi-server:$SHA
docker push mantissaman/multi-worker:$SHA

kubectl delete -f server-deployment.yaml
kubectl apply -f database-persistent-volume-claim.yaml
kubectl apply -f worker-deployment.yaml
kubectl apply -f ingress-service.yaml 
kubectl apply -f postgres-deployment.yaml
kubectl apply -f postgres-cluster-ip-service.yaml 
kubectl apply -f redis-deployment.yaml
kubectl apply -f redis-cluster-ip-service.yaml  
kubectl apply -f client-cluster-ip-service.yaml         
kubectl apply -f client-deployment.yaml 
kubectl apply -f server-cluster-ip-service.yaml          
kubectl apply -f server-deployment.yaml

kubectl set image deployments/server-deployment server=mantissaman/multi-server:$SHA
kubectl set image deployments/client-deployment client=mantissaman/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=mantissaman/multi-worker:$SHA