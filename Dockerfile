# First stage: Build the application
FROM ubuntu:latest AS build

# Install necessary packages
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    apt-get clean;

# Set the working directory to /app
WORKDIR /app

# Copy the project files into /app
COPY . /app

# Make the Gradle wrapper executable
RUN chmod +x /app/gradlew

# Build the application using Gradle
RUN /app/gradlew bootJar --no-daemon

# Second stage: Run the application
FROM openjdk:17-jdk-slim

# Expose the application port
EXPOSE 8080

# Copy the built .jar file from the previous stage
COPY --from=build /app/build/libs/demo-1.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
