IMAGE_REGISTRY := quay.io
ORGANIZATION := prometheus
PROJECT := node-exporter

CONTAINER_SUBSYS := podman

CONFIG_OPTS := "--path.rootfs=/host"

.PHONY: all
all: start

.PHONY: start
start: 
	systemctl start $(PROJECT).service

.PHONY: stop
stop: 
	systemctl stop $(PROJECT).service

.PHONY: status
status:
	systemctl status $(PROJECT).service

.PHONY: run
run:
	$(CONTAINER_SUBSYS) run --name $(PROJECT) --net="host" --pid="host" --mount=type=bind,src=/,dst=/host,ro=true,bind-propagation=rslave -t quay.io/prometheus/node-exporter:latest "$(CONFIG_OPTS)"

.PHONY: install
install:
	cp $(PROJECT).service /etc/systemd/system
	systemctl daemon-reload
	systemctl enable $(PROJECT).service
	firewall-cmd --add-service=$(PROJECT) --permanent
	firewall-cmd --add-service=$(PROJECT)

