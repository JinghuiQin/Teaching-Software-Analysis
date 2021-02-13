FROM ubuntu:18.04

# Stop script if any individual command fails.
RUN set -e

# Define LLVM version.
ENV llvm_version=10.0.0

# Define home directory
ENV HOME=/home/SVF-tools

# Define dependencies.
ENV lib_deps="make g++ git zlib1g-dev libncurses5-dev libssl-dev libpcre2-dev zip vim"
ENV build_deps="wget xz-utils cmake python git gdb"

# Fetch dependencies.
RUN apt-get update
RUN apt-get install -y $build_deps $lib_deps

# Fetch and build SVF source.
RUN echo "Downloading LLVM and building SVF to " ${HOME}
WORKDIR ${HOME}
RUN git clone "https://github.com/SVF-tools/SVF.git"
WORKDIR ${HOME}/SVF
RUN echo "Building SVF ..."
RUN bash ./build.sh

# Export SVF and llvm paths
ENV PATH=${HOME}/SVF/Release-build/bin:$PATH
ENV SVF_DIR=${HOME}/SVF
ENV LLVM_DIR=${HOME}/SVF/llvm-$llvm_version.obj

# Fetch and build SVF-Teaching example.
WORKDIR ${HOME}
RUN git clone "https://github.com/SVF-tools/SVF-Teaching.git"
WORKDIR ${HOME}/SVF-Teaching
RUN echo "Building SVF-Teaching example ..."
RUN cmake -DCMAKE_BUILD_TYPE=Debug .
RUN make
