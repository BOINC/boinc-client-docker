FROM boinc/client:nvidia

LABEL maintainer="BOINC" \
      description="Multi GPU-savvy (Intel 5th gen+ & Nvidia) BOINC client."

# Install
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Install PPA dependency
    software-properties-common \
    # Generic OpenCL ICD Loader
    ocl-icd-libopencl1 && \
# Install Intel NEO OpenCL
    add-apt-repository -y ppa:jdanecki/intel-opencl && \
    apt-get update && apt-get install -y --no-install-recommends \
    intel-opencl-icd && \
# Cleaning up
    apt-get remove -y software-properties-common && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
