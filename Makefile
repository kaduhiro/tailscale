.ONESHELL:

SERVICE := tailscale

#
# tailscale
#
node: up # connect to tailscale, logging in if needed
	docker exec $(SERVICE) tailscale up

subnet-router: up # # connect to tailscale as subnet router
	docker exec $(SERVICE) tailscale up \
		--advertise-exit-node \
		--advertise-routes=10.0.0.0/8,172.16.0.0/12,192.168.0.0/16

exit: # disconnect from tailscale
	docker exec $(SERVICE) tailscale down
	$(MAKE) down

.PHONY: node subnet-router exit

st: status
status: # show state of tailscaled and its connections
	docker exec $(SERVICE) tailscale status

nc: netcheck
netcheck: # connect to a port on a host, connected to stdin/stdout
	docker exec $(SERVICE) tailscale netcheck

.PHONY: st status nc netcheck

#
# docker
#
up: # create and start containers, networks, and volumes
	docker-compose up -d
up/%: # create and start a container
	docker-compose up -d $*

down: # stop and remove containers, networks, images, and volumes
	docker-compose down
down/%: # stop and remove a container
	docker-compose rm -fsv $*

logs: # view output from containers
	docker-compose logs -f

log: log/$(SERVICE)
log/%: # view output from a container
	docker-compose logs -f $*

.PHONY: up up/% exec exec/% down down/% logs log log/%

help: # list available targets and some
	@len=$$(awk -F':' 'BEGIN {m = 0;} /^[^\s]+:/ {gsub(/%/, "<service>", $$1); l = length($$1); if(l > m) m = l;} END {print m;}' $(MAKEFILE_LIST)) && \
	printf \
		"%s%s\n\n%s\n%s\n\n%s\n%s\n" \
		"usage:" \
		"$$(printf " make <\033[1mtarget\033[0m>")" \
		"services:" \
		"$$(docker-compose config --services | awk '{ $$1 == "$(SERVICE)" ? x = "* " : x = ""; } { printf("  \033[1m%s%s\033[0m\n", x, $$1); }')" \
		"targets:" \
		"$$(awk -F':' '/^\S+:/ {gsub(/%/, "<service>", $$1); gsub(/^[^#]+/, "", $$2); gsub(/^[# ]+/, "", $$2); if ($$2) printf "  \033[1m%-'$$len's\033[0m  %s\n", $$1, $$2;}' $(MAKEFILE_LIST))"

clean: # remove cache files from the working directory

.PHONY: help clean

