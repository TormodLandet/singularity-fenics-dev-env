Bootstrap: docker
From: trlandet/fenics-dev

%post
    chmod a+rwX -R /opt

%runscript
    echo "Welcome to the Singularity FEniCS dev container"
    export PS1="FEnarity \w> "
    export FENICS_PREFIX=${FENICS_PREFIX:-/opt}
    export FENICS_SRC_DIR=${FENICS_PREFIX}/src
    export SLEPC_DIR=${FENICS_PREFIX}
    export PETSC_DIR=${FENICS_PREFIX}
    export PATH=${FENICS_PREFIX}/bin:/usr/lib/ccache:$PATH
    export LD_LIBRARY_PATH=${FENICS_PREFIX}/lib:$LD_LIBRARY_PATH
    export MANPATH=${FENICS_PREFIX}/share/man:$MANPATH
    export CPATH=${FENICS_PREFIX}/include:$CPATH
    exec /bin/bash "$@"

