FROM dtomcej/minica:meetup2018

COPY certs/minica/minica.pem /minica.pem
COPY certs/minica/minica-key.pem /minica-key.pem
COPY minica.Entrypoint.sh /entrypoint.sh