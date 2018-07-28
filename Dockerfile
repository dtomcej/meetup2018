FROM dtomcej/boulder:meetup2018

RUN rm -rf /test/test-ca.pem

COPY certs/boulder /go/src/github.com/letsencrypt/boulder/test
