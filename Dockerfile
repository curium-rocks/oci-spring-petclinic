

# Use the JDK base and grab the repo and build the jar
FROM ghcr.io/curium-rocks/alpine-zulu-jdk as build_base
WORKDIR /build
RUN apk add --no-cache git && \
  git clone https://github.com/spring-projects/spring-petclinic.git 
WORKDIR /build/spring-petclinic
RUN ./gradlew bootJar 

FROM ghcr.io/curium-rocks/alpine-zulu-jre as runtime_base
COPY --from=build_base --chown=docker:docker /build/spring-petclinic/build/libs/*.jar /app/petclinic.jar
CMD [ "java", "-jar", "/app/petclinic.jar" ]
EXPOSE 8080