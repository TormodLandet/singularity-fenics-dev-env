# Builds a Docker image for consumption by Singularity
# based on base and dev-env images from
# https://bitbucket.org/fenics-project/docker

FROM trlandet/fenics-dev:base
MAINTAINER Tormod Landet <tormod@landet.net>

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

