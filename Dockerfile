FROM ubuntu:rolling

LABEL maintainer="BOINC" \
      description="A base container image for lightweight BOINC clients" \
      boinc-version="7.8.3"

# Global environment settings
ENV DEBIAN_FRONTEND="noninteractive" \
    BOINC_GUI_RPC_PASSWORD="123" \
    BOINC_REMOTE_HOST="127.0.0.1" \
    BOINC_CMD_LINE_OPTIONS=""

# Install
RUN apt update && apt install -y --no-install-recommends \
    boinc-client \
 && apt clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure
WORKDIR /var/lib/boinc-client

# Copy files
COPY start-boinc.sh /start-boinc.sh
RUN chmod +x /start-boinc.sh

# BOINC RPC port
EXPOSE 31416

CMD ["/bin/bash","/start-boinc.sh"]
