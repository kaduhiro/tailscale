# Tailscale

# Usage

```
usage: make <target>

services:
  * tailscale

targets:
  node              connect to tailscale, logging in if needed
  subnet-router     connect to tailscale as subnet router
  exit              disconnect from tailscale
  status            show state of tailscaled and its connections
  netcheck          connect to a port on a host, connected to stdin/stdout
  up                create and start containers, networks, and volumes
  up/<service>      create and start a container
  down              stop and remove containers, networks, images, and volumes
  down/<service>    stop and remove a container
  logs              view output from containers
  log/<service>     view output from a container
  help              list available targets and some
  clean             remove cache files from the working directory
```

## Author

[Twitter](https://twitter.com/kaduhiro_)

## License

[MIT](https://en.wikipedia.org/wiki/MIT_License)

