openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./ca.key -out ./ca.crt -subj "/CN=mysql/O=kubedb"
kubectl create secret tls sdb-ca \
     --cert=ca.crt \
     --key=ca.key \
     --namespace=demo

kubectl apply -f issuer.yaml

-------------------------------------------------------------------------------------------------------------------------
                                         singlestore doc

openssl genrsa 2048 > ca-key.pem
openssl req -new -x509 -nodes -days 3600 -key ca-key.pem -out ca-cert.pem -subj "/C=US/ST=CA/L=San Francisco/O=MemSQL/CN=memsql"
openssl req -newkey rsa:2048 -nodes -keyout server-key.pem -out server-req.pem -subj "/C=US/ST=CA/L=San Francisco/O=MemSQL/CN=singlestore-sample.demo.svc"
openssl rsa -in server-key.pem -out server-key.pem
openssl x509 -req -in server-req.pem -days 3600 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem
openssl verify -CAfile ca-cert.pem server-cert.pem

kubectl create secret generic sdb-secret \
  --from-file=ca-cert.pem \
  --from-file=ca-key.pem \
  --from-file=server-cert.pem \
  --from-file=server-key.pem \
  --from-file=server-req.pem \
  -n demo


-----------------------------------------------------------------------------------------------------------------  

kubectl create secret generic sdb-secret \
  --from-file=ca-cert.pem \
  --from-file=server-cert.pem \
  --from-file=server-key.pem \
  -n demo



----------------------------------------------------------------------------------------------------------------  
                                              Mobarak Pgpool


openssl req -new -x509 -days 365 -nodes -out ca-cert.pem -keyout ca.key -subj "/CN=root-ca"
openssl genrsa -out server-key.pem 2048
openssl req -new -key server-key.pem -out server.csr -subj "/C=US/ST=California/L=San Francisco/O=kubedb/CN=singlestore-sample.demo.svc"
openssl x509 -req -in server.csr -CA ca-cert.pem -CAkey ca.key -CAcreateserial -out server-cert.pem -days 365 -sha256
openssl genrsa -out client-key.pem 2048
openssl req -new -key client-key.pem -out client.csr -subj "/C=US/ST=California/L=San Francisco/O=appscode/CN=alice"
openssl x509 -req -in client.csr -CA ca-cert.pem -CAkey ca.key -CAcreateserial -out client-cert.pem -days 365 -sha256



kubectl create secret generic sdb-secret \
  --from-file=ca-cert.pem \
  --from-file=server-cert.pem \
  --from-file=server-key.pem \
  --from-file=client-cert.pem \
  --from-file=client-key.pem \
  -n demo

------------------------------------------------------------------------------------------------------------------------------------
                                          MySQL
# Create CA certificate
openssl genrsa 2048 > ca-key.pem
openssl req -new -x509 -nodes -days 3600 \
        -key ca-key.pem -out ca-cert.pem -subj "/CN=root-ca"
openssl req -newkey rsa:2048 -days 3600 \
        -nodes -keyout server-key.pem -out server-req.pem -subj "/C=US/ST=California/L=San Francisco/O=kubedb/CN=singlestore-sample"
openssl rsa -in server-key.pem -out server-key.pem
openssl x509 -req -in server-req.pem -days 3600 \
        -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem
openssl req -newkey rsa:2048 -days 3600 \
        -nodes -keyout client-key.pem -out client-req.pem -subj "/C=US/ST=California/L=San Francisco/O=appscode/CN=root"
openssl rsa -in client-key.pem -out client-key.pem
openssl x509 -req -in client-req.pem -days 3600 \
        -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem   


kubectl create secret generic sdb-secret \
  --from-file=ca-cert.pem \
  --from-file=server-cert.pem \
  --from-file=server-key.pem \
  --from-file=client-cert.pem \
  --from-file=client-key.pem \
  -n demo

-------------------------------------------------------------------------------------------------------------------------------                         