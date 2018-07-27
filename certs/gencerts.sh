#!/bin/sh

mkdir certs csr newcerts private intermediate/certs intermediate/csr intermediate/private

openssl genrsa -aes256 -passout pass:meetup2018 -out private/ca.key.pem 4096

openssl req -config openssl.cnf -key private/ca.key.pem -passin pass:meetup2018 -new -x509 -days 7300 -sha256 -extensions v3_ca -out certs/ca.cert.pem

openssl genrsa -aes256 -passout pass:meetup2018 -out intermediate/private/intermediate.key.pem 4096

openssl req -config intermediate/openssl.cnf -new -sha256 -key intermediate/private/intermediate.key.pem -passin pass:meetup2018 -out intermediate/csr/intermediate.csr.pem

openssl ca -config openssl.cnf -extensions v3_intermediate_ca -days 3650 -notext -md sha256 -in intermediate/csr/intermediate.csr.pem -passin pass:meetup2018 -out intermediate/certs/intermediate.cert.pem