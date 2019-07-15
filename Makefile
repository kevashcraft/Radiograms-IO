default: dev

build_bash:
	docker-compose -p radiograms_io_dev build radiograms_io_bash

bash: build_bash
	docker-compose -p radiograms_io_dev run radiograms_io_bash bash

build:
	docker-compose -p radiograms_io_dev build radiograms_io

build-no-cache:
	docker-compose -p radiograms_io_dev build --no-cache

dev: down build
	docker-compose -p radiograms_io_dev up radiograms_io

down:
	docker-compose -p radiograms_io_dev down -v

cordova_build:
	docker build -t radiograms_io_cordova -f Dockerfile.cordova .

cordova_bash:
	docker run \
            -it \
            -v $(shell pwd)/dist:/dist \
            -v $(shell pwd)/secret:/secret \
            -v $(shell pwd)/config.xml:/cordova/radiograms-io/config.xml \
            -e "keystore_pass=$(keystore_pass)" \
			radiograms_io_cordova bash

cordova: cordova_build
	docker run \
            -it \
            -v $(shell pwd)/dist:/dist \
            -v $(shell pwd)/secret:/secret \
            -v $(shell pwd)/config.xml:/cordova/radiograms-io/config.xml \
			radiograms_io_cordova bash -c "cordova build android \
			--release \
			-- \
			--keystore /secret/kevapps.pfx \
			--alias kevapps_one \
			--storePassword=$(keystore_pass) \
			--password=$(keystore_pass) && \
			cp /cordova/radiograms-io/platforms/android/app/build/outputs/apk/release/app-release.apk /dist/app-release.apk"

prod_build:
	docker build -f Dockerfile.prod -t kevashcraft/radiograms-io:latest .

prod_push: prod_build
	docker push kevashcraft/radiograms-io:latest

upgrade: prod_build prod_push
	helm upgrade radiograms-io ./helm --recreate-pods

install: prod_build prod_push
	helm install --name radiograms-io ./helm

nc: build-no-cache
ncb: build-no-cache bash
ncd: build-no-cache dev
