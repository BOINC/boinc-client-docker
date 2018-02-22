FROM boinc/client:latest

LABEL maintainer="BOINC" \
      description="A base container image for lightweight AMD OpenCL-savvy BOINC clients"

RUN apt update && apt install -y --no-install-recommends \
    boinc-client-opencl \
 && apt clean

CMD ["/bin/bash","/start-boinc.sh"]
