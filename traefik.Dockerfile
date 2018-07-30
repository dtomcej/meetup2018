FROM library/traefik:1.7.0-rc2-alpine

COPY certs/boulder/test-ca2.pem /intermediate.pem

RUN cat /intermediate.pem >> /etc/ssl/certs/ca-certificates.crt