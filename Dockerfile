#  Dockerfile
# Base image that includes Python 2, Python 3, and R using debian image
FROM debian:bullseye
# Install Python 2, Python 3, R, packages
RUN apt-get update && \
    apt-get install -y \
        python2.7 python3-pip \
        python3 python3-pip \
        r-base \
        # Add additional packages as needed
        && \
    apt-get clean
# Set up a working directory '/app' 
WORKDIR /app
# Copy your application code and requirements.txt file into the container
COPY requirements.txt /app/
# Installing Python dependencies
RUN pip3 install -r requirements.txt
# Set the default command to run when the container starts
CMD ["bash"]