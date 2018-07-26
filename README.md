# meetup2018
E2E Encryption using Traefik, and Boulder

Boulder image: `dtomcej/boulder:meetup2018`

https://github.com/dtomcej/boulder

This boulder image has the latest files baked in, and has a custom servers configuration to allow it to run in kubernetes.

(Ensure traefik.rocks resolves to localhost either by your `/etc/hosts` file, or DNS A records in your resolver)
* `kubectl create -f traefik`
* `kubectl create -f boulder`
