singularity-fenics-dev
=============================

A Singularity image with the fenics-dev docker environment

Based on the FEniCS docker images,
https://bitbucket.org/fenics-project/docker

See generated images here:
https://singularity-hub.org/collections/94/
based on
https://hub.docker.com/r/trlandet/fenics-dev/


How to use
----------

Currently singularity-hub builds images using singularity v 2.2. The same
version does not implement pulling images from the HUB ... What I found
that works best for me is to install the development (2.3?) version of
singularity (does not have to be installed as root) and then run::

     singularity pull shub://TormodLandet/singularity-fenics-dev-env

This downloads an ``*.img`` file. Now we can run this with singularity 2.2
(will not work very well with dev version since the image format has been
upgraded). Singularity version 2.2 must be installed as root (needs the 
suid bit), but can be run as a normal user::

    singularity run XXXXXXX.img

Inside the container both python2/ipython2 and python3/ipython3 has full
installations of FEniCS dolfin available with PETSc/SLEPc etc


How to rebuild
----------------

First, push changes to the Dockerfile, then trigger a rebuild on docker
hub. After this build is finished a new push must be made to trigger 
generation of the singularity image. Remember to reenable the master 
branch on singularity hub for automatic builds first. There does not
seem to be a way to trigger builds manually yet.

