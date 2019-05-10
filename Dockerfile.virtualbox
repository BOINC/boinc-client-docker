FROM boinc/client:baseimage-ubuntu

LABEL maintainer="BOINC" \
      description="VirtualBox-savvy BOINC client."

# Install
RUN apt-get update && apt-get install -y --no-install-recommends \
# Install VirtualBox
    virtualbox && \
# Cleaning up
    rm -rf /var/lib/apt/lists/*
