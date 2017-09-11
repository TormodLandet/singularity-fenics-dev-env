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
    FENICS_VERSION=5c8f44ecf4924f8d74dfcc6b5dfe4b6744dc0dc8 /opt/bin/fenics-update fiat && \
    FENICS_VERSION=61cd6d9e51dc3e48c7a24fb066eb4c88f8d33645 /opt/bin/fenics-update dijitso && \
    FENICS_VERSION=b9e56604c5aacf1fa45ebd9876f207073b311b50 /opt/bin/fenics-update instant && \
    FENICS_VERSION=4fbc66b400fe07496a052b9e559af530d6e34b4a /opt/bin/fenics-update ufl && \
    FENICS_VERSION=159a44234f387961442895c20256b400bad5234e /opt/bin/fenics-update ffc && \
    FENICS_VERSION=f510b50ca600bdd0dfe0c36ca1fa2d31071c464d /opt/bin/fenics-update dolfin && \
    echo /opt/lib/python2.7/site-packages >> $(python2 -c "import site; print(site.getsitepackages()[0])")/fenics.pth

