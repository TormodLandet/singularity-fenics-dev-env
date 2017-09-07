# Builds a Docker image for consumption by Singularity
# based on base and dev-env images from
# https://bitbucket.org/fenics-project/docker

FROM trlandet/fenics-dev:base
MAINTAINER Tormod Landet <tormod@landet.net>

COPY bin/fenics-build  $FENICS_PREFIX/bin/fenics-build
COPY bin/fenics-pull   $FENICS_PREFIX/bin/fenics-pull
COPY bin/fenics-update $FENICS_PREFIX/bin/fenics-update

ARG FENICS_BUILD_TYPE
ENV FENICS_BUILD_TYPE ${FENICS_BUILD_TYPE:-Release}
ENV PATH $FENICS_PREFIX/bin:$PATH

RUN export FENICS_PYTHON=python2 && \
    export PIP_NO_CACHE_DIR=off && \
    /opt/bin/fenics-update && \
    export FENICS_PYTHON=python3 && \
    /opt/bin/fenics-build && \
    echo /opt/lib/python2.7/site-packages >> $(python2 -c "import site; print(site.getsitepackages()[0])")/fenics.pth && \
    echo /opt/lib/python3.5/site-packages >> $(python3 -c "import site; print(site.getsitepackages()[0])")/fenics.pth

