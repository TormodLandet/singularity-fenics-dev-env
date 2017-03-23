# Builds a Docker image for consumption by Singularity
# based on base and dev-env images from
# https://bitbucket.org/fenics-project/docker

FROM phusion/baseimage:0.9.19
MAINTAINER Tormod Landet <tormod@landet.net>

# Get Ubuntu updates
USER root
RUN apt-get update && \ 
    apt-get upgrade -y -o Dpkg::Options::="--force-confold" && \
    apt-get -y install locales sudo && \
    echo "C.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set locale environment
ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8

WORKDIR /tmp

# Environment variables
ENV PETSC_VERSION=3.7.5 \
    SLEPC_VERSION=3.7.3 \
    SWIG_VERSION=3.0.12 \
    MPI4PY_VERSION=2.0.0 \
    PETSC4PY_VERSION=3.7.0 \
    SLEPC4PY_VERSION=3.7.0 \
    TRILINOS_VERSION=12.10.1 \
    OPENBLAS_NUM_THREADS=1 \
    OPENBLAS_VERBOSE=0 \
    FENICS_PREFIX=/opt \
    FENICS_SRC_DIR=/opt/src

# Non-Python utilities and libraries
RUN apt-get -qq update && \
    apt-get -y --with-new-pkgs \
        -o Dpkg::Options::="--force-confold" upgrade && \
    apt-get -y install curl && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get -y install \
        bison \
        cmake \
        doxygen \
        flex \
        g++ \
        gfortran \
        git \
        git-lfs \
        libboost-filesystem-dev \
        libboost-iostreams-dev \
        libboost-program-options-dev \
        libboost-system-dev \
        libboost-thread-dev \
        libboost-timer-dev \
        libeigen3-dev \
        liblapack-dev \
        libmpich-dev \
        libopenblas-dev \
        libpcre3-dev \
        libhdf5-mpich-dev \
        libgmp-dev \
        libcln-dev \
        libmpfr-dev \
        mpich \
        nano \
        pkg-config \
        man \
        wget \
        ccache \
        bash-completion && \
    git lfs install && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Python2 based environment
RUN apt-get -qq update && \
    apt-get -y --with-new-pkgs \
        -o Dpkg::Options::="--force-confold" upgrade && \
    apt-get -y install \
        python-dev python3-dev \
        python-flufl.lock python3-flufl.lock \
        python-numpy python3-numpy \
        python-ply python3-ply \
        python-pytest python3-pytest \
        python-scipy python3-scipy \
        python-six python3-six \
        python-subprocess32 \
        python-urllib3  python3-urllib3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install setuptools
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    pip3 install --no-cache-dir setuptools && \
    python2 get-pip.py && \
    pip2 install --no-cache-dir setuptools && \
    rm -rf /tmp/*

# Install PETSc from source
RUN wget --quiet -nc http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-${PETSC_VERSION}.tar.gz && \
    tar -xf petsc-lite-${PETSC_VERSION}.tar.gz && \
    cd petsc-${PETSC_VERSION} && \
    ./configure --COPTFLAGS="-O2" \
                --CXXOPTFLAGS="-O2" \
                --FOPTFLAGS="-O2" \
                --with-blas-lib=/usr/lib/libopenblas.a --with-lapack-lib=/usr/lib/liblapack.a \
                --with-c-support \
                --with-debugging=0 \
                --with-shared-libraries \
                --download-suitesparse \
                --download-scalapack \
                --download-metis \
                --download-parmetis \
                --download-ptscotch \
                --download-hypre \
                --download-mumps \
                --download-blacs \
                --download-spai \
                --download-ml \
                --prefix=${FENICS_PREFIX} && \
     make && \
     make install && \
     rm -rf /tmp/*

# Install SLEPc from source
RUN wget -nc --quiet https://bitbucket.org/slepc/slepc/get/v${SLEPC_VERSION}.tar.gz -O slepc-${SLEPC_VERSION}.tar.gz && \
    mkdir -p slepc-src && tar -xf slepc-${SLEPC_VERSION}.tar.gz -C slepc-src --strip-components 1 && \
    export PETSC_DIR=${FENICS_PREFIX} && \
    cd slepc-src && \
    ./configure --prefix=${FENICS_PREFIX} && \
    make && \
    make install && \
    rm -rf /tmp/*

# By default use the 32-bit build of SLEPc and PETSc.
ENV SLEPC_DIR=${FENICS_PREFIX} \
    PETSC_DIR=${FENICS_PREFIX}

# Install Jupyter, sympy, mpi4py, petsc4py and slepc4py and Swig from source.
RUN pip2 install --no-cache-dir sympy && \
    pip2 install --no-cache-dir matplotlib && \
    pip2 install --no-cache-dir https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-${MPI4PY_VERSION}.tar.gz && \
    pip2 install --no-cache-dir https://bitbucket.org/petsc/petsc4py/downloads/petsc4py-${PETSC4PY_VERSION}.tar.gz && \
    pip2 install --no-cache-dir https://bitbucket.org/slepc/slepc4py/downloads/slepc4py-${SLEPC4PY_VERSION}.tar.gz && \
    pip3 install --no-cache-dir jupyter && \
    pip2 install --no-cache-dir ipython ipykernel && \
    python2 -m ipykernel install --prefix=/usr/local && \
    pip3 install --no-cache-dir sympy && \
    pip3 install --no-cache-dir matplotlib && \
    pip3 install --no-cache-dir https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-${MPI4PY_VERSION}.tar.gz && \
    pip3 install --no-cache-dir https://bitbucket.org/petsc/petsc4py/downloads/petsc4py-${PETSC4PY_VERSION}.tar.gz && \
    pip3 install --no-cache-dir https://bitbucket.org/slepc/slepc4py/downloads/slepc4py-${SLEPC4PY_VERSION}.tar.gz && \
    wget -nc --quiet http://downloads.sourceforge.net/swig/swig-${SWIG_VERSION}.tar.gz -O swig-${SWIG_VERSION}.tar.gz && \
    tar -xf swig-${SWIG_VERSION}.tar.gz && \
    cd swig-${SWIG_VERSION} && \
    ./configure --prefix=${FENICS_PREFIX} && \
    make && \
    make install && \
    rm -rf /tmp/*

# Install FEniCS
RUN PYTHON2_SITE_DIR=$(python2 -c "import site; print(site.getsitepackages()[0])") && \
    PYTHON3_SITE_DIR=$(python3 -c "import site; print(site.getsitepackages()[0])") && \
    PYTHON2_VERSION=$(python2 -c 'import sys; print(str(sys.version_info[0]) + "." + str(sys.version_info[1]))') && \
    PYTHON3_VERSION=$(python3 -c 'import sys; print(str(sys.version_info[0]) + "." + str(sys.version_info[1]))') && \
    echo "${FENICS_PREFIX}/lib/python$PYTHON2_VERSION/site-packages" >> $PYTHON2_SITE_DIR/fenics-user.pth && \
    echo "${FENICS_PREFIX}/lib/python$PYTHON3_VERSION/site-packages" >> $PYTHON3_SITE_DIR/fenics-user.pth && \
    export FENICS_BUILD_TYPE="${FENICS_BUILD_TYPE:-Release}"  && \
    for FENICS_PYTHON in python2 python3; do \
        export USE_PYTHON3=$(${FENICS_PYTHON} -c "import sys; print('OFF' if sys.version_info.major == 2 else 'ON')") && \
        export CMAKE_EXTRA_ARGS="${CMAKE_EXTRA_ARGS} -DDOLFIN_USE_PYTHON3=${USE_PYTHON3}" && \
        for package in fiat ufl dijitso instant ffc; do \
            pckdir=${FENICS_SRC_DIR}/${package} && \
            mkdir -p ${pckdir} && \
            cd ${pckdir} && \
            if [ ! -d .git ] ; then git clone https://bitbucket.org/fenics-project/${package}.git .; fi && \
            ${FENICS_PYTHON} -m pip install --prefix=${FENICS_PREFIX} . ; \
        done && \
        for package in dolfin; do \
            pckdir=${FENICS_SRC_DIR}/${package} && \
            mkdir -p ${pckdir} && \
            cd ${pckdir} && \
            if [ ! -d .git ] ; then git clone https://bitbucket.org/fenics-project/${package}.git .; fi && \
            rm -rf build && mkdir build && \
            cd build && \
            cmake ../ -DCMAKE_INSTALL_PREFIX=${FENICS_PREFIX} -DCMAKE_BUILD_TYPE=${FENICS_BUILD_TYPE} \
                  -Wno-dev -DPYTHON_EXECUTABLE:FILEPATH=$(which ${FENICS_PYTHON}) ${CMAKE_EXTRA_ARGS} && \
            make && \
            make install ; \
        done ; \
    done ; \
    chmod a+rwX -R ${FENICS_PREFIX}

