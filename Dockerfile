FROM ubuntu:bionic

LABEL maintainer="BOINC" \
      description="A base container image for lightweight BOINC clients" \
      boinc-version="7.10.2"

# Global environment settings
ENV DEBIAN_FRONTEND="noninteractive" \
    BOINC_GUI_RPC_PASSWORD="123" \
    BOINC_REMOTE_HOST="127.0.0.1" \
    BOINC_CMD_LINE_OPTIONS=""

# Copy files
COPY bin/ /usr/bin/

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4 \
    && rm -rf /var/lib/apt/lists/*

# Install BOINC
RUN apt install ./usr/bin/boinc-client_7.10.2_amd64.deb

# Configure
WORKDIR /var/lib/boinc-client

# BOINC RPC port
EXPOSE 31416

CMD ["start-boinc.sh"]
