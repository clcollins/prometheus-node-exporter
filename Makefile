IMAGE_REGISTRY := quay.io
ORGANIZATION := prometheus
PROJECT := node-exporter

CONTAINER_SUBSYS := podman

CONFIG_OPTS := "--path.rootfs=/host"

.PHONY: all
all: start

.PHONY: run start
run start: 
	systemctl --user start $(PROJECT).service

.PHONY: stop
stop: 
	systemctl --user stop $(PROJECT).service

.PHONY: status
status:
	systemctl --user status $(PROJECT).service

.PHONY: run_local
run_local:
	$(CONTAINER_SUBSYS) run --name $(PROJECT) --net="host" --pid="host" --mount=type=bind,src=/,dst=/host,ro=true,bind-propagation=rslave -t quay.io/prometheus/node-exporter:latest "$(CONFIG_OPTS)"
