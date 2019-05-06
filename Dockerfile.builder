#################################################################
# Build insturction:                                            #
#    - https://boinc.berkeley.edu/trac/wiki/BuildSystem         #
#    - https://boinc.berkeley.edu/trac/wiki/CompileClient       #
#    - http://boinc.berkeley.edu/wiki/Compiling_the_core_client #
#                                                               #
# Folder structure:                                             #
# /                                                             #
# |-- build/                                                    #
# |-- workspace/                                                #
#     |-- boinc/                                                #
#                                                               #
#################################################################

FROM ubuntu:18.04

LABEL description="This container will allow you to build a BOINC Client .deb file without installing any build dependencies on your system."

# Global environment settings
ENV DEBIAN_FRONTEND="noninteractive"

# Configure
WORKDIR /build

# Install the dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Git Dependencies
    git ca-certificates python \
    # BOINC Dependencies
    make m4 libtool autoconf automake gcc g++ pkg-config \
    openssl libcurl4 libcurl4-openssl-dev libssl-dev libnotify-dev \
    checkinstall && \
    rm -rf /var/lib/apt/lists/* && \
# Download the source code
    mkdir /workspace && \
    cd /workspace && \
    git clone https://github.com/BOINC/boinc boinc && \
# Build
    cd /workspace/boinc && \
    LATEST_BOINC_CLIENT_TAG=$(git describe --tags $(git rev-list --tags='client_release*' --max-count=1)) && \
    BOINC_VERSION=$(echo $LATEST_BOINC_CLIENT_TAG | sed 's@.*/@@') && \
    git checkout $LATEST_BOINC_CLIENT_TAG && \
    ./_autosetup && \
    ./configure --disable-server --disable-manager CXXFLAGS="-O3" && \
    make && \
    cd client && \
    checkinstall -Dy --pkgname=boinc-client --pkgversion=$BOINC_VERSION --install=no --nodoc && \
    mv *.deb /build/ && \
# Cleaning up
    cd /build  && \
    rm -R /workspace && \
    apt-get remove -y git ca-certificates python make m4 libtool autoconf automake gcc pkg-config openssl libcurl4 libcurl4-openssl-dev libssl-dev libnotify-dev checkinstall && \
    apt-get autoremove -y

CMD ["/bin/bash"]
