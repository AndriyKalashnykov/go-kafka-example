.DEFAULT_GOAL := help

CURRENTTAG:=$(shell git describe --tags --abbrev=0)
NEWTAG ?= $(shell bash -c 'read -p "Please provide a new tag (currnet tag - ${CURRENTTAG}): " newtag; echo $$newtag')
GOFLAGS=-mod=mod

#help: @ List available tasks
help:
	@clear
	@echo "Usage: make COMMAND"
	@echo "Commands :"
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(MAKEFILE_LIST)| tr -d '#' | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-17s\033[0m - %s\n", $$1, $$2}'

#test: @ Run tests
test:
	@export export GOFLAGS=$(GOFLAGS); go test ./...

#build: @ Build
build:
	@export GOPRIVATE=$(GOPRIVATE); export GOFLAGS=$(GOFLAGS); go build -o ./producer/producer ./producer/producer.go
	@export GOPRIVATE=$(GOPRIVATE); export GOFLAGS=$(GOFLAGS); go build -o ./consumer/consumer ./consumer/consumer.go

#get: @ Download and install dependency packages
get:
	@export GOPRIVATE=$(GOPRIVATE); export GOFLAGS=$(GOFLAGS); go get ./... ; go mod tidy

#release: @ Create and push a new tag
release:
	$(eval NT=$(NEWTAG))
	@echo -n "Are you sure to create and push ${NT} tag? [y/N] " && read ans && [ $${ans:-N} = y ]
	@echo ${NT} > ./version.txt
	@git add -A
	@git commit -a -s -m "Cut ${NT} release"
	@git tag ${NT}
	@git push origin ${NT}
	@git push
	@echo "Done."

#update: @ Update dependency packages to latest versions
update:
	@export GOPRIVATE=$(GOPRIVATE); export GOFLAGS=$(GOFLAGS); cd ./producer; go get -u; go mod tidy; cd ..
	@export GOPRIVATE=$(GOPRIVATE); export GOFLAGS=$(GOFLAGS); cd ./worker; go get -u; go mod tidy; cd ..

#version: @ Print current version(tag)
version:
	@echo $(shell git describe --tags --abbrev=0)

#runp: @ Run producer
runp:
	@export GOFLAGS=$(GOFLAGS); go run ./producer/producer.go

#runc: @ Run consumer
runc:
	@export GOFLAGS=$(GOFLAGS); go run ./worker/worker.go

#startk: @ Start Kafka
startk:
	@docker-compose -f docker-compose.yaml up -d

#stopk: @ Stop Kafka
stopk:
	@docker-compose -f docker-compose.yaml down
