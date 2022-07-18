# Ubuntu Base
docker build -t boinc/client:base-ubuntu -f Dockerfile.base-ubuntu .
docker push boinc/client:base-ubuntu

# Alpine Base
docker build -t boinc/client:base-alpine -f Dockerfile.base-alpine .
docker push boinc/client:base-alpine

# Nvidia
docker build -t boinc/client:nvidia -f Dockerfile.nvidia .
docker push boinc/client:nvidia

# AMD
docker build -t boinc/client:amd -f Dockerfile.amd .
docker push boinc/client:amd

# Intel
docker build -t boinc/client:intel -f Dockerfile.intel .
docker push boinc/client:intel

# Intel Legacy
docker build -t boinc/client:intel-legacy -f Dockerfile.intel-legacy .
docker push boinc/client:intel-legacy

# Multi GPU
docker build -t boinc/client:multi-gpu -f Dockerfile.multi-gpu .
docker push boinc/client:multi-gpu

# VirtualBox
docker build -t boinc/client:virtualbox -f Dockerfile.virtualbox .
docker push boinc/client:virtualbox

# Enable builds for other architectures (i.e. arm32v7, arm64v8)
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

# Arm32v7
docker build -t boinc/client:arm32v7 -f Dockerfile.arm32v7 .
docker push boinc/client:arm32v7

# Arm64v8
docker build -t boinc/client:arm64v8 -f Dockerfile.arm64v8 .
docker push boinc/client:arm64v8

# Remove all the docker images
docker system prune -a
