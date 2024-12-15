# Use Ubuntu 22.04 LTS as the base image
FROM ubuntu:22.04

LABEL maintainer="idunerg@gmail.com"

# Set build arguments (provided by docker-compose or CLI)
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
ARG REPO_URL

# Install essential packages for Android and development
RUN apt update && apt install -y --no-install-recommends \
    less ssh bc bison build-essential ccache curl flex g++-multilib \
    gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev \
    lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev \
    libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync \
    schedtool squashfs-tools xsltproc zip zlib1g-dev \
    android-tools-adb android-tools-fastboot \
    python3 python-is-python3 ca-certificates \
    # Full system build required packages
    imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev \
    libncurses5 libsdl1.2-dev libssl-dev libxml2 lzop pngcrush \
    rsync squashfs-tools android-tools-adb android-tools-fastboot \
    python3 python-is-python3 ca-certificates \
    # Standalone build method required packages
    bc bison build-essential ca-certificates cpio curl flex git kmod \
    libssl-dev libtinfo5 python2 sudo unzip wget xz-utils img2simg jq \
    && rm -rf /var/lib/apt/lists/*




# Create a user and configure permissions
RUN useradd -m ubpuser && \
    usermod -aG plugdev ubpuser

# Configure git and repo with ARG values
RUN git config --global user.name "${GIT_USER_NAME}" \
    && git config --global user.email "${GIT_USER_EMAIL}" \
    # https://stackoverflow.com/questions/78396934/error-1824-bytes-of-body-are-still-expected-while-cloning-repository-from-git
    && git config --global http.postBuffer 524288000 \
    && git config --global http.version HTTP/1.1 \
    && mkdir -p /home/ubpuser/bin \
    && curl ${REPO_URL} > /home/ubpuser/bin/repo \
    && chmod a+x /home/ubpuser/bin/repo \
    && echo 'export PATH=/home/ubpuser/bin:$PATH' >> /home/ubpuser/.bashrc

# Configure SSH client for Git
RUN mkdir -p /home/ubpuser/.ssh && \
    echo "Host *\n\
    ServerAliveInterval 60\n\
    ServerAliveCountMax 10000\n\
    ConnectTimeout 300" > /home/ubpuser/.ssh/config \
    && chmod 600 /home/ubpuser/.ssh/config \
    && chown -R ubpuser:ubpuser /home/ubpuser/.ssh

# Set up build environment
RUN echo 'export USE_CCACHE=1' >> /home/ubpuser/.bashrc \
    && echo 'export CCACHE_DIR=/home/ubpuser/.ccache' >> /home/ubpuser/.bashrc \
    && echo 'export CCACHE_SIZE=50G' >> /home/ubpuser/.bashrc \
    && ccache -M 50G

# Prepare build directory
RUN mkdir /home/ubpuser/ubports-builds && \
    chown -R ubpuser:ubpuser /home/ubpuser

# Copy scripts from host to the container
COPY ./scripts /home/ubpuser/bin/

# Configure Git after switching to ubpuser
USER ubpuser
RUN git config --global user.name "${GIT_USER_NAME}" \
    && git config --global user.email "${GIT_USER_EMAIL}" \
    # https://stackoverflow.com/questions/78396934/error-1824-bytes-of-body-are-still-expected-while-cloning-repository-from-git
    && git config --global http.postBuffer 524288000 \
    && git config --global http.version HTTP/1.1

# Verify installation (ensure repo is in the PATH)
RUN export PATH="/home/ubpuser/bin:$PATH" && \
    git --version && \
    /home/ubpuser/bin/repo --version && \
    adb version && \
    fastboot --version && \
    python3 --version

# Set default command
CMD ["bash", "-l"]
