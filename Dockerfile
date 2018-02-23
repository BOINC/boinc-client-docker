FROM ubuntu:bionic

LABEL maintainer="BOINC" \
      description="A base container image for lightweight BOINC clients" \
      boinc-version="7.8.3"

# Global environment settings
ENV DEBIAN_FRONTEND="noninteractive" \
    BOINC_GUI_RPC_PASSWORD="123" \
    BOINC_REMOTE_HOST="127.0.0.1" \
    BOINC_CMD_LINE_OPTIONS=""

# Install
RUN apt-get update && apt-get install -y --no-install-recommends \
        boinc-client \
    && rm -rf /var/lib/apt/lists/*

# Configure
WORKDIR /var/lib/boinc-client

# Copy files
COPY bin/ /usr/bin/

# BOINC RPC port
EXPOSE 31416

CMD ["start-boinc.sh"]
