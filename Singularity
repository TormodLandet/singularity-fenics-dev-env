Bootstrap: docker
From: ubuntu:16.10

%post
    # Most of this is taken from the FEniCS dockerfiles
    # https://bitbucket.org/fenics-project/docker
    #
    # Singularity does not translate the dev-env from
    # fenics docker very well, so this is the alternative
    # approach of having Singularity do the work
    
    # Helper function to export a variable and save it to
    # the container environment as well
    ENV () {
        export "$1"
        echo "export \"$1\"" >> /environment
        mkdir -p /.singularity/env/
        echo "export \"$1\"" >> /.singularity/env/XX_fenics.sh
    }
    
    # Main environment variables
    ENV FENICS_PREFIX="${FENICS_PREFIX:-/opt}"
    ENV FENICS_SRC_DIR="${FENICS_SRC_DIR:-/opt/src}"

    # Extend the PATH and do some basic configuring
    ENV PATH=${FENICS_PREFIX}/bin:$PATH
    ENV LD_LIBRARY_PATH=${FENICS_PREFIX}/lib:${FENICS_PREFIX}/lib64:$LD_LIBRARY_PATH    
    ENV PS1="SinglarityFEniCS:\w\$ "
    ENV LC_ALL=C.UTF-8
    ENV LANG=C.UTF-8
    ENV LANGUAGE=C.UTF-8

    # Extend the PYTHONPATH
    mkdir -p /usr/lib/python3/dist-packages
    mkdir -p /usr/lib/python2.7/dist-packages
    echo ${FENICS_PREFIX}/lib/python3.5/site-packages >> /usr/lib/python3/dist-packages/fenics.pth
    echo ${FENICS_PREFIX}/lib64/python3.5/site-packages >> /usr/lib/python3/dist-packages/fenics.pth
    echo ${FENICS_PREFIX}/lib/python2.7/site-packages >> /usr/lib/python2.7/dist-packages/fenics.pth
    echo ${FENICS_PREFIX}/lib64/python2.7/site-packages >> /usr/lib/python2.7/dist-packages/fenics.pth

    # Software versions to use
    ENV PETSC_VERSION=3.7.5
    ENV SLEPC_VERSION=3.7.3
    ENV SWIG_VERSION=3.0.12
    ENV MPI4PY_VERSION=2.0.0
    ENV PETSC4PY_VERSION=3.7.0
    ENV SLEPC4PY_VERSION=3.7.0
    ENV TRILINOS_VERSION=12.10.1
    ENV OPENBLAS_NUM_THREADS=1
    ENV OPENBLAS_VERBOSE=0

    apt-get -qq update
    apt-get -y --with-new-pkgs -o Dpkg::Options::="--force-confold" upgrade

    apt-get -y install locales
    echo "C.UTF-8 UTF-8" > /etc/locale.gen
    locale-gen
    
    apt-get -y install \
        bison \
        cmake \
        doxygen \
        flex \
        g++ \
        gfortran \
        git \
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
        bash-completion \
        vim wget curl

    #curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
    #apt-get -qq update
    #apt-get -y install git-lfs
    #git lfs install

    # Install Python environment
    apt-get -y install \
        python-dev python3-dev \
        python-flufl.lock python3-flufl.lock \
        python-numpy python3-numpy \
        python-ply python3-ply \
        python-pytest python3-pytest \
        python-scipy python3-scipy \
        python-six python3-six \
        python-subprocess32 \
        python-urllib3  python3-urllib3
    apt-get clean
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

    # Install setuptools
    cd /tmp
        wget https://bootstrap.pypa.io/get-pip.py
    python3 get-pip.py
    pip3 install --no-cache-dir setuptools
    python2 get-pip.py
    pip2 install --no-cache-dir setuptools
    rm -rf /tmp/*

    # Install PETSc from source
    cd /tmp
    wget --quiet -nc http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-${PETSC_VERSION}.tar.gz
    tar -xf petsc-lite-${PETSC_VERSION}.tar.gz
    cd petsc-${PETSC_VERSION} &&
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
                --prefix=${FENICS_PREFIX}
    make
    make install
    rm -rf /tmp/*
    ENV PETSC_DIR=${FENICS_PREFIX}

    # Install SLEPc from source
    cd /tmp
    wget -nc --quiet https://bitbucket.org/slepc/slepc/get/v${SLEPC_VERSION}.tar.gz -O slepc-${SLEPC_VERSION}.tar.gz
    mkdir -p slepc-src && tar -xf slepc-${SLEPC_VERSION}.tar.gz -C slepc-src --strip-components 1
    cd slepc-src
    ./configure --prefix=${FENICS_PREFIX}
    make
    make install
    rm -rf /tmp/*
    ENV SLEPC_DIR=${FENICS_PREFIX}

    # Install Jupyter, sympy, mpi4py, petsc4py and slepc4py and Swig from source.
    cd /tmp
    pip2 install --prefix=${FENICS_PREFIX} --no-cache-dir sympy
    pip2 install --prefix=${FENICS_PREFIX} --no-cache-dir matplotlib
    pip2 install --prefix=${FENICS_PREFIX} --no-cache-dir https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-${MPI4PY_VERSION}.tar.gz
    pip2 install --prefix=${FENICS_PREFIX} --no-cache-dir https://bitbucket.org/petsc/petsc4py/downloads/petsc4py-${PETSC4PY_VERSION}.tar.gz
    pip2 install --prefix=${FENICS_PREFIX} --no-cache-dir https://bitbucket.org/slepc/slepc4py/downloads/slepc4py-${SLEPC4PY_VERSION}.tar.gz
    pip3 install --prefix=${FENICS_PREFIX} --no-cache-dir jupyter
    pip2 install --prefix=${FENICS_PREFIX} --no-cache-dir ipython ipykernel
    python2 -m ipykernel install --prefix=${FENICS_PREFIX}
    pip3 install --prefix=${FENICS_PREFIX} --no-cache-dir sympy
    pip3 install --prefix=${FENICS_PREFIX} --no-cache-dir matplotlib
    pip3 install --prefix=${FENICS_PREFIX} --no-cache-dir https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-${MPI4PY_VERSION}.tar.gz
    pip3 install --prefix=${FENICS_PREFIX} --no-cache-dir https://bitbucket.org/petsc/petsc4py/downloads/petsc4py-${PETSC4PY_VERSION}.tar.gz
    pip3 install --prefix=${FENICS_PREFIX} --no-cache-dir https://bitbucket.org/slepc/slepc4py/downloads/slepc4py-${SLEPC4PY_VERSION}.tar.gz
    wget -nc --quiet http://downloads.sourceforge.net/swig/swig-${SWIG_VERSION}.tar.gz -O swig-${SWIG_VERSION}.tar.gz
    tar -xf swig-${SWIG_VERSION}.tar.gz
    cd swig-${SWIG_VERSION}
    ./configure --prefix=${FENICS_PREFIX}
    make
    make install
    rm -rf /tmp/*

    ###########################################################################
    
    ENV FENICS_PYTHON="${FENICS_PYTHON:-python3}"
    ENV FENICS_BUILD_TYPE="${FENICS_BUILD_TYPE:-Release}"
    
    ENV USE_PYTHON3=$(${FENICS_PYTHON} -c "import sys; print('OFF' if sys.version_info.major == 2 else 'ON')")
    ENV CMAKE_EXTRA_ARGS="${CMAKE_EXTRA_ARGS} -DDOLFIN_USE_PYTHON3=${USE_PYTHON3}"
    
    # Download and install pip installable packages
    for package in fiat ufl dijitso instant ffc; do
        pckdir=${FENICS_SRC_DIR}/${package}
        mkdir -p ${pckdir}
        cd ${pckdir}
        git clone https://bitbucket.org/fenics-project/${package}.git .
        pip3 install --prefix=${FENICS_PREFIX} .
    done
    
    # Download dolfin
    for package in dolfin; do
        pckdir=${FENICS_SRC_DIR}/${package}
        mkdir -p ${pckdir}
        cd ${pckdir}
        git clone https://bitbucket.org/fenics-project/${package}.git .
        mkdir build
        cd build
        cmake ../ -DCMAKE_INSTALL_PREFIX=${FENICS_PREFIX} -DCMAKE_BUILD_TYPE=${FENICS_BUILD_TYPE} \
              -Wno-dev -DPYTHON_EXECUTABLE:FILEPATH=$(which ${FENICS_PYTHON}) ${CMAKE_EXTRA_ARGS}
        make
        make install
    done
    
    chmod a+rwX -R ${FENICS_PREFIX}

%runscript
    /bin/bash "$@"

