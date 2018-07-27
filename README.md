# meetup2018
E2E Encryption using Traefik, and Boulder

Generate root certs:
```bash
cd certs

mkdir certs csr newcerts private
touch index.txt
echo 1000 > serial

openssl genrsa -aes256 -out private/ca.key.pem 4096

openssl req -config openssl.cnf \
      -key private/ca.key.pem \
      -new -x509 -days 7300 -sha256 -extensions v3_ca \
      -out certs/ca.cert.pem
```
*Make sure you add a "ROOT" Common Name in the options*

``bash
mkdir intermediate
cd intermediate
mkdir certs csr private
touch index.txt
echo 1000 > serial
echo 1000 > crlnumber
cd ..

openssl genrsa -aes256 \
      -out intermediate/private/intermediate.key.pem 4096

openssl req -config intermediate/openssl.cnf -new -sha256 \
      -key intermediate/private/intermediate.key.pem \
      -out intermediate/csr/intermediate.csr.pem

*Make sure you add an "INTERMEDIATE CA" Common Name in the options*

```bash
openssl ca -config openssl.cnf -extensions v3_intermediate_ca \
      -days 3650 -notext -md sha256 \
      -in intermediate/csr/intermediate.csr.pem \
      -out intermediate/certs/intermediate.cert.pem

```

Verify using:

```bash
openssl verify -CAfile certs/ca.cert.pem \
      intermediate/certs/intermediate.cert.pem
```


https://jamielinux.com/docs/openssl-certificate-authority/index.html


Boulder image: `dtomcej/boulder:meetup2018`

https://github.com/dtomcej/boulder

This boulder image has the latest files baked in, and has a custom servers configuration to allow it to run in kubernetes.

Although, this image is ~1.35G, whereas the base image is 550M. You probably want to just clone my repo and `docker build .` yourself ;)

Boulder folder has 3 parts:
* Mysql/Maria
* HSM - Keystore
* Boulder itself

 - We use an init container to wait for requirements to be read before starting pod. This coupled with good readiness probes allows evaluation order independance.

(Ensure traefik.rocks and traefik2.rocks resolves to localhost either by your `/etc/hosts` file, or DNS A records in your resolver)
* `kubectl create -f traefik`
* `kubectl create -f boulder`
