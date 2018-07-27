# meetup2018
E2E Encryption using Traefik, and Boulder

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
