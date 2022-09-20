# Create base with zulu apk repo added
FROM alpine:latest as zulu_base
RUN apk add --no-cache wget && \
  wget -P /etc/apk/keys/ https://cdn.azul.com/public_keys/alpine-signing@azul.com-5d5dc44c.rsa.pub && \
  echo "https://repos.azul.com/zulu/alpine" | tee -a /etc/apk/repositories && \
  apk update --no-cache && \
  apk del --no-cache wget

# Create base that can be used to build the jar
FROM zulu_base AS jdk_base
RUN apk add --no-cache zulu17-jdk

# Create a base that can be used to run the jar
FROM zulu_base AS jre_base
RUN apk add --no-cache zulu17-jre-headless

# Use the JDK base and grab the repo and build the jar
FROM jdk_base as build_base
WORKDIR /build
RUN apk add --no-cache git && \
  git clone https://github.com/spring-projects/spring-petclinic.git 
WORKDIR /build/spring-petclinic
RUN ./gradlew bootJar 

FROM jre_base as runtime_base
ENV USER=docker
ENV UID=1000
ENV GID=1000

WORKDIR /app
RUN addgroup -g ${GID} docker && \
    adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$UID" \
    "$USER"
COPY --from=build_base --chown=docker:docker /build/spring-petclinic/build/libs/*.jar /app/petclinic.jar
CMD [ "java", "-jar", "/app/petclinic.jar" ]
EXPOSE 8080