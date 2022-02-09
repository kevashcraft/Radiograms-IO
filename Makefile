default: dev

.PHONY: build

bash: build
	docker run \
		-v $(shell pwd)/app:/app \
		radiograms_io_dev \
		bash

build:
	docker build -t radiograms_io -f build/development.dockerfile .

dev: down build
	docker run \
		-v $(shell pwd)/app/src:/app/src \
		-v $(shell pwd)/app/public:/app/public \
		-p 54001:8080 \
		radiograms_io_dev

down:
	docker stop radiograms_io_dev

prod_build:
	docker build \
		-f build/production.dockerfile \
		-t kevashcraft/radiograms-io:latest \
		.

prod_push: prod_build
	docker push kevashcraft/radiograms-io:latest

upgrade: prod_build prod_push
	helm upgrade radiograms-io build/chart

install: prod_build prod_push
	helm install radiograms-io build/chart

