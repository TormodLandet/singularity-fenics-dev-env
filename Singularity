Bootstrap: docker
From: trlandet/fenics-dev:latest

%post
    chmod a+rwX -R /opt
    echo 'PS1="FEnarity \w> "' > /opt/bashrc

%environment
    export FENICS_PREFIX=${FENICS_PREFIX:-/opt}
    export FENICS_SRC_DIR=${FENICS_PREFIX}/src
    export SLEPC_DIR=${FENICS_PREFIX}
    export PETSC_DIR=${FENICS_PREFIX}
    export PATH=${FENICS_PREFIX}/bin:/usr/lib/ccache:$PATH
    export LD_LIBRARY_PATH=${FENICS_PREFIX}/lib:$LD_LIBRARY_PATH
    export MANPATH=${FENICS_PREFIX}/share/man:$MANPATH
    export CPATH=${FENICS_PREFIX}/include:$CPATH

%runscript
    echo "Welcome to the Singularity FEniCS dev container"
    echo "FEniCS is installed for python2 and python3"
    exec /bin/bash --rcfile /opt/bashrc -i "$@"
