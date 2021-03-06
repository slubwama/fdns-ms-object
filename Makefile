docker-build:
	docker-compose up -d
	docker build \
		-t fdns-ms-object \
		--network=fdns-ms-object_default \
		--rm \
		--build-arg OBJECT_PORT=8083 \
		--build-arg OBJECT_MONGO_HOST=mongo \
		--build-arg OBJECT_MONGO_PORT=27017 \
		--build-arg OBJECT_FLUENTD_HOST=fluentd \
		--build-arg OBJECT_FLUENTD_PORT=24224 \
		--build-arg OBJECT_PROXY_HOSTNAME= \
		--build-arg OBJECT_IMMUTABLE= \
		--build-arg OAUTH2_ACCESS_TOKEN_URI= \
		--build-arg OAUTH2_PROTECTED_URIS= \
		--build-arg OAUTH2_CLIENT_ID= \
		--build-arg OAUTH2_CLIENT_SECRET= \
		--build-arg SSL_VERIFYING_DISABLE=false \
		.
	docker-compose down

docker-run: docker-start
docker-start:
	docker-compose up -d
	docker run -d \
		-p 8083:8083 \
		--network=fdns-ms-object_default  \
		--name=fdns-ms-object_main \
		fdns-ms-object

docker-stop:
	docker stop fdns-ms-object_main || true
	docker rm fdns-ms-object_main || true
	docker-compose down

docker-restart:
	make docker-stop 2>/dev/null || true
	make docker-start

sonarqube:
	docker-compose up -d
	docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube || true
	mvn clean test sonar:sonar
	docker-compose down
