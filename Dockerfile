# Use a Debian-based image
FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    cmake \
    git

# Set up the working directory
WORKDIR /work

# Copy the source code into the container
COPY . /work

# Set the entrypoint to bash
ENTRYPOINT ["/bin/bash"]
