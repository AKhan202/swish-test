# Use Debian Bullseye as the base image
FROM debian:bullseye

# Install Python 2, Python 3, R, and Java
RUN apt-get update && \
    apt-get install -y \
        python2.7 python3-pip \
        python3 python3-pip \
        r-base \
        openjdk-11-jdk \
        maven \
        && \
    apt-get clean

# Set up a working directory '/app'
WORKDIR /app

# Copy requirements.txt file into the container and install Python dependencies
COPY requirements.txt /app/
RUN pip3 install -r requirements.txt

# Copy the JAR file from the build context to the container
COPY target/kubernetes.jar /kubernetes.jar

# Expose the port that your application will run on
EXPOSE 8080

# Set the entry point to run the JAR file
ENTRYPOINT ["java", "-jar", "/kubernetes.jar"]
