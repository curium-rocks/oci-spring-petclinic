image:
	docker buildx build --platform linux/arm64,linux/amd64 \
		--tag ghcr.io/curium-rocks/spring-petclinic:local .
push:
	docker buildx build --platform linux/arm64,linux/amd64 \
		--tag ghcr.io/curium-rocks/spring-petclinic:local . \
		--push
