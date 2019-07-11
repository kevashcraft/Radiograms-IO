default: dev

build_bash:
	docker-compose -p radiogram_io_dev build radiogram_io_bash

bash: build_bash
	docker-compose -p radiogram_io_dev run radiogram_io_bash bash

build:
	docker-compose -p radiogram_io_dev build radiogram_io

build-no-cache:
	docker-compose -p radiogram_io_dev build --no-cache

dev: down build
	docker-compose -p radiogram_io_dev up radiogram_io

down:
	docker-compose -p radiogram_io_dev down -v

cordova_build:
	docker build -t radiogram_io_cordova -f Dockerfile.cordova .

cordova_bash:
	docker run \
            -it \
            -v $(shell pwd)/dist:/dist \
            -v $(shell pwd)/secret:/secret \
            -v $(shell pwd)/config.xml:/cordova/radiogram-io/config.xml \
            -e "keystore_pass=$(keystore_pass)" \
			radiogram_io_cordova bash

cordova: cordova_build
	docker run \
            -it \
            -v $(shell pwd)/dist:/dist \
            -v $(shell pwd)/secret:/secret \
            -v $(shell pwd)/config.xml:/cordova/radiogram-io/config.xml \
			radiogram_io_cordova bash -c "cordova build android \
			--release \
			-- \
			--keystore /secret/kevapps.pfx \
			--alias kevapps_one \
			--storePassword=$(keystore_pass) \
			--password=$(keystore_pass) && \
			cp /cordova/radiogram-io/platforms/android/app/build/outputs/apk/release/app-release.apk /dist/app-release.apk"

prod_build:
	docker build -f Dockerfile.prod -t kevashcraft/radiogram-io:latest .

prod_push: prod_build
	docker push kevashcraft/radiogram-io:latest

upgrade: prod_build prod_push
	helm upgrade radiogram-io ./helm --recreate-pods

install: prod_build prod_push
	helm install --name radiogram-io ./helm

nc: build-no-cache
ncb: build-no-cache bash
ncd: build-no-cache dev
