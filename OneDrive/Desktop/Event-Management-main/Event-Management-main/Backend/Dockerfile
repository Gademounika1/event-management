FROM maven:3.10.3-eclipse-temurin-21 AS build
WORKDIR /app

# copy only what's necessary to build
COPY pom.xml mvnw mvnw.cmd ./
COPY .mvn .mvn
COPY src ./src

RUN mvn -B -DskipTests package --no-transfer-progress

FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
ARG JAR_FILE=target/*.jar
COPY --from=build /app/${JAR_FILE} app.jar
EXPOSE 2025
ENTRYPOINT ["java","-jar","/app/app.jar"]
