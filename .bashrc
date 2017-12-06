# Set prompt
export PS1="Singularity [\W]$ "

# Bash history will ignore repeated commands and commands starting with whitespace
export HISTCONTROL=erasedups:ignorespace

# Setup FEniCS
export FENICS_PYTHON=python3
export FENICS_SRC_DIR=${HOME}/fenics_src
export FENICS_PREFIX=${HOME}/.local

# Adjust paths
export PATH=~/bin:~/.local/bin:${PATH}
export PYTHONPATH=~/.local/lib/python3.5/site-packages/:$PYTHONPATH
export LD_LIBRARY_PATH=~/.local/lib:$LD_LIBRARY_PATH
export CPATH=~/.local/include:$CPATH
export PKG_CONFIG_PATH=~/.local/lib/pkgconfig:$PKG_CONFIG_PATH
export MANPATH=~/.local/share/man:$MANPATH
export PYBIND11_DIR=/usr/local

alias ls="ls --color=auto"
alias l="ls -lah"