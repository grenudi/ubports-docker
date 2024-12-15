# Use Ubuntu 22.04 LTS as the base image
FROM ubuntu:22.04

# Set the maintainer label using ARG (build-time variable)
ARG MAINTAINER_EMAIL
LABEL maintainer="idunerg@gmail.com"

# Set environment variables (for runtime) from ARG values
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
ARG REPO_URL

# Install essential packages for Ubuntu/Debian
RUN apt update && apt install -y --no-install-recommends \
    git gcc adb fastboot repo \
    python3 python-is-python3 android-tools-adb android-tools-fastboot \
    htop iotop ccache \
    curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create a user and add it to the necessary group (optional)
RUN useradd -m androiddev && \
    usermod -aG plugdev androiddev

# Configure git and repo using the ARG environment variables
RUN git config --global user.name "${GIT_USER_NAME}" \
    && git config --global user.email "${GIT_USER_EMAIL}" \
    && mkdir -p /home/androiddev/bin \
    && curl ${REPO_URL} > /home/androiddev/bin/repo \
    && chmod a+x /home/androiddev/bin/repo \
    && echo 'export PATH=/home/androiddev/bin:$PATH' >> /home/androiddev/.bashrc

# Verify installation by running the following commands
RUN repo --version && adb version && fastboot --version

# Switch to the new user
USER androiddev

# Set the default command
CMD ["/bin/bash"]
