FROM boinc/client:latest

LABEL maintainer="BOINC" \
      description="A base container image for lightweight AMD OpenCL-savvy BOINC clients"

RUN echo "deb http://deb.debian.org/debian stretch contrib" >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y --no-install-recommends \
        boinc-client-opencl \
    && rm -rf /var/lib/apt/lists/*
