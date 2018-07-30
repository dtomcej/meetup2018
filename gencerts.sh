#!/bin/sh

echo "Creating Directories..."
rm -rf certs
mkdir certs certs/boulder certs/certs certs/newcerts certs/private certs/browser certs/minica certs/intermediate certs/intermediate/certs certs/intermediate/csr certs/intermediate/private 2>/dev/null 

echo "Preparing Certs Directory..."
rm -rf certs/index.txt certs/intermediate/index.txt
touch certs/index.txt certs/intermediate/index.txt
echo 1000 > certs/serial
echo 1000 > certs/intermediate/crlnumber
echo 1000 > certs/intermediate/serial

echo "Creating CA Key..."
openssl genrsa -aes256 -passout pass:meetup2018 -out certs/private/ca.key.pem 4096 2>/dev/null 

echo "Creating CA Certificate..."
openssl req -config openssl.ca.cnf -key certs/private/ca.key.pem -passin pass:meetup2018 -new -x509 -days 7300 -sha256 -extensions v3_ca -out certs/certs/ca.cert.pem 2>/dev/null 

echo "Creating Intermediate Key..."
openssl genrsa -aes256 -passout pass:meetup2018 -out certs/intermediate/private/intermediate.key.pem 4096 2>/dev/null 

echo "Creating Intermediate Certificate Requests..."
openssl req -config openssl.intermediate.cnf -new -sha256 -key certs/intermediate/private/intermediate.key.pem -passin pass:meetup2018 -out certs/intermediate/csr/intermediate.csr.pem 2>/dev/null 
openssl req -config openssl.intermediate2.cnf -new -sha256 -key certs/intermediate/private/intermediate.key.pem -passin pass:meetup2018 -out certs/intermediate/csr/intermediate2.csr.pem 2>/dev/null 

echo "Signing Intermediate Certificate..."
openssl ca -batch -config openssl.ca.cnf -extensions v3_intermediate_ca -days 3650 -notext -md sha256 -in certs/intermediate/csr/intermediate.csr.pem -passin pass:meetup2018 -out certs/intermediate/certs/intermediate.cert.pem 2>/dev/null 
openssl ca -batch -config openssl.ca.cnf -extensions v3_intermediate_ca -days 3650 -notext -md sha256 -in certs/intermediate/csr/intermediate2.csr.pem -passin pass:meetup2018 -out certs/intermediate/certs/intermediate2.cert.pem 2>/dev/null 

echo "Verifying Intermediate Certificate..."
openssl verify -CAfile certs/certs/ca.cert.pem certs/intermediate/certs/intermediate.cert.pem
openssl verify -CAfile certs/certs/ca.cert.pem certs/intermediate/certs/intermediate2.cert.pem

echo "Creating Boulder Certificate Files..."
openssl rsa -in certs/private/ca.key.pem -passin pass:meetup2018 -outform DER -out certs/private/ca.key.der 2>/dev/null
openssl rsa -in certs/intermediate/private/intermediate.key.pem -passin pass:meetup2018 -outform der -out certs/intermediate/private/intermediate.key.der 2>/dev/null
openssl x509 -outform der -in certs/intermediate/certs/intermediate.cert.pem -out certs/intermediate/certs/intermediate.cert.der 2>/dev/null
openssl x509 -outform der -in certs/intermediate/certs/intermediate2.cert.pem -out certs/intermediate/certs/intermediate2.cert.der 2>/dev/null

echo "Creating MiniCA Certificate Files..."
openssl rsa -in certs/intermediate/private/intermediate.key.pem -passin pass:meetup2018 -out certs/minica/minica-key.pem 2>/dev/null
cp certs/intermediate/certs/intermediate2.cert.pem certs/minica/minica.pem
echo "Moving Boulder Certificates to Boulder Directory..."
cp certs/certs/ca.cert.pem certs/boulder/test-root.pem
cp certs/private/ca.key.pem certs/boulder/test-root.key
cp certs/private/ca.key.der certs/boulder/test-root.key.der

cp certs/intermediate/certs/intermediate.cert.pem certs/boulder/test-ca.pem
cp certs/intermediate/certs/intermediate2.cert.pem certs/boulder/test-ca2.pem
cp certs/intermediate/certs/intermediate.cert.der certs/boulder/test-ca.der
cp certs/intermediate/private/intermediate.key.pem certs/boulder/test-ca.key
cp certs/intermediate/private/intermediate.key.pem certs/boulder/test-ca2.key
cp certs/intermediate/private/intermediate.key.der certs/boulder/test-ca.key.der

echo "Moving Intermediate Cert For Browser Trust"
cp certs/intermediate/certs/intermediate2.cert.pem certs/browser/intermediate.crt

echo "Building Boulder Docker Image with Certs..."
docker build -f boulder.Dockerfile -t dtomcej/boulder:meetup2018-certsadded . 

echo "Building MiniCA Docker Image with Certs..."
docker build -f minica.Dockerfile -t dtomcej/minica:meetup2018-certsadded .

echo "Building Traefik Docker Image with Certs..."
docker build -f traefik.Dockerfile -t dtomcej/traefik:meetup2018-certsadded .
