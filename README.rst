Singularity images of FEniCS
============================

Definition of a Singularity image based on the fenics-dev docker environment.
Built on the FEniCS docker images, https://bitbucket.org/fenics-project/docker,
but adds some usefull packages like gmsh, h5py, meshio and valgrind.

See generated images here:

* Singularity: https://www.singularity-hub.org/collections/338
* Docker: https://hub.docker.com/r/trlandet/fenics-dev/

The repository also contains a suggested ``.bashrc`` file to put in the
directory used as ``$HOME`` in Singularity (using the ``-H`` switch). Create
a directory called ``fenics_src`` inside that home directory and run
``fenics-pull`` to download the latest versions of the FEniCS software to 
``fenics_src`` and then run ``fenics-build`` to build and install FEniCS.
