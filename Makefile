image:
	docker buildx build --platform linux/arm64,linux/amd64 \
		--tag curiumrocks/oci-spring-petclinic-multi-arch:latest .
push:
	docker buildx build --platform linux/arm64,linux/amd64 \
		--tag curiumrocks/oci-spring-petclinic-multi-arch:latest . \
		--push
