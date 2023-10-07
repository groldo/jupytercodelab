# jupytercodelab

This project contains a container setup for jupyterlab with code-server intalled

```bash
docker-compose up -d
docker-compose logs  | grep lab?token
docker-compose down -v
```
## traefik

As I am using this project in virtual machine and want to access jupyter and the code-server via vm host browser,
traefik is needed to access the code-server instance,
and dont get an `accessed over an insecure context` error

You can have your own certificate, 
but might as well go with a default certificate created from traefik on the fly.
